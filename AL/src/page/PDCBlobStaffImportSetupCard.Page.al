/// <summary>
/// Page PDC Blob Staff Import Setup Card (ID 50115).
/// Configure staff import settings per customer.
/// </summary>
page 50115 "PDC Blob Staff Imp. Setup Card"
{
    Caption = 'Blob Staff Import Setup Card';
    PageType = Card;
    SourceTable = "PDC Blob Staff Import Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
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
            }
            group(AzureConnection)
            {
                Caption = 'Azure Connection';
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
                field("SAS Token"; Rec."SAS Token")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SAS token for authentication.';
                }
                field("File Name Pattern"; Rec."File Name Pattern")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file name pattern to match (e.g., *.xlsx).';
                }
            }
            group(ImportOptions)
            {
                Caption = 'Import Options';
                field("Create New Staff"; Rec."Create New Staff")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to create new staff records during import.';
                }
                field("Update Existing Staff"; Rec."Update Existing Staff")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to update existing staff records during import.';
                }
            }
            group(LastImport)
            {
                Caption = 'Last Import';
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
                field("Last Import Staff Created"; Rec."Last Import Staff Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of staff records created in the last import.';
                }
                field("Last Import Staff Updated"; Rec."Last Import Staff Updated")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of staff records updated in the last import.';
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
            action(TestConnection)
            {
                Caption = 'Test Connection';
                ToolTip = 'Test the Azure Blob Storage connection.';
                ApplicationArea = All;
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.TestConnection() then
                        Message(ConnectionSuccessfulMsg)
                    else
                        Error(ConnectionFailedErr);
                end;
            }
            action(RunImportNow)
            {
                Caption = 'Run Import Now';
                ToolTip = 'Run the staff import immediately.';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BlobStaffImport: Codeunit "PDC Blob Staff Import";
                    Success: Boolean;
                begin
                    Success := BlobStaffImport.RunImport(Rec."Customer No.");
                    Rec.Find();
                    if Success then
                        Message(ImportCompletedMsg, Rec."Last Import Staff Created", Rec."Last Import Staff Updated", Rec."Last Import Errors")
                    else
                        Message(NoFilesFoundMsg);
                end;
            }
        }
        area(Navigation)
        {
            action(ViewStaffList)
            {
                Caption = 'View Staff List';
                ToolTip = 'View the branch staff list for this customer.';
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "PDC Branch Staff List";
                RunPageLink = "Sell-to Customer No." = field("Customer No.");
            }
            action(ViewImportLog)
            {
                Caption = 'View Import Log';
                ToolTip = 'View the import log history for this customer.';
                ApplicationArea = All;
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "PDC Blob Staff Import Log";
                RunPageLink = "Customer No." = field("Customer No.");
            }
        }
    }

    var
        ConnectionSuccessfulMsg: Label 'Connection to Azure Blob Storage was successful.';
        ConnectionFailedErr: Label 'Connection to Azure Blob Storage failed. Please check your settings.';
        ImportCompletedMsg: Label 'Import completed.\Created: %1\Updated: %2\Errors: %3';
        NoFilesFoundMsg: Label 'No files found matching the pattern in the container.';
}
