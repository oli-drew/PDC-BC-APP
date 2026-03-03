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
            field("PDC CF Truck Km"; Rec."PDC CF Truck Km")
            {
                Caption = 'CF Truck Km';
                ToolTip = 'Specifies the truck transport distance in kilometres from this country to the UK warehouse for Carbonfact.';
                ApplicationArea = All;
            }
            field("PDC CF Ship Km"; Rec."PDC CF Ship Km")
            {
                Caption = 'CF Ship Km';
                ToolTip = 'Specifies the ship transport distance in kilometres from this country to the UK warehouse for Carbonfact.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

