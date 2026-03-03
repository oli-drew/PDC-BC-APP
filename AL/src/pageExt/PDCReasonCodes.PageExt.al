/// <summary>
/// PageExtension PDCReasonCodes (ID 50046) extends Record Reason Codes.
/// </summary>
pageextension 50046 PDCReasonCodes extends "Reason Codes"
{
    layout
    {
        addafter(Description)
        {
            field(PDCCustomerNo; Rec."PDC Customer No.")
            {
                ToolTip = 'Customer No.';
                ApplicationArea = All;
            }
            field(PDCType; Rec."PDC Type")
            {
                ToolTip = 'Type';
                ApplicationArea = All;
            }
            field(PDCReturnCarriageRefunded; Rec."PDC Return Carriage Refunded")
            {
                ToolTip = 'Return Carriage Refunded';
                ApplicationArea = All;
            }
        }
    }
}

