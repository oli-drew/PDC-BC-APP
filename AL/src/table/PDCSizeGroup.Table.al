/// <summary>
/// Table PDC Size Group (ID 50036).
/// </summary>
table 50036 "PDC Size Group"
{
    // 21.08.2017 JEMEL J.Jemeljanovs #2278
    //   * Created

    Caption = 'Size Group';
    LookupPageID = "PDC Size Group";

    fields
    {
        field(1; "Code"; Code[6])
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

