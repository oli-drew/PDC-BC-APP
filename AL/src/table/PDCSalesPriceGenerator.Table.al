/// <summary>
/// Table PDC Sales Price Generator (ID 50041).
/// </summary>
table 50041 "PDC Sales Price Generator"
{
    // 03.03.2018 JEMEL J.Jemeljanovs #2559 - Created

    Caption = 'Sales Price Worksheet';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Item No." <> xRec."Item No." then begin
                    "Unit of Measure Code" := '';
                    "Variant Code" := '';
                end;
            end;
        }
        field(2; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(3; "Sales Type"; Enum "Sales Price Type")
        {
            Caption = 'Sales Type';

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                    Validate("Sales Code", '');
            end;
        }
        field(4; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = if ("Sales Type" = const(Customer)) Customer;

            trigger OnValidate()
            begin
                if ("Sales Code" <> '') and ("Sales Type" = "sales type"::"All Customers") then
                    Error(Text001Lbl, FieldCaption("Sales Code"));

                SetSalesDescription();
            end;
        }
        field(5; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(6; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(8; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(9; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(12; "VAT Bus. Posting Gr. (Price)"; Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(13; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000Lbl, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(14; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");
            end;
        }
        field(100; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            FieldClass = FlowField;
        }
        field(101; "Sales Description"; Text[100])
        {
            Caption = 'Sales Description';
        }
    }

    keys
    {
        key(Key1; "Item No.", "Variant Code", "Sales Type", "Sales Code", "Unit of Measure Code", "Minimum Quantity", "Currency Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Sales Type" = "sales type"::"All Customers" then
            "Sales Code" := ''
        else
            TestField("Sales Code");
        TestField("Item No.");
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "sales type"::"All Customers" then
            TestField("Sales Code");
        TestField("Item No.");
    end;

    var
        Text000Lbl: label '%1 cannot be after %2', Comment = '%1 cannot be after %2';
        Text001Lbl: label '%1 must be blank.', Comment = '%1 must be blank.';

    /// <summary>
    /// SetSalesDescription.
    /// </summary>
    procedure SetSalesDescription()
    var
        Customer: Record Customer;
    begin
        "Sales Description" := '';
        if "Sales Code" = '' then
            exit;
        case "Sales Type" of
            "sales type"::Customer:
                if Customer.Get("Sales Code") then
                    "Sales Description" := Customer.Name;
        end;
    end;
}

