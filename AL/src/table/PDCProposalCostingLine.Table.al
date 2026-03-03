/// <summary>
/// Table PDC Proposal Costing Line (ID 50048).
/// </summary>
table 50048 "PDC Proposal Costing Line"
{
    // 07.02.2020 JEMEL J.Jemeljanovs #3208 * Created

    Caption = 'Proposal Costing Line';

    fields
    {
        field(1; "Proposal No."; Code[20])
        {
            Caption = 'Proposal No.';
            TableRelation = "PDC Proposal Header"."No.";
        }
        field(2; "Proposal Line No."; Integer)
        {
            Caption = 'Proposal Line No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item where(Type = const(Inventory),
                                        "PDC Product Code" = field("Product Code"));

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then begin
                    Colour := Item."PDC Colour";
                    Fit := Item."PDC Fit";
                    Size := Item."PDC Size";
                end;

                UpdateValues();
            end;
        }
        field(6; Colour; Code[10])
        {
            Caption = 'Colour';
            TableRelation = "PDC Product colour";
        }
        field(7; Fit; Code[10])
        {
            Caption = 'Fit';
        }
        field(8; Size; Code[10])
        {
            Caption = 'Size';
        }
        field(9; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            FieldClass = FlowField;
        }
        field(10; Price; Decimal)
        {
            Caption = 'Price';
            DecimalPlaces = 2 : 5;

            trigger OnValidate()
            begin
                UpdateValues();
            end;
        }
        field(11; Issue; Decimal)
        {
            Caption = 'Issue';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                UpdateValues();
            end;
        }
        field(12; Staff; Decimal)
        {
            Caption = 'Staff';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                UpdateValues();
            end;
        }
        field(13; "Churn Pct."; Integer)
        {
            Caption = 'Churn Pct.';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                UpdateValues();
            end;
        }
        field(14; "Annual Usage"; Decimal)
        {
            Caption = 'Annual Usage';
            Editable = false;
        }
        field(15; "Item Cost"; Decimal)
        {
            Caption = 'Item Cost';

            trigger OnValidate()
            begin
                UpdateValues();
            end;
        }
        field(16; "Branding Routing Cost"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Branding Line"."Routing Cost" where("Proposal No." = field("Proposal No."),
                                                                             "Proposal Line No." = field("Proposal Line No.")));
            Caption = 'Branding Routing Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Branding Component Cost"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Branding Line"."Consuming Component Cost" where("Proposal No." = field("Proposal No."),
                                                                                         "Proposal Line No." = field("Proposal Line No.")));
            Caption = 'Branding Component Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Cost Roll Up"; Decimal)
        {
            Caption = 'Cost Roll Up';
            Editable = false;
        }
        field(19; "Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(20; Margin; Decimal)
        {
            Caption = 'Margin';
            Editable = false;
        }
        field(21; "Total Sales"; Decimal)
        {
            Caption = 'Total Sales';
            Editable = false;
        }
        field(22; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            Editable = false;
        }
        field(23; "Gross Profit Total"; Decimal)
        {
            Caption = 'Gross Profit Total';
            Editable = false;
        }
        field(25; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No.";
        }
        field(26; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header"."No.";
        }
        field(27; "Size Scale Code"; Code[20])
        {
            CalcFormula = lookup(Item."PDC Size Scale Code" where("No." = field("Item No.")));
            Caption = 'Size Scale Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "PDC Size Scale Header".Code;
        }
        field(28; SLA; Integer)
        {
            Caption = 'SLA';
        }
        field(29; "Return Period"; Integer)
        {
            Caption = 'Return Period (Days)';
        }
        field(30; "Vendor Item No."; Text[50])
        {
            CalcFormula = lookup(Item."Vendor Item No." where("No." = field("Item No.")));
            Caption = 'Vendor Item No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Prod.Line Active"; Boolean)
        {
            CalcFormula = Lookup("PDC Proposal Product Line".Active where("Proposal No." = FIELD("Proposal No."), "Line No." = FIELD("Proposal Line No.")));
            Caption = 'Prod.Line Active';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; "Proposal No.", "Proposal Line No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    /// <summary>
    /// UpdateValues
    /// </summary>
    procedure UpdateValues()
    var
        Item: Record Item;
        TempPurchPrice: Record "Purchase Price" temporary;
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
    begin
        "Annual Usage" := Issue * Staff * (1 + "Churn Pct." / 100);

        if Item.Get("Item No.") and (Item."Vendor No." <> '') then begin
            PurchPriceCalcMgt.FindPurchPrice(TempPurchPrice, Item."Vendor No.", Item."No.", '', Item."Base Unit of Measure", '', WorkDate(), false);
            PurchPriceCalcMgt.CalcBestDirectUnitCost(TempPurchPrice);
            "Item Cost" := TempPurchPrice."Direct Unit Cost";
        end;

        CalcFields("Branding Routing Cost", "Branding Component Cost");
        "Cost Roll Up" := "Item Cost" + "Branding Routing Cost" + "Branding Component Cost";

        "Gross Profit" := Price - "Cost Roll Up";

        if Price <> 0 then
            Margin := ROUND("Gross Profit" / Price * 100, 0.001)
        else
            Margin := 0;

        "Total Sales" := Price * "Annual Usage";
        "Total Cost" := "Cost Roll Up" * "Annual Usage";
        "Gross Profit Total" := "Gross Profit" * "Annual Usage";
    end;
}

