/// <summary>
/// Page PDC Email Management Setup List (ID 50010).
/// </summary>
page 50010 "PDC Email Managem. Setup List"
{
    Caption = 'Email Management Setup List';
    Editable = false;
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    CardPageId = "PDC Email Management Setup";
    SourceTable = "PDC Email Management Setup";
    SourceTableView = sorting(Code, Type, "Line No.")
                      where(Type = const(Setup));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code';
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Subject';
                }
                field(Parameter1; Rec."Parameter 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Parameter 1';
                }
                field(Parameter2; Rec."Parameter 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Parameter 2';
                }
                field(Parameter3; Rec."Parameter 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Parameter 3';
                }
                field("Email HTML Template Exists"; Rec."Email HTML Template".Hasvalue)
                {
                    Caption = 'Email HTML Template Exists';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Email HTML Template Exists';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action26>")
            {
                ApplicationArea = All;
                Caption = 'Card';
                ToolTip = 'Card';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                begin
                    Page.Run(Page::"PDC Email Management Setup", Rec)
                end;
            }
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

