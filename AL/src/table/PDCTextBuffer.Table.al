/// <summary>
/// Table PDC Text Buffer (ID 50057).
/// </summary>
table 50057 "PDC Text Buffer"
{
    //Old No. 9062765

    // //DOC NA2016.10 JH 23/10/2015 - Created
    // //DOC NA2016.15 JH 06/05/2016 - CfMD amendments

    Caption = 'Text Buffer';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(10; Text; Text[250])
        {
            Caption = 'Text';
        }
        field(11; "Text 2"; Text[250])
        {
            Caption = 'Text 2';
        }
        field(12; "Text 3"; Text[250])
        {
            Caption = 'Text 3';
        }
        field(13; "Text 4"; Text[250])
        {
            Caption = 'Text 4';
        }
        field(14; "Text 5"; Text[24])
        {
            Caption = 'Text 5';
        }
        field(100; "Bool 1"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; ID)
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetText(pText: Text)
    begin
        Rec.Text := CopyStr(pText, 1, 250);
        Rec."Text 2" := CopyStr(pText, 251, 250);
        Rec."Text 3" := CopyStr(pText, 501, 250);
        Rec."Text 4" := CopyStr(pText, 751, 250);
        Rec."Text 5" := CopyStr(pText, 1001, 24);
    end;

    procedure GetText(): Text
    begin
        exit(Rec.Text + Rec."Text 2" + Rec."Text 3" + Rec."Text 4" + Rec."Text 5");
    end;
}

