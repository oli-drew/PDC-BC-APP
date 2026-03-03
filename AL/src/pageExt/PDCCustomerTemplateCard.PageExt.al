/// <summary>
/// PageExtension PDCCustomerTemplateCard (ID 50057) extends Record Customer Template Card.
/// </summary>
pageextension 50057 PDCCustomerTemplateCard extends "Customer Templ. Card"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field(PDCConfigTemplateCode; Rec."PDC Config. Template Code")
            {
                ToolTip = 'Config. Template Code';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

