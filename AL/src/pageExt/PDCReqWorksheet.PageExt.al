/// <summary>
/// PageExtension PDCReqWorksheet (ID 50055) extends Record Req. Worksheet.
/// </summary>
pageextension 50055 PDCReqWorksheet extends "Req. Worksheet"
{
    layout
    {
        addafter("Planning Flexibility")
        {
            field(PDCPrepaid; Rec."PDC Prepaid")
            {
                ToolTip = 'Prepaid';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

