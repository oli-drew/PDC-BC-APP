/// <summary>
/// TableExtension PDCWarehouseEntry (ID 50048) extends Record Warehouse Entry.
/// </summary>
tableextension 50048 PDCWarehouseEntry extends "Warehouse Entry"
{
    fields
    {
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
}

