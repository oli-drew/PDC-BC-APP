/// <summary>
/// TableExtension PDCRoutingHeader (ID 50052) extends Record Routing Header.
/// </summary>
tableextension 50052 PDCRoutingHeader extends "Routing Header"
{
    fields
    {
        field(50000; "PDC Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
    }
}

