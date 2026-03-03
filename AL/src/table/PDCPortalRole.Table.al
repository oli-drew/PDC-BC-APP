/// <summary>
/// Table PDC Portal Role (ID 50054).
/// </summary>
table 50054 "PDC Portal Role"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(100; Incidents; Boolean)
        {
        }
        field(101; Finances; Boolean)
        {
        }
        field(102; Orders; Boolean)
        {
        }
        field(103; AllowSSO; Boolean)
        {
        }
        field(104; DefaultRole; Boolean)
        {
            InitValue = false;
            NotBlank = true;

            trigger OnValidate()
            var
                PDCPortalRole: Record "PDC Portal Role";
            begin
                if Rec.DefaultRole then begin
                    PDCPortalRole.setfilter(Code, '<>%1', Rec.Code);
                    PDCPortalRole.setrange(DefaultRole, true);
                    if not PDCPortalRole.IsEmpty then
                        Rec.DefaultRole := false;
                end;
            end;
        }
        field(105; Workflow; Boolean)
        {
            InitValue = false;
            NotBlank = true;
        }
        field(106; "User Type"; enum "PDC Portal User Type")
        {
            Caption = 'User Type';
        }
        field(50000; Returns; Boolean)
        {
            Caption = 'Returns';
        }
        field(50001; Staff; Boolean)
        {
            Caption = 'Staff';
        }
        field(50002; Contracts; Boolean)
        {
            Caption = 'Contracts';
        }
        field(50003; "General Reports"; Boolean)
        {
            Caption = 'General Reports';
        }
        field(50004; "Financial Reports"; Boolean)
        {
            Caption = 'Financial Reports';
        }
        field(50005; Entitlement; Boolean)
        {
            Caption = 'Entitlement';
        }
        field(50006; Checkout; Boolean)
        {
            Caption = 'Checkout';
        }
        field(50007; Wardrobe; Boolean)
        {
            Caption = 'Wardrobe';
        }
        field(50008; "All Branches"; Boolean)
        {
            Caption = 'Staff All Branches';
        }
        field(50009; "Staff Request Approve"; Boolean)
        {
            Caption = 'Staff Request Approve';
        }
        field(50010; "Staff Request Create"; Boolean)
        {
            Caption = 'Staff Request Create';
        }
        field(50011; "Address Create"; Boolean)
        {
            Caption = 'Address Create';
        }
        field(50012; "Address List Company"; Boolean)
        {
            Caption = 'Address List Company';
        }
        field(50013; "Address List Branch"; Boolean)
        {
            Caption = 'Address List Branch';
        }
        field(50014; "Staff Create"; Boolean)
        {
            Caption = 'Staff Create';
        }
        field(50015; "Staff Edit"; Boolean)
        {
            Caption = 'Staff Edit';
        }
        field(50016; "Address Edit"; Boolean)
        {
            Caption = 'Address Edit';
        }
        field(50017; "Bulk Order"; Boolean)
        {
            Caption = 'Bulk Order';
        }

    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PDCNavPortalUserRole.Reset();
        PDCNavPortalUserRole.SetRange("User Role Code", Code);
        PDCNavPortalUserRole.DeleteAll();
    end;

    var
        PDCNavPortalUserRole: Record "PDC Portal User Role";
}

