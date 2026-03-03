/// <summary>
/// PageExtension PDCPurchaseOrderSubform (ID 50016) extends Record Purchase Order Subform.
/// </summary>
pageextension 50016 PDCPurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = LineStyle;
        }
        modify(Description)
        {
            StyleExpr = LineStyle;
        }
        addafter("No.")
        {
            field(PDCVendorItemNo; Rec."Vendor Item No.")
            {
                ToolTip = 'Vendor Item No.';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field(PDCSkipPmtDiscount; Rec."PDC Skip Pmt. Discount")
            {
                ToolTip = 'Skip Pmt. Discount';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

    var
        LineStyle: Text;

    trigger OnAfterGetRecord()
    begin
        LineStyle := 'Standard';
        if (Rec.Quantity = Rec."Quantity Received") and (Rec.Quantity = Rec."Quantity Invoiced") then
            LineStyle := 'Subordinate'
        else
            if (Rec."Quantity Received" < Rec.Quantity) then
                LineStyle := 'Unfavorable';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;
    end;
}

