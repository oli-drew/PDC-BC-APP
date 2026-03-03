/// <summary>
/// TableExtension PDCPurchasesPayablesSetup (ID 50031) extends Record Purchases &amp; Payables Setup.
/// </summary>
tableextension 50031 PDCPurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "PDC Default G/L Account"; Code[10])
        {
            Caption = 'Default G/L Account';
            TableRelation = "G/L Account" where("Direct Posting" = const(true),
                                                 "Account Type" = const(Posting),
                                                 Blocked = const(false));
        }
        field(50001; "PDC Def. Purch. Labels Cnt."; Integer)
        {
            Caption = 'Def. Purch. Labels Cnt.';
            DataClassification = CustomerContent;
        }
    }
}

