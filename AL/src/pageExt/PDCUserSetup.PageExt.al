/// <summary>
/// PageExtension PDCUserSetup (ID 50024) extends Record User Setup.
/// </summary>
pageextension 50024 PDCUserSetup extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field(PDCLabelPrinter; Rec."PDC Label Printer")
            {
                ToolTip = 'Label Printer';
                ApplicationArea = All;
            }
            field("PDC Contact No."; Rec."PDC Contact No.")
            {
                ToolTip = 'Contact No.';
                ApplicationArea = All;
            }
        }
    }
}

