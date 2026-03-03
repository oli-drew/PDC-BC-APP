/// <summary>
/// TableExtension PDCPurchCrMemoLine (ID 50024) extends Record Purch. Cr. Memo Line.
/// </summary>
tableextension 50024 PDCPurchCrMemoLine extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
    }
}

