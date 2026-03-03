/// <summary>
/// TableExtension PDCWarehouseJournalLine (ID 50047) extends Record Warehouse Journal Line.
/// </summary>
tableextension 50047 PDCWarehouseJournalLine extends "Warehouse Journal Line"
{
    fields
    {

        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                "PDC Product Code" := Item."PDC Product Code";
            end;
        }
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50016; "PDC Comment"; Text[100])
        {
            Caption = 'Comment';
        }
    }

    var
        Item: Record Item;
}

