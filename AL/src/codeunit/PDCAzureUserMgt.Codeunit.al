codeunit 50010 "PDC Azure User Mgt."
{

    procedure CreateUser(var PortalUser: Record "PDC Portal User")
    var
        Portal: Record "PDC Portal";
        PortalUserRole: Record "PDC Portal User Role";
        GraphClient: Codeunit "Graph Client";
        GraphAuthorization: Codeunit "Graph Authorization";
        GraphOptionalParameters: Codeunit "Graph Optional Parameters";
        RequestHttpContent: Codeunit "Http Content";
        HttpResponseMessage: Codeunit "Http Response Message";
        GraphAuthorizationIFace: interface "Graph Authorization";
        BodyJson: JsonObject;
        BodyJsonArray: JsonArray;
        BodyJson2: JsonObject;
        JsonContent: Text;
        JsonToken: JsonToken;
        ResponseMessage: HttpResponseMessage;
        JsonResponse: JsonObject;
    begin
        if not IsNullGuid(PortalUser."Azure User Id") then
            exit;

        PortalUser.TestField(Name);

        PortalUserRole.setrange("User Id", PortalUser.Id);
        PortalUserRole.findfirst();
        Portal.get(PortalUserRole."Portal Code");
        Portal.TestField("Tenant Id");
        Portal.TestField("Client Id");
        Portal.TestField("Secret");
        Portal.TestField(Issuer);

        BodyJson.Add('accountEnabled', true);
        BodyJson.Add('displayName', PortalUser.Name);
        BodyJson.Add('userType', 'Guest');

        clear(BodyJson2);
        BodyJson2.Add('signInType', 'emailAddress');
        BodyJson2.Add('issuer', Portal."Issuer");
        BodyJson2.Add('issuerAssignedId', PortalUser.Id);
        BodyJsonArray.Add(BodyJson2);
        BodyJson.Add('identities', BodyJsonArray);

        BodyJson.Add('passwordPolicies', 'DisablePasswordExpiration');

        clear(BodyJson2);
        BodyJson2.Add('forceChangePasswordNextSignIn', true);
        BodyJson2.Add('password', '@Portal1234!');

        BodyJson.Add('passwordProfile', BodyJson2);

        RequestHttpContent := RequestHttpContent.Create(BodyJson);

        //Create Microsoft Graph Authorization
        GraphAuthorizationIFace := GraphAuthorization.CreateAuthorizationWithClientCredentials(Portal."Tenant Id", Portal."Client Id", Portal.Secret, 'https://graph.microsoft.com/.default');

        //Initialize Microsoft Graph Client
        GraphClient.Initialize(Enum::"Graph API Version"::"v1.0", GraphAuthorizationIFace);

        if GraphClient.Post('users', GraphOptionalParameters, RequestHttpContent, HttpResponseMessage) then begin
            ResponseMessage := HttpResponseMessage.GetResponseMessage();
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(JsonContent);
                JsonResponse.ReadFrom(JsonContent);
                JsonResponse.get('id', JsonToken);
                PortalUser."Azure User Id" := JsonToken.AsValue().AsText();
                PortalUser."Azure Enabled" := true;
                PortalUser.Modify();
            end;
        end;
    end;

    procedure EnableUser(var PortalUser: Record "PDC Portal User")
    var
        Portal: Record "PDC Portal";
        PortalUserRole: Record "PDC Portal User Role";
        GraphClient: Codeunit "Graph Client";
        GraphAuthorization: Codeunit "Graph Authorization";
        GraphOptionalParameters: Codeunit "Graph Optional Parameters";
        RequestHttpContent: Codeunit "Http Content";
        HttpResponseMessage: Codeunit "Http Response Message";
        GraphAuthorizationIFace: interface "Graph Authorization";
        BodyJson: JsonObject;
        ResponseMessage: HttpResponseMessage;
        RelativeUriToResource: Text;
    begin
        if IsNullGuid(PortalUser."Azure User Id") then
            exit;

        PortalUserRole.setrange("User Id", PortalUser.Id);
        PortalUserRole.findfirst();
        Portal.get(PortalUserRole."Portal Code");
        Portal.TestField("Tenant Id");
        Portal.TestField("Client Id");
        Portal.TestField("Secret");
        Portal.TestField(Issuer);

        BodyJson.Add('accountEnabled', not PortalUser."Azure Enabled");

        RequestHttpContent := RequestHttpContent.Create(BodyJson);

        RelativeUriToResource := 'users/' + PortalUser."Azure User Id";

        //Create Microsoft Graph Authorization
        GraphAuthorizationIFace := GraphAuthorization.CreateAuthorizationWithClientCredentials(Portal."Tenant Id", Portal."Client Id", Portal.Secret, 'https://graph.microsoft.com/.default');

        //Initialize Microsoft Graph Client
        GraphClient.Initialize(Enum::"Graph API Version"::"v1.0", GraphAuthorizationIFace);

        if GraphClient.Patch(RelativeUriToResource, GraphOptionalParameters, RequestHttpContent, HttpResponseMessage) then begin
            ResponseMessage := HttpResponseMessage.GetResponseMessage();
            if ResponseMessage.IsSuccessStatusCode then begin
                PortalUser."Azure Enabled" := not PortalUser."Azure Enabled";
                PortalUser.Modify();
            end;
        end;
    end;

    procedure SendWelcomeEmail(var PortalUser: Record "PDC Portal User")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        AttRec: Record Attachment;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        BodyText: Text;
        BlobInStream: InStream;
        ListTo: list of [Text];
        ListCC: list of [Text];
        ListBCC: list of [Text];
        SubjectTxt: label 'Welcome to the Uniform Portal';
        ConfirmEmailResendTxt: label 'A Welcome email has already been sent. Would you like to send it again?';
    begin
        if PortalUser."E-Mail" = '' then
            exit;

        if IsNullGuid(PortalUser."Azure User Id") then
            exit;

        if PortalUser."Azure Email Sent" then
            if not Confirm(ConfirmEmailResendTxt) then
                exit;

        SalesSetup.Get();
        if AttRec.Get(SalesSetup."PDC User Welcome E-mail Body") then
            AttRec.CalcFields("Attachment File");
        if AttRec."Attachment File".Hasvalue then begin
            AttRec."Attachment File".CreateInstream(BlobInStream, Textencoding::UTF8);
            BlobInStream.Read(BodyText);
        end;

        if BodyText <> '' then begin
            MapHTMLFields(BodyText, '{{userFirstName}}', PortalUser.Name);
            MapHTMLFields(BodyText, '{{userID}}', PortalUser.Id);

            ListTo.Add(PortalUser."E-Mail");
            EmailMessage.Create(ListTo, SubjectTxt, BodyText, true, ListCC, ListBCC);
            if Email.Send(EmailMessage, enum::"Email Scenario"::Default) then begin
                PortalUser."Azure Email Sent" := true;
                PortalUser."Azure Email Sent Date" := CurrentDateTime;
                PortalUser.Modify();
            end;
        end;
    end;

    procedure CreateUserAndSendEmail(var PortalUser: Record "PDC Portal User")
    begin
        CreateUser(PortalUser);
        if not IsNullGuid(PortalUser."Azure User Id") then
            SendWelcomeEmail(PortalUser);
    end;

    local procedure MapHTMLFields(var SourceText: Text; FieldName: Text; FieldValue: Text)
    begin
        while StrPos(SourceText, FieldName) <> 0 do
            SourceText := CopyStr(SourceText, 1, StrPos(SourceText, FieldName) - 1) +
                          FieldValue +
                          CopyStr(SourceText, StrPos(SourceText, FieldName) + StrLen(FieldName));
    end;
}
