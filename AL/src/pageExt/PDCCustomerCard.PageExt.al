/// <summary>
/// PageExtension PDCCustomerCard (ID 50001) extends Record Customer Card.
/// </summary>
PageExtension 50001 PDCCustomerCard extends "Customer Card"
{
    layout
    {

        modify("Phone No.")
        {
            trigger OnAssistEdit()
            begin
                TAPIManagement.Dial(Rec."Phone No."); //DN9.00 
            end;
        }

        addafter(Name)
        {
            field(PDCCompanyNumber; Rec."PDC Company Number")
            {
                ToolTip = 'Company Number';
                ApplicationArea = All;
            }
        }

        addafter("Country/Region Code")
        {
            field("PDC Phone"; Rec."Phone No.")
            {
                ToolTip = 'Phone No.';
                ApplicationArea = All;
                trigger OnAssistEdit()
                begin
                    TAPIManagement.Dial(Rec."Phone No."); //DN9.00 
                end;
            }
        }
        addafter(Blocked)
        {
            field(PDCDonotsendEMails; Rec."PDC Do not send E-Mails")
            {
                ToolTip = 'Do not send E-Mails';
                ApplicationArea = All;
                Visible = false;
            }
            field(PDCDonotprintsendreports; Rec."PDC Do not print/send reports")
            {
                ToolTip = 'Do not print/send reports';
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter(General)
        {
            group(PDCGeneralFastTab)
            {
                CaptionML = ENU = 'PDC General';
                field("PDC Carriage Charge Limit"; Rec."PDC Carriage Charge Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Carriage Charge Limit';
                }
                field("PDC Allow Auto-Pick"; Rec."PDC Allow Auto-Pick")
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow Auto-Pick';
                }
                field("PDC Default Branch No."; Rec."PDC Default Branch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default Branch No.';
                }
                field("PDC Branch Mandatory"; Rec."PDC Branch Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Branch Mandatory';
                }
                field("PDC Block Release"; Rec."PDC Block Release")
                {
                    ApplicationArea = All;
                    ToolTip = 'Block Release';
                }
                group(PDCDocumentEmailSettings)
                {
                    ShowCaption = false;
                    grid("PDC Documents E-mail Settings")
                    {
                        Caption = 'Documents E-mail Settings';
                        GridLayout = Rows;
                        group(PDCDocumentEmailSettings1)
                        {
                            ShowCaption = false;
                            field("PDC Statement E-Mail"; Rec."PDC Statement E-Mail")
                            {
                                ToolTip = 'Statement E-Mail';
                                ApplicationArea = All;
                            }
                            field("PDC Statement Mailing Group"; Rec."PDC Statement Mailing Group")
                            {
                                ToolTip = 'Statement Mailing Group';
                                ApplicationArea = All;
                            }
                            field("PDC Send Statement"; Rec."PDC Send Statement")
                            {
                                ApplicationArea = All;
                                Caption = 'Send';
                                ToolTip = 'Send';
                            }
                            field("PDC Print Statement"; Rec."PDC Print Statement")
                            {
                                ApplicationArea = All;
                                Caption = 'Print';
                                ToolTip = 'Print';
                            }
                        }
                        group(PDCDocumentEmailSettings2)
                        {
                            ShowCaption = false;
                            field("PDC Invoice E-Mail"; Rec."PDC Invoice E-Mail")
                            {
                                ToolTip = 'Invoice E-Mail';
                                ApplicationArea = All;
                            }
                            field("PDC Invoice Mailing Group"; Rec."PDC Invoice Mailing Group")
                            {
                                ToolTip = 'Invoice Mailing Group';
                                ApplicationArea = All;
                            }
                            field("PDC Send Invoice"; Rec."PDC Send Invoice")
                            {
                                ApplicationArea = All;
                                Caption = 'Send';
                                ToolTip = 'Send';
                            }
                            field("PDC Print Invoice"; Rec."PDC Print Invoice")
                            {
                                ApplicationArea = All;
                                Caption = 'Print';
                                ToolTip = 'Print';
                            }
                        }
                    }
                }
            }
            group(PDCPortal)
            {
                CaptionML = ENU = 'PDC Portal';
                field("PDC Use Custom Reason Codes"; Rec."PDC Use Custom Reason Codes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Use Custom Reason Codes';
                }
                field("PDC PO Number Format"; Rec."PDC PO Number Format")
                {
                    ApplicationArea = All;
                    ToolTip = 'PO Number Format';
                }
                field("PDC Contract No. Format"; Rec."PDC Contract No. Format")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contract No. Format';
                }
                field("PDC Portal Default Split Order"; Rec."PDC Portal Default Split Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Portal Default Split Order';
                }
                field("PDC Portal Logo"; Rec."PDC Portal Logo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Portal Logo';
                }
                field("PDC Entitlement Enabled"; Rec."PDC Entitlement Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Enabled';
                }
                field("PDC Over Entitlement Action"; Rec."PDC Over Entitlement Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Over Entitlement Action';
                }
            }
        }
    }
    actions
    {


        addafter("Sales Journal")
        {
            action("PDCSendStatement")
            {
                ApplicationArea = All;
                Caption = 'Send Statement';
                ToolTip = 'Send Statement';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.SendStatement(0D, 0D, true, true);
                end;
            }
            action("PDC Send Statement to All Customers")
            {
                ApplicationArea = All;
                Caption = 'Send Statement to All Customers';
                ToolTip = 'Send Statement to All Customers';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.SendStatementToAll();
                end;
            }
            action("PDC View Sent E-Mails")
            {
                ApplicationArea = All;
                Caption = 'View Sent E-Mails';
                ToolTip = 'View Sent E-Mails';
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "PDC Email Management Log";
                RunPageLink = "Customer No." = field("No.");
            }
        }
    }

    var
        TAPIManagement: Codeunit TAPIManagement;
}

