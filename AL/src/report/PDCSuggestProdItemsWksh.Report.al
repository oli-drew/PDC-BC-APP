/// <summary>
/// Report PDC Suggest Prod. Items Wksh (ID 50058).
/// </summary>
Report 50058 "PDC Suggest Prod. Items Wksh."
{
    Caption = 'Suggest Production Items on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loop; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                ConsGarmentItem: Record Item;
                TempSalesPrice: Record "Sales Price" temporary;
                TempPurchasePrice: Record "Purchase Price" temporary;
                SalesPrice: Codeunit "Sales Price Calc. Mgt.";
                PurchPriceCalcMgt: codeunit "Purch. Price Calc. Mgt.";
                SalesPriceMgt: Codeunit "PDC Portal Sales Price";
            begin
                if ItemCategoryLines.Findset() then
                    repeat
                        SizeScaleLine.FindSet();
                        repeat
                            Item.Reset();
                            Item.SetFilter("No.", '%1*', ItemCategoryLines."Item Category Code" +
                                                        ProductName +
                                                        ItemCategoryLines."Colour Code");
                            if Item.FindFirst() then
                                Error(ProdExistsErr, ItemCategoryLines."Item Category Code" +
                                               ProductName,
                                               ItemCategoryLines."Colour Code");

                            Worksheet.Init();
                            Worksheet."Journal Batch Name" := ToBatchName;
                            Worksheet."Item No." := copystr(
                                                        ItemCategoryLines."Item Category Code" +
                                                        ProductName +
                                                        ItemCategoryLines."Colour Code" +
                                                        SizeScaleLine.Size +
                                                        SizeScaleLine.Fit,
                                                        1, MaxStrLen(Worksheet."Item No."));
                            Worksheet.Validate("Item No.");
                            Window.Update(1, Worksheet."Item No.");

                            Worksheet."Product Code" := ItemCategoryLines."Item Category Code" +
                                                            ProductName;
                            Worksheet."Item Description" := ItemDescription;
                            Worksheet."Lead Time Calculation" := LeadTimeCalc;
                            Worksheet.Validate("Customer No.", CustomerNo);
                            Worksheet.Validate(Gender, Gender);
                            Worksheet."Item Category Code" := ItemCategoryLines."Item Category Code";
                            Worksheet."Colour Code" := ItemCategoryLines."Colour Code";
                            Worksheet."Colour Description" := ItemCategoryLines.Description;
                            Worksheet."Size Scale Code" := SizeScaleLine."Size Scale Code";
                            Worksheet.Size := SizeScaleLine.Size;
                            Worksheet."Size Sequence" := SizeScaleLine."Size Sequence";
                            Worksheet."Size Description" := SizeScaleLine."Size Description";
                            Worksheet.Fit := SizeScaleLine.Fit;
                            Worksheet."Fit Sequence" := SizeScaleLine."Fit Sequence";
                            Worksheet."Fit Description" := SizeScaleLine."Fit Description";
                            Worksheet."Unit of Measure Code" := UoMCode;
                            Worksheet.Include := true;
                            Worksheet."Config. Template Code" := ConfigTemplateCode;
                            Worksheet."Routing No." := RoutingNo;
                            if ConsGarmentItemNo <> '' then begin
                                ConsGarmentItem.get(ConsGarmentItemNo);
                                Item.Reset();
                                Item.SetRange("PDC Product Code", ConsGarmentItem."PDC Product Code");
                                Item.SetRange("PDC Colour", Worksheet."Colour Code");
                                Item.SetRange("PDC Size", Worksheet.Size);
                                Item.setrange("PDC fit", Worksheet.Fit);
                                if Item.FindFirst() then begin
                                    Worksheet."Consuming Garmet Item No." := Item."No.";

                                    if AddUnitPrice <> 0 then begin
                                        SalesPrice.FindSalesPrice(TempSalesPrice, '', '', '', '', Item."No.", '', Item."Base Unit of Measure", '', WorkDate(), false);
                                        SalesPriceMgt.CalcBestUnitPrice(TempSalesPrice);
                                        if TempSalesPrice."Unit Price" <> 0 then
                                            Worksheet."Unit Price" := TempSalesPrice."Unit Price" + AddUnitPrice;
                                    end;
                                    if (Item."Vendor No." <> '') and (AddUnitCost <> 0) then begin
                                        PurchPriceCalcMgt.FindPurchPrice(TempPurchasePrice, Item."Vendor No.", Item."No.", '', Item."Base Unit of Measure", '', WorkDate(), false);
                                        PurchPriceCalcMgt.CalcBestDirectUnitCost(TempPurchasePrice);
                                        if TempPurchasePrice."Direct Unit Cost" <> 0 then
                                            Worksheet."Unit Cost" := TempPurchasePrice."Direct Unit Cost" + AddUnitCost;
                                    end;
                                end;
                            end;
                            Worksheet."Consuming Brand 1 Item No." := ConsItems[1];
                            Worksheet."Consuming Brand 2 Item No." := ConsItems[2];
                            Worksheet."Consuming Brand 3 Item No." := ConsItems[3];
                            Worksheet."Consuming Brand 4 Item No." := ConsItems[4];
                            Worksheet."Consuming Brand 5 Item No." := ConsItems[5];
                            Worksheet."Consuming Brand 6 Item No." := ConsItems[6];
                            if (Worksheet."Consuming Garmet Item No." <> '') or (ConsGarmentItemNo = '') then
                                Worksheet.Insert(true);
                        until SizeScaleLine.next() = 0;
                    until ItemCategoryLines.next() = 0;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(ProgressTxt);

                if StrLen(ItemCategoryCode) > 3 then
                    Error(MaxLengthErr, 'Category Group', 30);

                ItemCategory.Reset();
                ItemCategory.SetRange(Code, ItemCategoryCode);
                ItemCategory.FindFirst();
                ItemCategoryLines.SetRange("Item Category Code", ItemCategory."Code");
                ItemCategoryLines.SetFilter("Colour Code", ColourFilter);

                SizeScale.Get(SizeScaleCode);
                SizeScaleLine.SetRange("Size Scale Code", SizeScale.Code);
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

                    field("Consuming Garment Item No."; ConsGarmentItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Garment Item No.';
                        ToolTip = 'Consuming Garment Item No.';
                        TableRelation = Item."No.";

                        trigger OnValidate()
                        var
                            Item1: Record Item;
                        begin
                            Item1.get(ConsGarmentItemNo);
                            ItemCategoryCode := Item1."Item Category Code";
                            ColourFilter := Item1."PDC Colour";
                            SizeScaleCode := Item1."PDC Size Scale Code";
                            Gender := Item1."PDC Gender";
                            UoMCode := Item1."Base Unit of Measure";
                        end;
                    }

                    field(ItemCategoryCodeFld; ItemCategoryCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Category Code';
                        ToolTip = 'Category Code';
                        TableRelation = "Item Category".Code;
                    }
                    field(ColourFilterFld; ColourFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Colour Filter';
                        ToolTip = 'Colour Filter';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ProdColour: Record "PDC Product colour";
                        begin
                            if ItemCategoryCode <> '' then begin
                                ProdColour.Reset();

                                ItemCategoryLines.Reset();
                                ItemCategoryLines.SETRANGE("Item Category Code", ItemCategoryCode);
                                if ItemCategoryLines.Findset() then
                                    repeat
                                        if ProdColour.Get(ItemCategoryLines."Colour Code") then
                                            ProdColour.Mark(true);
                                    until ItemCategoryLines.next() = 0;

                                ProdColour.MarkedOnly(true);
                                if ProdColour.Findset() then
                                    if Page.RunModal(0, ProdColour) = Action::LookupOK then
                                        ColourFilter := ProdColour.Code;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if ColourFilter <> '' then begin
                                ItemCategoryLines.SETRANGE("Item Category Code", ItemCategoryCode);
                                ItemCategoryLines.SetRange("Colour Code", ColourFilter);
                                ItemCategoryLines.FindFirst();
                            end;
                        end;
                    }
                    field(SizeScaleCodeFld; SizeScaleCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Size Scale Code';
                        ToolTip = 'Size Scale Code';
                        TableRelation = "PDC Size Scale Header";
                    }
                    field(ProductNameFld; ProductName)
                    {
                        ApplicationArea = All;
                        Caption = 'Product Name';
                        ToolTip = 'Product Name';
                    }
                    field(ItemDescriptionFld; ItemDescription)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Description';
                        ToolTip = 'Item Description';
                    }
                    field(UoMCodeFld; UoMCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Unit of Measure code';
                        ToolTip = 'Unit of Measure code';
                        TableRelation = "Unit of Measure";
                    }
                    field(GenderFld; Gender)
                    {
                        ApplicationArea = All;
                        Caption = 'Gender';
                        ToolTip = 'Gender';
                        TableRelation = "PDC Gender";
                    }
                    field(LeadTimeCalcFld; LeadTimeCalc)
                    {
                        ApplicationArea = All;
                        Caption = 'Lead Time Calculation';
                        ToolTip = 'Lead Time Calculation';
                    }
                    field(UnitCostFld; AddUnitCost)
                    {
                        ApplicationArea = All;
                        Caption = 'Additional Unit Cost';
                        ToolTip = 'Additional Unit Cost';
                    }
                    field(UnitPriceFld; AddUnitPrice)
                    {
                        ApplicationArea = All;
                        AutoFormatType = 2;
                        Caption = 'Additinal Unit Price';
                        ToolTip = 'Additinal Unit Price';
                    }
                    field(CustomerNoFld; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.';
                        ToolTip = 'Customer No.';
                        TableRelation = Customer;
                    }
                    field(ConfigTemplateCodeFld; ConfigTemplateCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Config. Template Code';
                        ToolTip = 'Config. Template Code';
                        TableRelation = "Config. Template Header".Code where("Table ID" = const(27));
                    }
                    field("Routing No."; RoutingNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Routing No.';
                        ToolTip = 'Routing No.';
                        TableRelation = "Routing Header";
                    }

                    field("Consuming Brand 1 Item No."; ConsItems[1])
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Brand 1 Item No.';
                        ToolTip = 'Consuming Brand 1 Item No.';
                        TableRelation = Item;
                    }
                    field("Consuming Brand 2 Item No."; ConsItems[2])
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Brand 2 Item No.';
                        ToolTip = 'Consuming Brand 2 Item No.';
                        TableRelation = Item;
                    }
                    field("Consuming Brand 3 Item No."; ConsItems[3])
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Brand 3 Item No.';
                        ToolTip = 'Consuming Brand 3 Item No.';
                        TableRelation = Item;
                    }
                    field("Consuming Brand 4 Item No."; ConsItems[4])
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Brand 4 Item No.';
                        ToolTip = 'Consuming Brand 4 Item No.';
                        TableRelation = Item;
                    }
                    field("Consuming Brand 5 Item No."; ConsItems[5])
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Brand 5 Item No.';
                        ToolTip = 'Consuming Brand 5 Item No.';
                        TableRelation = Item;
                    }
                    field("Consuming Brand 6 Item No."; ConsItems[6])
                    {
                        ApplicationArea = All;
                        Caption = 'Consuming Brand 6 Item No.';
                        ToolTip = 'Consuming Brand 6 Item No.';
                        TableRelation = Item;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if ToBatchName = '' then
            Error(SpecifyValueErr, 'Journal Batch Name');
        if ItemCategoryCode = '' then
            Error(SpecifyValueErr, 'Item Category code');
        if ColourFilter = '' then
            Error(SpecifyValueErr, 'Colour filter');
        if ProductName = '' then
            Error(SpecifyValueErr, 'Product Name');
        if SizeScaleCode = '' then
            Error(SpecifyValueErr, 'Size Scale Code');
        if ItemDescription = '' then
            Error(SpecifyValueErr, 'Item Description');
        if Gender = '' then
            Error(SpecifyValueErr, 'Gender');
        if UoMCode = '' then
            Error(SpecifyValueErr, 'Unit of Measure code');
        if UoMCode = '' then
            Error(SpecifyValueErr, 'Unit of Measure code');
    end;

    var

        Worksheet: Record "PDC Item Creation Engine";
        ItemCategory: Record "Item Category";
        ItemCategoryLines: Record "PDC Item Category Line";
        SizeScale: Record "PDC Size Scale Header";
        SizeScaleLine: Record "PDC Size Scale Line";
        Item: Record Item;
        LeadTimeCalc: DateFormula;
        ToBatchName: code[10];
        Window: Dialog;
        ColourFilter: Text;
        ProductName: Code[5];
        ItemDescription: Text[50];
        ItemCategoryCode: Code[20];
        SizeScaleCode: Code[20];
        AddUnitPrice: Decimal;
        AddUnitCost: Decimal;
        Gender: Text[2];
        UoMCode: Code[10];
        CustomerNo: Code[20];
        ProdExistsErr: label 'Product with Product No.%1 and Color %2 already exists', Comment = '%1=product, %2=colour';
        SpecifyValueErr: label '%1 must be specified', Comment = '%1=value to be specified';
        MaxLengthErr: label 'Maximum length of %1 is %2', Comment = '%1=field, %2=max.length';
        ConfigTemplateCode: Code[10];
        RoutingNo: Code[20];
        ConsGarmentItemNo: Code[20];
        ConsItems: array[6] of Code[20];
        ProgressTxt: label 'Processing items  #1##########', Comment = '%1=progress';

    procedure Initialize(ToBatchName2: Code[10])
    begin
        ToBatchName := ToBatchName2;
    end;
}

