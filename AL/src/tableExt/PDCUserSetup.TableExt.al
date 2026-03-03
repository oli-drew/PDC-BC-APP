/// <summary>
/// TableExtension PDCUserSetup (ID 50014) extends Record User Setup.
/// </summary>
tableextension 50014 PDCUserSetup extends "User Setup"
{
    fields
    {
        field(50000; "PDC Label Printer"; Text[250])
        {
            Caption = 'Label Printer';
            TableRelation = Printer;
        }

        field(50001; "PDC Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
    }
}

