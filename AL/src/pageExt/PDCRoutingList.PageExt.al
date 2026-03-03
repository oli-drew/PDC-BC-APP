/// <summary>
/// PageExtension PDCRoutingList (ID 50043) extends Record Routing List.
/// </summary>
pageextension 50043 PDCRoutingList extends "Routing List"
{
    layout
    {

        addlast(Control1)
        {
            field("PDC Sell-to Customer No."; Rec."PDC Sell-to Customer No.")
            {
                ToolTip = 'Sell-to Customer No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

