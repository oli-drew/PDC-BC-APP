/// <summary>
/// PageExtension PDCSalesOrder (ID 50010) extends Record Sales Order.
/// </summary>
pageextension 50010 PDCSalesOrder extends "Sales Order"
{
    layout
    {
        modify("Requested Delivery Date")
        {
            Caption = 'Requested Despatch Date';
        }

        addafter(Status)
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
                ShowMandatory = true;
            }
            field(PDCOrderStatus; Rec."PDC Order Status")
            {
                ToolTip = 'Order Status';
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field(PDCCheckedBy; Rec."PDC Checked By")
            {
                ToolTip = 'Checked By';
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
            field(PDCRollOutNo; Rec."PDC Roll-Out No.")
            {
                ToolTip = 'Roll-Out No.';
                ApplicationArea = All;
            }
            field(PDCRollOutDate; PDCRollout."Deadline Date")
            {
                Caption = 'Roll-Out Deadline Date';
                ToolTip = 'Roll-Out Deadline Date';
                Editable = false;
                ApplicationArea = All;
            }
            field("PDC Urgent"; Rec."PDC Urgent")
            {
                ToolTip = 'Urgent';
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
            field("PDC Delivery Instruction"; Rec."PDC Delivery Instruction")
            {
                ToolTip = 'Delivery Instruction';
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(PDCMakeQuote)
            {
                ApplicationArea = All;
                Caption = 'Make &Quote';
                ToolTip = 'Make Quote';
                Image = MakeOrder;

                trigger OnAction()
                var
                    SalesHeader1: Record "Sales Header";
                begin
                    if Confirm(Text003Lbl, false, Rec."No.") then begin
                        SalesHeader1.Get(Rec."Document Type", Rec."No.");
                        SalesHeader1.SetRecfilter();
                        Report.Run(Report::"PDC Create Quote From Order", false, false, SalesHeader1);
                    end;
                end;
            }
            action(PDCCalcReqDeliveryDate)
            {
                ApplicationArea = All;
                Caption = 'Calculate Req.Despatch Date';
                ToolTip = 'Calculate Req.Despatch Date';
                Image = Calendar;

                trigger OnAction()
                begin
                    Rec.CalcReqDeliveryDate();
                end;
            }
        }
        addlast(Action21)
        {
            action(PDCReleasePickPrint)
            {
                ApplicationArea = All;
                Caption = 'Release & Create Inv.Pick';
                ToolTip = 'Release & Create Inv.Pick';
                Image = ReleaseDoc;

                trigger OnAction()
                begin
                    Rec.PerformReleasePickPrint();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(PDCMakeQuote_Promoted; PDCMakeQuote)
            {
            }
            actionref(PDCCalcReqDeliveryDate_Promoted; PDCCalcReqDeliveryDate)
            {
            }
        }
        addlast(Category_Category5)
        {
            actionref(PDCReleasePickPrint_Promoted; PDCReleasePickPrint)
            {
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not PDCRollout.get(Rec."PDC Roll-Out No.") then Clear(PDCRollout);
    end;

    var
        PDCRollout: Record "PDC Roll-out";
        Text003Lbl: label 'Do you want to create Quote from Order %1?', Comment = 'Do you want to create Quote from Order %1?';
}

