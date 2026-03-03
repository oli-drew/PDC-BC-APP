/// <summary>
/// Codeunit PDC R777 CSV Format (ID 50304).
/// Implements E-Document interface for R777 CSV file format.
/// This format is used to receive CSV order files and create Sales Orders.
/// </summary>
codeunit 50304 "PDC R777 CSV Format" implements "E-Document"
{
    /// <summary>
    /// Check is used for outbound document validation. Not applicable for import-only format.
    /// </summary>
    procedure Check(var SourceDocumentHeader: RecordRef; EDocumentService: Record "E-Document Service"; EDocumentProcessingPhase: Enum "E-Document Processing Phase")
    begin
        // Not applicable for import-only format
    end;

    /// <summary>
    /// Create is used for outbound document creation. Not applicable for import-only format.
    /// </summary>
    procedure Create(EDocumentService: Record "E-Document Service"; var EDocument: Record "E-Document"; var SourceDocumentHeader: RecordRef; var SourceDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    begin
        Error(ExportNotSupportedErr);
    end;

    /// <summary>
    /// CreateBatch is used for batch outbound. Not applicable for import-only format.
    /// </summary>
    procedure CreateBatch(EDocumentService: Record "E-Document Service"; var EDocuments: Record "E-Document"; var SourceDocumentHeaders: RecordRef; var SourceDocumentsLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    begin
        Error(ExportNotSupportedErr);
    end;

    /// <summary>
    /// Extracts basic information from received CSV file.
    /// Sets Document Type to "Purchase Invoice" to pass framework validation,
    /// actual Sales Order creation happens in OnBeforePrepareReceivedDoc event.
    /// </summary>
    procedure GetBasicInfoFromReceivedDocument(var EDocument: Record "E-Document"; var TempBlob: Codeunit "Temp Blob")
    var
        EDocumentService: Record "E-Document Service";
        CSVBuffer: Record "CSV Buffer" temporary;
        InStream: InStream;
    begin
        if not TempBlob.HasValue() then
            exit;

        // Parse CSV to get basic info
        TempBlob.CreateInStream(InStream);
        CSVBuffer.LoadDataFromStream(InStream, ',');

        // Extract order number from first row, column A (field 1)
        if CSVBuffer.Get(1, 1) then
            EDocument."Incoming E-Document No." := CopyStr(CSVBuffer.Value, 1, MaxStrLen(EDocument."Incoming E-Document No."));

        // Extract order date from first row, column D (field 4)
        if CSVBuffer.Get(1, 4) then
            EDocument."Document Date" := ParseDate(CSVBuffer.Value);

        // Set Document Type to "Purchase Invoice" to pass framework's Document Type check
        // The actual Sales Order creation happens in OnBeforePrepareReceivedDoc event subscriber
        EDocument."Document Type" := EDocument."Document Type"::"Purchase Invoice";

        // Set Dummy Vendor to pass framework validation (vendor is not actually used)
        EDocumentService := EDocument.GetEDocumentService();
        if EDocumentService."PDC Dummy Vendor No." <> '' then
            EDocument."Bill-to/Pay-to No." := EDocumentService."PDC Dummy Vendor No.";

        EDocument.Modify();
    end;

    /// <summary>
    /// Gets complete document information from received file.
    /// For R777 CSV, the actual processing happens in OnBeforePrepareReceivedDoc event,
    /// so this returns empty RecordRef to prevent Purchase document creation.
    /// </summary>
    procedure GetCompleteInfoFromReceivedDocument(var EDocument: Record "E-Document"; var CreatedDocumentHeader: RecordRef; var CreatedDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    begin
        // The actual Sales Order creation happens in OnBeforePrepareReceivedDoc event subscriber.
        // TempBlob is cleared by the event subscriber, so nothing to do here.
        // Return empty RecordRef to prevent framework from creating Purchase document.
    end;

    local procedure ParseDate(DateText: Text): Date
    var
        Day, Month, Year : Integer;
        DateParts: List of [Text];
    begin
        // Expected format: YYYY-MM-DD
        DateParts := DateText.Split('-');
        if DateParts.Count() = 3 then begin
            if Evaluate(Year, DateParts.Get(1)) and
               Evaluate(Month, DateParts.Get(2)) and
               Evaluate(Day, DateParts.Get(3)) then
                exit(DMY2Date(Day, Month, Year));
        end;
        exit(Today());
    end;

    var
        ExportNotSupportedErr: Label 'R777 CSV format is for import only. Export is not supported.';
}
