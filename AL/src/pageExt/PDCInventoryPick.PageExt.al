/// <summary>
/// PageExtension PDCInventoryPick (ID 50067) extends Record Inventory Pick.
/// </summary>
pageextension 50067 PDCInventoryPick extends "Inventory Pick"
{
    layout
    {
        addafter("External Document No.2")
        {
            field("PDC Urgent"; Rec."PDC Urgent")
            {
                ToolTip = 'Urgent';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addlast(Content)
        {
            group(PDCShipping)
            {
                Caption = 'Shipping';

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
            }
            group(PDCPaperlessPicking)
            {
                Caption = 'Paperless Picking';

                field(PDCTrolleyCode; Rec."PDC Trolley Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The trolley assigned to this inventory pick.';
                }
                field(PDCPickStatus; Rec."PDC Pick Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The current pick status.';
                    Editable = false;
                    StyleExpr = PickStatusStyle;
                }
                field(PDCPickedBy; Rec."PDC Picked By")
                {
                    ApplicationArea = All;
                    ToolTip = 'The user who is picking this order.';
                    Editable = false;
                }
                field(PDCPickStartedAt; Rec."PDC Pick Started At")
                {
                    ApplicationArea = All;
                    ToolTip = 'When picking started.';
                    Editable = false;
                }
                field(PDCPickCompletedAt; Rec."PDC Pick Completed At")
                {
                    ApplicationArea = All;
                    ToolTip = 'When picking was completed.';
                    Editable = false;
                }
                field(PDCTotalQuantity; Rec."PDC Total Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total quantity across all pick lines.';
                    Editable = false;
                }
                field(PDCUniqueWearers; Rec."PDC Unique Wearers")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of unique wearers on this pick.';
                    Editable = false;
                }
                field(PDCTotalLines; Rec."PDC Total Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total number of pick lines.';
                    Editable = false;
                }
            }
        }
        addfirst(FactBoxes)
        {
            part(PDCPickSlots; "PDC Trolley Slot Subform")
            {
                ApplicationArea = All;
                Caption = 'Trolley Slots';
                SubPageLink = "Inv Pick No." = field("No.");
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

    trigger OnAfterGetRecord()
    var
        PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
    begin
        if Rec."PDC Unique Wearers" = 0 then begin
            PDCPickStatusMgt.RecalcUniqueWearers(Rec."No.");
            Rec.Find();
        end;
        SetPickStatusStyle();
    end;

    var
        PickStatusStyle: Text;

    local procedure SetPickStatusStyle()
    begin
        case Rec."PDC Pick Status" of
            Rec."PDC Pick Status"::Complete:
                PickStatusStyle := 'Favorable';
            Rec."PDC Pick Status"::"In Progress":
                PickStatusStyle := 'Ambiguous';
            else
                PickStatusStyle := 'Standard';
        end;
    end;
}

