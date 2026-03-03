/// <summary>
/// Table Branding Type (ID 50043).
/// </summary>
table 50043 "PDC Branding Type"
{
    // 07.02.2020 JEMEL J.Jemeljanovs #3208 * Created

    Caption = 'Branding Type';
    DrillDownPageID = "PDC Branding Type";
    LookupPageID = "PDC Branding Type";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Routing; Text[50])
        {
            Caption = 'Routing';
        }
        field(4; "Routing Cost"; Decimal)
        {
            Caption = 'Routing Cost';
            DecimalPlaces = 2 : 5;
        }
        field(5; Consuming; Boolean)
        {
            Caption = 'Consuming';
        }
        field(6; "Run Time Multiplier"; Decimal)
        {
            Caption = 'Run Time Multiplier';
            DecimalPlaces = 0 : 5;
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";

            trigger OnValidate()
            begin
                "No." := '';
            end;
        }
        field(8; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("Work Center")) "Work Center"
            else
            if (Type = const("Machine Center")) "Machine Center";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

