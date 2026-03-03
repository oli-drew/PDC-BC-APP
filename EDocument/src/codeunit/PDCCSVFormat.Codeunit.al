/// <summary>
/// Codeunit PDC CSV Format (ID 50305).
/// Implements E-Document interface for PDC CSV invoice export format.
/// This format is used to export Posted Sales Invoices as CSV files.
/// </summary>
codeunit 50305 "PDC CSV Format" implements "E-Document"
{
    /// <summary>
    /// Check is used for outbound document validation.
    /// </summary>
    procedure Check(var SourceDocumentHeader: RecordRef; EDocumentService: Record "E-Document Service"; EDocumentProcessingPhase: Enum "E-Document Processing Phase")
    begin
        // No specific validation required for CSV export
    end;

    /// <summary>
    /// Create generates a CSV file from a Posted Sales Invoice.
    /// Output format: flat CSV with header data repeated per line, no header row.
    /// </summary>
    procedure Create(EDocumentService: Record "E-Document Service"; var EDocument: Record "E-Document"; var SourceDocumentHeader: RecordRef; var SourceDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        CompanyInfo: Record "Company Information";
        OutStream: OutStream;
        TotalNetValue: Decimal;
        TotalVatValue: Decimal;
        LineCount: Integer;
        LineVat: Decimal;
        CSVLine: Text;
    begin
        if SourceDocumentHeader.Number() <> Database::"Sales Invoice Header" then
            Error(InvalidSourceDocErr);

        SourceDocumentHeader.SetTable(SalesInvoiceHeader);
        CompanyInfo.Get();

        // Calculate totals first
        CalculateLineTotals(SalesInvoiceHeader."No.", TotalNetValue, TotalVatValue, LineCount);

        // Create output stream
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);

        // Write CSV lines (no header row)
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLine.FindSet() then
            repeat
                LineVat := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount";

                CSVLine :=
                    EscapeCSV(SalesInvoiceHeader."No.") + ',' +                           // A: Invoice Number
                    EscapeCSV(CompanyInfo.Name) + ',' +                                      // B: Source
                    EscapeCSV(SalesInvoiceHeader."Your Reference") + ',' +                // C: Invoice header text
                    FormatDate(SalesInvoiceHeader."Posting Date") + ',' +                 // D: Invoice date
                    FormatDecimal(TotalNetValue) + ',' +                                  // E: Total NET value
                    FormatDecimal(TotalVatValue) + ',' +                                  // F: Total VAT value
                    Format(LineCount) + ',' +                                             // G: Detail line count
                    EscapeCSV(SalesInvoiceLine."No.") + ',' +                             // H: Product code
                    EscapeCSV(SalesInvoiceHeader."Your Reference") + ',' +                // I: Order number
                    EscapeCSV(SalesInvoiceLine.Description) + ',' +                       // J: Invoice line text
                    FormatDecimal(SalesInvoiceLine.Quantity) + ',' +                      // K: Quantity
                    EscapeCSV(SalesInvoiceLine."Unit of Measure") + ',' +                 // L: Units
                    FormatDecimal(SalesInvoiceLine."Unit Price") + ',' +                  // M: NET unit cost
                    FormatDecimal(SalesInvoiceLine."Line Amount") + ',' +                 // N: NET line value
                    FormatDecimal(LineVat);                                               // O: Line VAT

                OutStream.WriteText(CSVLine);
                OutStream.WriteText();  // New line
            until SalesInvoiceLine.Next() = 0;
    end;

    /// <summary>
    /// CreateBatch is used for batch outbound. Not supported.
    /// </summary>
    procedure CreateBatch(EDocumentService: Record "E-Document Service"; var EDocuments: Record "E-Document"; var SourceDocumentHeaders: RecordRef; var SourceDocumentsLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    begin
        Error(BatchNotSupportedErr);
    end;

    /// <summary>
    /// GetBasicInfoFromReceivedDocument is for inbound processing. Not supported for export-only format.
    /// </summary>
    procedure GetBasicInfoFromReceivedDocument(var EDocument: Record "E-Document"; var TempBlob: Codeunit "Temp Blob")
    begin
        Error(ImportNotSupportedErr);
    end;

    /// <summary>
    /// GetCompleteInfoFromReceivedDocument is for inbound processing. Not supported for export-only format.
    /// </summary>
    procedure GetCompleteInfoFromReceivedDocument(var EDocument: Record "E-Document"; var CreatedDocumentHeader: RecordRef; var CreatedDocumentLines: RecordRef; var TempBlob: Codeunit "Temp Blob")
    begin
        Error(ImportNotSupportedErr);
    end;

    local procedure CalculateLineTotals(DocumentNo: Code[20]; var TotalNetValue: Decimal; var TotalVatValue: Decimal; var LineCount: Integer)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TotalNetValue := 0;
        TotalVatValue := 0;
        LineCount := 0;

        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        if SalesInvoiceLine.FindSet() then
            repeat
                TotalNetValue += SalesInvoiceLine."Line Amount";
                TotalVatValue += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount";
                LineCount += 1;
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure FormatDate(DateValue: Date): Text
    begin
        exit(Format(DateValue, 0, '<Year4>-<Month,2>-<Day,2>'));
    end;

    local procedure FormatDecimal(DecimalValue: Decimal): Text
    begin
        exit(Format(DecimalValue, 0, '<Precision,2:2><Standard Format,9>'));
    end;

    local procedure EscapeCSV(InputText: Text): Text
    var
        NeedsQuotes: Boolean;
    begin
        NeedsQuotes := (InputText.Contains(',')) or (InputText.Contains('"')) or (InputText.Contains(CrLf()));

        if InputText.Contains('"') then
            InputText := InputText.Replace('"', '""');

        if NeedsQuotes then
            InputText := '"' + InputText + '"';

        exit(InputText);
    end;

    local procedure CrLf(): Text
    begin
        exit(TypeHelper.CRLFSeparator());
    end;

    var
        TypeHelper: Codeunit "Type Helper";
        InvalidSourceDocErr: Label 'PDC CSV format only supports Posted Sales Invoices.';
        ImportNotSupportedErr: Label 'PDC CSV format is for export only. Import is not supported.';
        BatchNotSupportedErr: Label 'PDC CSV format does not support batch export.';
}
