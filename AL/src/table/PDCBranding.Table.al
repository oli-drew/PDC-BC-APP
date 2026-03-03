/// <summary>
/// Table PDCBranding (ID 50045).
/// </summary>
table 50045 "PDC Branding"
{

    Caption = 'Branding';
    DrillDownPageID = "PDC Branding";
    LookupPageID = "PDC Branding";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    SalesReceivablesSetup.Get();
                    NoSeries.TestManual(SalesReceivablesSetup."PDC Branding Nos.");
                end;
            end;
        }
        field(2; "Branding Type Code"; Code[20])
        {
            Caption = 'Branding Type Code';
            NotBlank = true;
            TableRelation = "PDC Branding Type".Code;
        }
        field(3; "Branding Position Code"; Code[20])
        {
            Caption = 'Branding Position Code';
            NotBlank = true;
            TableRelation = "PDC Branding Position".Code;
        }
        field(4; "Branding File"; Text[30])
        {
            Caption = 'Branding File';
        }
        field(5; "Branding Description"; Text[50])
        {
            Caption = 'Branding Description';
        }
        field(6; "Consuming Item No."; Code[20])
        {
            Caption = 'Consuming Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                if "Consuming Item No." <> '' then begin
                    PDCBrandingType.Get("Branding Type Code");
                    if not PDCBrandingType.Consuming then
                        FieldError("Consuming Item No.");
                end;
            end;
        }
        field(7; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(8; "Routing Qty."; Integer)
        {
            Caption = 'Routing Qty.';
            InitValue = 1;
            MinValue = 1;
        }
        field(9; "Routing Set Up Cost"; Decimal)
        {
            Caption = 'Routing Set Up Cost';
            DecimalPlaces = 2 : 2;
        }
        field(10; "Item Component Cost"; Decimal)
        {
            Caption = 'Item Component Cost';
        }
        field(11; "Consuming Component Cost"; Decimal)
        {
            Caption = 'Consuming Component Cost';
        }
        field(12; "Routing Calc. Cost"; Decimal)
        {
            Caption = 'Routing Calc. Cost';
            DecimalPlaces = 2 : 5;
        }
        field(13; "Routing Cost Final"; Decimal)
        {
            Caption = 'Routing Cost Final';
        }
        field(14; "Routing Run Time Mins"; Decimal)
        {
            Caption = 'Routing Run Time Mins';
            DecimalPlaces = 0 : 5;
        }
        field(100; "Branding Type Description"; Text[50])
        {
            CalcFormula = lookup("PDC Branding Type".Description where(Code = field("Branding Type Code")));
            Caption = 'Branding Type Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Branding Posit. Description"; Text[50])
        {
            CalcFormula = lookup("PDC Branding Position".Description where(Code = field("Branding Position Code")));
            Caption = 'Branding Position Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; Consuming; Boolean)
        {
            CalcFormula = lookup("PDC Branding Type".Consuming where(Code = field("Branding Type Code")));
            Caption = 'Consuming';
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "Consuming Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Consuming Item No.")));
            Caption = 'Consuming Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Consuming Item Qty."; Integer)
        {
            CalcFormula = lookup("PDC Branding Position".Operations where(Code = field("Branding Position Code")));
            Caption = 'Consuming Item Qty.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Routing Cost"; Decimal)
        {
            CalcFormula = lookup("PDC Branding Type"."Routing Cost" where(Code = field("Branding Type Code")));
            Caption = 'Routing Cost';
            DecimalPlaces = 2 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "Run Time Multiplier"; Decimal)
        {
            CalcFormula = lookup("PDC Branding Type"."Run Time Multiplier" where(Code = field("Branding Type Code")));
            Caption = 'Run Time Multiplier';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(108; "Routing Type"; Option)
        {
            CalcFormula = lookup("PDC Branding Type".Type where(Code = field("Branding Type Code")));
            Caption = 'Routing Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";

            trigger OnValidate()
            begin
                "No." := '';
            end;
        }
        field(109; "Routing No."; Code[20])
        {
            CalcFormula = lookup("PDC Branding Type"."No." where(Code = field("Branding Type Code")));
            Caption = 'Routing No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; Routing; Text[50])
        {
            CalcFormula = lookup("PDC Branding Type".Routing where(Code = field("Branding Type Code")));
            Caption = 'Routing';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.TestField("PDC Branding Nos.");
            NoSeriesCode := SalesReceivablesSetup."PDC Branding Nos.";
            "No." := NoSeries.GetNextNo(NoSeriesCode, WorkDate());
        end;
        Update();
    end;

    trigger OnModify()
    begin
        PDCBrandingType.Get("Branding Type Code");
        if PDCBrandingType.Consuming then
            TestField("Consuming Item No.");
        Update();
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PDCBrandingType: Record "PDC Branding Type";
        Item: Record Item;
        NoSeries: Codeunit "No. Series";
        NoSeriesCode: Code[20];

    /// <summary>
    /// Update.
    /// </summary>
    procedure Update()
    var
        TempPurchPrice: Record "Purchase Price" temporary;
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
    begin
        if Item.Get("Consuming Item No.") and (Item."Vendor No." <> '') then begin
            PurchPriceCalcMgt.FindPurchPrice(
                      TempPurchPrice, Item."Vendor No.", Item."No.", '', Item."Base Unit of Measure",
                      '', WorkDate(), false);
            PurchPriceCalcMgt.CalcBestDirectUnitCost(TempPurchPrice);
            "Item Component Cost" := TempPurchPrice."Direct Unit Cost";
            CalcFields("Consuming Item Qty.");
            "Consuming Component Cost" := "Consuming Item Qty." * "Item Component Cost";
        end;

        CalcFields("Routing Cost");
        "Routing Calc. Cost" := "Routing Qty." * "Routing Cost";
        "Routing Cost Final" := "Routing Calc. Cost" + "Routing Set Up Cost";

        CalcFields("Run Time Multiplier");
        if "Run Time Multiplier" <> 0 then
            "Routing Run Time Mins" := ROUND("Routing Qty." * "Run Time Multiplier", 0.00001)
        else
            Clear("Routing Run Time Mins");
    end;

    /// <summary>
    /// procedure UpdateCostOnLinkedRouting update cost per line in Routing line table. 
    /// </summary>
    procedure UpdateCostOnLinkedRouting()
    var
        RoutingLine: Record "Routing Line";
    begin
        RoutingLine.setrange("PDC Branding No.", "No.");
        if RoutingLine.FindSet(true) then
            repeat
                RoutingLine.Validate("Unit Cost per", "Routing Cost Final");
                RoutingLine.Modify();
            until RoutingLine.Next() = 0;

    end;
}

