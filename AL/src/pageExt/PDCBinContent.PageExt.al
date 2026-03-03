/// <summary>
/// PageExtension PDCBinContent (ID 50065) extends Record Bin Content.
/// </summary>
PageExtension 50065 PDCBinContent extends "Bin Content"
{
    layout
    {
        addafter("Item No.")
        {
            field(PDCItemDescription; Rec."PDC Item Description")
            {
                ToolTip = 'Item Description';
                ApplicationArea = All;
            }
        }
    }
}

