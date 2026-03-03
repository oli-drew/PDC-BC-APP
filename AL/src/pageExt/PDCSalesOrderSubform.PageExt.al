/// <summary>
/// PageExtension PDCSalesOrderSubform (ID 50013) extends Record Sales Order Subform.
/// </summary>
pageextension 50013 PDCSalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = ShowAttention;
        }
        modify(Description)
        {
            StyleExpr = ShowAttention;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        addfirst(Control1)
        {
            field(PDCCommentLines; Rec."PDC Comment Lines")
            {
                ToolTip = 'Comment Lines';
                ApplicationArea = All;
                Editable = false;

                trigger OnValidate()
                begin
                    Rec.ShowLineComments();
                end;
            }
        }
        addafter("No.")
        {
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
        addafter(Quantity)
        {
            field(PDCInventory; Rec.PDCInventory)
            {
                ToolTip = 'Inventory';
                ApplicationArea = All;
            }
            field(PDCFree; g_Free)
            {
                Caption = 'Free';
                ToolTip = 'Free';
                ApplicationArea = All;
                DecimalPlaces = 0 : 0;
            }
        }
        addafter("Reserved Quantity")
        {
            field(PDCReservedFromItemLedgerFld; Rec.ReservedFromItemLedger())
            {
                Caption = 'Reserved from Stock';
                ToolTip = 'Reserved from Stock';
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
        }
        addafter("Line No.")
        {
            field(PDCWearerID; Rec."PDC Wearer ID")
            {
                ToolTip = 'Wearer ID';
                ApplicationArea = All;
            }
            field(PDCWearerName; Rec."PDC Wearer Name")
            {
                ToolTip = 'Wearer Name';
                ApplicationArea = All;
            }
            field(PDCCustomerReference; Rec."PDC Customer Reference")
            {
                ToolTip = 'Customer Reference';
                ApplicationArea = All;
            }
            field(PDCWebOrderNo; Rec."PDC Web Order No.")
            {
                ToolTip = 'Web Order No.';
                ApplicationArea = All;
            }
            field(PDCOrderedByID; Rec."PDC Ordered By ID")
            {
                ToolTip = 'Ordered By ID';
                ApplicationArea = All;
            }
            field(PDCOrderedByName; Rec."PDC Ordered By Name")
            {
                ToolTip = 'Ordered By Name';
                ApplicationArea = All;
            }
            field(PDCContractNo; Rec."PDC Contract No.")
            {
                ToolTip = 'Contract No.';
                ApplicationArea = All;
            }
            field(PDCContractCode; Rec."PDC Contract Code")
            {
                ToolTip = 'Contract Code';
                ApplicationArea = All;
            }
            field(PDCOrderReasonCode; Rec."PDC Order Reason Code")
            {
                ToolTip = 'Order Reason Code';
                ApplicationArea = All;
            }
            field(PDCOrderReason; Rec."PDC Order Reason")
            {
                ToolTip = 'Order Reason';
                ApplicationArea = All;
            }
            field(PDCCreatedByID; Rec."PDC Created By ID")
            {
                ToolTip = 'Created By ID';
                ApplicationArea = All;
            }
            field(PDCCreatedByName; Rec."PDC Created By Name")
            {
                ToolTip = 'Created By Name';
                ApplicationArea = All;
            }
            field(PDCStaffID; Rec."PDC Staff ID")
            {
                ToolTip = 'Staff ID';
                ApplicationArea = All;
            }
        }

        modify("TotalSalesLine.""Line Amount""")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        addlast(Control45)
        {
            field(PDCCalcOutstandingAmt; CalcOutstandingAmtProc(false))
            {
                Caption = 'Outstanding Amount';
                ToolTip = 'Outstanding Amount';
                ApplicationArea = All;
                Editable = false;
            }
            field(PDCCalcOutstandingAmtInclVAT; CalcOutstandingAmtProc(true))
            {
                Caption = 'Outstanding Amount incl. VAT';
                ToolTip = 'Outstanding Amount incl. VAT';
                ApplicationArea = All;
                Editable = false;
            }
        }

    }
    actions
    {
    }

    var
        Item: Record Item;
        SalesInfoPaneManagement: Codeunit "Sales Info-Pane Management";
        ShowAttention: Text;
        g_Free: Decimal;

    trigger OnAfterGetRecord()
    var
    begin
        ShowAttention := 'Standard';
        if Rec.Type = Rec.Type::Item then
            if Rec."No." <> '' then begin
                Item.GET(Rec."No.");
                Item.CALCFIELDS("Assembly BOM");
            end;
        g_Free := SalesInfoPaneManagement.CalcAvailableInventory(Rec) - SalesInfoPaneManagement.CalcGrossRequirements(Rec);
        Rec.CalcFields("Reserved Quantity");
        g_Free += Rec."Reserved Quantity";

        if Rec.Type = Rec.Type::Item then
            if (Rec.Quantity = Rec."Quantity Shipped") And (Rec.Quantity = Rec."Quantity Invoiced") then
                ShowAttention := 'Subordinate'
            else
                if Rec."Qty. to Ship" > Rec."Reserved Quantity" then
                    ShowAttention := 'StandardAccent'
                else
                    if Rec."Qty. to Ship" > Rec.ReservedFromItemLedger() then
                        ShowAttention := 'Unfavorable'
                    else
                        if Rec."Qty. to Ship" = Rec.ReservedFromItemLedger() then
                            ShowAttention := 'Favorable';

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;
    end;

    local procedure CalcOutstandingAmtProc(InclVAT: Boolean): Decimal
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(Rec."Document Type", Rec."Document No.");
        exit(SalesHeader.CalcOutstandingAmt(InclVAT));
    end;
}

