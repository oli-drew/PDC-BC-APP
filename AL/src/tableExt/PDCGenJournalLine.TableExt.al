/// <summary>
/// TableExtension PDCGenJournalLine (ID 50012) extends Record Gen. Journal Line.
/// </summary>
tableextension 50012 PDCGenJournalLine extends "Gen. Journal Line"
{
    fields
    {
        field(50001; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
        field(50002; "PDC Exclude from Payment Disc."; Decimal)
        {
            Caption = 'Exclude from Payment Disc.';
        }
        field(50003; "PDC Excl.from Paym.Disc.(LCY)"; Decimal)
        {
            Caption = 'Exclude from Payment Disc. (LCY)';
        }
    }
}

