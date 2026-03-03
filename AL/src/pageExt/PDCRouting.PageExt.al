/// <summary>
/// PageExtension PDCRouting (ID 50045) extends Record Routing.
/// </summary>
pageextension 50045 PDCRouting extends "Routing"
{
    layout
    {
        addfirst(General)
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

