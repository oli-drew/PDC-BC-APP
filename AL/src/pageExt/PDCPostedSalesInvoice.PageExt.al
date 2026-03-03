/// <summary>
/// PageExtension PDCPostedSalesInvoice (ID 50027) extends Record Posted Sales Invoice.
/// </summary>
pageextension 50027 PDCPostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addafter("No. Printed")
        {
            field("PDC Notes"; Rec."PDC Notes")
            {
                ToolTip = 'Notes';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action(PDCSendinEMail)
            {
                ApplicationArea = All;
                Caption = 'Send in E-Mail';
                ToolTip = 'Send in E-Mail';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.SendEmail();
                end;
            }
        }
    }
}

