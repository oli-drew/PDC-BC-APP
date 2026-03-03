/// <summary>
/// TableExtension PDCShippingAgent (ID 50056) extends Record Shipping Agent.
/// </summary>
tableextension 50056 PDCShippingAgent extends "Shipping Agent"
{
    fields
    {
        field(50000; "PDC Connection Type"; Enum PDCShippingAgentConnectionType)
        {
            Caption = 'Connection Type';
            DataClassification = CustomerContent;
        }
        field(50001; "PDC Login"; Text[50])
        {
            Caption = 'Login';
            DataClassification = CustomerContent;
        }
        field(50002; "PDC Password"; Text[50])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
        }
        field(50003; "PDC Account"; Text[50])
        {
            Caption = 'Account';
            DataClassification = CustomerContent;
        }
        field(50004; "PDC Label Printer"; Text[250])
        {
            Caption = 'Label Printer';
            DataClassification = CustomerContent;
            TableRelation = Printer;
        }
        field(50005; "PDC Main URL"; Text[150])
        {
            Caption = 'Main URL';
            DataClassification = CustomerContent;
        }

    }
}
