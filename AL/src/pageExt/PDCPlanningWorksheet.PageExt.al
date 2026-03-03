/// <summary>
/// PageExtension PDCPlanningWorksheet (ID 50041) extends Record Planning Worksheet.
/// </summary>
pageextension 50041 PDCPlanningWorksheet extends "Planning Worksheet"
{
    layout
    {
        addafter("Vendor No.")
        {
            field(PDCSource; Rec."PDC Source")
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

