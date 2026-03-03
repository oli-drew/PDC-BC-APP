/// <summary>
/// PageExtension PDCStockkeepingUnitList (ID 50059) extends Record Stockkeeping Unit List.
/// </summary>
pageextension 50059 PDCStockkeepingUnitList extends "Stockkeeping Unit List"
{
    layout
    {

        addafter("Assembly Policy")
        {
            field(PDCSource; Rec.PDCSource)
            {
                ToolTip = 'Source';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

