/// <summary>
/// Page PDC Portal User Wardrobes (ID 50023).
/// </summary>
Page 50072 "PDC Portal User Wardrobes"
{
    Caption = 'Portal User Wardrobes';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "PDC Portal User Wardrobe";
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
                        Rec.TestField("Sell-To Customer No.");
                    end;
                }
                field(SellToCustomerNo; Rec."Sell-To Customer No.")
                {
                    ToolTip = 'Sell-To Customer No.';
                    ApplicationArea = All;
                }
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

