/// <summary>
/// PageExtension PDCPurchasesPayablesSetup (ID 50052) extends Record Purchases &amp; Payables Setup.
/// </summary>
pageextension 50052 PDCPurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field(PDCDefaultGLAccount; Rec."PDC Default G/L Account")
            {
                ToolTip = 'Default G/L Account';
                ApplicationArea = All;
            }
            field("PDC Def. Purch. Labels Cnt."; Rec."PDC Def. Purch. Labels Cnt.")
            {
                ToolTip = 'Def. Purch. Labels Cnt.';
                ApplicationArea = All;
            }
        }
    }
}

