/// <summary>
/// Table PDC Item Category Line (ID 50030).
/// </summary>
table 50030 "PDC Item Category Line"
{
    // 21.08.2017 JEMEL J.Jemeljanovs #2278
    //   * Created

    Caption = 'Product Group Line';

    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            NotBlank = true;
        }
        field(3; "Colour Code"; Code[6])
        {
            Caption = 'Colour Code';
            TableRelation = "PDC Product colour";

            trigger OnValidate()
            begin
                if PDCProductColour.Get("Colour Code") then
                    Description := PDCProductColour.Description
                else
                    Description := '';
            end;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Colour Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PDCProductColour: Record "PDC Product Colour";
}

