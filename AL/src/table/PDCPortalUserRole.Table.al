/// <summary>
/// Table PDC Portal User Role (ID 50052).
/// </summary>
table 50052 "PDC Portal User Role"
{
    //Old No. 9062667
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Portal Code"; Code[20])
        {
            TableRelation = "PDC Portal";
        }
        field(3; "User Id"; Text[250])
        {
            TableRelation = "PDC Portal User";
            ValidateTableRelation = false;
        }
        field(4; "User Role Code"; Code[20])
        {
            TableRelation = "PDC Portal Role";

            trigger OnValidate()
            var
                PortalUser: Record "PDC Portal User";
                PortalRole: Record "PDC Portal Role";
            begin
                if PortalRole.get("User Role Code") then begin
                    PortalUser.get("User Id");
                    PortalUser.TestField("User Type", PortalRole."User Type");
                end;


            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

