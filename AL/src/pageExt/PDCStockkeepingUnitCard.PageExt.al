/// <summary>
/// PageExtension PDCStockkeepingUnitCard (ID 50058) extends Record Stockkeeping Unit Card.
/// </summary>
pageextension 50058 PDCStockkeepingUnitCard extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter("Lead Time Calculation")
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

