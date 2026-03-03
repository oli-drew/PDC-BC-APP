/// <summary>
/// Report PDC CF Product Data Export (ID 50064).
/// Exports Carbonfact product data as a 3-sheet Excel workbook
/// (Products, Packaging, BOM).
/// </summary>
Report 50064 "PDC CF Product Data Export"
{
    Caption = 'Carbonfact Product Data Export';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where("PDC Carbonfact Enabled" = const(true));
            RequestFilterFields = "No.", "Item Category Code";

            trigger OnPreDataItem()
            begin
                if Item.IsEmpty() then
                    Error(NoItemsErr);
            end;

            trigger OnAfterGetRecord()
            begin
                // dataitem provides filters + validation; actual export in OnPostDataItem
                CurrReport.Break();
            end;

            trigger OnPostDataItem()
            begin
                // Sheet 1: Products
                WriteProductHeaders();
                if Item.FindSet() then
                    repeat
                        WriteProductRow(Item);
                    until Item.Next() = 0;
                TempExcelBuffer.CreateNewBook('Products');
                TempExcelBuffer.WriteSheet('', CompanyName(), UserId());
                TempExcelBuffer.DeleteAll();
                TempExcelBuffer."Row No." := 0;

                // Sheet 2: Packaging
                TempExcelBuffer.ClearNewRow();
                WritePackagingHeaders();
                if Item.FindSet() then
                    repeat
                        WritePackagingRows(Item);
                    until Item.Next() = 0;
                TempExcelBuffer.SelectOrAddSheet('Packaging');
                TempExcelBuffer.WriteSheet('', CompanyName(), UserId());
                TempExcelBuffer.DeleteAll();
                TempExcelBuffer."Row No." := 0;

                // Sheet 3: BOM
                TempExcelBuffer.ClearNewRow();
                WriteBOMHeaders();
                if Item.FindSet() then
                    repeat
                        WriteBOMRows(Item);
                    until Item.Next() = 0;
                TempExcelBuffer.SelectOrAddSheet('BOM');
                TempExcelBuffer.WriteSheet('', CompanyName(), UserId());

                TempExcelBuffer.CloseBook();
                TempExcelBuffer.SetFriendlyFilename('CarbonfactProductData');
                TempExcelBuffer.OpenExcel();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    label(InfoLabel)
                    {
                        ApplicationArea = All;
                        Caption = 'Exports all items with Carbonfact Enabled = Yes as a 3-sheet Excel file (Products, Packaging, BOM).';
                    }
                }
            }
        }
    }

    local procedure WriteProductHeaders()
    begin
        TempExcelBuffer.NewRow();
        AddTextColumn(TempExcelBuffer, 'product_id', true);
        AddTextColumn(TempExcelBuffer, 'product_name', true);
        AddTextColumn(TempExcelBuffer, 'image_url', true);
        AddTextColumn(TempExcelBuffer, 'category', true);
        AddTextColumn(TempExcelBuffer, 'mass_kg', true);
        AddTextColumn(TempExcelBuffer, 'care_label_composition', true);
        AddTextColumn(TempExcelBuffer, 'country_of_origin', true);
        AddTextColumn(TempExcelBuffer, 'lifecycle_weeks', true);
        AddTextColumn(TempExcelBuffer, 'number_of_wears', true);
        AddTextColumn(TempExcelBuffer, 'uses_per_wash', true);
        AddTextColumn(TempExcelBuffer, 'tumble_dried_share', true);
        AddTextColumn(TempExcelBuffer, 'end_of_life_recycled_share', true);
        AddTextColumn(TempExcelBuffer, 'end_of_life_waste_share', true);
    end;

    local procedure WriteProductRow(var CurrItem: Record Item)
    var
        ItemCategory: Record "Item Category";
        COO: Code[10];
        Mass: Decimal;
        CareLabel: Text;
    begin
        if ItemCategory.Get(CurrItem."Item Category Code") then;

        COO := GetItemCOO(CurrItem, ItemCategory);
        Mass := GetItemMass(CurrItem, ItemCategory);
        CareLabel := BuildCareLabel(CurrItem."No.", ItemCategory);

        TempExcelBuffer.NewRow();
        AddTextColumn(TempExcelBuffer, CurrItem."No.", false);
        AddTextColumn(TempExcelBuffer, CurrItem.Description, false);
        AddTextColumn(TempExcelBuffer, '', false);
        AddTextColumn(TempExcelBuffer, ItemCategory."PDC CF Category", false);
        AddDecimalColumn(TempExcelBuffer, Mass);
        AddTextColumn(TempExcelBuffer, CareLabel, false);
        AddTextColumn(TempExcelBuffer, COO, false);
        AddIntegerColumn(TempExcelBuffer, ItemCategory."PDC CF Lifecycle Weeks");
        AddIntegerColumn(TempExcelBuffer, ItemCategory."PDC CF No. of Wears");
        AddIntegerColumn(TempExcelBuffer, ItemCategory."PDC CF Uses per Wash");
        AddDecimalColumn(TempExcelBuffer, ItemCategory."PDC CF Tumble Dried %");
        AddDecimalColumn(TempExcelBuffer, ItemCategory."PDC CF End Life Recycled %");
        AddDecimalColumn(TempExcelBuffer, ItemCategory."PDC CF End Life Waste %");
    end;

    local procedure WritePackagingHeaders()
    begin
        TempExcelBuffer.NewRow();
        AddTextColumn(TempExcelBuffer, 'product_id', true);
        AddTextColumn(TempExcelBuffer, 'packaging_type', true);
        AddTextColumn(TempExcelBuffer, 'material', true);
        AddTextColumn(TempExcelBuffer, 'recycled', true);
        AddTextColumn(TempExcelBuffer, 'mass_kg', true);
    end;

    local procedure WritePackagingRows(var CurrItem: Record Item)
    var
        ItemCategory: Record "Item Category";
    begin
        if not ItemCategory.Get(CurrItem."Item Category Code") then
            exit;

        if ItemCategory."PDC CF Pkg Bag Material" <> '' then begin
            TempExcelBuffer.NewRow();
            AddTextColumn(TempExcelBuffer, CurrItem."No.", false);
            AddTextColumn(TempExcelBuffer, ItemCategory."PDC CF Pkg Bag Type", false);
            AddTextColumn(TempExcelBuffer, ItemCategory."PDC CF Pkg Bag Material", false);
            AddTextColumn(TempExcelBuffer, 'Yes', false);
            AddDecimalColumn(TempExcelBuffer, ItemCategory."PDC CF Pkg Bag Mass Kg");
        end;

        if ItemCategory."PDC CF Pkg Carton Material" <> '' then begin
            TempExcelBuffer.NewRow();
            AddTextColumn(TempExcelBuffer, CurrItem."No.", false);
            AddTextColumn(TempExcelBuffer, ItemCategory."PDC CF Pkg Carton Type", false);
            AddTextColumn(TempExcelBuffer, ItemCategory."PDC CF Pkg Carton Material", false);
            AddTextColumn(TempExcelBuffer, 'Yes', false);
            AddDecimalColumn(TempExcelBuffer, ItemCategory."PDC CF Pkg Carton Mass Kg");
        end;
    end;

    local procedure WriteBOMHeaders()
    begin
        TempExcelBuffer.NewRow();
        AddTextColumn(TempExcelBuffer, 'product_id', true);
        AddTextColumn(TempExcelBuffer, 'material_type', true);
        AddTextColumn(TempExcelBuffer, 'composition', true);
        AddTextColumn(TempExcelBuffer, 'recycled', true);
        AddTextColumn(TempExcelBuffer, 'mass_share', true);
    end;

    local procedure WriteBOMRows(var CurrItem: Record Item)
    var
        ItemAttrValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
        ItemAttrValue: Record "Item Attribute Value";
        Material: Text;
        Construction: Text;
        RecycledStatus: Text;
        Percentage: Decimal;
        IsRecycled: Text;
    begin
        ItemAttrValueMapping.SetRange("Table ID", Database::Item);
        ItemAttrValueMapping.SetRange("No.", CurrItem."No.");
        ItemAttrValueMapping.SetFilter("Item Attribute ID", '%1..%2', 12, 70);
        if ItemAttrValueMapping.FindSet() then
            repeat
                if ItemAttribute.Get(ItemAttrValueMapping."Item Attribute ID") then
                    if ItemAttrValue.Get(ItemAttrValueMapping."Item Attribute ID", ItemAttrValueMapping."Item Attribute Value ID") then begin
                        Percentage := ItemAttrValue."Numeric Value";

                        ParseAttributeName(ItemAttribute.Name, Material, Construction, RecycledStatus);

                        if UpperCase(RecycledStatus) = 'RECYCLED' then
                            IsRecycled := 'Yes'
                        else
                            IsRecycled := 'No';

                        TempExcelBuffer.NewRow();
                        AddTextColumn(TempExcelBuffer, CurrItem."No.", false);
                        AddTextColumn(TempExcelBuffer, Construction, false);
                        AddTextColumn(TempExcelBuffer, RecycledStatus + ' ' + Material, false);
                        AddTextColumn(TempExcelBuffer, IsRecycled, false);
                        AddTextColumn(TempExcelBuffer, Format(Round(Percentage, 1)) + '%', false);
                    end;
            until ItemAttrValueMapping.Next() = 0;
    end;

    internal procedure ParseAttributeName(AttrName: Text; var Material: Text; var Construction: Text; var RecycledStatus: Text)
    var
        CommaPos: Integer;
        Remainder: Text;
    begin
        Clear(Material);
        Clear(Construction);
        Clear(RecycledStatus);
        Remainder := AttrName;

        CommaPos := StrPos(Remainder, ', ');
        if CommaPos > 0 then begin
            Material := CopyStr(Remainder, 1, CommaPos - 1);
            Remainder := CopyStr(Remainder, CommaPos + 2);
        end else begin
            Material := Remainder;
            exit;
        end;

        CommaPos := StrPos(Remainder, ', ');
        if CommaPos > 0 then begin
            Construction := CopyStr(Remainder, 1, CommaPos - 1);
            Remainder := CopyStr(Remainder, CommaPos + 2);
        end else begin
            Construction := Remainder;
            exit;
        end;

        CommaPos := StrPos(Remainder, ', ');
        if CommaPos > 0 then
            RecycledStatus := CopyStr(Remainder, 1, CommaPos - 1)
        else
            RecycledStatus := Remainder;
    end;

    internal procedure GetItemCOO(var CurrItem: Record Item; ItemCategory: Record "Item Category"): Code[10]
    begin
        if CurrItem."Country/Region of Origin Code" <> '' then
            exit(CurrItem."Country/Region of Origin Code");
        exit(ItemCategory."PDC CF Default COO");
    end;

    internal procedure GetItemMass(var CurrItem: Record Item; ItemCategory: Record "Item Category"): Decimal
    begin
        if CurrItem."Net Weight" <> 0 then
            exit(CurrItem."Net Weight");
        exit(ItemCategory."PDC CF Default Mass");
    end;

    internal procedure BuildCareLabel(ItemNo: Code[20]; ItemCategory: Record "Item Category"): Text
    var
        ItemAttrValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
        ItemAttrValue: Record "Item Attribute Value";
        Material: Text;
        Construction: Text;
        RecycledStatus: Text;
        Percentages: array[59] of Decimal;
        Compositions: array[59] of Text[250];
        EntryCount: Integer;
        i: Integer;
        j: Integer;
        TempDec: Decimal;
        TempTxt: Text[250];
        CareLabel: Text;
    begin
        ItemAttrValueMapping.SetRange("Table ID", Database::Item);
        ItemAttrValueMapping.SetRange("No.", ItemNo);
        ItemAttrValueMapping.SetFilter("Item Attribute ID", '%1..%2', 12, 70);
        if ItemAttrValueMapping.FindSet() then
            repeat
                if ItemAttribute.Get(ItemAttrValueMapping."Item Attribute ID") then
                    if ItemAttrValue.Get(ItemAttrValueMapping."Item Attribute ID", ItemAttrValueMapping."Item Attribute Value ID") then
                        if ItemAttrValue."Numeric Value" <> 0 then begin
                            EntryCount += 1;
                            ParseAttributeName(ItemAttribute.Name, Material, Construction, RecycledStatus);
                            Percentages[EntryCount] := ItemAttrValue."Numeric Value";
                            Compositions[EntryCount] := CopyStr(RecycledStatus + ' ' + Material, 1, 250);
                        end;
            until ItemAttrValueMapping.Next() = 0;

        if EntryCount = 0 then
            exit(ItemCategory."PDC CF Default Care Label");

        for i := 1 to EntryCount - 1 do
            for j := 1 to EntryCount - i do
                if Percentages[j] < Percentages[j + 1] then begin
                    TempDec := Percentages[j];
                    Percentages[j] := Percentages[j + 1];
                    Percentages[j + 1] := TempDec;
                    TempTxt := Compositions[j];
                    Compositions[j] := Compositions[j + 1];
                    Compositions[j + 1] := TempTxt;
                end;

        for i := 1 to EntryCount do begin
            if CareLabel <> '' then
                CareLabel += ' ';
            CareLabel += Format(Round(Percentages[i], 1)) + '% ' + Compositions[i];
        end;

        exit(CareLabel);
    end;

    local procedure AddTextColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Text; IsBold: Boolean)
    begin
        ExcelBuffer.AddColumn(Value, false, '', IsBold, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddDecimalColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Decimal)
    begin
        ExcelBuffer.AddColumn(Value, false, '', false, false, false, '0.00###', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure AddIntegerColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Integer)
    begin
        ExcelBuffer.AddColumn(Value, false, '', false, false, false, '0', ExcelBuffer."Cell Type"::Number);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NoItemsErr: Label 'No items with Carbonfact Enabled found.';
}
