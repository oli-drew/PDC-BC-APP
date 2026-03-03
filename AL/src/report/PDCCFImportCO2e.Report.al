/// <summary>
/// Report PDC CF Import CO2e (ID 50067).
/// Imports Carbonfact CO2e values from a CSV file and optionally
/// propagates them to production items.
/// </summary>
Report 50067 "PDC CF Import CO2e"
{
    Caption = 'Carbonfact Import CO2e';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Dummy; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                ImportCO2eFromCSV();
                if PropagateCO2e then
                    PropagateCO2eToProductionItems();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PropagateCO2eFld; PropagateCO2e)
                    {
                        ApplicationArea = All;
                        Caption = 'Propagate CO2e to production items';
                        ToolTip = 'If enabled, CO2e values are automatically copied from consuming garments to their production items after import.';
                    }
                }
            }
        }
    }

    local procedure ImportCO2eFromCSV()
    var
        Item: Record Item;
        InStr: InStream;
        FileName: Text;
        Line: Text;
        SKU: Code[20];
        FootprintValue: Decimal;
        UpdatedCount: Integer;
        NotFoundCount: Integer;
        ParseErrorCount: Integer;
    begin
        if not UploadIntoStream(ImportCO2eDialogTitleLbl, '', 'CSV Files (*.csv)|*.csv', FileName, InStr) then
            exit;

        InStr.ReadText(Line);
        if not Line.StartsWith('sku,') then
            Error(InvalidHeaderErr);

        while not InStr.EOS() do begin
            InStr.ReadText(Line);

            if Line = '' then
                continue;

            if not ParseCO2eLine(Line, SKU, FootprintValue) then begin
                ParseErrorCount += 1;
                continue;
            end;

            if Item.Get(SKU) then begin
                if Item."PDC Carbon Emissions CO2e" <> FootprintValue then begin
                    Item."PDC Carbon Emissions CO2e" := FootprintValue;
                    Item.Modify();
                end;
                UpdatedCount += 1;
            end else
                NotFoundCount += 1;
        end;

        Message(CO2eImportSummaryMsg, UpdatedCount, NotFoundCount, ParseErrorCount);
    end;

    local procedure ParseCO2eLine(Line: Text; var SKU: Code[20]; var FootprintValue: Decimal): Boolean
    var
        CommaPos: Integer;
        Remainder: Text;
        FootprintTxt: Text;
    begin
        CommaPos := StrPos(Line, ',');
        if CommaPos = 0 then
            exit(false);

        SKU := CopyStr(Line, 1, CommaPos - 1);
        Remainder := CopyStr(Line, CommaPos + 1);

        CommaPos := StrPos(Remainder, ',');
        if CommaPos = 0 then
            FootprintTxt := Remainder
        else
            FootprintTxt := CopyStr(Remainder, 1, CommaPos - 1);

        if not Evaluate(FootprintValue, FootprintTxt, 9) then
            exit(false);

        exit(true);
    end;

    internal procedure PropagateCO2eToProductionItems()
    var
        Item: Record Item;
        ConsumingItem: Record Item;
        ProdBOMLine: Record "Production BOM Line";
        UpdateCount: Integer;
    begin
        Item.SetRange("PDC Carbonfact Enabled", true);
        Item.SetFilter("Production BOM No.", '<>%1', '');
        if Item.FindSet() then
            repeat
                ProdBOMLine.SetRange("Production BOM No.", Item."Production BOM No.");
                ProdBOMLine.SetRange("Line No.", 10000);
                ProdBOMLine.SetRange(Type, ProdBOMLine.Type::Item);
                if ProdBOMLine.FindFirst() then
                    if ConsumingItem.Get(ProdBOMLine."No.") then
                        if Item."PDC Carbon Emissions CO2e" <> ConsumingItem."PDC Carbon Emissions CO2e" then begin
                            Item."PDC Carbon Emissions CO2e" := ConsumingItem."PDC Carbon Emissions CO2e";
                            Item.Modify();
                            UpdateCount += 1;
                        end;
            until Item.Next() = 0;

        Message(CO2ePropagatedMsg, UpdateCount);
    end;

    var
        PropagateCO2e: Boolean;
        ImportCO2eDialogTitleLbl: Label 'Import Carbonfact CO2e Data';
        InvalidHeaderErr: Label 'Invalid CSV file. Expected header: sku,footprint,unit';
        CO2eImportSummaryMsg: Label 'CO2e import complete.\%1 items updated.\%2 SKUs not found.\%3 lines could not be parsed.\Remember to run Propagate CO2e if needed.', Comment = '%1=updated count, %2=not found count, %3=parse error count';
        CO2ePropagatedMsg: Label 'CO2e values propagated to %1 production items.', Comment = '%1=count';
}
