/// <summary>
/// PageExtension PDCPostedSalesShipments (ID 50069) extends Record Posted Sales Shipments.
/// </summary>
pageextension 50069 PDCPostedSalesShipments extends "Posted Sales Shipments"
{
    layout
    {
        addlast(Control1)
        {
            field("PDC Order No."; Rec."Order No.")
            {
                ToolTip = 'Order No.';
                ApplicationArea = All;
            }
            field("PDC Last Picking No."; Rec."PDC Last Picking No.")
            {
                ToolTip = 'Last Picking No.';
                ApplicationArea = All;
            }
        }
    }
}
