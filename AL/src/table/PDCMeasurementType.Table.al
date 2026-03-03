/// <summary>
/// Table PDC Measurement Type (ID 50037).
/// </summary>
table 50037 "PDC Measurement Type"
{
    // 21.08.2017 JEMEL J.Jemeljanovs #2278
    //   * Created

    Caption = 'Measurement Type';
    LookupPageID = "PDC Measurement Type";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Size,Fit,MTM';
            OptionMembers = Size,Fit,MTM;
        }
        field(2; "Code"; Code[6])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Gender; Code[2])
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
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

