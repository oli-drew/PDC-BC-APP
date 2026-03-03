/// <summary>
/// PageExtension PDCVATStatement (ID 50050) extends Record VAT Statement.
/// </summary>
pageextension 50050 PDCVATStatement extends "VAT Statement"
{
    layout
    {
        addafter("New Page")
        {
            field(PDCBoxNo; Rec."Box No.")
            {
                ToolTip = 'Box No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

