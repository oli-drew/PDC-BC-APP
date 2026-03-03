/// <summary>
/// Page PDC Portal User Card (ID 50086).
/// </summary>
Page 50086 "PDC Portal User Card"
{
    PageType = Card;
    SourceTable = "PDC Portal User";
    Caption = 'Portal User Card';
    UsageCategory = Administration;
    ApplicationArea = All;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Id';
                }
                field("Azure User Id"; AzureUserId)
                {
                    ApplicationArea = All;
                    Caption = 'Azure User Id';
                    ToolTip = 'Azure User Id';
                    Editable = false;
                }
                field("Azure Enabled"; Rec."Azure Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Azure Enabled';
                    Editable = false;
                }
                field(UserName; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'User Name';
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contact No.';
                }
                field(CompanyContactNo; Rec."Company Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Company Contact No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name';
                }
                field(Name2; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name 2';
                    Visible = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Address';
                    Visible = false;
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Address 2';
                    Visible = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'City';
                    Visible = false;
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Post Code';
                    Visible = false;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'County';
                    Visible = false;
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Country/Region Code';
                    Visible = false;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Phone No.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'E-Mail';
                }
                field(NavUserId; Rec."Nav User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Nav User Id';
                    Visible = false;
                }
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'User Type';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(DefaultShiptoCode; Rec."Default Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default Ship-to Code';
                }
                field(POperWearer; Rec."PO per Wearer")
                {
                    ApplicationArea = All;
                    ToolTip = 'PO per Wearer';
                    Visible = false;
                }
                field(EntitlementEmailReport; Rec."Entitlement Email Report")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Email Report';
                }
                field("Min Order Value"; Rec."Min Order Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Min Order Value';
                }
                field("Max Order Value"; Rec."Max Order Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Max Order Value';
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Staff ID';
                    Editable = StaffIDEditable;
                }
                field("Allow Approval Email"; Rec."Allow Approval Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Approval Email';
                }
                field("Approval Email Report"; Rec."Approval Email Report")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval Email Report';
                }
            }
            part(NavPortalUserCardSubf; "PDC Nav Portal User Card Subf.")
            {
                Caption = 'User Roles';
                SubPageLink = "User Id" = field(Id);
            }
        }
    }

    actions
    {
        area(processing)
        {
            // action("Generate Password")
            // {
            //     Caption = 'Generate Password';
            //     ToolTip = 'Generate Password';
            //     ApplicationArea = All;
            //     Image = SendMail;

            //     trigger OnAction()
            //     begin
            //         if not Rec.IsWorkflowNotificationsEnabled() then
            //             Rec.ResetPasswordWithAutoGen(false)
            //         else
            //             Rec.ResetPasswordFromUI(Confirm(cnfDoPasswordWFlowQst));
            //     end;
            // }
            // action("Manual Set Password")
            // {
            //     Caption = 'Manual Set Password';
            //     ToolTip = 'Manual Set Password';
            //     ApplicationArea = All;
            //     Image = Edit;

            //     trigger OnAction()
            //     begin
            //         Rec.ResetPasswordFromUI(Confirm(cnfDoPasswordWFlowQst));
            //     end;
            // }
            action("Create Azure User")
            {
                Caption = 'Create Azure User';
                ToolTip = 'Create Azure User';
                ApplicationArea = All;
                Image = User;
                trigger OnAction()
                var
                    AzureUserMgt: Codeunit "PDC Azure User Mgt.";
                begin
                    AzureUserMgt.CreateUser(Rec);
                end;
            }
            action("Create Azure User and Send E-mail")
            {
                Caption = 'Create Azure User and Send E-mail';
                ToolTip = 'Create Azure User and Send E-mail';
                ApplicationArea = All;
                Image = User;
                trigger OnAction()
                var
                    AzureUserMgt: Codeunit "PDC Azure User Mgt.";
                begin
                    AzureUserMgt.CreateUSerAndSendEmail(Rec);
                end;
            }
            action("Azure User Enable/Disable")
            {
                Caption = 'Azure User Enable/Disable';
                ToolTip = 'Azure User Enable/Disable';
                ApplicationArea = All;
                Image = User;
                trigger OnAction()
                var
                    AzureUserMgt: Codeunit "PDC Azure User Mgt.";
                begin
                    AzureUserMgt.EnableUser(Rec);
                end;
            }
            action("Send Welcome E-mail")
            {
                Caption = 'Send Welcome E-mail';
                ToolTip = 'Send Welcome E-mail';
                ApplicationArea = All;
                Image = Email;

                trigger OnAction()
                var
                    AzureUserMgt: Codeunit "PDC Azure User Mgt.";
                begin
                    AzureUserMgt.SendWelcomeEmail(Rec);
                end;
            }
        }
        area(navigation)
        {
            action(PortalUserBranches)
            {
                ApplicationArea = All;
                Caption = 'Portal User Branches';
                ToolTip = 'Portal User Branches';
                Image = User;
                RunObject = Page "PDC Portal User Branches";
                RunPageLink = "Portal User ID" = field(Id),
                              "Sell-To Customer No." = field("Customer No.");
            }
            action(PortalUserShipToAddrs)
            {
                ApplicationArea = All;
                Caption = 'Portal User Ship-to Addresses';
                ToolTip = 'Portal User Ship-to Addresses';
                Image = User;
                RunObject = Page "PDC Portal User Ship-to Addrs";
                RunPageLink = "Portal User ID" = field(Id),
                              "Customer No." = field("Customer No.");
            }
            action(PortalUserWardrobes)
            {
                ApplicationArea = All;
                Caption = 'Portal User Wardrobes';
                ToolTip = 'Portal User Wardrobes';
                Image = User;
                RunObject = Page "PDC Portal User Wardrobes";
                RunPageLink = "Portal User ID" = field(Id),
                              "Sell-To Customer No." = field("Customer No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                group(Category_Azure)
                {
                    Caption = 'Azure';
                    ShowAs = SplitButton;

                    actionref("Create Azure User_Promoted"; "Create Azure User")
                    {
                    }
                    actionref("Create Azure User and Send E-mail_Promoted"; "Create Azure User and Send E-mail")
                    {
                    }
                    actionref("Send Welcome E-mail_Promoted"; "Send Welcome E-mail")
                    {
                    }
                    actionref("Azure User Enable/Disable_Promoted"; "Azure User Enable/Disable")
                    {
                    }
                }
            }
            actionref("PortalUserBranches_Promoted"; PortalUserBranches)
            {
            }
            actionref("PortalUserWardrobes_Promoted"; PortalUserWardrobes)
            {
            }
            actionref("PortalUserShipToAddrs_Promoted"; PortalUserShipToAddrs)
            {
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        clear(AzureUserId);
        if not IsNullGuid(Rec."Azure User Id") then
            AzureUserId := '********-****-****-****-************';

        StaffIDEditable := Rec."User Type" in [Rec."User Type"::Staff, Rec."User Type"::Bulk];
    end;

    var
        AzureUserId: Text;
        StaffIDEditable: Boolean;
    //cnfDoPasswordWFlowQst: label 'Would you like the password reset to trigger the workflow associated with it in the NAV Portal Setup?';
}

