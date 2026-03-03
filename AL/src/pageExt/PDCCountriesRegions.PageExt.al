/// <summary>
/// PageExtension PDCCountriesRegions (ID 50000) extends Record Countries/Regions.
/// </summary>
PageExtension 50000 PDCCountriesRegions extends "Countries/Regions"
{
    layout
    {

        addafter("Intrastat Code")
        {
            field(PDCAvailableinPortal; Rec."PDC Available in Portal")
            {
                ToolTip = 'Available in Portal';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

