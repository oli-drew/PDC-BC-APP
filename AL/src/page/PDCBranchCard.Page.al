/// <summary>
/// Page PDC Branch Card (ID 50028).
/// </summary>
page 50028 "PDC Branch Card"
{

    Caption = 'Branch Card';
    PageType = Card;
    SourceTable = "PDC Branch";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                }
                field(BranchNo; Rec."Branch No.")
                {
                    ToolTip = 'Branch No.';
                    ApplicationArea = All;
                }
                field("Parent Branch No."; Rec."Parent Branch No.")
                {
                    ToolTip = 'Parent Branch No.';
                    ApplicationArea = All;
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Branch Staff List";
                RunPageLink = "Sell-to Customer No." = field("Customer No."),
                              "Branch ID" = field("Branch No.");
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        Rec.TestField("Customer No."); //DOC JC 110717 PDCP5
    end;
}

