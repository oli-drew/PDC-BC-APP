/// <summary>
/// Report PDC Suggest Items On Wksh. (ID 50012).
/// </summary>
Report 50012 "PDC Suggest Items On Wksh."
{
    Caption = 'Suggest Items on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loop; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));

            trigger OnAfterGetRecord()
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
                            Worksheet."Unit Price" := UnitPrice;
                            Worksheet."Lead Time Calculation" := LeadTimeCalc;
                            Worksheet."Contract Item" := ContractItem;
                            Worksheet.Validate("Vendor No.", VendorNo);
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
                            Worksheet."Unit Cost" := UnitCost;
                            Worksheet."Vendor Item No." := VendorItemNo;
                            Worksheet."Config. Template Code" := ConfigTemplateCode;
                            Worksheet."Return Period" := ReturnPeriod;
                            Worksheet."Routing No." := RoutingNo;
                            Worksheet."Net Weight" := NetWeight;
                            Worksheet.GTIN := GTIN;
                            Worksheet."Tariff No." := TariffNo;
                            if ConsGarmetProdCode <> '' then begin
                                Item.Reset();
                                Item.SetRange("PDC Product Code", ConsGarmetProdCode);
                                Item.SetRange("PDC Colour", Worksheet."Colour Code");
                                Item.SetRange("PDC Size", Worksheet.Size);
                                Item.setrange("PDC fit", Worksheet.Fit);
                                if Item.FindFirst() then
                                    Worksheet."Consuming Garmet Item No." := Item."No.";
                            end;
                            if (Worksheet."Consuming Garmet Item No." <> '') or (ConsGarmetProdCode = '') then
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
                    field(ContractItemFld; ContractItem)
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Item';
                        ToolTip = 'Contract Item';
                    }
                    field("Return Period"; ReturnPeriod)
                    {
                        ApplicationArea = All;
                        Caption = 'Return Period';
                        ToolTip = 'Return Period';
                    }
                    field(UnitCostFld; UnitCost)
                    {
                        ApplicationArea = All;
                        Caption = 'Unit Cost';
                        ToolTip = 'Unit Cost';
                    }
                    field(UnitPriceFld; UnitPrice)
                    {
                        ApplicationArea = All;
                        AutoFormatType = 2;
                        Caption = 'Unit Price';
                        ToolTip = 'Unit Price';
                    }
                    field(VendorNoFld; VendorNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        ToolTip = 'Vendor No.';
                        TableRelation = Vendor;
                    }
                    field(VendorItemNoFld; VendorItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Item No.';
                        ToolTip = 'Vendor Item No.';
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
                    field(NetWeightFld; NetWeight)
                    {
                        ApplicationArea = All;
                        Caption = 'Net Weight';
                        ToolTip = 'Specifies the net weight in kilograms for the items to be created.';
                        DecimalPlaces = 0 : 5;
                        MinValue = 0;
                    }
                    field(GTINFld; GTIN)
                    {
                        ApplicationArea = All;
                        Caption = 'GTIN';
                        ToolTip = 'Specifies the Global Trade Item Number for the items to be created.';
                    }
                    field(TariffNoFld; TariffNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Tariff No.';
                        ToolTip = 'Specifies the tariff number for the items to be created.';
                        TableRelation = "Tariff Number";
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
        ItemCategoryCode: Code[10];
        SizeScaleCode: Code[20];
        UnitPrice: Decimal;
        VendorNo: Code[20];
        CustomerNo: Code[20];
        Gender: Text[2];
        UoMCode: Code[10];
        ProdExistsErr: label 'Product with Product No.%1 and Color %2 already exists', Comment = '%1=product, %2=colour';
        SpecifyValueErr: label '%1 must be specified', Comment = '%1=value to be specified';
        MaxLengthErr: label 'Maximum length of %1 is %2', Comment = '%1=field, %2=max.length';
        UnitCost: Decimal;
        VendorItemNo: Text[20];
        ConfigTemplateCode: Code[10];
        ReturnPeriod: Integer;
        RoutingNo: Code[20];
        ConsGarmetProdCode: Code[30];
        ContractItem: Boolean;
        NetWeight: Decimal;
        GTIN: Code[14];
        TariffNo: Code[20];
        ProgressTxt: label 'Processing items  #1##########', Comment = '%1=progress';

    procedure Initialize(ToBatchName2: Code[10])
    begin
        ToBatchName := ToBatchName2;
    end;
}

