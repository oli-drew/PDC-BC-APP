/// <summary>
/// Codeunit PDC R777 CSV Parser (ID 50301).
/// Parses R777/TemplaCMS CSV format and creates Sales Orders.
/// </summary>
codeunit 50301 "PDC R777 CSV Parser"
{
    // Column indices (0-based) for R777 CSV format
    // A=0: Order Number (External Document No., Your Reference, AND PDC Customer Reference on Sales Lines)
    // D=3: Order date (YYYY-MM-DD)
    // H=7: Special instructions (Sales Comment)
    // I=8: Delivery code (Ship-to Code)
    // L=11: Product code (Item No.)
    // N=13: Quantity
    // Y=24: Contact name (Ship-to Contact)
    // Z=25: Contact phone
    // AB=27: Contact email

    /// <summary>
    /// Processes a CSV file and creates a Sales Order.
    /// </summary>
    procedure ProcessFile(var TempBlob: Codeunit "Temp Blob"; var EDocumentService: Record "E-Document Service"; var SalesOrderNo: Code[20]; var ErrorText: Text): Boolean
    var
        SalesOrderCreator: Codeunit "PDC EDI Sales Order Creator";
        TempPDCEDILine: Record "PDC EDI Import Line" temporary;
        InStream: InStream;
        CsvLine: Text;
        LineNo: Integer;
        HeaderOrderNo: Code[35];
        HeaderYourRef: Text[35];
        HeaderCustomerRef: Text[50];
        HeaderOrderDate: Date;
        HeaderSpecialInstr: Text[250];
        HeaderShipToCode: Code[10];
        HeaderContactName: Text[100];
        HeaderContactPhone: Text[30];
        HeaderContactEmail: Text[80];
        IsFirstLine: Boolean;
    begin
        Clear(SalesOrderNo);
        Clear(ErrorText);

        if not TempBlob.HasValue() then begin
            ErrorText := EmptyFileErr;
            exit(false);
        end;

        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        IsFirstLine := true;
        LineNo := 0;

        // Parse all lines
        while not InStream.EOS() do begin
            InStream.ReadText(CsvLine);
            CsvLine := CsvLine.Trim();

            if CsvLine <> '' then begin
                LineNo += 1;

                if IsFirstLine then begin
                    // Extract header data from first line
                    if not ParseHeaderData(CsvLine, HeaderOrderNo, HeaderYourRef, HeaderCustomerRef,
                                           HeaderOrderDate, HeaderSpecialInstr, HeaderShipToCode,
                                           HeaderContactName, HeaderContactPhone, HeaderContactEmail,
                                           ErrorText) then
                        exit(false);
                    IsFirstLine := false;
                end;

                // Parse line item data
                if not ParseLineData(CsvLine, LineNo, TempPDCEDILine, ErrorText) then begin
                    // Log error but continue processing other lines
                    ErrorText := StrSubstNo(LineParseErrorLbl, LineNo, ErrorText);
                end;
            end;
        end;

        if LineNo = 0 then begin
            ErrorText := NoLinesFoundErr;
            exit(false);
        end;

        // Check for duplicate order
        if IsDuplicateOrder(HeaderOrderNo, EDocumentService."PDC Customer No.") then begin
            ErrorText := StrSubstNo(DuplicateOrderErr, HeaderOrderNo);
            exit(false);
        end;

        // Create sales order
        exit(SalesOrderCreator.CreateSalesOrder(
            EDocumentService,
            HeaderOrderNo,
            HeaderYourRef,
            HeaderCustomerRef,
            HeaderOrderDate,
            HeaderSpecialInstr,
            HeaderShipToCode,
            HeaderContactName,
            HeaderContactPhone,
            HeaderContactEmail,
            TempPDCEDILine,
            SalesOrderNo,
            ErrorText
        ));
    end;

    local procedure ParseHeaderData(CsvLine: Text; var OrderNo: Code[35]; var YourRef: Text[35]; var CustomerRef: Text[50];
                                     var OrderDate: Date; var SpecialInstr: Text[250]; var ShipToCode: Code[10];
                                     var ContactName: Text[100]; var ContactPhone: Text[30]; var ContactEmail: Text[80];
                                     var ErrorText: Text): Boolean
    var
        Fields: List of [Text];
    begin
        Fields := ParseCsvLine(CsvLine);

        if Fields.Count() < 28 then begin
            ErrorText := StrSubstNo(InsufficientColumnsErr, Fields.Count(), 28);
            exit(false);
        end;

        // Column A (0): Order Number → External Document No., Your Reference, AND PDC Customer Reference
        OrderNo := CopyStr(GetFieldValue(Fields, 0), 1, MaxStrLen(OrderNo));
        YourRef := CopyStr(GetFieldValue(Fields, 0), 1, MaxStrLen(YourRef));
        CustomerRef := CopyStr(GetFieldValue(Fields, 0), 1, MaxStrLen(CustomerRef));

        // Column D (3): Order Date (YYYY-MM-DD)
        if not ParseDate(GetFieldValue(Fields, 3), OrderDate) then begin
            ErrorText := StrSubstNo(InvalidDateErr, GetFieldValue(Fields, 3));
            exit(false);
        end;

        // Column H (7): Special Instructions
        SpecialInstr := CopyStr(GetFieldValue(Fields, 7), 1, MaxStrLen(SpecialInstr));

        // Column I (8): Ship-to Code
        ShipToCode := CopyStr(GetFieldValue(Fields, 8), 1, MaxStrLen(ShipToCode));

        // Column Y (24): Contact Name
        ContactName := CopyStr(GetFieldValue(Fields, 24), 1, MaxStrLen(ContactName));

        // Column Z (25): Contact Phone
        ContactPhone := CopyStr(GetFieldValue(Fields, 25), 1, MaxStrLen(ContactPhone));

        // Column AB (27): Contact Email
        ContactEmail := CopyStr(GetFieldValue(Fields, 27), 1, MaxStrLen(ContactEmail));

        exit(true);
    end;

    local procedure ParseLineData(CsvLine: Text; LineNo: Integer; var TempPDCEDILine: Record "PDC EDI Import Line" temporary; var ErrorText: Text): Boolean
    var
        Fields: List of [Text];
        ItemNo: Code[20];
        Quantity: Decimal;
    begin
        Fields := ParseCsvLine(CsvLine);

        if Fields.Count() < 14 then begin
            ErrorText := StrSubstNo(InsufficientColumnsErr, Fields.Count(), 14);
            exit(false);
        end;

        // Column L (11): Item No.
        ItemNo := CopyStr(GetFieldValue(Fields, 11), 1, MaxStrLen(ItemNo));

        // Column N (13): Quantity
        if not Evaluate(Quantity, GetFieldValue(Fields, 13)) then begin
            ErrorText := StrSubstNo(InvalidQuantityErr, GetFieldValue(Fields, 13));
            exit(false);
        end;

        if ItemNo = '' then begin
            ErrorText := MissingItemNoErr;
            exit(false);
        end;

        // Add line to temp table
        TempPDCEDILine.Init();
        TempPDCEDILine."Line No." := LineNo * 10000;
        TempPDCEDILine."Item No." := ItemNo;
        TempPDCEDILine.Quantity := Quantity;
        TempPDCEDILine.Insert();

        exit(true);
    end;

    local procedure ParseCsvLine(CsvLine: Text): List of [Text]
    var
        Fields: List of [Text];
        CurrentField: TextBuilder;
        InQuotes: Boolean;
        CurrentChar: Char;
        i: Integer;
    begin
        // CSV parser that handles quoted fields (with commas inside quotes)
        InQuotes := false;

        for i := 1 to StrLen(CsvLine) do begin
            CurrentChar := CsvLine[i];

            case true of
                (CurrentChar = '"') and (not InQuotes):
                    InQuotes := true;
                (CurrentChar = '"') and InQuotes:
                    InQuotes := false;
                (CurrentChar = ',') and (not InQuotes):
                    begin
                        Fields.Add(CurrentField.ToText());
                        Clear(CurrentField);
                    end;
                else
                    CurrentField.Append(CurrentChar);
            end;
        end;

        // Add last field
        Fields.Add(CurrentField.ToText());

        exit(Fields);
    end;

    local procedure GetFieldValue(Fields: List of [Text]; Index: Integer): Text
    var
        FieldValue: Text;
    begin
        if (Index >= 0) and (Index < Fields.Count()) then begin
            Fields.Get(Index + 1, FieldValue); // List is 1-based
            FieldValue := FieldValue.Trim();
            // Remove surrounding quotes if present (using nested if to avoid AL's non-short-circuit evaluation)
            if StrLen(FieldValue) >= 2 then
                if (FieldValue[1] = '"') and (FieldValue[StrLen(FieldValue)] = '"') then
                    FieldValue := CopyStr(FieldValue, 2, StrLen(FieldValue) - 2);
        end;
        exit(FieldValue);
    end;

    local procedure ParseDate(DateText: Text; var ResultDate: Date): Boolean
    var
        Day, Month, Year : Integer;
        Parts: List of [Text];
    begin
        // Expected format: YYYY-MM-DD
        Parts := DateText.Split('-');

        if Parts.Count() <> 3 then
            exit(false);

        if not Evaluate(Year, Parts.Get(1)) then
            exit(false);
        if not Evaluate(Month, Parts.Get(2)) then
            exit(false);
        if not Evaluate(Day, Parts.Get(3)) then
            exit(false);

        ResultDate := DMY2Date(Day, Month, Year);
        exit(ResultDate <> 0D);
    end;

    local procedure IsDuplicateOrder(ExternalDocNo: Code[35]; CustomerNo: Code[20]): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        SalesHeader.SetRange("External Document No.", ExternalDocNo);
        exit(not SalesHeader.IsEmpty());
    end;

    var
        EmptyFileErr: Label 'The file is empty.';
        NoLinesFoundErr: Label 'No data lines found in the file.';
        InsufficientColumnsErr: Label 'Insufficient columns: found %1, expected at least %2.', Comment = '%1 = Found count, %2 = Expected count';
        InvalidDateErr: Label 'Invalid date format: %1. Expected YYYY-MM-DD.', Comment = '%1 = Date value';
        InvalidQuantityErr: Label 'Invalid quantity value: %1.', Comment = '%1 = Quantity value';
        MissingItemNoErr: Label 'Item No. is missing.';
        LineParseErrorLbl: Label 'Error on line %1: %2', Comment = '%1 = Line number, %2 = Error message';
        DuplicateOrderErr: Label 'Order %1 already exists. Skipping duplicate.', Comment = '%1 = External Document No.';
}
