/// <summary>
/// Report PDC Staff Entitl. Calc. Qty (ID 50031).
/// </summary>
Report 50031 "PDC Staff Entitl. Calc. Qty"
{

    Caption = 'Staff Entitlement Calculate Quantities';
    ProcessingOnly = true;

    dataset
    {
        dataitem(StaffEntitlement; "PDC Staff Entitlement")
        {
            DataItemTableView = where(Inactive = const(false));

            trigger OnAfterGetRecord()
            begin
                if Customer."No." <> "Customer No." then
                    Customer.get("Customer No.");
                if Customer.Blocked = Customer.Blocked::All then
                    CurrReport.Skip();
                if not Customer."PDC Entitlement Enabled" then
                    CurrReport.Skip();

                if PrevStaffID <> "Staff ID" then begin
                    clear(Staff);
                    if Staff.get("Staff ID") then
                        if (Staff."Wardrobe ID" <> "Wardrobe ID") or
                             Staff.Blocked
                        then
                            clear(Staff);

                    PrevStaffID := "Staff ID";
                end;
                if Staff."Staff ID" <> '' then begin
                    Validate("End Date", WorkDate());
                    Modify(true);
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

    trigger OnPostReport()
    begin
        StaffEntitlementPredicted.CreateRecords('');
    end;

    var
        StaffEntitlementPredicted: Record "PDC Staff Entitlement Predict.";
        Staff: Record "PDC Branch Staff";
        Customer: Record Customer;
        PrevStaffID: code[20];

}

