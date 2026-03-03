/// <summary>
/// Page PDC Ship.Agent Serv. Per Cust. (ID 50069).
/// </summary>
page 50069 "PDC Ship.Agent Serv. Per Cust."
{
    Caption = 'Shipping Agent Services Per Customer';
    PageType = List;
    SourceTable = "PDC Ship.Agent Serv. Per Cust.";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Shipping Agent Code';
                    ApplicationArea = All;
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ToolTip = 'Shipping Agent Service Code';
                    ApplicationArea = All;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field(CarriageCharge; Rec."Carriage Charge")
                {
                    ToolTip = 'Carriage Charge';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

