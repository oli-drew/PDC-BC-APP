/// <summary>
/// Table PDC Gender (ID 50034).
/// </summary>
table 50034 "PDC Gender"
{
    Caption = 'Gender';
    LookupPageID = "PDC Gender";

    fields
    {
        field(1; "Code"; Code[2])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
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

