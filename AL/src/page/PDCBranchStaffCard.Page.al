/// <summary>
/// Page PDC Branch Staff Card (ID 50029).
/// </summary>
page 50029 "PDC Branch Staff Card"
{
    Caption = 'Branch Staff Card';
    PageType = Card;
    SourceTable = "PDC Branch Staff";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit(); //DOC PDCP57 JF 20/11/2017 -+
                    end;
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
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    ToolTip = 'Created By';
                    Editable = false;
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = All;
                    Caption = 'Created On';
                    ToolTip = 'Created On';
                    Editable = false;
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
        area(Processing)
        {
            action(GetApprovers)
            {
                ApplicationArea = All;
                Caption = 'Get Approvers';
                ToolTip = 'Get Approvers';
                Image = ApprovalSetup;

                trigger OnAction()
                var
                    TempApproversPortalUser: Record "PDC Portal User" temporary;
                    PortalsManagement: Codeunit "PDC Portals Management";
                begin
                    PortalsManagement.GetStaffApproversList(TempApproversPortalUser, Rec);
                    page.run(0, TempApproversPortalUser);
                end;
            }
        }
        area(Promoted)
        {
            group(Staff)
            {
                Caption = 'Staff';

                actionref(Entitlement_Promoted; Entitlement)
                { }
                actionref(Wardrobe_Promoted; Wardrobe)
                { }
                actionref(StaffUniformHistory_Promoted; StaffUniformHistory)
                { }
                actionref(EntitlementPredicted_Promoted; EntitlementPredicted)
                { }
            }
            group(Approvers)
            {
                Caption = 'Approvers';
                actionref(GetApprovers_Promoted; GetApprovers)
                { }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if ((Rec."Staff ID" <> '') and (Rec."Sell-to Customer No." <> '')) then begin
            Rec.TestField("Branch ID");
            Rec.TestField("Body Type/Gender");
        end;
    end;
}

