/// <summary>
/// Table PDC Portal User Wardrobe (ID 50058).
/// </summary>
table 50058 "PDC Portal User Wardrobe"
{
    DrillDownPageID = "PDC Portal User Wardrobes";
    LookupPageID = "PDC Portal User Wardrobes";

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
        field(3; "Wardrobe ID"; Code[20])
        {
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID" where("Customer No." = field("Sell-To Customer No."));
        }
    }

    keys
    {
        key(Key1; "Portal User ID", "Sell-To Customer No.", "Wardrobe ID")
        {
        }
    }

    fieldgroups
    {
    }
}

