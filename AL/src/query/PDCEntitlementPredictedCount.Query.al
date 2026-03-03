/// <summary>
/// Query PDCEntitlementPredictedCount (ID 50008).
/// </summary>
query 50008 PDCEntitlementPredictedCount
{
    // 30.06.2020 JEMEL J.Jemeljanovs #3293 Created


    elements
    {
        dataitem(Nav_Portal_User; "PDC Portal User")
        {
            filter(Id_Filter; Id)
            {
            }
            column(Customer_No; "Customer No.")
            {
            }
            dataitem(Staff; "PDC Branch Staff")
            {
                DataItemLink = "Sell-to Customer No." = Nav_Portal_User."Customer No.";
                DataItemTableFilter = Blocked = const(false);
                filter(BranchID_Filter; "Branch ID")
                {
                }
                column(Staff_ID; "Staff ID")
                {
                }
                dataitem(Entitlement; "PDC Staff Entitlement Predict.")
                {
                    DataItemLink = "Customer No." = Staff."Sell-to Customer No.", "Branch No." = Staff."Branch ID", "Staff ID" = Staff."Staff ID";
                    filter(QtyRemaining_Filter; "Calc. Qty. Remaining in Period")
                    {
                    }
                    filter(Wardobe_Discontinued_Filter; "Wardrobe Discontinued")
                    {
                    }
                    column(EntitlementCount)
                    {
                        Method = Count;
                    }
                }
            }
        }
    }
}

