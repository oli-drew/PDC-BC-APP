/// <summary>
/// TableExtension PDCPhysInventoryLedgerEntry (ID 50029) extends Record Phys. Inventory Ledger Entry.
/// </summary>
tableextension 50029 PDCPhysInventoryLedgerEntry extends "Phys. Inventory Ledger Entry"
{
    fields
    {
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
    }
}

