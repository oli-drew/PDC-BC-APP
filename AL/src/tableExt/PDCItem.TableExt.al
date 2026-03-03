/// <summary>
/// TableExtension PDCItem (ID 50005) extends Record Item.
/// </summary>
TableExtension 50005 PDCItem extends Item
{
    fields
    {
        field(50000; "PDC Style"; Code[10])
        {
            Caption = 'Style';
        }
        field(50001; "PDC Colour"; Code[10])
        {
            Caption = 'Colour';
            TableRelation = "PDC Product colour";
        }
        field(50002; "PDC Fit"; Code[10])
        {
            Caption = 'Fit';
        }
        field(50003; "PDC Size"; Code[10])
        {
            Caption = 'Size';
        }
        field(50004; "PDC Zero Price Block"; Boolean)
        {
            Caption = 'Zero Price Block';
        }
        field(50005; "PDC FOC"; Boolean)
        {
            Caption = 'FOC';
        }
        field(50006; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
        }
        field(50007; "PDC Barcode"; Code[50])
        {
            CalcFormula = lookup("Item Reference"."Reference No." where("Item No." = field("No."),
                                                                                   "Reference Type" = filter("Bar Code")));
            Caption = 'Barcode';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "PDC Product"; Code[10])
        {
            Caption = 'Product';
        }
        field(50009; "PDC Product Description"; Text[250])
        {
            Caption = 'Product Description';
        }
        field(50010; "PDC Style Description"; Text[250])
        {
            Caption = 'Style Description';
        }
        field(50011; "PDC Style Sequence"; Code[10])
        {
            Caption = 'Style Sequence';
        }
        field(50012; "PDC Colour Description"; Text[250])
        {
            Caption = 'Colour Description';
        }
        field(50013; "PDC Colour Sequence"; Code[10])
        {
            Caption = 'Colour Sequence';
        }
        field(50014; "PDC Size Description"; Text[250])
        {
            Caption = 'Size Description';
        }
        field(50015; "PDC Size Sequence"; Integer)
        {
            Caption = 'Size Sequence';
        }
        field(50016; "PDC Fit Description"; Text[250])
        {
            Caption = 'Fit Description';
        }
        field(50017; "PDC Fit Sequence"; Integer)
        {
            Caption = 'Fit Sequence';
        }
        field(50018; "PDC Branding Description"; Text[250])
        {
            Caption = 'Branding Description';
        }
        field(50019; "PDC Demand Planning Group"; Code[20])
        {
            Caption = 'Demand Planning Group';
        }
        field(50020; "PDC Web Picture Path"; Text[100])
        {
            Caption = 'Web Picture Path';
        }
        field(50021; "PDC Contract Item"; Boolean)
        {
            Caption = 'Contract Item';
        }
        field(50022; "PDC Variable Price"; Boolean)
        {
            Caption = 'Variable Price';
        }
        field(50023; "PDC Carbon Emissions CO2e"; Decimal)
        {
            Caption = 'Carbon Emissions CO2e';
            DecimalPlaces = 0 : 5;
        }
        field(50030; "PDC Source"; enum PDCItemSource)
        {
            Caption = 'Source';
        }
        field(50031; "PDC Size Scale Code"; Code[20])
        {
            Caption = 'Size Scale Code';
            TableRelation = "PDC Size Scale Header".Code;
        }
        field(50032; "PDC Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(50033; "PDC Gender"; Code[2])
        {
            Caption = 'Gender';
            TableRelation = "PDC Gender";

            trigger OnValidate()
            var
                loc_ValueErr: label 'value must be within [M,F,U]';
            begin
                if "PDC Gender" <> '' then
                    if not ("PDC Gender" in ['M', 'F', 'U']) then
                        error(loc_ValueErr);
            end;
        }
        field(50034; "PDC SLA"; Integer)
        {
            Caption = 'SLA';
        }
        field(50035; "PDC Size Group"; Code[10])
        {
            Caption = 'Size Group';
            TableRelation = "PDC Size Group".Code;
        }
        field(50036; "PDC Return Period"; Integer)
        {
            Caption = 'Return Period (Days)';
        }
        field(50037; "PDC Prepaid"; Boolean)
        {
            Caption = 'Prepaid';
        }
        field(50038; "PDC Qty. to Ship"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = sum("Sales Line"."Qty. to Ship (Base)" where("Document Type" = const(Order),
                                                                        Type = const(Item),
                                                                        "No." = field("No."),
                                                                        "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                        "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                        "Location Code" = field("Location Filter"),
                                                                        "Drop Shipment" = field("Drop Shipment Filter"),
                                                                        "Variant Code" = field("Variant Filter"),
                                                                        "Shipment Date" = field("Date Filter")));
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50039; "PDC Vendor Inventory"; Decimal)
        {
            CalcFormula = lookup("Item Vendor"."PDC Vendor Inventory" where("Item No." = field("No."),
                                                                         "Vendor No." = field("Vendor No.")));
            Caption = 'Vendor Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                ItemVendor: Record "Item Vendor";
            begin
                ItemVendor.SetRange("Vendor No.", "Vendor No.");
                ItemVendor.SetRange("Item No.", "No.");
                Page.Run(Page::"Item Vendor Catalog", ItemVendor);
            end;
        }
        field(50040; "PDC Qty. on Rel. Prod. Order"; Decimal)
        {
            Caption = 'Qty. on Rel. Prod. Order';
            FieldClass = FlowField;
            CalcFormula = Sum("Prod. Order Component"."Remaining Quantity" where(Status = CONST(Released), "Item No." = FIELD("No."), "Location Code" = FIELD("Location Filter"), "Bin Code" = FIELD("Bin Filter")));
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50041; "PDC Qty. on Prod. Purch. Order"; Decimal)
        {
            Caption = 'Qty. on Prod. Purch. Order';
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" where("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Expected Receipt Date" = FIELD("Date Filter"), "Prod. Order No." = FILTER(<> '')));
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
    }
    keys
    {
        key(PDCKey1; "PDC Style")
        {
        }
        key(PDCKey2; "PDC Fit")
        {
        }
        key(PDCKey3; "PDC Colour")
        {
        }
        key(PDCKey4; "PDC Size")
        {
        }
        key(PDCKey5; "PDC Product Code")
        {
        }
        key(PDCKey6; "PDC Product Code", "PDC Colour", "PDC Fit", "PDC Size")
        {
        }
        key(PDCKey7; "PDC Product Code", "PDC Colour Sequence", "PDC Fit Sequence", "PDC Size Sequence")
        {
        }
    }
    fieldgroups
    {
        addlast(DropDown; "PDC Product Code", "PDC Colour")
        {
        }
    }

    trigger OnAfterInsert()
    begin
        GenerateBarcode();
    end;

    local procedure GenerateBarcode()
    var
        ItemReference: Record "Item Reference";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
        BarcodeL: Code[20];
        EvenSum: Integer;
        OddSum: Integer;
        i: Integer;
        TempInt: Integer;
        TotalSum: Integer;
        TotalSum2: Integer;
        CheckSum: Code[10];
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."PDC Barcode Nos." = '' then exit;
        SalesReceivablesSetup.TestField("PDC Barcode Nos.");
        BarcodeL := NoSeries.GetNextNo(SalesReceivablesSetup."PDC Barcode Nos.");
        for i := 1 to StrLen(BarcodeL) - 1 do begin
            Evaluate(TempInt, Format(BarcodeL[i]));
            OddSum += TempInt;
            Evaluate(TempInt, Format(BarcodeL[i + 1]));
            EvenSum += TempInt;
            i += 1;
        end;

        TotalSum := (OddSum * 3) + EvenSum;
        TotalSum2 := ROUND(TotalSum, 10, '>');
        CheckSum := Format(TotalSum2 - TotalSum);
        ItemReference."Item No." := "No.";
        ItemReference."Reference Type" := ItemReference."Reference type"::"Bar Code";
        ItemReference."Reference No." := CopyStr(BarcodeL + CheckSum, 1, 10);
        ItemReference.Insert();
    end;

    /// <summary>
    /// procedure OpenDemandProduct open page with demand products.
    /// </summary>
    procedure OpenDemandProduct()
    var
        PDCDemandProduct: Record "PDC Demand Product";
    begin
        //01.09.2017 JEMEL J.Jemeljanovs #2296
        TestField("PDC Product Code");
        TestField("PDC Colour");
        if not PDCDemandProduct.Get("PDC Product Code", "PDC Colour") then begin
            PDCDemandProduct.Init();
            PDCDemandProduct.Validate("Product Code", "PDC Product Code");
            PDCDemandProduct.Validate("Colour Code", "PDC Colour");
            PDCDemandProduct.Insert(true);
        end;
        PDCDemandProduct.SetRecfilter();
        Page.Run(0, PDCDemandProduct);
    end;

    /// <summary>
    /// procedure CalcComponentInventory calculate inventory with Production BOM components.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcComponentInventory(): Decimal
    var
        ProductionBOMLine: Record "Production BOM Line";
        Item: Record Item;
        CompInv: Decimal;
        CurrInv: Decimal;
        FstLine: Boolean;
    begin
        clear(CompInv);
        ProductionBOMLine.setrange("Production BOM No.", "Production BOM No.");
        if ProductionBOMLine.findset() then begin
            FstLine := true;
            repeat
                if ProductionBOMLine.Type = ProductionBOMLine.Type::Item then begin
                    Item.reset();
                    CopyFilter("Date Filter", Item."Date Filter");
                    CopyFilter("Location Filter", Item."Location Filter");
                    Item.get(ProductionBOMLine."No.");
                    Item.CalcFields(Inventory);
                    if ProductionBOMLine."Quantity per" = 0 then
                        exit(0);
                    CurrInv := round(Item.Inventory / ProductionBOMLine."Quantity per" * ProductionBOMLine.Quantity);

                    if (CurrInv < CompInv) or FstLine then
                        CompInv := CurrInv;
                    FstLine := false;
                end;
            until ProductionBOMLine.Next() = 0;
        end;

        exit(CompInv);
    end;

    /// <summary>
    /// procedure ShowComponentInventory shows production BOM components inventory.
    /// </summary>
    procedure ShowComponentInventory()
    var
        ProductionBOMLine: Record "Production BOM Line";
        Item: Record Item;
    begin
        Item.reset();
        CopyFilter("Date Filter", Item."Date Filter");
        CopyFilter("Location Filter", Item."Location Filter");

        ProductionBOMLine.setrange("Production BOM No.", "Production BOM No.");
        if ProductionBOMLine.findset() then
            repeat
                Item.get(ProductionBOMLine."No.");
                Item.Mark(true);
            until ProductionBOMLine.Next() = 0;

        Item.MarkedOnly(true);
        page.RunModal(page::"Item List", Item);
    end;

}

