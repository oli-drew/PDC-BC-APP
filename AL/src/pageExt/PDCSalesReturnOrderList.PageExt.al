/// <summary>
/// PageExtension PDCSalesReturnOrderList (ID 50034) extends Record Sales Return Order List.
/// </summary>
pageextension 50034 PDCSalesReturnOrderList extends "Sales Return Order List"
{
    layout
    {
        addafter("Shipment Date")
        {
            field(PDCReturnFromInvoiceNo; Rec."PDC Return From Invoice No.")
            {
                ToolTip = 'Return From Invoice No.';
                ApplicationArea = All;
            }
            field(PDCReturnSubmitted; Rec."PDC Return Submitted")
            {
                ToolTip = 'Return Submitted';
                ApplicationArea = All;
            }
            field("PDC Drop-Off"; Rec."PDC Drop-Off")
            {
                ToolTip = 'Drop-Off';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

