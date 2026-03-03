/// <summary>
/// Query PDCEntitlementCount (ID 50007).
/// </summary>
query 50007 PDCEntitlementCount
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
                dataitem(Entitlement; "PDC Staff Entitlement")
                {
                    DataItemLink = "Customer No." = Staff."Sell-to Customer No.", "Branch No." = Staff."Branch ID", "Staff ID" = Staff."Staff ID";
                    filter(QtyRemaining_Filter; "Calc. Qty. Remaining in Period")
                    {
                    }
                    filter(Wardobe_Discontinued_Filter; "Wardrobe Discontinued")
                    {
                    }
                    filter(Posponed_Days_Filter; "Posponed Period (Days)")
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

