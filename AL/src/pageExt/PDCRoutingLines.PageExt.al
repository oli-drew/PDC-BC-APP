/// <summary>
/// PageExtension PDCRoutingLines (ID 50044) extends Record Routing Lines.
/// </summary>
pageextension 50044 PDCRoutingLines extends "Routing Lines"
{
    layout
    {
        modify("Wait Time")
        {
            Visible = false;
        }
        modify("Fixed Scrap Quantity")
        {
            Visible = false;
        }
        modify("Send-Ahead Quantity")
        {
            Visible = false;
        }
        addlast(Control1)
        {
            field(PDCBrandingNo; Rec."PDC Branding No.")
            {
                ToolTip = 'Branding No.';
                ApplicationArea = All;
            }
            field(PDCBrandingTypeCode; Rec."PDC Branding Type Code")
            {
                ToolTip = 'Branding Type Code';
                ApplicationArea = All;
            }
            field(PDCBrandingPositionCode; Rec."PDC Branding Position Code")
            {
                ToolTip = 'Branding Position Code';
                ApplicationArea = All;
            }
            field("PDC Branding File"; Rec."PDC Branding File")
            {
                ToolTip = 'Branding File';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

