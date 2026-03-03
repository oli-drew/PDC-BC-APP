/// <summary>
/// Table PDC Portal User Branch (ID 50017).
/// </summary>
table 50017 "PDC Portal User Branch"
{
    DrillDownPageID = "PDC Portal User Branches";
    LookupPageID = "PDC Portal User Branches";

    fields
    {
        field(1; "Portal User ID"; Text[80])
        {
            TableRelation = "PDC Portal User" where("Customer No." = field("Sell-To Customer No."));
        }
        field(2; "Sell-To Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(3; "Branch ID"; Code[20])
        {
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Sell-To Customer No."));
        }
    }

    keys
    {
        key(Key1; "Portal User ID", "Sell-To Customer No.", "Branch ID")
        {
        }
    }

    fieldgroups
    {
    }
}

