/// <summary>
/// PageExtension PDCSmallBusinessOwnerAct (ID 50032) extends Record Small Business Owner Act..
/// </summary>
pageextension 50032 PDCSmallBusinessOwnerAct extends "Small Business Owner Act."
{
    layout
    {
        addafter("Customers - Blocked")
        {
            field(PDCCustomersOverCreditLimit; Rec."PDC Customers-Over Cred. Limit")
            {
                ToolTip = 'Customers Over Credit Limit';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.ShowCustomers();
                end;
            }
        }
    }
    actions
    {
    }
}

