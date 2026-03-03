/// <summary>
/// PageExtension PDCPurchCrMemoSubform (ID 50021) extends Record Purch. Cr. Memo Subform.
/// </summary>
pageextension 50021 PDCPurchCrMemoSubform extends "Purch. Cr. Memo Subform"
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

