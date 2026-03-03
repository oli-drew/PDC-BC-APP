/// <summary>
/// TableExtension PDCStockkeepingUnit (ID 50038) extends Record Stockkeeping Unit.
/// </summary>
tableextension 50038 PDCStockkeepingUnit extends "Stockkeeping Unit"
{
    fields
    {
        field(50000; PDCSource; Option)
        {
            OptionMembers = " ",UK,Overseas;
            Caption = 'Source';
        }
    }
}

