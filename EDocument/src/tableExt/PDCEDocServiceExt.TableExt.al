/// <summary>
/// TableExtension PDC E-Doc Service Ext (ID 50300) extends E-Document Service.
/// Adds Azure File Share connection settings and EDI import configuration.
/// </summary>
tableextension 50300 "PDC E-Doc Service Ext" extends "E-Document Service"
{
    fields
    {
        field(50300; "PDC Azure Storage Account"; Text[100])
        {
            Caption = 'Azure Storage Account Name';
            ToolTip = 'Specifies the Azure Storage Account name for the file share connection.';
            DataClassification = CustomerContent;
        }
        field(50301; "PDC Azure File Share"; Text[100])
        {
            Caption = 'Azure File Share Name';
            ToolTip = 'Specifies the Azure File Share name to connect to.';
            DataClassification = CustomerContent;
        }
        field(50302; "PDC Azure Directory Path"; Text[250])
        {
            Caption = 'Azure Directory Path';
            ToolTip = 'Specifies the directory path within the file share where files are stored.';
            DataClassification = CustomerContent;
        }
        field(50303; "PDC Azure SAS Token Key"; Guid)
        {
            Caption = 'Azure SAS Token Key';
            ToolTip = 'Specifies the key for the SAS token stored in Isolated Storage.';
            DataClassification = SystemMetadata;
        }
        field(50305; "PDC Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer for which orders will be created from this service.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(50306; "PDC Order Source"; Code[20])
        {
            Caption = 'Order Source';
            ToolTip = 'Specifies the order source code to set on created sales orders.';
            DataClassification = CustomerContent;
        }
        field(50307; "PDC Dummy Vendor No."; Code[20])
        {
            Caption = 'Dummy Vendor No.';
            ToolTip = 'Specifies a vendor used to satisfy E-Document framework validation. This vendor is not actually used for document creation.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(50308; "PDC Azure Outbound Dir Path"; Text[250])
        {
            Caption = 'Azure Outbound Directory Path';
            ToolTip = 'Specifies the directory path within the file share where outbound documents are uploaded. If empty, uses the same directory as inbound.';
            DataClassification = CustomerContent;
        }
    }

    /// <summary>
    /// Stores the SAS token in Isolated Storage.
    /// </summary>
    procedure SetSASToken(SASToken: Text)
    begin
        if IsNullGuid(Rec."PDC Azure SAS Token Key") then
            Rec."PDC Azure SAS Token Key" := CreateGuid();

        IsolatedStorage.Set(Rec."PDC Azure SAS Token Key", SASToken, DataScope::Company);
    end;

    /// <summary>
    /// Retrieves the SAS token value from Isolated Storage.
    /// </summary>
    procedure GetSASTokenValue(): Text
    var
        SASToken: Text;
    begin
        if not IsNullGuid(Rec."PDC Azure SAS Token Key") then
            if IsolatedStorage.Get(Rec."PDC Azure SAS Token Key", DataScope::Company, SASToken) then
                exit(SASToken);
        exit('');
    end;

    /// <summary>
    /// Checks if a SAS token is configured.
    /// </summary>
    procedure HasSASToken(): Boolean
    begin
        if IsNullGuid(Rec."PDC Azure SAS Token Key") then
            exit(false);
        exit(IsolatedStorage.Contains(Rec."PDC Azure SAS Token Key", DataScope::Company));
    end;

    /// <summary>
    /// Deletes the SAS token from Isolated Storage.
    /// </summary>
    procedure DeleteSASToken()
    begin
        if not IsNullGuid(Rec."PDC Azure SAS Token Key") then
            if IsolatedStorage.Contains(Rec."PDC Azure SAS Token Key", DataScope::Company) then
                IsolatedStorage.Delete(Rec."PDC Azure SAS Token Key", DataScope::Company);
    end;
}
