/// <summary>
/// Page PDC Parcels Info (ID 50050) shows list pr Parcels with tracking information.
/// </summary>
page 50050 "PDC Parcels Info"
{
    Caption = 'Parcels Info';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "PDC Parcels Info";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1101975008)
            {
                ShowCaption = false;
                field(ConsignmentNumber; Rec.ConsignmentNumber)
                {
                    ToolTip = 'ConsignmentNumber';
                    ApplicationArea = All;
                }
            }
            repeater(Group)
            {
                field(ParcelNumber; Rec.ParcelNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Parcel Number';
                }
                field(ParcelCode; Rec.ParcelCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Parcel Code';
                }
                field(StatusCode; Rec.StatusCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Status Code';
                }
                field(StatusDateTime; Rec.StatusDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Status DateTime';
                }
                field(StatusDescription; Rec.StatusDescription)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Status Description';
                }
                field(ErrorText; Rec.ErrorText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Error Text';
                }
                field(StopTracking; Rec."Stop Tracking")
                {
                    ApplicationArea = All;
                    ToolTip = 'Stop Tracking';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Status';
                }
                field(DeliveredDate; Rec."Delivered Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Delivered Date';
                }
                field(SalesShipmentNo; Rec.SalesShipmentNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Sales Shipment No.';
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Customer No.';
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Customer Name';
                }
                field(ShipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipment Date';
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Post Code';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipping Agent Code';
                }
                field(LastTrackDT; Rec."Last Track DT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Last Track DT';
                }
                field("Return Status"; Rec."Return Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Return Status';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Tracking)
            {
                Caption = 'Tracking';
                ToolTip = 'Tracking';
                ApplicationArea = All;
                Image = Track;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.TrackingRequest(Rec.ConsignmentNumber);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Deleted, false); //27.11.2017 JEMEL J.Jemeljanovs #2415
    end;
}

