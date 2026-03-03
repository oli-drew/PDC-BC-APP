/// <summary>
/// PageExtension PDCInventoryPick (ID 50067) extends Record Inventory Pick.
/// </summary>
pageextension 50067 PDCInventoryPick extends "Inventory Pick"
{
    layout
    {
        addafter("External Document No.2")
        {
            field(PDCShippingAgentCode; Rec."PDC Shipping Agent Code")
            {
                ApplicationArea = All;
                ToolTip = 'Shipping Agent Code';
            }
            field(PDCShippingAgentServiceCode; Rec."PDC Shipping Agent Serv. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Shipping Agent Service Code';
            }
            field(PDCNumberOfPackages; Rec."PDC Number Of Packages")
            {
                ApplicationArea = All;
                ToolTip = 'Number Of Packages';
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
            field(PDCPackageType; Rec."PDC Package Type")
            {
                ApplicationArea = All;
                ToolTip = 'Package Type';
            }
            field("PDC Urgent"; Rec."PDC Urgent")
            {
                ToolTip = 'Urgent';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addlast("P&ick")
        {
            action(PDCShipments)
            {
                ApplicationArea = All;
                Caption = 'S&hipments';
                ToolTip = 'Shipments';
                Image = Shipment;
                RunObject = Page "Posted Sales Shipments";
                RunPageLink = "Order No." = field("Source No.");
                RunPageView = sorting("Order No.");
            }
        }
        addafter(PostAndPrint)
        {
            action(PDCPostPrintandSendInvoice)
            {
                ApplicationArea = All;
                Caption = 'Post, &Print and Send Invoice';
                ToolTip = 'Post, &Print and Send Invoice';
                Image = PostMail;

                trigger OnAction()
                begin
                    PostAndPrintAndSend();
                end;
            }
        }
        addlast(reporting)
        {
            action(PDCPickNote)
            {
                ApplicationArea = All;
                Caption = 'Pick Note PDC';
                ToolTip = 'Pick Note PDC';

                trigger OnAction()
                var
                    WhsActHdr: Record "Warehouse Activity Header";
                begin
                    WhsActHdr.Get(Rec.Type, Rec."No.");
                    WhsActHdr.SetRecfilter();
                    Report.Run(Report::"PDC Pick List", true, false, WhsActHdr);
                end;
            }
        }
        addlast(Category_Category5)
        {
            actionref(PDCPostPrintandSendInvoice_Promoted; PDCPostPrintandSendInvoice)
            {
            }
        }
        addlast(Category_Process)
        {
            actionref(PDCShipments_Promoted; PDCShipments)
            {
            }
        }
    }

    local procedure PostAndPrintAndSend()
    begin
        CurrPage.WhseActivityLines.Page.PostAndPrintAndEmail();
    end;
}

