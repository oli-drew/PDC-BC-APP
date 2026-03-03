/// <summary>
/// Page PDC Email Management Setup (ID 50008).
/// </summary>
page 50008 "PDC Email Management Setup"
{
    Caption = 'Email Management Setup';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "PDC Email Management Setup";
    SourceTableView = sorting(Code, Type, "Line No.")
                      where(Type = const(Setup));

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
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Subject';
                    ApplicationArea = All;
                }
                field(SenderEmailAddress; Rec."Sender Email Address")
                {
                    ToolTip = 'Sender Email Address';
                    ApplicationArea = All;
                }
                field(SenderEmailName; Rec."Sender Email Name")
                {
                    ToolTip = 'Sender Email Name';
                    ApplicationArea = All;
                }
                field("Email HTML Template Exists"; Rec."Email HTML Template".Hasvalue)
                {
                    Caption = 'Email HTML Template Exists';
                    ToolTip = 'Email HTML Template Exists';
                    ApplicationArea = All;
                    Editable = false;
                }
                group(Parameters)
                {
                    Caption = 'Parameters';

                    field(Parameter1; Rec."Parameter 1")
                    {
                        ToolTip = 'Parameter 1';
                        ApplicationArea = All;
                    }
                    field(Parameter2; Rec."Parameter 2")
                    {
                        ToolTip = 'Parameter 2';
                        ApplicationArea = All;
                    }
                    field(Parameter3; Rec."Parameter 3")
                    {
                        ToolTip = 'Parameter 3';
                        ApplicationArea = All;
                    }
                }
            }
            part(EmailManagementAddresses; "PDC Email Management Addresses")
            {
                SubPageLink = Code = field(Code),
                              Type = const(Address);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000024>")
            {
                ApplicationArea = All;
                Caption = 'Import HTML Template';
                ToolTip = 'Import HTML Template';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.ImportTemplate();
                end;
            }
            action("<Action1000000025>")
            {
                ApplicationArea = All;
                Caption = 'Remove HTML Template';
                ToolTip = 'Remove HTML Template';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction()
                begin
                    Rec.ClearTemplate();
                end;
            }
            action("<Action1000000026>")
            {
                ApplicationArea = All;
                Caption = 'Export HTML Template';
                ToolTip = 'Export HTML Template';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.ExportTemplate();
                end;
            }
        }
    }
}

