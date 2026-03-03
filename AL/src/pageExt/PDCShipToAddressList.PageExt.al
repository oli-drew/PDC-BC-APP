/// <summary>
/// PageExtension PDCShipToAddressList (ID 50049) extends Record Ship-to Address List.
/// </summary>
pageextension 50049 PDCShipToAddressList extends "Ship-to Address List"
{
    layout
    {
        addafter(Contact)
        {
            field(PDCIsHomeShipToAddress; Rec."PDC Is Home Ship-To Address")
            {
                ToolTip = 'Is Home Ship-To Address';
                ApplicationArea = All;
            }
            field(PDCEMail; Rec."E-Mail")
            {
                ToolTip = 'E-Mail';
                ApplicationArea = All;
            }
            field(PDCShowOnPortal; Rec."PDC Show On Portal")
            {
                ToolTip = 'Show On Portal';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

