/// <summary>
/// Report PDC Staff Entitlement Inactiv (ID 50051).
/// </summary>
Report 50051 "PDC Staff Entitlement Inactiv"
{
    Caption = 'Staff Entitlement Inactivate';
    ProcessingOnly = true;

    dataset
    {
        dataitem(StaffEntitlement; "PDC Staff Entitlement")
        {
            DataItemTableView = where(Inactive = const(false));

            trigger OnAfterGetRecord()
            begin
                if PrevStaffID <> "Staff ID" then begin
                    ToInactivate := not IsStaffActive("Staff ID");

                    PrevStaffID := "Staff ID";
                end;
                if ToInactivate then begin
                    StaffEntitlement2.get("Staff ID", "Product Code");
                    StaffEntitlement2.validate(Inactive, true);
                    StaffEntitlement2."Inactivated Datetime" := CurrentDateTime;
                    StaffEntitlement2.Modify(true);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        StaffEntitlement2: Record "PDC Staff Entitlement";
        PrevStaffID: code[20];
        ToInactivate: Boolean;

    local procedure IsStaffActive(StaffID: Code[20]): Boolean
    var
        ItemLEByStaffQuery: Query PDCItemLEByStaff;
    begin
        Clear(ItemLEByStaffQuery);
        ItemLEByStaffQuery.SetRange(Staff_ID_Flt, StaffID);
        ItemLEByStaffQuery.SetRange(Posting_Date_Flt, CALCDATE('<-24M>', WorkDate()), WorkDate());
        ItemLEByStaffQuery.Open();
        while ItemLEByStaffQuery.Read() do
            if ItemLEByStaffQuery.RecCnt > 0 then
                exit(true);

        exit(false);
    end;

}

