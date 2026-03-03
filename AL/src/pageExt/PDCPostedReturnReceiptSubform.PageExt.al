/// <summary>
/// PageExtension PDCPostedReturnReceiptSubform (ID 50064) extends Record Posted Return Receipt Subform.
/// </summary>
pageextension 50064 PDCPostedReturnReceiptSubform extends "Posted Return Receipt Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(PDCContractNo; Rec."PDC Contract No.")
            {
                ToolTip = 'Contract No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

