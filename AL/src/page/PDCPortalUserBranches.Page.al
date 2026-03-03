/// <summary>
/// Page PDC Portal User Branches (ID 50023).
/// </summary>
Page 50023 "PDC Portal User Branches"
{
    Caption = 'Portal User Branches';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "PDC Portal User Branch";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PortalUserID; Rec."Portal User ID")
                {
                    ToolTip = 'Portal User ID';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        // Testfield here because on table prevented the page from opening pre-filtered
                        Rec.TestField("Sell-To Customer No."); //DOC PDCP98 JF 26/12/2017 -+
                    end;
                }
                field(SellToCustomerNo; Rec."Sell-To Customer No.")
                {
                    ToolTip = 'Sell-To Customer No.';
                    ApplicationArea = All;
                }
                field(BranchID; Rec."Branch ID")
                {
                    ToolTip = 'Branch ID';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

