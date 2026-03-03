/// <summary>
/// Page PDC Courier Sales Shipments (ID 50016).
/// </summary>
page 50016 "PDC Courier Sales Shipments"
{
    Caption = 'Courier Sales Shipments';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = PDCCourierShipmentHeader;
    SourceTableView = sorting(ConsignmentNo)
                      order(descending);

    layout
    {
        area(content)
        {
            group(Filters)
            {
                field(ShipmentDate; g_DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Date';
                    ToolTip = 'Shipment Date';

                    trigger OnValidate()
                    begin
                        FilterLines();
                    end;
                }
                field(ConsignmentNo; g_ConsignmentFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Consignment No.';
                    ToolTip = 'Consignment No.';

                    trigger OnValidate()
                    begin
                        FilterLines();
                    end;
                }
                field(PostCode; g_PostCodeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Post Code';
                    ToolTip = 'Post Code';

                    trigger OnValidate()
                    begin
                        FilterLines();
                    end;
                }
            }
            repeater(Group)
            {
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipping Agent Code';
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipping Agent Service Code';
                }
                field(Control1120034010; Rec.ConsignmentNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Consignment No.';
                    ShowCaption = false;
                }
                field(SellToCustomerNo; Rec.SellToCustomerNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-To Customer No.';
                }
                field(SalesShipmentHeaderNo; Rec.SalesShipmentHeaderNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Sales Shipment Header No.';
                }
                field(OriginalOrderNo; Rec.OriginalOrderNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Original Order No.';
                }
                field(ShipToName2; Rec.ShipToName2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Name 2';
                }
                field(ShipToAddress; Rec.ShipToAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Address';
                }
                field(ShipToAddress2; Rec.ShipToAddress2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Address 2';
                }
                field(ShipToCity; Rec.ShipToCity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To City';
                }
                field(ShipToContact; Rec.ShipToContact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Contact';
                }
                field(ShipToCountryRegionCode; Rec.ShipToCountryRegionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Country/Region Code';
                }
                field(ShipToCounty; Rec.ShipToCounty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To County';
                }
                field(Phone; Rec.Phone)
                {
                    ApplicationArea = All;
                    ToolTip = 'Phone';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Notes';
                }
                field(Contact; g_Contact.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Contact';
                }
                field(Email; g_Contact."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Email';
                }
                field(ShipToCode; Rec.ShipToCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Code';
                }
                field(ShipToName; Rec.ShipToName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-To Name';
                }
                field(Bill; Rec.Bill)
                {
                    ApplicationArea = All;
                    ToolTip = 'Bill';
                }
                field(PackageType; Rec.PackageType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Package Type';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Weight';
                }
                field(NumberOfPackages; Rec.NumberOfPackages)
                {
                    ApplicationArea = All;
                    ToolTip = 'Number Of Packages';
                }
                field(Memo; Rec.Memo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Memo';
                }
                field(OrdererName; Rec.OrdererName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Orderer Name';
                }
                field(SenttoCourier; Rec."Sent to Courier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sent to Courier';
                    Editable = false;
                }
                field(shipmentId; Rec.shipmentId)
                {
                    ApplicationArea = All;
                    ToolTip = 'shipmentId';
                }
                field(consignmentNumber; Rec.consignmentNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'consignmentNumber';
                }
                field(errorCode; Rec.errorCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'errorCode';
                }
                field(errorMessage; Rec.errorMessage)
                {
                    ApplicationArea = All;
                    ToolTip = 'errorMessage';
                }
                field(errorObject; Rec.errorObject)
                {
                    ApplicationArea = All;
                    ToolTip = 'errorObject';
                }
                field(Deleted; Rec.Deleted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Deleted';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Send)
            {
                ApplicationArea = All;
                Caption = 'Send';
                ToolTip = 'Send';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.Send_InsertShipment(Rec.SalesShipmentHeaderNo);
                end;
            }
            action("Parcels Info")
            {
                Caption = 'Parcels Info';
                ToolTip = 'Parcels Info';
                ApplicationArea = All;
                Image = PhysicalInventory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Parcels Info";
                RunPageLink = SalesShipmentNo = field(SalesShipmentHeaderNo);
                RunPageView = sorting(ConsignmentNumber, ParcelNumber);
            }
            action("Open Label")
            {
                ApplicationArea = All;
                Caption = 'Open Label';
                ToolTip = 'Open Label';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.LabelRequest(Rec.SalesShipmentHeaderNo);
                end;
            }
            action("Preview Label")
            {
                ApplicationArea = All;
                Caption = 'Preview Label';
                ToolTip = 'Preview Label';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.LabelPreview(Rec.SalesShipmentHeaderNo);
                end;
            }
            action("DPD Update Parcels Info Status")
            {
                ApplicationArea = All;
                Caption = 'DPD Update Parcels Info Status';
                ToolTip = 'DPD Update Parcels Info Status';
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "PDC Update Parcels Info Status";
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.FindFirst() then;
    end;

    var
        g_Contact: Record Contact;
        g_DateFilter: Text;
        g_ConsignmentFilter: Code[100];
        g_PostCodeFilter: Code[50];


    local procedure FilterLines()
    begin
        if g_DateFilter <> '' then
            Rec.SetFilter(ShipToCode, g_DateFilter)
        else
            Rec.SetRange(ShipToCode);

        if g_ConsignmentFilter <> '' then
            Rec.SetFilter(SalesShipmentHeaderNo, g_ConsignmentFilter)
        else
            Rec.SetRange(SalesShipmentHeaderNo);

        if g_PostCodeFilter <> '' then
            Rec.SetFilter(ShipToCounty, g_PostCodeFilter)
        else
            Rec.SetRange(ShipToCounty);
        CurrPage.Update(false);
    end;
}

