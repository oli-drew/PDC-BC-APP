/// <summary>
/// TableExtension PDCCustomerTemplate (ID 50035) extends Record Customer Template.
/// </summary>
tableextension 50035 PDCCustomerTemplate extends "Customer Templ."
{
    fields
    {
        field(50000; "PDC Config. Template Code"; Code[10])
        {
            Caption = 'Config. Template Code';
            TableRelation = "Config. Template Header";
        }
    }
}

