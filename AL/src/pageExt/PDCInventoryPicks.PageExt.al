/// <summary>
/// PageExtension PDCInventoryPicks (ID 50037) extends Record Inventory Picks.
/// </summary>
pageextension 50037 PDCInventoryPicks extends "Inventory Picks"
{
    layout
    {
        addafter("Sorting Method")
        {
            field(PDCDateofFirstPrinting; Rec."PDC Date of First Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Date of First Printing';
            }
            field(PDCTimeofFirstPrinting; Rec."PDC Time of First Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Time of First Printing';
            }
            field(PDCDateofLastPrinting; Rec."Date of Last Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Date of Last Printing';
            }
            field(PDCTimeofLastPrinting; Rec."Time of Last Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Time of Last Printing';
            }
            field(PDCSalesDocCreatedAt; Rec."PDC Sales Doc. Created At")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Doc. Created At';
            }
            field(PDCShiptoPostCode; Rec."PDC Ship-to Post Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Post Code';
            }
            field(PDCShipToCountryRegionCode; Rec."PDC Ship-to Country/Reg. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Country/Region Code';
            }
            field("PDC Urgent"; Rec."PDC Urgent")
            {
                ToolTip = 'Urgent';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

