/// <summary>
/// TableExtension PDCManufacturingSetup (ID 50054) extends Record Manufacturing Setup.
/// </summary>
tableextension 50054 PDCManufacturingSetup extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "PDC Def. Prod. Labels Cnt."; Integer)
        {
            Caption = 'Def. Prod. Labels Cnt.';
            DataClassification = CustomerContent;
        }
    }
}
