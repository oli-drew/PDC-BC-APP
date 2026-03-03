/// <summary>
/// PageExtension PDCPurchInvoiceSubform (ID 50017) extends Record Purch. Invoice Subform.
/// </summary>
pageextension 50017 PDCPurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;
    end;
}

