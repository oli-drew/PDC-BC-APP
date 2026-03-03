/// <summary>
/// Page PDC Branches (ID 50018).
/// </summary>
page 50018 "PDC Branches"
{
    Caption = 'Branches';
    CardPageID = "PDC Branch Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "PDC Branch";
    ApplicationArea = All;
    RefreshOnActivate = true;
    SourceTableView = sorting("Presentation Order");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = BranchNo;
                ShowAsTree = true;
                ShowCaption = false;
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(BranchNo; Rec."Branch No.")
                {
                    ToolTip = 'Branch No.';
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Name';
                    ApplicationArea = All;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ToolTip = 'Customer Name';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Address';
                    ApplicationArea = All;
                }
                field(Address2; Rec."Address 2")
                {
                    ToolTip = 'Address 2';
                    ApplicationArea = All;
                }
                field(Address3; Rec."Address 3")
                {
                    ToolTip = 'Address 3';
                    ApplicationArea = All;
                }
                field(Address4; Rec."Address 4")
                {
                    ToolTip = 'Address 4';
                    ApplicationArea = All;
                }
                field(Address5; Rec."Address 5")
                {
                    ToolTip = 'Address 5';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'City';
                    ApplicationArea = All;
                }
                field(PostCode; Rec."Post Code")
                {
                    ToolTip = 'Post Code';
                    ApplicationArea = All;
                }
                field(Phone; Rec.Phone)
                {
                    ToolTip = 'Phone';
                    ApplicationArea = All;
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ToolTip = 'Ship-to Address';
                    ApplicationArea = All;
                }
                field("Default Branch"; Rec."Default Branch")
                {
                    ToolTip = 'Default Branch';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(PortalUserBranches)
            {
                ApplicationArea = All;
                Caption = 'Portal User Branches';
                ToolTip = 'Portal User Branches';
                Image = User;
                RunObject = Page "PDC Portal User Branches";
                RunPageLink = "Branch ID" = field("Branch No."),
                              "Sell-To Customer No." = field("Customer No.");
            }
            action(BranchStaff)
            {
                ApplicationArea = All;
                Caption = 'Branch Staff';
                ToolTip = 'Branch Staff';
                Image = User;
                RunObject = Page "PDC Branch Staff List";
                RunPageLink = "Sell-to Customer No." = field("Customer No."),
                              "Branch ID" = field("Branch No.");
            }
        }
        area(creation)
        {
            action(Recalculate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Recalculate';
                Image = Hierarchy;
                ToolTip = 'Update the tree of item categories based on recent changes.';

                trigger OnAction()
                var
                    PortalsManagement: Codeunit "PDC Portals Management";
                begin
                    PortalsManagement.UpdatePresentationOrder(Rec."Customer No.");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Branch)
            {
                Caption = 'Branch';

                actionref(PortalUserBranches_Promoted; PortalUserBranches)
                {
                }
                actionref(BranchStaff_Promoted; BranchStaff)
                {
                }
            }
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Recalculate_Promoted; Recalculate)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    // trigger OnOpenPage()
    // begin
    //     PortalMgt.CheckPresentationOrder();
    // end;

    var
        PortalMgt: Codeunit "PDC Portal Mgt";
        StyleTxt: Text;

}

