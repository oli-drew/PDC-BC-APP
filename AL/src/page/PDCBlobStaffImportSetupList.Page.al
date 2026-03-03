/// <summary>
/// Page PDC Blob Staff Import Setup List (ID 50116).
/// List all configured staff imports.
/// </summary>
page 50116 "PDC Blob Staff Imp. Setup List"
{
    Caption = 'Blob Staff Import Setup List';
    PageType = List;
    SourceTable = "PDC Blob Staff Import Setup";
    CardPageId = "PDC Blob Staff Imp. Setup Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer for this import configuration.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this import configuration is enabled.';
                }
                field("Storage Account Name"; Rec."Storage Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure Storage Account name.';
                }
                field("Container Name"; Rec."Container Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure Blob container name.';
                }
                field("Last Import DateTime"; Rec."Last Import DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the last import was run.';
                }
                field("Last Import File Name"; Rec."Last Import File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file name that was imported last.';
                }
                field("Last Import Errors"; Rec."Last Import Errors")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of errors in the last import.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunAllEnabled)
            {
                Caption = 'Run All Enabled';
                ToolTip = 'Run the staff import for all enabled configurations.';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BlobStaffImport: Codeunit "PDC Blob Staff Import";
                begin
                    BlobStaffImport.RunAllEnabled();
                    CurrPage.Update(false);
                    Message(ImportAllCompletedMsg);
                end;
            }
        }
    }

    var
        ImportAllCompletedMsg: Label 'Import completed for all enabled configurations.';
}
