/// <summary>
/// PageExtension PDCShipToAddress (ID 50048) extends Record Ship-to Address.
/// </summary>
pageextension 50048 PDCShipToAddress extends "Ship-to Address"
{
    layout
    {
        addafter(Code)
        {
            field(PDCAddress3; Rec."PDC Address 3")
            {
                Caption = 'Customer Address Code';
                ToolTip = 'Customer Address Code';
                ApplicationArea = All;
            }
        }
        addafter("Service Zone Code")
        {
            field(PDCIsHomeShipToAddress; Rec."PDC Is Home Ship-To Address")
            {
                ToolTip = 'Is Home Ship-To Address';
                ApplicationArea = All;
            }
            field(PDCShowOnPortal; Rec."PDC Show On Portal")
            {
                ToolTip = 'Show On Portal';
                ApplicationArea = All;
            }
            field("PDC Branch No."; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

