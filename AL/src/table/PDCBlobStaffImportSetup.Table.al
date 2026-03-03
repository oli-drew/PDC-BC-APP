/// <summary>
/// Table PDC Blob Staff Import Setup (ID 50059).
/// Stores per-customer Azure Blob connection settings for staff import.
/// </summary>
table 50059 "PDC Blob Staff Import Setup"
{
    Caption = 'PDC Blob Staff Import Setup';
    DataClassification = CustomerContent;
    LookupPageId = "PDC Blob Staff Imp. Setup List";
    DrillDownPageId = "PDC Blob Staff Imp. Setup List";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            NotBlank = true;
        }
        field(2; "Storage Account Name"; Text[100])
        {
            Caption = 'Storage Account Name';
        }
        field(3; "Container Name"; Text[100])
        {
            Caption = 'Container Name';
        }
        field(4; "SAS Token"; Text[500])
        {
            Caption = 'SAS Token';
            ExtendedDatatype = Masked;
        }
        field(5; Enabled; Boolean)
        {
            Caption = 'Enabled';
            InitValue = false;
        }
        field(6; "File Name Pattern"; Text[100])
        {
            Caption = 'File Name Pattern';
            InitValue = '*.xlsx';
        }
        field(10; "Create New Staff"; Boolean)
        {
            Caption = 'Create New Staff';
            InitValue = true;
        }
        field(11; "Update Existing Staff"; Boolean)
        {
            Caption = 'Update Existing Staff';
            InitValue = true;
        }
        field(20; "Last Import DateTime"; DateTime)
        {
            Caption = 'Last Import DateTime';
            Editable = false;
        }
        field(21; "Last Import File Name"; Text[250])
        {
            Caption = 'Last Import File Name';
            Editable = false;
        }
        field(22; "Last Import Staff Created"; Integer)
        {
            Caption = 'Last Import Staff Created';
            Editable = false;
        }
        field(23; "Last Import Staff Updated"; Integer)
        {
            Caption = 'Last Import Staff Updated';
            Editable = false;
        }
        field(24; "Last Import Errors"; Integer)
        {
            Caption = 'Last Import Errors';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestField("Customer No.");
    end;

    var
        BlobListUrlTxt: Label 'https://%1.blob.core.windows.net/%2?restype=container&comp=list&%3', Locked = true;
        BlobDownloadUrlTxt: Label 'https://%1.blob.core.windows.net/%2/%3?%4', Locked = true;

    /// <summary>
    /// Tests the Azure Blob connection by listing blobs.
    /// </summary>
    /// <returns>True if connection successful.</returns>
    procedure TestConnection(): Boolean
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: Text;
    begin
        TestField("Storage Account Name");
        TestField("Container Name");
        TestField("SAS Token");

        if not Client.Get(GetBlobListUrl(), Response) then
            exit(false);

        if not Response.IsSuccessStatusCode then
            exit(false);

        Response.Content.ReadAs(Content);
        exit(Content <> '');
    end;

    /// <summary>
    /// Gets the URL for listing blobs in the container.
    /// </summary>
    /// <returns>The blob list URL with SAS token.</returns>
    procedure GetBlobListUrl(): Text
    begin
        exit(StrSubstNo(BlobListUrlTxt, "Storage Account Name", "Container Name", CleanSasToken()));
    end;

    /// <summary>
    /// Gets the URL for downloading a specific blob.
    /// </summary>
    /// <param name="BlobName">The name of the blob to download.</param>
    /// <returns>The blob download URL with SAS token.</returns>
    procedure GetBlobDownloadUrl(BlobName: Text): Text
    begin
        exit(StrSubstNo(BlobDownloadUrlTxt, "Storage Account Name", "Container Name", BlobName, CleanSasToken()));
    end;

    local procedure CleanSasToken(): Text
    var
        Token: Text;
    begin
        Token := "SAS Token";
        if Token.StartsWith('?') then
            Token := CopyStr(Token, 2);
        exit(Token);
    end;
}
