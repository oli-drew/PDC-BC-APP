/// <summary>
/// PageExtension PDCSubcontractingWorksheet (ID 50075) extends Record Subcontracting Worksheet.
/// </summary>
pageextension 50075 PDCSubcontractingWorksheet extends "Subcontracting Worksheet"
{
    actions
    {
        addafter("Calculate Subcontracts")
        {
            action("PDCCalculate&CreatePO")
            {
                Caption = 'Calculate & Create Purchase Documents';
                ToolTip = 'Calculate & Create Purchase Documents';
                ApplicationArea = All;
                Image = CalculatePlan;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = report "PDC Create Subcontracting PO";
            }
        }
    }
}
