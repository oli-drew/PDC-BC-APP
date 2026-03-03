/// <summary>
/// PageExtension PDCSalesOrderList (ID 50035) extends Record Sales Order List.
/// </summary>
pageextension 50035 PDCSalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = LineStyleExpr;
        }
        modify("Sell-to Customer No.")
        {
            StyleExpr = LineStyleExpr;
        }
        modify("Sell-to Customer Name")
        {
            StyleExpr = LineStyleExpr;
        }
        modify("Requested Delivery Date")
        {
            Caption = 'Requested Despatch Date';
            StyleExpr = LineStyleExpr;
        }
        addafter(Status)
        {
            field(PDCRollOutNo; Rec."PDC Roll-Out No.")
            {
                ToolTip = 'Roll-Out No.';
                ApplicationArea = All;
            }
            field(PDCRollOutDate; PDCRollout."Deadline Date")
            {
                ApplicationArea = All;
                Caption = 'Roll-Out Deadline Date';
                ToolTip = 'Roll-Out Deadline Date';
                Editable = false;
            }
        }
        addafter("Job Queue Status")
        {
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
            field("PDC Notes"; Rec."PDC Notes")
            {
                ToolTip = 'Notes';
                ApplicationArea = All;
            }
            field(PDCLastShippingNo; Rec."Last Shipping No.")
            {
                ToolTip = 'Last Shipping No.';
                ApplicationArea = All;
            }
            field(PDCLastPickingNo; Rec."PDC Last Picking No.")
            {
                ToolTip = 'Last Picking No.';
                ApplicationArea = All;
            }
            field(PDCWarehouseDocumentNo; Rec."PDC Warehouse Document No.")
            {
                ToolTip = 'Warehouse Document No.';
                ApplicationArea = All;
            }
            field(PDCCreatedAt; Rec."PDC Created At")
            {
                ToolTip = 'Created At';
                ApplicationArea = All;
            }
            field(PDCCalcOutstandingAmt; Rec.CalcOutstandingAmt(false))
            {
                Caption = 'Outstanding Amount';
                ToolTip = 'Outstanding Amount';
                ApplicationArea = All;
                Editable = false;
            }
            field(PDCCalcOutstandingAmtInclVAT; Rec.CalcOutstandingAmt(true))
            {
                Caption = 'Outstanding Amount incl. VAT';
                ToolTip = 'Outstanding Amount incl. VAT';
                ApplicationArea = All;
                Editable = false;
            }
            field("PDC Urgent"; Rec."PDC Urgent")
            {
                ToolTip = 'Urgent';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Reopen)
        {
            action("PDC Release and Pick")
            {
                ApplicationArea = All;
                Caption = 'Release and Pick';
                ToolTip = 'Release and Pick';
                Image = PickWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    ReleaseSalesDocument: Codeunit "Release Sales Document";
                begin
                    ReleaseSalesDocument.PerformManualRelease(Rec);
                    if Rec.Status = Rec.Status::Released then begin
                        Rec.SetAutoCreatePutAway(true);
                        Customer.Get(Rec."Sell-to Customer No.");
                        if Customer."PDC Allow Auto-Pick" then
                            Rec.PDCCreateInvtPutAwayPick();
                    end;
                end;
            }
        }
        addlast("F&unctions")
        {
            action(PDCAutoReserveLines)
            {
                ApplicationArea = All;
                Caption = 'Auto Reserve lines';
                ToolTip = 'Auto Reserve lines';
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PDCFunctions: Codeunit "PDC Functions";
                begin
                    PDCFunctions.SalesOrderAutoReserve();
                end;
            }
        }
        addafter("Send IC Sales Order Cnfmn.")
        {
            action(PDCCalcReqDeliveryDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Req.Despatch Date';
                ToolTip = 'Calculate Req.Despatch Date';
                Image = Calendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CalcReqDeliveryDate();
                    Rec.Modify();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not PDCRollout.get(Rec."PDC Roll-Out No.") then clear(PDCRollout);
        LineStyleExpr := 'standard';
        if Rec."Requested Delivery Date" < WorkDate() then
            LineStyleExpr := 'unfavorable';
    end;

    var
        PDCRollout: Record "PDC Roll-out";
        LineStyleExpr: Text;

}

