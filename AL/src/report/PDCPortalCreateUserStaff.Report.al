report 50059 "PDC Portal Create User Staff"
{
    ApplicationArea = All;
    Caption = 'Portal Create User from Staff';
    UsageCategory = Tasks;
    ProcessingOnly = true;


    dataset
    {
        dataitem(Staff; "PDC Branch Staff")
        {
            DataItemTableView = where("Email Address" = filter(<> ''));
            RequestFilterFields = "Sell-to Customer No.", "Branch ID", "Staff ID";


            trigger OnPreDataItem()
            begin
                if PortalCode = '' then
                    Error(PortalCodeErr);
                if UserRole = '' then
                    Error(UserRoleErr);

                if GuiAllowed then
                    Window.OPEN(CreatingTxt);

                RMSetup.get();
                RMSetup.TestField("Contact Nos.");
            end;

            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then
                    Window.UPDATE(1, Staff."Staff ID");

                if PortalUser.get(LowerCase(Staff."Email Address")) then
                    CurrReport.Skip();

                PortalUser.setrange("Staff ID", "Staff ID");
                if not PortalUser.IsEmpty then
                    CurrReport.Skip();

                Customer.GET(Staff."Sell-to Customer No.");
                ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.setrange("No.", Customer."No.");
                ContactBusinessRelation.FindFirst();
                CustomerContact.GET(ContactBusinessRelation."Contact No.");

                PersonContact.setrange("Company No.", CustomerContact."No.");
                PersonContact.setrange(Name, Staff.Name);
                if not PersonContact.FindFirst() then begin
                    clear(NoSeries);
                    PersonContact.Init();
                    PersonContact."No. Series" := RMSetup."Contact Nos.";
                    PersonContact."No." := NoSeries.GetNextNo(PersonContact."No. Series");
                    PersonContact.Name := Staff.Name;
                    PersonContact.Type := PersonContact.Type::Person;
                    PersonContact."Company No." := CustomerContact."No.";
                    PersonContact."Company Name" := CustomerContact.Name;
                    PersonContact.Insert(true);
                end;

                PortalUser.Init();
                PortalUser.Id := LowerCase(Staff."Email Address");
                PortalUser."User Name" := Staff.Name;
                PortalUser.Name := Staff.Name;
                PortalUser."E-Mail" := LowerCase(Staff."Email Address");
                PortalUser.Insert(true);
                PortalUser."Contact No." := PersonContact."No.";
                PortalUser.Created := CurrentDatetime();
                PortalUser."Company Contact No." := CustomerContact."No.";
                PortalUser."Customer No." := Customer."No.";
                PortalUser."Staff ID" := "Staff ID";
                PortalUser."User Type" := UserType;
                PortalUser.Modify(true);

                clear(PortalUserRole);
                PortalUserRole.Init();
                PortalUserRole.validate("Portal Code", PortalCode);
                PortalUserRole.validate("User ID", PortalUser.Id);
                PortalUserRole.validate("User Role Code", UserRole);
                PortalUserRole.insert(true);
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(PortalCodeFld; PortalCode)
                    {
                        Caption = 'Portal Code';
                        ToolTip = 'Portal Code';
                        ApplicationArea = All;
                        TableRelation = "PDC Portal".Code;
                    }
                    field(UserRoleFld; UserRole)
                    {
                        Caption = 'User Role';
                        ToolTip = 'User Role';
                        ApplicationArea = All;
                        TableRelation = "PDC Portal Role".Code;
                    }
                    field(UserTypeFld; UserType)
                    {
                        Caption = 'User Type';
                        ToolTip = 'User Type';
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        UserType := UserType::Staff;
    end;


    var
        PortalUser: Record "PDC Portal User";
        PortalUserRole: Record "PDC Portal User Role";
        Customer: Record Customer;
        CustomerContact: Record Contact;
        PersonContact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        RMSetup: Record "Marketing Setup";
        NoSeries: Codeunit "No. Series";
        PortalCode: Code[20];
        UserRole: Code[20];
        UserType: enum "PDC Portal User Type";
        Window: Dialog;
        CreatingTxt: label 'Creating User #1####################', Comment = '%1=user id';
        PortalCodeErr: label 'Portal Code is required';
        UserRoleErr: label 'User Role is required';



}
