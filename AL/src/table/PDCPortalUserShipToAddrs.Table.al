/// <summary>
/// Table Portal User Branch (ID 50017).
/// </summary>
Table 50003 "PDC Portal User Ship-to Addrs"
{
    Caption = 'Portal User Ship-to Addresses';
    DrillDownPageID = "PDC Portal User Ship-to Addrs";
    LookupPageID = "PDC Portal User Ship-to Addrs";

    fields
    {
        field(1; "Portal User ID"; Text[80])
        {
            TableRelation = "PDC Portal User".Id;
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            NotBlank = true;
        }
        field(3; "Ship-to Code"; Code[20])
        {
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Portal User ID", "Customer No.", "Ship-to Code")
        {
        }
    }

    fieldgroups
    {
    }
}

