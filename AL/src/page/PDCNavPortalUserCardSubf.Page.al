/// <summary>
/// Page PDC Nav Portal User Card Subf. (ID 50087).
/// </summary>
page 50087 "PDC Nav Portal User Card Subf."
{
    Caption = 'Nav Portal User Card Subf.';
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "PDC Portal User Role";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserId; Rec."User Id")
                {
                    ToolTip = 'User Id';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(PortalCode; Rec."Portal Code")
                {
                    ToolTip = 'Portal Code';
                    ApplicationArea = All;
                }
                field(UserRoleCode; Rec."User Role Code")
                {
                    ToolTip = 'User Role Code';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

