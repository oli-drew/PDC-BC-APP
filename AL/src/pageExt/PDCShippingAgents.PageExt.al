/// <summary>
/// PageExtension PDCShippingAgents (ID 50081) extends Record Shipping Agents.
/// </summary>
pageextension 50081 PDCShippingAgents extends "Shipping Agents"
{
    layout
    {
        addlast(Control1)
        {
            field("PDC Connection Type"; Rec."PDC Connection Type")
            {
                ToolTip = 'Connection Type';
                ApplicationArea = All;
            }
            field("PDC Main URL"; Rec."PDC Main URL")
            {
                ToolTip = 'Main URL';
                ApplicationArea = All;
            }
            field("PDC Account"; Rec."PDC Account")
            {
                ToolTip = 'Account';
                ApplicationArea = All;
            }
            field("PDC Login"; Rec."PDC Login")
            {
                ToolTip = 'Login';
                ApplicationArea = All;
            }
            field("PDC Password"; Rec."PDC Password")
            {
                ToolTip = 'Password';
                ApplicationArea = All;
                ExtendedDatatype = Masked;
            }
            field("PDC Label Printer"; Rec."PDC Label Printer")
            {
                ToolTip = 'Label Printer IP';
                ApplicationArea = All;
            }
        }
    }
}
