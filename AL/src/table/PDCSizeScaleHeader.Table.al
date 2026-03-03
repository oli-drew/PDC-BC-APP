/// <summary>
/// Table PDC Size Scale Header (ID 50031).
/// </summary>
table 50031 "PDC Size Scale Header"
{
    // 21.08.2017 JEMEL J.Jemeljanovs #2278
    //   * Created

    Caption = 'Size Scale Header';
    LookupPageID = "PDC Size Scale List";

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
        field(3; "Scale Type"; Text[20])
        {
            Caption = 'Scale Type';
        }
        field(4; "Size Group"; Code[10])
        {
            Caption = 'Size Group';
            TableRelation = "PDC Size Group".Code;
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

