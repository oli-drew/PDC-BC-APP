/// <summary>
/// PageExtension PDCPostedPurchaseReceipt (ID 50082) extends Record Posted Purchase Receipt.
/// </summary>
pageextension 50082 PDCPostedPurchaseReceipt extends "Posted Purchase Receipt"
{
    actions
    {
        addafter("&Print")
        {
            action("PDC Purchase Order Labels")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Labels';
                ToolTip = 'Purchase Order Labels';
                Image = PrintForm;

                trigger OnAction()
                var
                    PurchRcptHeader1: Record "Purch. Rcpt. Header";
                begin
                    PurchRcptHeader1.Get(Rec."No.");
                    PurchRcptHeader1.SetRecfilter();
                    Report.Run(Report::"PDC Purchase Receipt Labels", true, false, PurchRcptHeader1);
                end;
            }
        }
        addlast(Category_Category5)
        {
            actionref("PDC Purchase Order Labels_Promoted"; "PDC Purchase Order Labels")
            {
            }
        }
    }

}
