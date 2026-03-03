/// <summary>
/// PageExtension PDCPhysInventoryJournal (ID 50077) extends Record Phys. Inventory Journal.
/// </summary>
pageextension 50077 PDCPhysInventoryJournal extends "Phys. Inventory Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("PDC Vendor No."; Rec."PDC Vendor No.")
            {
                ToolTip = 'Vendor No.';
                ApplicationArea = All;
            }
            field("PDC Replenishment System"; Rec."PDC Replenishment System")
            {
                ToolTip = 'Replenishment System';
                ApplicationArea = All;
            }
        }
    }
}
