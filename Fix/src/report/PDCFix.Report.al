/// <summary>
/// Report PDCFix (ID 50099).
/// </summary>
Report 60000 PDCFix
{
    ProcessingOnly = true;
    Permissions = TableData 32 = rm, TableData 110 = rm, TableData 111 = rm, TableData 113 = rm, TableData 115 = rm, TableData 5802 = rm;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = CONST(1));
            trigger OnAfterGetRecord()
            var
                //PDCPortalsWebService: Codeunit "PDC Portals Web Service";
                PDCStaffEntitlement: Record "PDC Staff Entitlement";
                SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                SalesCrMemoLine: Record "Sales Cr.Memo Line";
                Customer: Record Customer;
            begin
                // PDCStaffEntitlement.FindSet();
                // repeat
                //     if Customer.Get(PDCStaffEntitlement."Customer No.") then
                //         if not Customer."PDC Entitlement Enabled" then begin
                //             Customer."PDC Entitlement Enabled" := true;
                //             Customer.Modify(true);
                //         end;
                // until PDCStaffEntitlement.Next() = 0;


                //message(PDCPortalsWebService.Call2('test', 'CUSTP', 'main', '', '{}'));
                SalesCrMemoLine.FindSet();
                repeat
                    if SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then begin
                        SalesCrMemoLine."PDC Document Id" := SalesCrMemoHeader.SystemId;
                        SalesCrMemoLine.Modify();
                    end;
                until SalesCrMemoLine.Next() = 0;
            end;
        }
    }
}