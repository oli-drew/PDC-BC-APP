/// <summary>
/// PageExtension PDCPurchaseOrder (ID 50015) extends Record Purchase Order.
/// </summary>
pageextension 50015 PDCPurchaseOrder extends "Purchase Order"
{
    layout
    {
        addafter("Buy-from Post Code")
        {
            field(PDCBuyfromCountryRegionCode; Rec."Buy-from Country/Region Code")
            {
                ToolTip = 'Buy-from Country/Region Code';
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field(PDCRollOutNo; Rec."PDC Roll-Out No.")
            {
                ToolTip = 'Roll-Out No.';
                ApplicationArea = All;
            }
            field(PDCEstimatedReceiptDate; Rec."PDC Estimated Receipt Date")
            {
                ToolTip = 'Estimated Receipt Date';
                ApplicationArea = All;
            }
        }
        addfirst(FactBoxes)
        {
            part(PDCReservationEntries; "PDC Purch Res. Entry FactBox")
            {
                ApplicationArea = All;
                Caption = 'Reservation Entries';
                Provider = PurchLines;
                SubPageLink = "Source Type" = const(39),
                              "Source Subtype" = field("Document Type"),
                              "Source ID" = field("Document No."),
                              "Source Ref. No." = field("Line No.");
            }
        }
    }
    actions
    {
        addafter(MoveNegativeLines)
        {
            action(PDCExportToFile)
            {
                ApplicationArea = All;
                Caption = 'Export to File';
                ToolTip = 'Export to File';
                Ellipsis = true;
                Image = ExportFile;

                trigger OnAction()
                begin
                    Rec.ExportPO();
                end;
            }
        }
        addafter(Post)
        {
            action(PDCReceiveToday)
            {
                ApplicationArea = All;
                Caption = 'Receive Today';
                ToolTip = 'Receive Today';
                Ellipsis = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    PurchPostYesNo: Codeunit "PDC Functions";
                begin
                    PurchPostYesNo.PurchPostReceiveToday(Rec, false);
                end;
            }
            action(PDCReceiveTodayLabel)
            {
                ApplicationArea = All;
                Caption = 'Receive Today & Label';
                ToolTip = 'Receive Today & Label';
                Ellipsis = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    PurchPostYesNo: Codeunit "PDC Functions";
                begin
                    PurchPostYesNo.PurchPostReceiveToday(Rec, true);
                end;
            }
            action(PDCReceiveTodayLabelProd)
            {
                ApplicationArea = All;
                Caption = 'Receive Today & PO Label & Prod';
                ToolTip = 'Receives the purchase order items for the current work date, prints purchase order labels, processes related production orders, and prints production labels.';
                Ellipsis = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    PDCFunctions: Codeunit "PDC Functions";
                begin
                    PDCFunctions.PurchPostReceiveTodayAndProduction(Rec, true);
                end;
            }
        }
        addafter("&Print")
        {
            action("PDC Purchase Order Labels")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Labels';
                ToolTip = 'Purchase Order Labels';
                Image = PrintForm;

                trigger OnAction()
                var
                    PurchHeader1: Record "Purchase Header";
                begin
                    PurchHeader1.Get(Rec."Document Type", Rec."No.");
                    PurchHeader1.SetRecfilter();
                    Report.Run(Report::"PDC Purchase Order Labels", true, false, PurchHeader1);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(PDCExportToFile_Promoted; PDCExportToFile)
            {
            }
        }
        addlast(Category_Category6)
        {
            actionref(PDCReceiveToday_Promoted; PDCReceiveToday)
            {
            }
            actionref(PDCReceiveTodayLabel_Promoted; PDCReceiveTodayLabel)
            {
            }
            actionref(PDCReceiveTodayLabelProd_Promoted; PDCReceiveTodayLabelProd)
            {
            }
        }
        addlast(Category_Category10)
        {
            actionref("PDC Purchase Order Labels_Promoted"; "PDC Purchase Order Labels")
            {
            }
        }
    }
}

