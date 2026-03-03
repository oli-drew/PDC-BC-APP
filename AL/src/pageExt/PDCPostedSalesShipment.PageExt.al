/// <summary>
/// PageExtension PDCPostedSalesShipment (ID 50025) extends Record Posted Sales Shipment.
/// </summary>
pageextension 50025 PDCPostedSalesShipment extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("PDC Notes"; Rec."PDC Notes")
            {
                ToolTip = 'Notes';
                ApplicationArea = All;
                Editable = false;
            }
            field("PDC Last Picking No."; Rec."PDC Last Picking No.")
            {
                ToolTip = 'Last Picking No.';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Ship-to Contact")
        {
            field(PDCShiptoEMail; Rec."PDC Ship-to E-Mail")
            {
                ToolTip = 'Ship-to E-Mail';
                ApplicationArea = All;
                Editable = false;
            }
            field(PDCShiptoMobilePhoneNo; Rec."PDC Ship-to Mobile Phone No.")
            {
                ToolTip = 'Ship-to Mobile Phone No.';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
    }
}

