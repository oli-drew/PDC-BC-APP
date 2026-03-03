/// <summary>
/// PageExtension PDC E-Doc Service Card Ext (ID 50300) extends E-Document Service.
/// Adds Azure File Share configuration fields for EDI import.
/// </summary>
pageextension 50300 "PDC E-Doc Service Card Ext" extends "E-Document Service"
{
    layout
    {
        addafter(ImportProcessing)
        {
            group(PDCAzureFileShare)
            {
                Caption = 'Azure File Share';

                field("PDC Azure Storage Account"; Rec."PDC Azure Storage Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure Storage Account name for the file share connection.';
                }
                field("PDC Azure File Share"; Rec."PDC Azure File Share")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Azure File Share name to connect to.';
                }
                field("PDC Azure Directory Path"; Rec."PDC Azure Directory Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the directory path within the file share where inbound files are retrieved.';
                }
                field("PDC Azure Outbound Dir Path"; Rec."PDC Azure Outbound Dir Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the directory path within the file share where outbound documents are uploaded.';
                }
                field(PDCSASTokenConfigured; SASTokenConfigured)
                {
                    ApplicationArea = All;
                    Caption = 'SAS Token Configured';
                    ToolTip = 'Indicates whether a SAS token has been configured for authentication.';
                    Editable = false;
                }
            }
            group(PDCEDISettings)
            {
                Caption = 'EDI Import Settings';

                field("PDC Customer No."; Rec."PDC Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer for which orders will be created from this service.';
                }
                field("PDC Order Source"; Rec."PDC Order Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the order source code to set on created sales orders.';
                }
                field("PDC Dummy Vendor No."; Rec."PDC Dummy Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a vendor used to satisfy E-Document framework validation. This vendor is not actually used for document creation.';
                }
            }
        }
    }

    actions
    {
        addafter(Receive)
        {
            action(PDCSetSASToken)
            {
                ApplicationArea = All;
                Caption = 'Set SAS Token';
                ToolTip = 'Configure the Azure SAS token for authentication.';
                Image = EncryptionKeys;

                trigger OnAction()
                var
                    SASTokenDialog: Page "PDC SAS Token Dialog";
                    SASTokenSetMsg: Label 'SAS Token has been configured.';
                begin
                    SASTokenDialog.SetEDocumentService(Rec);
                    if SASTokenDialog.RunModal() = Action::OK then begin
                        CurrPage.Update(false);
                        Message(SASTokenSetMsg);
                    end;
                end;
            }
            action(PDCClearSASToken)
            {
                ApplicationArea = All;
                Caption = 'Clear SAS Token';
                ToolTip = 'Remove the configured Azure SAS token.';
                Image = Delete;

                trigger OnAction()
                var
                    ClearConfirmQst: Label 'Are you sure you want to clear the SAS token?';
                    SASTokenClearedMsg: Label 'SAS Token has been cleared.';
                begin
                    if Confirm(ClearConfirmQst) then begin
                        Rec.DeleteSASToken();
                        Clear(Rec."PDC Azure SAS Token Key");
                        Rec.Modify(true);
                        Message(SASTokenClearedMsg);
                    end;
                end;
            }
            action(PDCTestConnection)
            {
                ApplicationArea = All;
                Caption = 'Test Connection';
                ToolTip = 'Test the connection to Azure File Share.';
                Image = ValidateEmailLoggingSetup;

                trigger OnAction()
                var
                    PDCEDIImportMgt: Codeunit "PDC EDI Import Mgt";
                begin
                    PDCEDIImportMgt.TestConnection(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SASTokenConfigured := Rec.HasSASToken();
    end;

    var
        SASTokenConfigured: Boolean;
}
