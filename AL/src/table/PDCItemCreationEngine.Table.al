table 50033 "PDC Item Creation Engine"
{

    Caption = 'Item Creation Engine';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                if Item.Get("Item No.") then
                    FieldError("Item No.");
            end;
        }
        field(2; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(3; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(4; SLA; Integer)
        {
            Caption = 'SLA';
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced with Lead Time Calculation';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            ValidateTableRelation = true;
        }
        field(6; Include; Boolean)
        {
            Caption = 'Include';
        }
        field(7; Gender; Code[2])
        {
            Caption = 'Gender';
            TableRelation = "PDC Gender";

            trigger OnValidate()
            var
                loc_text001Lbl: label 'value must be within [M,F,U]';
            begin
                if not (Gender in ['M', 'F', 'U']) then
                    FieldError(Gender, loc_text001Lbl)
            end;
        }
        field(8; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category".Code where("Parent Category" = filter(''));
        }
        field(10; "Colour Code"; Code[6])
        {
            Caption = 'Colour Code';
            TableRelation = "PDC Product colour";
        }
        field(11; "Colour Description"; Text[50])
        {
            Caption = 'Colour Description';
        }
        field(12; "Size Scale Code"; Code[20])
        {
            Caption = 'Size Scale Code';
            NotBlank = true;
            TableRelation = "PDC Size Scale Header".Code;
        }
        field(13; Size; Code[10])
        {
            Caption = 'Size';
        }
        field(14; "Size Sequence"; Integer)
        {
            Caption = 'Size Sequence';
        }
        field(15; "Size Description"; Text[50])
        {
            Caption = 'Size Description';
        }
        field(16; Fit; Code[10])
        {
        }
        field(17; "Fit Sequence"; Integer)
        {
            Caption = 'Fit Sequence';
        }
        field(18; "Fit Description"; Text[50])
        {
            Caption = 'Fit Description';
        }
        field(19; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
        }
        field(20; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = true;
        }
        field(21; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
        }
        field(22; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
        }
        field(23; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(24; "Config. Template Code"; Code[10])
        {
            Caption = 'Config. Template Code';
            TableRelation = "Config. Template Header".Code where("Table ID" = const(27));
        }
        field(25; "Return Period"; Integer)
        {
            Caption = 'Return Period (Days)';
        }
        field(27; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";
        }
        field(28; "Consuming Garmet Item No."; Code[20])
        {
            Caption = 'Consuming Garmet Item No.';
            TableRelation = Item;
        }
        field(29; "Consuming Brand 1 Item No."; Code[20])
        {
            Caption = 'Consuming Brand 1 Item No.';
            TableRelation = Item;
        }
        field(30; "Consuming Brand 2 Item No."; Code[20])
        {
            Caption = 'Consuming Brand 2 Item No.';
            TableRelation = Item;
        }
        field(31; "Consuming Brand 3 Item No."; Code[20])
        {
            Caption = 'Consuming Brand 3 Item No.';
            TableRelation = Item;
        }
        field(32; "Consuming Brand 4 Item No."; Code[20])
        {
            Caption = 'Consuming Brand 4 Item No.';
            TableRelation = Item;
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(34; "Contract Item"; Boolean)
        {
            Caption = 'Contract Item';
        }
        field(35; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "PDC Item Creation Batch".Name;
        }
        field(36; "Consuming Brand 5 Item No."; Code[20])
        {
            Caption = 'Consuming Brand 5 Item No.';
            TableRelation = Item;
        }
        field(37; "Consuming Brand 6 Item No."; Code[20])
        {
            Caption = 'Consuming Brand 6 Item No.';
            TableRelation = Item;
        }
    }

    keys
    {
        key(Key1; "Journal Batch Name", "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;

    procedure Margin(): Decimal
    begin
        if "Unit Price" <> 0 then
            Exit(round(("Unit Price" - "Unit Cost") / "Unit Price" * 100, 0.0001))
        else
            exit(0);
    end;
}

