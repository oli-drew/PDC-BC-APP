/// <summary>
/// Codeunit PDC Azure File Share Connector (ID 50300).
/// Implements E-Document interfaces for Azure File Share connectivity.
/// </summary>
codeunit 50300 "PDC Azure File Share Connector" implements IDocumentSender, IDocumentReceiver, IReceivedDocumentMarker
{
    #region IDocumentSender

    /// <summary>
    /// Uploads the document to Azure File Share.
    /// </summary>
    procedure Send(var EDocument: Record "E-Document"; var EDocumentService: Record "E-Document Service"; SendContext: Codeunit SendContext)
    var
        TempBlob: Codeunit "Temp Blob";
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        InStream: InStream;
        RequestUrl: Text;
        FileName: Text;
        ContentLength: Integer;
    begin
        // Get document blob from SendContext
        TempBlob := SendContext.GetTempBlob();
        if not TempBlob.HasValue() then
            Error(EmptyDocumentErr);

        // Generate filename from document
        FileName := GenerateOutboundFileName(EDocument);

        // Build upload URL (uses outbound directory)
        RequestUrl := BuildUploadFileUrl(EDocumentService, FileName);

        // First, create the file with x-ms-type: file and Content-Length header
        // Azure File Share requires creating the file first, then writing content
        ContentLength := TempBlob.Length();

        // Step 1: Create empty file
        CreateAzureFile(EDocumentService, FileName, ContentLength);

        // Step 2: Write content using Put Range
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        HttpContent.WriteFrom(InStream);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/octet-stream');
        ContentHeaders.Add('x-ms-range', StrSubstNo('bytes=0-%1', ContentLength - 1));
        ContentHeaders.Add('x-ms-write', 'update');

        HttpRequest.Method('PUT');
        HttpRequest.SetRequestUri(BuildPutRangeUrl(EDocumentService, FileName));
        HttpRequest.Content(HttpContent);

        if not HttpClient.Send(HttpRequest, HttpResponse) then
            Error(UploadFailedErr, FileName, GetLastErrorText());

        if not HttpResponse.IsSuccessStatusCode() then
            Error(UploadHttpFailedErr, FileName, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase());

        // Update E-Document with file reference
        EDocument."File Name" := CopyStr(FileName, 1, MaxStrLen(EDocument."File Name"));
        EDocument.Modify();
    end;

    local procedure CreateAzureFile(var EDocumentService: Record "E-Document Service"; FileName: Text; ContentLength: Integer)
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        RequestUrl: Text;
    begin
        RequestUrl := BuildUploadFileUrl(EDocumentService, FileName);

        HttpRequest.Method('PUT');
        HttpRequest.SetRequestUri(RequestUrl);
        HttpRequest.GetHeaders(RequestHeaders);
        RequestHeaders.Add('x-ms-type', 'file');
        RequestHeaders.Add('x-ms-content-length', Format(ContentLength));

        if not HttpClient.Send(HttpRequest, HttpResponse) then
            Error(CreateFileFailedErr, FileName, GetLastErrorText());

        if not HttpResponse.IsSuccessStatusCode() then
            Error(CreateFileHttpFailedErr, FileName, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase());
    end;

    local procedure GenerateOutboundFileName(var EDocument: Record "E-Document"): Text
    var
        EDocumentService: Record "E-Document Service";
        FileExtension: Text;
    begin
        // Get file extension based on document format
        EDocumentService := EDocument.GetEDocumentService();
        FileExtension := GetFileExtension(EDocumentService."Document Format");

        if EDocument."Document No." <> '' then
            exit(EDocument."Document No." + FileExtension);

        // Fallback to Entry No if Document No is empty
        exit(Format(EDocument."Entry No") + FileExtension);
    end;

    local procedure GetFileExtension(DocumentFormat: Enum "E-Document Format"): Text
    begin
        case DocumentFormat of
            "E-Document Format"::"PDC CSV":
                exit('.csv');
            else
                exit('.xml');
        end;
    end;

    local procedure BuildUploadFileUrl(var EDocumentService: Record "E-Document Service"; FileName: Text): Text
    var
        SASToken: Text;
        Url: Text;
        DirectoryPath: Text;
    begin
        // https://{account}.file.core.windows.net/{share}/{directory}/{filename}?{sas}
        SASToken := EDocumentService.GetSASTokenValue();
        DirectoryPath := GetOutboundDirectoryPath(EDocumentService);
        if (DirectoryPath <> '') and (not DirectoryPath.EndsWith('/')) then
            DirectoryPath += '/';

        Url := StrSubstNo(
            'https://%1.file.core.windows.net/%2/%3%4?%5',
            EDocumentService."PDC Azure Storage Account",
            EDocumentService."PDC Azure File Share",
            DirectoryPath,
            FileName,
            SASToken
        );
        exit(Url);
    end;

    local procedure BuildPutRangeUrl(var EDocumentService: Record "E-Document Service"; FileName: Text): Text
    var
        SASToken: Text;
        Url: Text;
        DirectoryPath: Text;
    begin
        // https://{account}.file.core.windows.net/{share}/{directory}/{filename}?comp=range&{sas}
        SASToken := EDocumentService.GetSASTokenValue();
        DirectoryPath := GetOutboundDirectoryPath(EDocumentService);
        if (DirectoryPath <> '') and (not DirectoryPath.EndsWith('/')) then
            DirectoryPath += '/';

        Url := StrSubstNo(
            'https://%1.file.core.windows.net/%2/%3%4?comp=range&%5',
            EDocumentService."PDC Azure Storage Account",
            EDocumentService."PDC Azure File Share",
            DirectoryPath,
            FileName,
            SASToken
        );
        exit(Url);
    end;

    local procedure GetOutboundDirectoryPath(var EDocumentService: Record "E-Document Service"): Text
    begin
        // Use outbound directory if configured, otherwise fall back to inbound directory
        if EDocumentService."PDC Azure Outbound Dir Path" <> '' then
            exit(EDocumentService."PDC Azure Outbound Dir Path");
        exit(EDocumentService."PDC Azure Directory Path");
    end;

    #endregion

    #region IDocumentReceiver

    /// <summary>
    /// Retrieves list of files from Azure File Share directory.
    /// </summary>
    procedure ReceiveDocuments(var EDocumentService: Record "E-Document Service"; DocumentsMetadata: Codeunit "Temp Blob List"; ReceiveContext: Codeunit ReceiveContext)
    var
        TempBlob: Codeunit "Temp Blob";
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        ResponseText: Text;
        FileList: JsonArray;
        FileToken: JsonToken;
        FileName: Text;
        OutStream: OutStream;
        RequestUrl: Text;
    begin
        // Build URL for listing files in directory
        RequestUrl := BuildListFilesUrl(EDocumentService);

        // Make the request
        if not HttpClient.Get(RequestUrl, HttpResponse) then
            Error(ConnectionFailedErr, GetLastErrorText());

        if not HttpResponse.IsSuccessStatusCode() then
            Error(ListFilesFailedErr, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase());

        // Parse XML response to get file names
        HttpResponse.Content().ReadAs(ResponseText);
        FileList := ParseFileListResponse(ResponseText);

        // Add each file as metadata
        foreach FileToken in FileList do begin
            FileName := GetJsonText(FileToken, 'Name');
            if FileName <> '' then begin
                Clear(TempBlob);
                TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
                OutStream.WriteText(FileName);
                DocumentsMetadata.Add(TempBlob);
            end;
        end;
    end;

    /// <summary>
    /// Downloads a specific file from Azure File Share.
    /// </summary>
    procedure DownloadDocument(var EDocument: Record "E-Document"; var EDocumentService: Record "E-Document Service"; DocumentMetadata: Codeunit "Temp Blob"; ReceiveContext: Codeunit ReceiveContext)
    var
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
        RequestUrl: Text;
        FileContent: Text;
    begin
        // Get filename from metadata
        DocumentMetadata.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.ReadText(FileName);

        if FileName = '' then begin
            LogError(EDocument, FileNameNotFoundErr);
            exit;
        end;

        // Update document with file reference
        EDocument."File Name" := CopyStr(FileName, 1, MaxStrLen(EDocument."File Name"));
        EDocument.Modify();

        // Build URL for downloading file
        RequestUrl := BuildDownloadFileUrl(EDocumentService, FileName);

        // Download the file
        if not HttpClient.Get(RequestUrl, HttpResponse) then begin
            LogError(EDocument, StrSubstNo(DownloadFailedErr, FileName, GetLastErrorText()));
            exit;
        end;

        if not HttpResponse.IsSuccessStatusCode() then begin
            LogError(EDocument, StrSubstNo(DownloadHttpFailedErr, FileName, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase()));
            exit;
        end;

        // Store content in ReceiveContext
        HttpResponse.Content().ReadAs(FileContent);
        ReceiveContext.GetTempBlob().CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(FileContent);
    end;

    #endregion

    #region IReceivedDocumentMarker

    /// <summary>
    /// Marks a document as fetched by deleting it from Azure File Share.
    /// </summary>
    procedure MarkFetched(var EDocument: Record "E-Document"; var EDocumentService: Record "E-Document Service"; var DocumentBlob: Codeunit "Temp Blob"; ReceiveContext: Codeunit ReceiveContext)
    var
        HttpClient: HttpClient;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        FileName: Text;
        RequestUrl: Text;
    begin
        FileName := EDocument."File Name";
        if FileName = '' then
            exit;

        // Build URL for deleting file
        RequestUrl := BuildDeleteFileUrl(EDocumentService, FileName);

        // Send DELETE request
        HttpRequest.Method('DELETE');
        HttpRequest.SetRequestUri(RequestUrl);

        if not HttpClient.Send(HttpRequest, HttpResponse) then begin
            LogError(EDocument, StrSubstNo(DeleteFailedErr, FileName, GetLastErrorText()));
            Error(DeleteFailedErr, FileName, GetLastErrorText());
        end;

        if not HttpResponse.IsSuccessStatusCode() then begin
            LogError(EDocument, StrSubstNo(DeleteHttpFailedErr, FileName, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase()));
            Error(DeleteHttpFailedErr, FileName, HttpResponse.HttpStatusCode(), HttpResponse.ReasonPhrase());
        end;
    end;

    #endregion

    #region Azure URL Builders

    local procedure BuildListFilesUrl(var EDocumentService: Record "E-Document Service"): Text
    var
        SASToken: Text;
        Url: Text;
    begin
        // https://{account}.file.core.windows.net/{share}/{directory}?restype=directory&comp=list&{sas}
        SASToken := EDocumentService.GetSASTokenValue();
        Url := StrSubstNo(
            'https://%1.file.core.windows.net/%2/%3?restype=directory&comp=list&%4',
            EDocumentService."PDC Azure Storage Account",
            EDocumentService."PDC Azure File Share",
            EDocumentService."PDC Azure Directory Path",
            SASToken
        );
        exit(Url);
    end;

    local procedure BuildDownloadFileUrl(var EDocumentService: Record "E-Document Service"; FileName: Text): Text
    var
        SASToken: Text;
        Url: Text;
        DirectoryPath: Text;
    begin
        // https://{account}.file.core.windows.net/{share}/{directory}/{filename}?{sas}
        SASToken := EDocumentService.GetSASTokenValue();
        DirectoryPath := EDocumentService."PDC Azure Directory Path";
        if (DirectoryPath <> '') and (not DirectoryPath.EndsWith('/')) then
            DirectoryPath += '/';

        Url := StrSubstNo(
            'https://%1.file.core.windows.net/%2/%3%4?%5',
            EDocumentService."PDC Azure Storage Account",
            EDocumentService."PDC Azure File Share",
            DirectoryPath,
            FileName,
            SASToken
        );
        exit(Url);
    end;

    local procedure BuildDeleteFileUrl(var EDocumentService: Record "E-Document Service"; FileName: Text): Text
    begin
        // Same as download URL - DELETE method will be used
        exit(BuildDownloadFileUrl(EDocumentService, FileName));
    end;

    #endregion

    #region Response Parsing

    local procedure ParseFileListResponse(ResponseXml: Text): JsonArray
    var
        XmlDoc: XmlDocument;
        XmlRoot: XmlElement;
        XmlEntries: XmlNodeList;
        XmlEntry: XmlNode;
        XmlName: XmlNode;
        FileList: JsonArray;
        FileObj: JsonObject;
        FileName: Text;
    begin
        // Parse Azure File Share list response XML
        if not XmlDocument.ReadFrom(ResponseXml, XmlDoc) then
            exit(FileList);

        if not XmlDoc.GetRoot(XmlRoot) then
            exit(FileList);

        // Find all File entries
        XmlRoot.SelectNodes('//File', XmlEntries);
        foreach XmlEntry in XmlEntries do
            if XmlEntry.SelectSingleNode('Name', XmlName) then begin
                FileName := XmlName.AsXmlElement().InnerText();
                if FileName <> '' then begin
                    Clear(FileObj);
                    FileObj.Add('Name', FileName);
                    FileList.Add(FileObj);
                end;
            end;

        exit(FileList);
    end;

    local procedure GetJsonText(Token: JsonToken; PropertyName: Text): Text
    var
        JsonObj: JsonObject;
        PropertyToken: JsonToken;
    begin
        if not Token.IsObject() then
            exit('');

        JsonObj := Token.AsObject();
        if JsonObj.Get(PropertyName, PropertyToken) then
            if PropertyToken.IsValue() then
                exit(PropertyToken.AsValue().AsText());
        exit('');
    end;

    #endregion

    #region Error Handling

    local procedure LogError(var EDocument: Record "E-Document"; ErrorMessage: Text)
    var
        EDocErrorHelper: Codeunit "E-Document Error Helper";
    begin
        EDocErrorHelper.LogSimpleErrorMessage(EDocument, ErrorMessage);
    end;

    #endregion

    var
        // Send errors
        EmptyDocumentErr: Label 'Cannot send empty document. No content found.';
        CreateFileFailedErr: Label 'Failed to create file %1 in Azure: %2', Comment = '%1 = Filename, %2 = Error';
        CreateFileHttpFailedErr: Label 'Failed to create file %1 in Azure. HTTP Status: %2, Reason: %3', Comment = '%1 = Filename, %2 = Status code, %3 = Reason';
        UploadFailedErr: Label 'Failed to upload file %1: %2', Comment = '%1 = Filename, %2 = Error';
        UploadHttpFailedErr: Label 'Failed to upload file %1. HTTP Status: %2, Reason: %3', Comment = '%1 = Filename, %2 = Status code, %3 = Reason';
        // Receive errors
        ConnectionFailedErr: Label 'Failed to connect to Azure File Share: %1', Comment = '%1 = Error message';
        ListFilesFailedErr: Label 'Failed to list files. HTTP Status: %1, Reason: %2', Comment = '%1 = Status code, %2 = Reason';
        FileNameNotFoundErr: Label 'File name not found in document metadata.';
        DownloadFailedErr: Label 'Failed to download file %1: %2', Comment = '%1 = Filename, %2 = Error';
        DownloadHttpFailedErr: Label 'Failed to download file %1. HTTP Status: %2, Reason: %3', Comment = '%1 = Filename, %2 = Status code, %3 = Reason';
        DeleteFailedErr: Label 'Failed to delete file %1: %2', Comment = '%1 = Filename, %2 = Error';
        DeleteHttpFailedErr: Label 'Failed to delete file %1. HTTP Status: %2, Reason: %3', Comment = '%1 = Filename, %2 = Status code, %3 = Reason';
}
