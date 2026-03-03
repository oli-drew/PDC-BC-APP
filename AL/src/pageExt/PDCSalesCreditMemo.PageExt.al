/// <summary>
/// PageExtension PDCSalesCreditMemo (ID 50012) extends Record Sales Credit Memo.
/// </summary>
pageextension 50012 PDCSalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
    }
    actions
    {
        addafter("PostAndSend")
        {
            action(PDCPostPrintandSendCredit)
            {
                ApplicationArea = All;
                Caption = 'Post, &Print and Send Credit';
                ToolTip = 'Post, Print and Send Credit';
                Image = PostMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PDCFunctions: Codeunit "PDC Functions";
                begin
                    PDCFunctions.SalesCrMemoPrintAndEmail(Rec);
                end;
            }
        }
    }
}

