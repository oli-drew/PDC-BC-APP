/// <summary>
/// PageExtension PDCCustomerLedgerEntries (ID 50003) extends Record Customer Ledger Entries.
/// </summary>
PageExtension 50003 PDCCustomerLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer No.")
        {
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

