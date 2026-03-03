/// <summary>
/// PageExtension PDCSalesQuote (ID 50009) extends Record Sales Quote.
/// </summary>
pageextension 50009 PDCSalesQuote extends "Sales Quote"
{
    layout
    {
        addafter("Requested Delivery Date")
        {
            field(PDCExternalDocumentNo; Rec."External Document No.")
            {
                ToolTip = 'External Document No.';
                ApplicationArea = All;
            }
        }
        addafter("No. of Archived Versions")
        {
            field("PDC Notes"; Rec."PDC Notes")
            {
                ToolTip = 'Notes';
                ApplicationArea = All;
            }
            field(PDCOrderSource; Rec."PDC Order Source")
            {
                ToolTip = 'Order Source';
                ApplicationArea = All;
            }
            field(PDCOrderStatus; Rec."PDC Order Status")
            {
                ToolTip = 'Order Status';
                ApplicationArea = All;
            }
            field(PDCCheckedBy; Rec."PDC Checked By")
            {
                ToolTip = 'Checked By';
                ApplicationArea = All;
            }
            field(PDCRollOutNo; Rec."PDC Roll-Out No.")
            {
                ToolTip = 'Roll-Out No.';
                ApplicationArea = All;
            }
        }
        addafter("Ship-to County")
        {
            field(PDCHomeAddress; Rec."PDC Home Address")
            {
                ToolTip = 'Home Address';
                ApplicationArea = All;
            }
        }
        addafter("Ship-to Contact")
        {
            field(PDCShiptoEMail; Rec."PDC Ship-to E-Mail")
            {
                ToolTip = 'Ship-to E-Mail';
                ApplicationArea = All;
            }
            field(PDCShiptoMobilePhoneNo; Rec."PDC Ship-to Mobile Phone No.")
            {
                ToolTip = 'Ship-to Mobile Phone No.';
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
        {
            field(PDCOutboundWhseHandlingTime; Rec."Outbound Whse. Handling Time")
            {
                ToolTip = 'Outbound Whse. Handling Time';
                ApplicationArea = All;
            }
        }
        addafter("Shipment Method Code")
        {
            field(PDCShippingAgentCode; Rec."Shipping Agent Code")
            {
                ToolTip = 'Shipping Agent Code';
                ApplicationArea = All;
                Importance = Additional;
            }
            field(PDCShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            {
                ToolTip = 'Shipping Agent Service Code';
                ApplicationArea = All;
                Importance = Additional;
            }
        }
        addafter("Shipment Date")
        {
            field(PDCShippingAdvice; Rec."Shipping Advice")
            {
                ToolTip = 'Shipping Advice';
                ApplicationArea = All;
                Importance = Promoted;
            }
            field(PDCShippingTime; Rec."Shipping Time")
            {
                ToolTip = 'Shipping Time';
                ApplicationArea = All;
            }
            field(PDCPackageTrackingNo; Rec."Package Tracking No.")
            {
                ToolTip = 'Package Tracking No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

