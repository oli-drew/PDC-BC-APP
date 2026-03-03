/// <summary>
/// Page PDC Branch Staff List (ID 50026).
/// </summary>
page 50026 "PDC Branch Staff List"
{
    Caption = 'Branch Staff List';
    CardPageID = "PDC Branch Staff Card";
    Editable = false;
    PageType = List;
    SourceTable = "PDC Branch Staff";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Sell-to Customer No.';
                    ApplicationArea = All;
                }
                field(BranchID; Rec."Branch ID")
                {
                    ToolTip = 'Branch ID';
                    ApplicationArea = All;
                }
                field(FirstName; Rec."First Name")
                {
                    ToolTip = 'First Name';
                    ApplicationArea = All;
                }
                field(LastName; Rec."Last Name")
                {
                    ToolTip = 'Last Name';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Name';
                    ApplicationArea = All;
                }
                field(BodyTypeGender; Rec."Body Type/Gender")
                {
                    ToolTip = 'Body Type/Gender';
                    ApplicationArea = All;
                }
                field(WearerID; Rec."Wearer ID")
                {
                    ToolTip = 'Wearer ID';
                    ApplicationArea = All;
                }
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                }
                field(ContractID; Rec."Contract ID")
                {
                    ToolTip = 'Contract ID';
                    ApplicationArea = All;
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ToolTip = 'Email Address';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Blocked';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Entitlement)
            {
                ApplicationArea = All;
                Caption = '&Entitlement';
                ToolTip = 'Entitlement';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Staff Entitlement List";
                RunPageLink = "Staff ID" = field("Staff ID"),
                              "Customer No." = field("Sell-to Customer No."),
                              "Branch No." = field("Branch ID");
                RunPageMode = View;
            }
            action(Wardrobe)
            {
                ApplicationArea = All;
                Caption = '&Wardrobe';
                ToolTip = 'Wardrobe';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Wardrobe Line List";
                RunPageLink = "Customer No." = field("Sell-to Customer No."),
                              "Wardrobe ID" = field("Wardrobe ID");
                RunPageMode = View;
            }
            action(StaffUniformHistory)
            {
                ApplicationArea = All;
                Caption = 'Staff Uniform History';
                ToolTip = 'Staff Uniform History';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Staff Uniform History";
                RunPageLink = "Staff ID" = field("Staff ID");
                RunPageMode = View;
            }
            action(StaffSizes)
            {
                ApplicationArea = All;
                Caption = 'Staff Sizes';
                ToolTip = 'Staff Sizes';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Staff Sizes";
                RunPageLink = "Staff ID" = field("Staff ID");
                RunPageMode = View;
            }
            action(EntitlementPredicted)
            {
                ApplicationArea = All;
                Caption = 'Entitlement Predicted';
                ToolTip = 'Entitlement Predicted';
                Image = LedgerEntries;
                RunObject = Page "PDC Staff Entitlement Predict.";
                RunPageLink = "Staff ID" = field("Staff ID"),
                              "Customer No." = field("Sell-to Customer No."),
                              "Branch No." = field("Branch ID");
            }
        }
    }
}

