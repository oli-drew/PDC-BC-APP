/// <summary>
/// Page PDC Portal User Ship-to Addrs (ID 50003).
/// </summary>
page 50003 "PDC Portal User Ship-to Addrs"
{
    Caption = 'Portal User Ship-to Addresses';
    SourceTable = "PDC Portal User Ship-to Addrs";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Portal User ID"; Rec."Portal User ID")
                {
                    ApplicationArea = All;
                    Tooltip = 'Portal User ID';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Sell-To Customer No.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Ship-to Code';
                }
            }
        }
    }
}
