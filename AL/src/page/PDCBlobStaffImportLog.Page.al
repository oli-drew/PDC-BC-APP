/// <summary>
/// Page PDC Blob Staff Import Log (ID 50117).
/// View import log entries.
/// </summary>
page 50117 "PDC Blob Staff Import Log"
{
    Caption = 'Blob Staff Import Log';
    PageType = List;
    SourceTable = "PDC Blob Staff Import Log";
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Import DateTime"; Rec."Import DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the import was run.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer.';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the imported file name.';
                }
                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Excel row number.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the import status.';
                    StyleExpr = StatusStyle;
                }
                field("Wearer ID"; Rec."Wearer ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Wearer ID from Excel.';
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BC Staff ID.';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first name.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last name.';
                }
                field("Branch ID"; Rec."Branch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the branch ID.';
                }
                field("Wardrobe ID"; Rec."Wardrobe ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the wardrobe ID.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract ID.';
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result message or error.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenStaff)
            {
                Caption = 'Open Staff Card';
                ToolTip = 'Open the staff card for this entry.';
                ApplicationArea = All;
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec."Staff ID" <> '';

                trigger OnAction()
                var
                    Staff: Record "PDC Branch Staff";
                begin
                    if Staff.Get(Rec."Staff ID") then
                        Page.Run(Page::"PDC Branch Staff Card", Staff);
                end;
            }
            action(DeleteOldEntries)
            {
                Caption = 'Delete Old Entries';
                ToolTip = 'Delete log entries older than 30 days.';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                var
                    ImportLog: Record "PDC Blob Staff Import Log";
                    DeletedCount: Integer;
                begin
                    ImportLog.SetFilter("Import DateTime", '<%1', CreateDateTime(CalcDate('<-30D>', Today), 0T));
                    DeletedCount := ImportLog.Count;
                    ImportLog.DeleteAll();
                    Message(DeletedEntriesMsg, DeletedCount);
                end;
            }
        }
    }

    var
        StatusStyle: Text;
        DeletedEntriesMsg: Label 'Deleted %1 log entries.';

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Created:
                StatusStyle := 'Favorable';
            Rec.Status::Updated:
                StatusStyle := 'StrongAccent';
            Rec.Status::Skipped:
                StatusStyle := 'Ambiguous';
            Rec.Status::Error:
                StatusStyle := 'Unfavorable';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
