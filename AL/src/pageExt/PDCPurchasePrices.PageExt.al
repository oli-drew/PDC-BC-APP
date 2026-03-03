/// <summary>
/// PageExtension PDCPurchasePrices (ID 50073) extends page Purchase Prices.
/// </summary>
pageextension 50073 PDCPurchasePrices extends "Purchase Prices"
{
    layout
    {
        addlast(Control1)
        {
            field("PDC Vendor Item No."; Rec."PDC Vendor Item No.")
            {
                ToolTip = 'Vendor Item No.';
                ApplicationArea = All;
            }
            field("PDC Item Blocked"; Rec."PDC Item Blocked")
            {
                ToolTip = 'Item Blocked';
                ApplicationArea = All;
            }
        }
    }
}
