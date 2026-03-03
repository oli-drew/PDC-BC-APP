table 50004 "PDC Item Creation Batch"
{
    Caption = 'Item Creation Batch Name';
    DataCaptionFields = Name, Description;
    LookupPageID = "PDC Item Creation Batches";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Type; enum "PDC Item Create Type")
        {
            Caption = 'Type';
        }

    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Line.SetRange("Journal Batch Name", Name);
        Line.DeleteAll(true);
    end;

    trigger OnRename()
    begin
        Line.SetRange("Journal Batch Name", xRec.Name);
        while Line.FindFirst() do
            Line.Rename(Name, Line."Item No.");
    end;

    var
        Line: Record "PDC Item Creation Engine";
}

