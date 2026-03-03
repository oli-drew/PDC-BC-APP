/// <summary>
/// PageExtension PDCPostedSalesCreditMemos (ID 50030) extends Record Posted Sales Credit Memos.
/// </summary>
pageextension 50030 PDCPostedSalesCreditMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

