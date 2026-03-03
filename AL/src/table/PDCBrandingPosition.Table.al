/// <summary>
/// Table PDC Branding Position (ID 50044).
/// </summary>
table 50044 "PDC Branding Position"
{
    // 07.02.2020 JEMEL J.Jemeljanovs #3208 * Created

    Caption = 'Branding Position';
    DrillDownPageID = "PDC Branding Position";
    LookupPageID = "PDC Branding Position";

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
        field(3; Detail; Text[50])
        {
            Caption = 'Detail';
        }
        field(4; Operations; Integer)
        {
            Caption = 'Operations';
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

