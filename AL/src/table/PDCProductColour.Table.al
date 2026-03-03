/// <summary>
/// Table PDC Product Colour (ID 50035).
/// </summary>
table 50035 "PDC Product Colour"
{
    // 21.08.2017 JEMEL J.Jemeljanovs #2278
    //   * Created

    Caption = 'Product Colour';
    LookupPageID = "PDC Product Colour";

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

