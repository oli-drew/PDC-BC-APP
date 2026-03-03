/// <summary>
/// Page PDC Portal User List (ID 50085).
/// </summary>
Page 50085 "PDC Portal User List"
{
    Caption = 'Portal User List';
    CardPageID = "PDC Portal User Card";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "PDC Portal User";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CompanyContactNo; Rec."Company Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Company Contact No.';
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contact No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name';
                    Editable = false;
                }
                field(Email; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'E-Mail';
                    Editable = false;
                    Enabled = true;
                    ExtendedDatatype = None;
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Created';
                    Editable = false;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Customer No.';
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer Name';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            // action("Auto Generate Password")
            // {
            //     Caption = 'Auto Generate Password';
            //     ToolTip = 'Auto Generate Password';
            //     ApplicationArea = All;
            //     Image = SendMail;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;

            //     trigger OnAction()
            //     begin
            //         if not Rec.IsWorkflowNotificationsEnabled() then
            //             Rec.ResetPasswordWithAutoGen(false)
            //         else
            //             Rec.ResetPasswordWithAutoGen(Confirm(cnfDoPasswordWFlowQst));
            //     end;
            // }
            // action("Manual Set Password")
            // {
            //     Caption = 'Manual Set Password';
            //     ToolTip = 'Manual Set Password';
            //     ApplicationArea = All;
            //     Image = Edit;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;

            //     trigger OnAction()
            //     begin
            //         Rec.ResetPasswordFromUI(Confirm(cnfDoPasswordWFlowQst));
            //     end;
            // }
        }
        area(navigation)
        {
            action(PortalUserBranches)
            {
                ApplicationArea = All;
                Caption = 'Portal User Branches';
                ToolTip = 'Portal User Branches';
                Image = User;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
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
    }

    // var
    //     cnfDoPasswordWFlowQst: label 'Would you like the password reset to trigger the workflow associated with it in the NAV Portal Setup?';
}

