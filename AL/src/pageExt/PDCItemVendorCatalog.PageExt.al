/// <summary>
/// PageExtension PDCItemVendorCatalog (ID 50022) extends page Item Vendor Catalog.
/// </summary>
pageextension 50022 PDCItemVendorCatalog extends "Item Vendor Catalog"
{
    layout
    {
        addafter("Lead Time Calculation")
        {
            field(PDCVendorInventory; Rec."PDC Vendor Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'Vendor Inventory';
            }
            field(PDCVendorInventoryDT; Rec."PDC Vendor Inventory DT")
            {
                ApplicationArea = All;
                ToolTip = 'Vendor Inventory DT';
            }
            field("PDC Item Blocked"; Rec."PDC Item Blocked")
            {
                ToolTip = 'Item Blocked';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

