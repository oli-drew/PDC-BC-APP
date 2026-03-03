/// <summary>
/// Page PDC Sales Shipments (ID 50015).
/// </summary>
page 50015 "PDC Sales Shipments"
{
    Caption = 'Sales Shipments';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Permissions = TableData "Sales Shipment Header" = rim;
    SourceTable = "Sales Shipment Header";

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
                field(NoFilter; g_NoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'No.';

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
                field(ShowNewOnly; g_New)
                {
                    ApplicationArea = All;
                    Caption = 'Show New Only';
                    ToolTip = 'Show New Only';

                    trigger OnValidate()
                    begin
                        FilterLines();
                    end;
                }
            }
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'No.';

                    trigger OnAssistEdit()
                    begin
                        Page.Run(130, Rec);
                    end;
                }
                field(Control1000000026; Rec."PDC Consignment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Consignment No.';
                    ShowCaption = false;
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Name';
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Name';
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Address 2';
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to City';
                }
                field(ShiptoCounty; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to County';
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Post Code';
                }
                field("PDC Ship-to Mobile Phone No."; Rec."PDC Ship-to Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Mobile Phone No.';
                }
                field("PDC Ship-to E-Mail"; Rec."PDC Ship-to E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to E-Mail';
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Contact';
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
                    Caption = 'Contact Email';
                    ToolTip = 'Contact Email';
                }
                field(Control1000000014; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipment Date';
                    ShowCaption = false;
                }
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
                field(WebOrderNo; Rec."PDC WebOrder No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'WebOrder No.';
                }
                field(NumberOfPackages; Rec."PDC Number Of Packages")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number Of Packages';
                }
                field("Package Type"; Rec."PDC Package Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Package Type';
                }
                field(Notes; Rec."PDC Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Notes';
                }
                field(OrderSource; Rec."PDC Order Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Order Source';
                }
                field(SenttoCourier; Rec."PDC Sent to Courier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sent to Courier';
                }
                field(SenttoCourierDateTime; Rec."PDC Sent to Courier Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sent to Courier Date Time';
                }
                field(Released; Rec."PDC Released")
                {
                    ApplicationArea = All;
                    ToolTip = 'Released';
                }
                field(ShipmentError; Rec."PDC Shipment Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipment Error';
                }
                field(ErrorText; ErrorText)
                {
                    Caption = 'Error Text';
                    ToolTip = 'Error Text';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Shipment)
            {
                Caption = '&Shipment';
                Image = Shipment;
                action(CourierSalesShipments)
                {
                    ApplicationArea = All;
                    Caption = 'Courier Sales Shipments';
                    ToolTip = 'Courier Sales Shipments';
                    Image = Shipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "PDC Courier Sales Shipments";
                    RunPageLink = SalesShipmentHeaderNo = field("No.");
                    ShortCutKey = 'F7';
                }
                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    ToolTip = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = const(Shipment),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                }
            }
        }
        area(processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                ToolTip = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    UPSShipmentHeader: Record PDCCourierShipmentHeader;
                begin
                    Rec.SendToUPSTable();
                    UPSShipmentHeader.Send_InsertShipment(Rec."No.");
                end;
            }
            action("Parcels Info")
            {
                ApplicationArea = All;
                Caption = 'Parcels Info';
                ToolTip = 'Parcels Info';
                Image = PhysicalInventory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Parcels Info";
                RunPageLink = SalesShipmentNo = field("No.");
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
                var
                    UPSShipmentHeader: Record PDCCourierShipmentHeader;
                begin
                    UPSShipmentHeader.LabelRequest(Rec."No.");
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
                var
                    UPSShipmentHeader: Record PDCCourierShipmentHeader;
                begin
                    UPSShipmentHeader.LabelPreview(Rec."No.");
                end;
            }
            separator(Separator2)
            {
            }
            action("Release&Print")
            {
                ApplicationArea = All;
                Caption = 'Release&Print';
                ToolTip = 'Release&Print';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UPSShipmentHeader: Record PDCCourierShipmentHeader;
                begin
                    Rec.SendToUPSTable();
                    UPSShipmentHeader.Send_InsertShipment(Rec."No.");
                    UPSShipmentHeader.LabelRequest(Rec."No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PDCCourierShipmentHeader: Record PDCCourierShipmentHeader;
    begin
        if not g_Contact.Get(Rec."Sell-to Contact No.") then
            g_Contact.Init();

        clear(ErrorText);
        if Rec."PDC Shipment Error" then begin
            PDCCourierShipmentHeader.setrange(SalesShipmentHeaderNo, Rec."No.");
            PDCCourierShipmentHeader.setrange(Deleted, false);
            PDCCourierShipmentHeader.setfilter(errorCode, '<>%1', '');
            if PDCCourierShipmentHeader.FindFirst() then
                ErrorText := PDCCourierShipmentHeader.errorMessage;
        end;
    end;

    trigger OnOpenPage()
    begin
        g_New := true;
        FilterLines();
    end;

    var
        g_Contact: Record Contact;
        g_DateFilter: Text;
        g_ConsignmentFilter: Code[100];
        g_NoFilter: Code[100];
        g_PostCodeFilter: Code[50];
        g_New: Boolean;
        ErrorText: text;

    local procedure FilterLines()
    begin
        if g_DateFilter <> '' then
            Rec.SetFilter("Shipment Date", g_DateFilter)
        else
            Rec.SetRange("Shipment Date");

        if g_NoFilter <> '' then
            Rec.SetFilter("No.", g_NoFilter)
        else
            Rec.SetRange("No.");

        if g_ConsignmentFilter <> '' then
            Rec.SetFilter("PDC Consignment No.", g_ConsignmentFilter)
        else
            Rec.SetRange("PDC Consignment No.");

        if g_PostCodeFilter <> '' then
            Rec.SetFilter("Sell-to Post Code", g_PostCodeFilter)
        else
            Rec.SetRange("Sell-to Post Code");

        if g_New then
            Rec.SetRange("PDC Released", false)
        else
            Rec.SetRange("PDC Released");

        CurrPage.Update(false);
    end;
}

