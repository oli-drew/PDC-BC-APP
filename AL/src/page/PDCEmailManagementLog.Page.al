/// <summary>
/// Page PDC Email Management Log (ID 50011).
/// </summary>
page 50011 "PDC Email Management Log"
{
    Caption = 'Email Management Log';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = History;
    ApplicationArea = All;
    SourceTable = "PDC Email Management Setup";
    SourceTableView = sorting(Code, Type, "Line No.")
                      where(Type = const(Log));

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
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ToolTip = 'Email Address';
                    ApplicationArea = All;
                }
                field(CCAddresses; Rec."CC Addresses")
                {
                    ToolTip = 'CC Addresses';
                    ApplicationArea = All;
                }
                field("Mailing Group"; Rec."Mailing Group")
                {
                    ToolTip = 'Mailing Group';
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Subject';
                    ApplicationArea = All;
                }
                field(Skip; Rec.Skip)
                {
                    ToolTip = 'Skip';
                    ApplicationArea = All;
                }
                field(Body; Rec.Body)
                {
                    ToolTip = 'Body';
                    ApplicationArea = All;
                }
                field(FileAttachmentLocationLog; Rec."File Attachment Location Log")
                {
                    ToolTip = 'File Attachment Location Log';
                    ApplicationArea = All;
                }
                field(BodyBLOB; Rec."Body BLOB".HasValue)
                {
                    Caption = 'BodyBLOB';
                    ToolTip = 'BodyBLOB';
                    ApplicationArea = All;
                }
                field(Sent; Rec.Sent)
                {
                    ToolTip = 'Sent';
                    ApplicationArea = All;
                }
                field(DateSent; Rec."Date Sent")
                {
                    ToolTip = 'Date Sent';
                    ApplicationArea = All;
                }
                field(ErrorText; Rec."Error Text")
                {
                    ToolTip = 'Error Text';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendEmail)
            {
                Caption = 'Send E-mails';
                ToolTip = 'Send E-mails';
                Image = Email;
                ApplicationArea = All;

                trigger OnAction()
                var
                    EmailMgmt: Codeunit "PDC Email Management";
                begin
                    EmailMgmt.SendEmails();
                end;
            }

            action(SkipEmail)
            {
                Caption = 'Skip';
                ToolTip = 'Skip';
                Image = Default;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Rec.IsEmpty() then begin
                        Rec.Skip := true;
                        Rec.Modify();
                    end;
                end;
            }
            action(ExportAttachment)
            {
                ApplicationArea = All;
                Caption = 'Export Attachment';
                ToolTip = 'Export Attachment';
                Image = Export;

                trigger OnAction()
                begin
                    Rec.ExportAttachment();
                end;
            }
        }
    }
}

