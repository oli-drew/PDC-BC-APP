/// <summary>
/// PageExtension PDCManufacturingSetup (ID 50074) extends Record Manufacturing Setup.
/// </summary>
pageextension 50074 PDCManufacturingSetup extends "Manufacturing Setup"
{
    layout
    {
        addlast(General)
        {
            field("PDC Def. Prod. Labels Cnt."; Rec."PDC Def. Prod. Labels Cnt.")
            {
                ToolTip = 'Def. Prod. Labels Cnt.';
                ApplicationArea = All;
            }
        }
    }
}
