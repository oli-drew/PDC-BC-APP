/// <summary>
/// PageExtension PDCGeneralLedgerSetup (ID 50023) extends Record General Ledger Setup.
/// </summary>
pageextension 50023 PDCGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        addafter("Bank Account Nos.")
        {
            field(PDCRollOutNos; Rec."PDC Roll-Out Nos.")
            {
                ToolTip = 'Roll-Out Nos.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

