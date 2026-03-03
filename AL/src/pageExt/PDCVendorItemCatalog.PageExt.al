/// <summary>
/// PageExtension PDCVendorItemCatalog (ID 50047) extends Record Vendor Item Catalog.
/// </summary>
pageextension 50047 PDCVendorItemCatalog extends "Vendor Item Catalog"
{
    layout
    {
        addafter("Lead Time Calculation")
        {
            field(PDCVendorInventory; Rec."PDC Vendor Inventory")
            {
                ToolTip = 'Vendor Inventory';
                ApplicationArea = All;
            }
            field(PDCVendorInventoryDT; Rec."PDC Vendor Inventory DT")
            {
                ToolTip = 'Vendor Inventory DT';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

