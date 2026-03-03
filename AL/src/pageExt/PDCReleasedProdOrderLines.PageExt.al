/// <summary>
/// PageExtension "PDC Released"ProdOrderLines (ID 50040) extends Record Released Prod. Order Lines.
/// </summary>
pageextension 50040 PDCReleasedProdOrderLines extends "Released Prod. Order Lines"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field(PDCPurchaseDocumentNo; Rec."PDC Purchase Document No.")
            {
                ToolTip = 'Purchase Document No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

