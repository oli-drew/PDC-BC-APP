/// <summary>
/// TableExtension PDCGeneralLedgerSetup (ID 50015) extends Record General Ledger Setup.
/// </summary>
tableextension 50015 PDCGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        field(50000; "PDC Roll-Out Nos."; Code[10])
        {
            Caption = 'Roll-Out Nos.';
            TableRelation = "No. Series";
        }
    }
}

