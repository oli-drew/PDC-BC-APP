/// <summary>
/// Page PDC Nav Portal List (ID 50088).
/// </summary>
page 50088 "PDC Nav Portal List"
{
    Caption = 'Nav Portal List';
    CardPageID = "PDC Nav Portal Card";
    PageType = List;
    SourceTable = "PDC Portal";
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
                field(PortalType; Rec."Portal Type")
                {
                    ToolTip = 'Portal Type';
                    ApplicationArea = All;
                }
                field(Url; Rec.Url)
                {
                    ToolTip = 'Url';
                    ApplicationArea = All;
                }
                field(ResetPwdEmailTemplCode; Rec."Reset Pwd. Email Templ. Code")
                {
                    ToolTip = 'Reset Pwd. Email Templ. Code';
                    ApplicationArea = All;
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ToolTip = 'Email Address';
                    ApplicationArea = All;
                }
                field(EmailSenderName; Rec."Email Sender Name")
                {
                    ToolTip = 'Email Sender Name';
                    ApplicationArea = All;
                }
                field(WardrobeSeriesNos; Rec."Wardrobe Series Nos.")
                {
                    ToolTip = 'Wardrobe Series Nos.';
                    ApplicationArea = All;
                }
                field(DraftOrdersSeriesNos; Rec."Draft Orders Series Nos.")
                {
                    ToolTip = 'Draft Orders Series Nos.';
                    ApplicationArea = All;
                }
                field("Contract Series Nos."; Rec."Contract Series Nos.")
                {
                    ToolTip = 'Contract Series Nos.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }
}

