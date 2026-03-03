/// <summary>
/// PageExtension PDCFirmPlannedProdOrders (ID 50080) extends Record Firm Planned Prod. Orders.
/// </summary>
pageextension 50080 PDCFirmPlannedProdOrders extends "Firm Planned Prod. Orders"
{
    actions
    {
        addafter("&Update Unit Cost")
        {
            action(PDCReserveComponents)
            {
                ApplicationArea = All;
                Caption = 'Auto Reserve Components';
                ToolTip = 'Auto Reserve Components';
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PDCFunctions: Codeunit "PDC Functions";
                begin
                    PDCFunctions.FirmProdOrderAutoReserve();
                end;
            }
            action(PDCAutoRelease)
            {
                ApplicationArea = All;
                Caption = 'Auto Release Production Orders';
                ToolTip = 'Auto Release Production Orders';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PDCFunctions: Codeunit "PDC Functions";
                begin
                    PDCFunctions.FirmProdOrderAutoRelease();
                end;
            }
        }
    }
}
