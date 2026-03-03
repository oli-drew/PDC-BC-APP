/// <summary>
/// TableExtension PDCValueEntry (ID 50042) extends Record Value Entry.
/// </summary>
tableextension 50042 PDCValueEntry extends "Value Entry"
{
    fields
    {
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50001; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
    }
}

