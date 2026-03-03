/// <summary>
/// PageExtension PDCPurchaseReturnOrderSubform (ID 50063) extends Record Purchase Return Order Subform.
/// </summary>
pageextension 50063 PDCPurchaseReturnOrderSubform extends "Purchase Return Order Subform"
{
    layout
    {
        addlast(Content)
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
}

