/// <summary>
/// Page PDC Nav Portal Card (ID 50089).
/// </summary>
page 50089 "PDC Nav Portal Card"
{
    Caption = 'Nav Portal Card';
    PageType = Card;
    SourceTable = "PDC Portal";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
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
                field(nEPayURL; Rec."nEPay URL")
                {
                    ToolTip = 'nEPay URL';
                    ApplicationArea = All;
                }
                field(nEPayMerchantId; Rec."nEPay Merchant Id")
                {
                    ToolTip = 'nEPay Merchant Id';
                    ApplicationArea = All;
                }
                field(UseWorkflowNotifications; Rec."Use Workflow Notifications")
                {
                    ToolTip = 'Use Workflow Notifications';
                    ApplicationArea = All;
                }
                field(ApplyReturnToInvoice; Rec."Apply Return To Invoice")
                {
                    ToolTip = 'Apply Return To Invoice';
                    ApplicationArea = All;
                }
                field(PageSize; Rec."Page Size")
                {
                    ToolTip = 'Page Size';
                    ApplicationArea = All;
                }
            }
            group(SeriesNos)
            {
                Caption = 'Series Nos.';
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
            group(InformationBar)
            {
                Caption = 'Information Bar';
                field(ShowMessage; Rec."Show Message")
                {
                    ToolTip = 'Show Message';
                    ApplicationArea = All;
                }
                field(MessageText; Rec."Message Text")
                {
                    ToolTip = 'Message Text';
                    ApplicationArea = All;
                }
                field(LinkAddress; Rec."Link Address")
                {
                    ToolTip = 'Link Address';
                    ApplicationArea = All;
                }
                field(OverrideDisplayCookie; Rec."Override Display Cookie")
                {
                    ToolTip = 'Override Display Cookie';
                    ApplicationArea = All;
                }
            }
            group(B2CUsers)
            {
                Caption = 'Users Creation';
                field(TenantId; Rec."Tenant Id")
                {
                    ToolTip = 'Tenant Id';
                    ApplicationArea = All;
                }
                field(ClientId; Rec."Client Id")
                {
                    ToolTip = 'Tenant Id';
                    ApplicationArea = All;
                }
                field(Secret; Rec.Secret)
                {
                    ToolTip = 'Secret';
                    ApplicationArea = All;
                }
                field(Issuer; Rec.Issuer)
                {
                    ToolTip = 'Issuer';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                Visible = false;
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

