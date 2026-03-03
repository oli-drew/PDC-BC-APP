/// <summary>
/// PageExtension PDCShippingAgentServices (ID 50070) extends Record Shipping Agent Services.
/// </summary>
pageextension 50070 PDCShippingAgentServices extends "Shipping Agent Services"
{
    layout
    {
        addafter(CustomizedCalendar)
        {
            field("PDC Carriage Charge"; Rec."PDC Carriage Charge")
            {
                ToolTip = 'Carriage Charge';
                ApplicationArea = All;
            }
            field("PDC Carriage Charge Limit"; Rec."PDC Carriage Charge Limit")
            {
                ToolTip = 'Carriage Charge Limit';
                ApplicationArea = All;
            }
            field("PDC Carriage Charge Type"; Rec."PDC Carriage Charge Type")
            {
                ToolTip = 'Carriage Charge Type';
                ApplicationArea = All;
            }
            field("PDC Carriage Charge No."; Rec."PDC Carriage Charge No.")
            {
                ToolTip = 'Carriage Charge No.';
                ApplicationArea = All;
            }
            field("PDC Show On Portal"; Rec."PDC Show On Portal")
            {
                ToolTip = 'Show On Portal';
                ApplicationArea = All;
            }
            field("PDC Check Carriage Limit"; Rec."PDC Check Carriage Limit")
            {
                ToolTip = 'Check Carriage Limit';
                ApplicationArea = All;
            }
            field("PDC Country/Region Code"; Rec."PDC Country/Region Code")
            {
                ToolTip = 'Country/Region Code';
                ApplicationArea = All;
            }
            field("PDC Portal Sequence"; Rec."PDC Portal Sequence")
            {
                ToolTip = 'Portal Sequence';
                ApplicationArea = All;
            }
            field("PDC Service Code"; Rec."PDC Service Code")
            {
                ToolTip = 'Service Code';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action("PDC Service Per Customer")
            {
                ApplicationArea = All;
                Caption = 'Service Per Customer';
                ToolTip = 'Service Per Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Ship.Agent Serv. Per Cust.";
                RunPageLink = "Shipping Agent Code" = FIELD("Shipping Agent Code"), "Shipping Agent Service Code" = FIELD(Code);
            }
        }
    }
}
