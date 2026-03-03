/// <summary>
/// Page PDC Nav Portal Roles (ID 50090).
/// </summary>
page 50090 "PDC Nav Portal Roles"
{
    Caption = 'Nav Portal Roles';
    PageType = List;
    SourceTable = "PDC Portal Role";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field("User Type"; Rec."User Type")
                {
                    ToolTip = 'User Type';
                    ApplicationArea = All;
                }

                field(AllowSSO; Rec.AllowSSO)
                {
                    ToolTip = 'AllowSSO';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DefaultRole; Rec.DefaultRole)
                {
                    ToolTip = 'DefaultRole';
                    ApplicationArea = All;
                }
                field(Incidents; Rec.Incidents)
                {
                    ToolTip = 'Incidents';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Finances; Rec.Finances)
                {
                    ToolTip = 'Finances';
                    ApplicationArea = All;
                }
                field(Orders; Rec.Orders)
                {
                    ToolTip = 'Orders';
                    ApplicationArea = All;
                }
                field(Workflow; Rec.Workflow)
                {
                    ToolTip = 'Workflow';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Returns; Rec.Returns)
                {
                    ToolTip = 'Returns';
                    ApplicationArea = All;
                }
                field(Staff; Rec.Staff)
                {
                    ToolTip = 'Staff';
                    ApplicationArea = All;
                }
                field(Contracts; Rec.Contracts)
                {
                    ToolTip = 'Contracts';
                    ApplicationArea = All;
                }
                field(GeneralReports; Rec."General Reports")
                {
                    ToolTip = 'General Reports';
                    ApplicationArea = All;
                }
                field(FinancialReports; Rec."Financial Reports")
                {
                    ToolTip = 'Financial Reports';
                    ApplicationArea = All;
                }
                field(Entitlement; Rec.Entitlement)
                {
                    ToolTip = 'Entitlement';
                    ApplicationArea = All;
                }
                field(Checkout; Rec.Checkout)
                {
                    ToolTip = 'Checkout';
                    ApplicationArea = All;
                }
                field(Wardrobe; Rec.Wardrobe)
                {
                    ToolTip = 'Wardrobe';
                    ApplicationArea = All;
                }
                field("Staff All Branches"; Rec."All Branches")
                {
                    ToolTip = 'Staff All Branches';
                    ApplicationArea = All;
                }
                field("Staff Request Approve"; Rec."Staff Request Approve")
                {
                    ToolTip = 'Staff Request Approve';
                    ApplicationArea = All;
                }
                field("Staff Request Create"; Rec."Staff Request Create")
                {
                    ToolTip = 'Staff Request Create';
                    ApplicationArea = All;
                }
                field("Address Create"; Rec."Address Create")
                {
                    ToolTip = 'Address Create';
                    ApplicationArea = All;
                }
                field("Address List Company"; Rec."Address List Company")
                {
                    ToolTip = 'Address List Company';
                    ApplicationArea = All;
                }
                field("Address List Branch"; Rec."Address List Branch")
                {
                    ToolTip = 'Address List Branch';
                    ApplicationArea = All;
                }
                field("Staff Create"; Rec."Staff Create")
                {
                    ToolTip = 'Staff Create';
                    ApplicationArea = All;
                }
                field("Staff Edit"; Rec."Staff Edit")
                {
                    ToolTip = 'Staff Edit';
                    ApplicationArea = All;
                }
                field("Address Edit"; Rec."Address Edit")
                {
                    ToolTip = 'Address Edit';
                    ApplicationArea = All;
                }
                field("Bulk Order"; Rec."Bulk Order")
                {
                    ToolTip = 'Bulk Order';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

