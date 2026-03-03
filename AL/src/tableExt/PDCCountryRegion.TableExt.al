/// <summary>
/// TableExtension PDCCountryRegion (ID 50000) extends Record Country/Region.
/// </summary>
tableextension 50000 PDCCountryRegion extends "Country/Region"
{
    fields
    {
        field(50000; "PDC Available in Portal"; Boolean)
        {
            Caption = 'Available in Portal';
        }
        field(50010; "PDC CF Truck Km"; Integer)
        {
            Caption = 'CF Truck Km';
            ToolTip = 'Specifies the truck transport distance in kilometres from this country to the UK warehouse for Carbonfact.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50011; "PDC CF Ship Km"; Integer)
        {
            Caption = 'CF Ship Km';
            ToolTip = 'Specifies the ship transport distance in kilometres from this country to the UK warehouse for Carbonfact.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}

