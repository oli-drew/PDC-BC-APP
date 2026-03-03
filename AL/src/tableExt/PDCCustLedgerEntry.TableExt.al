/// <summary>
/// TableExtension PDCCustLedgerEntry (ID 50004) extends Record Cust. Ledger Entry.
/// </summary>
tableextension 50004 PDCCustLedgerEntry extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
    }
}

