/// <summary>
/// Codeunit PDC EDI Import Mgt (ID 50303).
/// Provides event handlers for E-Document framework to create Sales Orders from CSV imports.
/// </summary>
codeunit 50303 "PDC EDI Import Mgt"
{
    /// <summary>
    /// Event subscriber that intercepts document processing for R777 CSV imports.
    /// This fires BEFORE the framework's Document Type check, allowing us to:
    /// 1. Create our Sales Order
    /// 2. Update E-Document
    /// 3. Clear TempBlob to prevent Purchase document creation
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"E-Doc. Import", OnBeforePrepareReceivedDoc, '', false, false)]
    local procedure HandleOnBeforePrepareReceivedDoc(var EDocument: Record "E-Document"; var TempBlob: Codeunit "Temp Blob"; SourceDocumentHeader: RecordRef; SourceDocumentLine: RecordRef; TempEDocMapping: Record "E-Doc. Mapping" temporary)
    var
        EDocumentService: Record "E-Document Service";
        R777Parser: Codeunit "PDC R777 CSV Parser";
        SalesOrderNo: Code[20];
        ErrorText: Text;
    begin
        // Get the E-Document Service
        EDocumentService := EDocument.GetEDocumentService();

        // Only handle if Document Format is "R777 CSV"
        if EDocumentService."Document Format" <> "E-Document Format"::"PDC R777 CSV" then
            exit;

        // Skip if already processed or no content
        if not TempBlob.HasValue() then
            exit;

        // Process CSV with our parser to create Sales Order
        if R777Parser.ProcessFile(TempBlob, EDocumentService, SalesOrderNo, ErrorText) then begin
            // Success - update E-Document with sales order reference
            EDocument."Document Record ID" := GetSalesOrderRecordId(SalesOrderNo);
            EDocument."Document No." := SalesOrderNo;
            EDocument.Status := "E-Document Status"::Processed;
            EDocument.Modify();

            UpdateEDocumentStatus(EDocument, EDocumentService, "E-Document Service Status"::"Imported Document Created");

            // Clear TempBlob to prevent framework from continuing with Purchase document creation
            Clear(TempBlob);
        end else
            // Let framework handle the error
            Error(ErrorText);
    end;

    local procedure UpdateEDocumentStatus(var EDocument: Record "E-Document"; var EDocumentService: Record "E-Document Service"; NewStatus: Enum "E-Document Service Status")
    var
        EDocumentServiceStatus: Record "E-Document Service Status";
    begin
        // Update service status
        if EDocumentServiceStatus.Get(EDocument."Entry No", EDocumentService.Code) then begin
            EDocumentServiceStatus.Status := NewStatus;
            EDocumentServiceStatus.Modify();
        end;

        // Update E-Document status based on service status
        if NewStatus = "E-Document Service Status"::"Imported Document Created" then
            EDocument.Status := "E-Document Status"::Processed
        else
            EDocument.Status := "E-Document Status"::Error;
        EDocument.Modify();
    end;

    /// <summary>
    /// Tests connection to Azure File Share.
    /// Only validates Azure connection settings, not import/export configuration.
    /// </summary>
    procedure TestConnection(var EDocumentService: Record "E-Document Service"): Boolean
    var
        Connector: Codeunit "PDC Azure File Share Connector";
        TempBlobList: Codeunit "Temp Blob List";
        ReceiveContext: Codeunit ReceiveContext;
    begin
        if not ValidateAzureConnection(EDocumentService) then
            exit(false);

        // Try to list files - if it succeeds, connection is working
        Connector.ReceiveDocuments(EDocumentService, TempBlobList, ReceiveContext);
        Message(ConnectionSuccessMsg, TempBlobList.Count());
        exit(true);
    end;

    /// <summary>
    /// Validates only Azure connection settings.
    /// </summary>
    local procedure ValidateAzureConnection(var EDocumentService: Record "E-Document Service"): Boolean
    var
        Errors: List of [Text];
    begin
        if EDocumentService."PDC Azure Storage Account" = '' then
            Errors.Add(StorageAccountRequiredErr);

        if EDocumentService."PDC Azure File Share" = '' then
            Errors.Add(FileShareRequiredErr);

        if not EDocumentService.HasSASToken() then
            Errors.Add(SASTokenRequiredErr);

        if Errors.Count() > 0 then begin
            ShowConfigurationErrors(Errors);
            exit(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Validates that required configuration is complete.
    /// Inbound formats (R777 CSV) require Customer and Dummy Vendor.
    /// Outbound formats (PDC CSV, PEPPOL) only require Azure connection.
    /// </summary>
    procedure ValidateConfiguration(var EDocumentService: Record "E-Document Service"): Boolean
    var
        Errors: List of [Text];
        IsInboundFormat: Boolean;
    begin
        // Azure connection settings required for all
        if EDocumentService."PDC Azure Storage Account" = '' then
            Errors.Add(StorageAccountRequiredErr);

        if EDocumentService."PDC Azure File Share" = '' then
            Errors.Add(FileShareRequiredErr);

        if not EDocumentService.HasSASToken() then
            Errors.Add(SASTokenRequiredErr);

        // Check if this is an inbound format
        IsInboundFormat := EDocumentService."Document Format" = "E-Document Format"::"PDC R777 CSV";

        // Customer and Dummy Vendor only required for inbound formats
        if IsInboundFormat then begin
            if EDocumentService."PDC Customer No." = '' then
                Errors.Add(CustomerRequiredErr);

            if EDocumentService."PDC Dummy Vendor No." = '' then
                Errors.Add(DummyVendorRequiredErr);
        end;

        if Errors.Count() > 0 then begin
            ShowConfigurationErrors(Errors);
            exit(false);
        end;

        exit(true);
    end;

    local procedure GetSalesOrderRecordId(SalesOrderNo: Code[20]): RecordId
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then
            exit(SalesHeader.RecordId());
    end;

    local procedure ShowConfigurationErrors(Errors: List of [Text])
    var
        ErrorMessage: Text;
        ErrorItem: Text;
    begin
        ErrorMessage := ConfigurationErrorsLbl;
        foreach ErrorItem in Errors do
            ErrorMessage += '\- ' + ErrorItem;

        Error(ErrorMessage);
    end;

    /// <summary>
    /// Event subscriber to set correct file extension when exporting from E-Document Log.
    /// CSV formats should export as .csv, not .xml.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"E-Document Log", OnBeforeExportDataStorage, '', false, false)]
    local procedure HandleOnBeforeExportDataStorage(EDocumentLog: Record "E-Document Log"; var FileName: Text)
    begin
        // Remove any existing extension that may have been added by other subscribers
        if FileName.EndsWith('.xml') then
            FileName := CopyStr(FileName, 1, StrLen(FileName) - 4);

        // Append correct file extension based on Document Format
        case EDocumentLog."Document Format" of
            "E-Document Format"::"PDC R777 CSV",
            "E-Document Format"::"PDC CSV":
                FileName := FileName + '.csv';
            else
                // Default to .xml for other formats (PEPPOL, etc.)
                FileName := FileName + '.xml';
        end;
    end;

    var
        StorageAccountRequiredErr: Label 'Azure Storage Account Name is required.';
        FileShareRequiredErr: Label 'Azure File Share Name is required.';
        SASTokenRequiredErr: Label 'Azure SAS Token must be configured.';
        CustomerRequiredErr: Label 'Customer No. must be configured.';
        DummyVendorRequiredErr: Label 'Dummy Vendor No. must be configured for E-Document framework validation.';
        ConfigurationErrorsLbl: Label 'Configuration errors:';
        ConnectionSuccessMsg: Label 'Connection successful. Found %1 files in the directory.', Comment = '%1 = File count';
}
