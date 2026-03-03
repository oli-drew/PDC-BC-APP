/// <summary>
/// TableExtension PDCReasonCode (ID 50026) extends Record Reason Code.
/// </summary>
tableextension 50026 PDCReasonCode extends "Reason Code"
{
    fields
    {
        field(50000; "PDC Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(50001; "PDC Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Order,Return';
            OptionMembers = " ","Order",Return;
        }
        field(50002; "PDC Return Carriage Refunded"; Boolean)
        {
            Caption = 'Return Carriage Refunded';
        }
    }
}

