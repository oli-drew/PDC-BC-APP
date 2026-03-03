/// <summary>
/// TableExtension PDCShipToAddress (ID 50025) extends Record Ship-to Address.
/// </summary>
tableextension 50025 PDCShipToAddress extends "Ship-to Address"
{
    fields
    {
        field(50000; "PDC Address 3"; Text[50])
        {
        }
        field(50001; "PDC Is Home Ship-To Address"; Boolean)
        {
            Caption = 'Is Home Ship-To Address?';
        }
        field(50002; "PDC Show On Portal"; Boolean)
        {
            Caption = 'Show On Portal';
            InitValue = true;
        }
        field(50003; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Customer No."));
        }
    }
}

