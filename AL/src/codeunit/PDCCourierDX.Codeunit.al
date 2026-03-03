/// <summary>
/// Codeunit PDCCourierDPD (ID 50002) handles communication with DPD api.
/// </summary>
codeunit 50007 PDCCourierDX
{
    var
        token: Text;
        tokenExpDT: DateTime;
        getTokenTxt: label '/Session/CreateToken', Locked = true;
        createConsignmentTxt: label '/Consignment/CreateConsignment', Locked = true;
        LabelUrlTxt: label '/Label/PDF', Locked = true;
        TrackingURLTxt: Label '/Tracking/GetConsignment', Locked = true;
        // DPDErr: label 'ERROR: DPD Error Code: "%1"; Message: "%2".', Locked = true;
        SuccessMsg: label 'SUCCESSFUL: DX Shipment ID: "%1" ', Locked = true;
        ConnectionErr: Label 'Connection Error', Locked = true;



    /// <summary>
    /// procedure Send_InsertShipment send shipment info to DPD Api.
    /// </summary>
    /// <param name="SalesShipNo">Code[20].</param>
    procedure Send_InsertShipment(SalesShipNo: Code[20])
    var
        SalesShipHdr: Record "Sales Shipment Header";
        ShippingAgent: Record "Shipping Agent";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headersContent: HttpHeaders;
        headersRequest: HttpHeaders;
        requestBodyText: Text;
        requestURL: Text;
        JsonText: text;
    begin
        SalesShipHdr.get(SalesShipNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");

        if not (ShippingAgent."PDC Connection Type" = ShippingAgent."PDC Connection Type"::DX) then
            exit;

        Send_Login(ShippingAgent); //get token
        if token = '' then
            exit;
        headersRequest := client.DefaultRequestHeaders;
        headersRequest.Add('Token', token);

        requestBodyText := Body_InsertShipment(SalesShipHdr);
        content.WriteFrom(requestBodyText);
        content.GetHeaders(headersContent);
        headersContent.Remove('Content-Type');
        headersContent.Add('Content-Type', 'application/json');
        headersContent.Remove('Return-Type');
        headersContent.Add('Return-Type', 'application/json');

        requestURL := ShippingAgent."PDC Main URL" + createConsignmentTxt;
        if not client.Post(requestURL, content, response) then begin
            UpdateWithErr(SalesShipHdr, 'ERR', ConnectionErr);
            exit;
        end;
        if not response.IsSuccessStatusCode then begin
            if response.Content().ReadAs(JsonText) then
                UpdateWithErr(SalesShipHdr, 'ERR', JsonText)
            else
                UpdateWithErr(SalesShipHdr, 'ERR', response.ReasonPhrase);
            exit;
        end;
        response.Content().ReadAs(JsonText);
        Parse_InsertShipment(JsonText, SalesShipHdr);
    end;

    local procedure Body_InsertShipment(var SalesShipHdr: Record "Sales Shipment Header") RequestTxt: Text
    var
        CompanyInfo: Record "Company Information";
        rShipHeader: Record PDCCourierShipmentHeader;
        rComInfo: Record "Company Information";
        //SalesShipLine: Record "Sales Shipment Line";
        ShippingAgent: Record "Shipping Agent";
        ShippingAgentServices: Record "Shipping Agent Services";
        DocObj: JsonObject;
        AddressObj: JsonObject;
        ItemsArr: JsonArray;
        ItemObj: JsonObject;
        ShippingAgentServiceCode: Text;
    begin
        CompanyInfo.get();
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");

        RequestTxt := '';
        rComInfo.Get();

        rShipHeader.Reset();
        rShipHeader.SetRange(SalesShipmentHeaderNo, SalesShipHdr."No.");
        rShipHeader.SetRange("Sent to Courier", false);
        rShipHeader.SetRange(Deleted, false);
        if rShipHeader.FindFirst() then begin
            rShipHeader.TestField("Shipping Agent Service Code");
            ShippingAgentServiceCode := rShipHeader."Shipping Agent Service Code";
            if ShippingAgentServices.Get(rShipHeader."Shipping Agent Code", rShipHeader."Shipping Agent Service Code") then
                if ShippingAgentServices."PDC Service Code" <> '' then
                    ShippingAgentServiceCode := ShippingAgentServices."PDC Service Code";

            DocObj.Add('accountCode', ShippingAgent."PDC Account");

            clear(AddressObj);
            AddressObj.Add('address1', copystr(rShipHeader.ShipToAddress, 1, 50));
            AddressObj.Add('countryCode', rShipHeader.ShipToCountryRegionCode);
            AddressObj.Add('town', copystr(rShipHeader.ShipToCity, 1, 30));
            AddressObj.Add('recipient', copystr(rShipHeader.ShipToContact, 1, 30));
            AddressObj.Add('company', copystr(rShipHeader.ShipToName, 1, 40));
            AddressObj.Add('address2', copystr(rShipHeader.ShipToAddress2, 1, 50));
            if rShipHeader.ShipToCountryRegionCode <> CompanyInfo."Country/Region Code" then
                AddressObj.Add('county', copystr(rShipHeader.ShipToCounty, 1, 30));
            AddressObj.Add('postcode', rShipHeader.ShipToPostCode);
            if STRLEN(rShipHeader."Ship-to Mobile Phone No.") in [8 .. 15] then
                AddressObj.Add('phone', rShipHeader."Ship-to Mobile Phone No.");
            if rShipHeader."Ship-to E-Mail" <> '' then
                if STRLEN(rShipHeader."Ship-to E-Mail") <= 50 then
                    AddressObj.Add('email', rShipHeader."Ship-to E-Mail");
            AddressObj.Add('specialInstructions', copystr(SalesShipHdr."PDC Delivery Instruction", 1, 75));
            DocObj.Add('deliveryAddress', AddressObj);

            DocObj.Add('despatchDate', CreateDatetime(rShipHeader.ShipmentDate, Time));
            DocObj.Add('reference', SalesShipHdr."No.");
            DocObj.Add('serviceCode', ShippingAgentServiceCode);

            clear(ItemsArr);
            clear(ItemObj);
            ItemObj.Add('packageTypeCode', rShipHeader.PackageType);
            ItemObj.Add('quantity', rShipHeader.NumberOfPackages);
            ItemObj.Add('weight', rShipHeader.Weight * rShipHeader.NumberOfPackages);
            ItemsArr.Add(ItemObj);
            DocObj.Add('items', ItemsArr);

            DocObj.AsToken().WriteTo(RequestTxt);
        end;
    end;

    local procedure Parse_InsertShipment(JsonText: Text; var SalesShipHdr: Record "Sales Shipment Header")
    var
        rShipHeader: Record PDCCourierShipmentHeader;
        rParcel: Record "PDC Parcels Info";
        PDCFunctions: Codeunit "PDC Functions";
        FromJsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        c1: Integer;
    begin
        rShipHeader.Reset();
        rShipHeader.SetRange(SalesShipmentHeaderNo, SalesShipHdr."No.");
        rShipHeader.SetRange("Sent to Courier", false);
        rShipHeader.SetRange(Deleted, false);
        if rShipHeader.FindFirst() then begin
            if FromJsonObject.ReadFrom(JsonText) then begin
                if FromJsonObject.Get('trackingNumbers', JsonToken) then
                    if JsonToken.IsArray then begin

                        JsonArray := JsonToken.AsArray();
                        for c1 := 0 to (JsonArray.Count - 1) do begin
                            JsonArray.Get(c1, JsonToken);

                            if c1 = 0 then begin //first tracking no.
                                rShipHeader.shipmentId := copystr(JsonToken.AsValue().AsText(), 1, MaxStrLen(rShipHeader.shipmentId));
                                rShipHeader.consignmentNumber := copystr(JsonToken.AsValue().AsText(), 1, MaxStrLen(rShipHeader.consignmentNumber));
                                rShipHeader."Sent to Courier" := true;
                                rShipHeader.errorCode := '';
                                rShipHeader.errorMessage := '';
                                rShipHeader.errorObject := '';
                            end;
                            rParcel.Init();
                            rParcel.SalesShipmentNo := rShipHeader.SalesShipmentHeaderNo;
                            rParcel.ConsignmentNumber := rShipHeader.consignmentNumber;
                            rParcel.ParcelNumber := copystr(JsonToken.AsValue().AsText(), 1, 20);
                            rParcel.Insert();
                        end;
                        PDCFunctions.UpdateDocConsignmentNo(rShipHeader.SalesShipmentHeaderNo, rShipHeader.consignmentNumber);
                        Message(SuccessMsg, rShipHeader.shipmentId);
                    end;
            end
            else begin
                rShipHeader.errorCode := 'ERR';
                rShipHeader.errorMessage := copystr(JsonText, 1, 250);
            end;
            rShipHeader.Modify();
        end;
    end;

    /// <summary>
    /// procedure LabelRequest requests labels from DX API.
    /// </summary>
    /// <param name="SalesShipNo">Code[20].</param>
    procedure LabelRequest(SalesShipNo: Code[20]; preview: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesShipHdr: Record "Sales Shipment Header";
        ShippingAgent: Record "Shipping Agent";
        UserSetup: Record "User Setup";
        rShipHeader: Record PDCCourierShipmentHeader;
        rParcel: Record "PDC Parcels Info";
        CourierPrintLabel: Report "PDC Courier Print Label";
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        CourierEvents: Codeunit "PDC Courier Events";
        OutStream: OutStream;
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headersContent: HttpHeaders;
        headersRequest: HttpHeaders;
        requestURL: Text;
        OutStr: OutStream;
        InStr: InStream;
        DocObj: JsonObject;
        RequestTxt: Text;
        FromJsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonText: Text;
        pdfText: Text;
        PrinterName: Text;
    begin
        SalesReceivablesSetup.Get();

        SalesShipHdr.GET(SalesShipNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");

        requestURL := ShippingAgent."PDC Main URL" + LabelUrlTxt;

        rShipHeader.Reset();
        rShipHeader.SetRange(SalesShipmentHeaderNo, SalesShipHdr."No.");
        rShipHeader.SetRange("Shipping Agent Code", SalesShipHdr."Shipping Agent Code");
        rShipHeader.SetRange(Deleted, false);
        if rShipHeader.FindFirst() then begin
            rParcel.setrange(SalesShipmentNo, rShipHeader.SalesShipmentHeaderNo);
            if rParcel.findset() then begin
                Send_Login(ShippingAgent); //get token
                if token = '' then
                    exit;
                repeat
                    headersRequest := client.DefaultRequestHeaders;
                    headersRequest.Add('Token', token);

                    clear(DocObj);
                    DocObj.Add('trackingNumber', rParcel.ParcelNumber);
                    JsonValue.SetValue(true);
                    DocObj.Add('printWholeConsignment', JsonValue);
                    DocObj.Add('pdfPaperSize', 3); //1 = A4, 2 = A6, 3 = inch4x4, 4 = inch4x6
                    DocObj.Add('pdfA4StartingLocation', 1); //1 = Top Left, 2 = Top Right, 3 = Bottom Left, 4 = Bottom Right
                    DocObj.AsToken().WriteTo(requestTxt);

                    content.WriteFrom(RequestTxt);
                    content.GetHeaders(headersContent);
                    headersContent.Remove('Content-Type');
                    headersContent.Add('Content-Type', 'application/json');

                    if not client.Post(requestURL, content, response) then exit;
                    if response.Content().ReadAs(JsonText) then
                        if FromJsonObject.ReadFrom(JsonText) then
                            if FromJsonObject.Get('data', JsonToken) then begin
                                pdfText := JsonToken.AsValue().AsText();
                                Clear(TempBlob);
                                TempBlob.CreateOutStream(OutStream);
                                Base64Convert.FromBase64(pdfText, OutStream);

                                if UserSetup.Get(UserId) and (UserSetup."PDC Label Printer" <> '') then
                                    PrinterName := UserSetup."PDC Label Printer"
                                else
                                    if ShippingAgent."PDC Label Printer" <> '' then
                                        PrinterName := ShippingAgent."PDC Label Printer"
                                    else
                                        if SalesReceivablesSetup."PDC Label Printer" <> '' then
                                            PrinterName := SalesReceivablesSetup."PDC Label Printer";

                                UnBindSubscription(CourierEvents);
                                BindSubscription(CourierEvents);
                                TempBlob.CreateInStream(InStr);
                                CourierEvents.Clean();
                                CourierEvents.SetReportBlob(InStr);
                                CourierEvents.SetRepId(Report::"PDC Courier Print Label");
                                if preview then
                                    CourierPrintLabel.Run()
                                else
                                    CourierPrintLabel.Print('', PrinterName);
                                CourierEvents.Clean();
                                UnBindSubscription(CourierEvents);

                            end;
                until rParcel.Next() = 0;
            end;
        end;
    end;

    local procedure Send_Login(var ShippingAgent: Record "Shipping Agent")
    var
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headersContent: HttpHeaders;
        headersRequest: HttpHeaders;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        JsonText: text;
        requestURL: Text;
    begin
        if token <> '' then
            if tokenExpDT > CurrentDateTime() then
                exit;

        clear(token);
        clear(tokenExpDT);

        ShippingAgent.TestField("PDC Connection Type", ShippingAgent."PDC Connection Type"::DX);
        shippingAgent.TestField("PDC Main URL");
        ShippingAgent.TestField("PDC Login");
        ShippingAgent.TestField("PDC Password");
        ShippingAgent.TestField("PDC Account");

        requestURL := ShippingAgent."PDC Main URL" + getTokenTxt;
        headersRequest := client.DefaultRequestHeaders;
        content.GetHeaders(headersContent);
        headersContent.Add('accountCode', ShippingAgent."PDC Account");
        headersContent.Add('username', ShippingAgent."PDC Login");
        headersContent.Add('password', ShippingAgent."PDC Password");

        if not client.Post(requestURL, content, response) then exit;
        if not response.IsSuccessStatusCode then exit;
        response.Content().ReadAs(JsonText);
        JsonObject.ReadFrom(JsonText);
        if JsonObject.Get('accessToken', JsonToken) then begin
            JsonObject := JsonToken.AsObject();
            if JsonObject.Get('key', JsonToken) then
                token := JsonToken.AsValue().AsText();
            if token <> '' then
                if JsonObject.Get('expiry', JsonToken) then
                    tokenExpDT := JsonToken.AsValue().AsDateTime();
        end;
    end;

    /// <summary>
    /// procedure TrackingRequest run tracking request for consignment.
    /// </summary>
    /// <param name="rParcel">VAR Record "Parcels Info".</param>
    procedure TrackingRequest(var rParcel: Record "PDC Parcels Info")
    var
        SalesShipHdr: Record "Sales Shipment Header";
        ShippingAgent: Record "Shipping Agent";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headersContent: HttpHeaders;
        headersRequest: HttpHeaders;
        requestBodyText: Text;
        responseBodyText: Text;
        requestURL: Text;
        DocObj: JsonObject;
    begin
        SalesShipHdr.get(rParcel.SalesShipmentNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");
        if not (ShippingAgent."PDC Connection Type" = ShippingAgent."PDC Connection Type"::DX) then
            exit;

        Send_Login(ShippingAgent); //get token
        if token = '' then
            exit;
        headersRequest := client.DefaultRequestHeaders;
        headersRequest.Add('Token', token);

        clear(DocObj);
        DocObj.Add('trackingNumber', rParcel.ParcelNumber);
        DocObj.AsToken().WriteTo(requestBodyText);

        content.WriteFrom(requestBodyText);
        content.GetHeaders(headersContent);
        headersContent.Remove('Content-Type');
        headersContent.Add('Content-Type', 'application/json');
        headersContent.Remove('Return-Type');
        headersContent.Add('Return-Type', 'application/json');

        requestURL := ShippingAgent."PDC Main URL" + TrackingURLTxt;
        if not client.Post(requestURL, content, response) then exit;
        if not response.IsSuccessStatusCode then exit;
        response.Content().ReadAs(responseBodyText);
        TrackingRequestParse(rParcel, responseBodyText);
    end;

    local procedure TrackingRequestParse(var rParcel: Record "PDC Parcels Info"; JsonText: Text)
    var
        FromJsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonArray2: JsonArray;
        c1: Integer;
        c2: Integer;
        eventDT: DateTime;
    begin
        if FromJsonObject.ReadFrom(JsonText) then begin
            if FromJsonObject.Get('consignment', JsonToken) then
                if JsonToken.AsObject().Get('items', JsonToken) then
                    if JsonToken.IsArray then begin
                        JsonArray := JsonToken.AsArray();
                        foreach JsonToken in JsonArray do begin
                            JsonObject := JsonToken.AsObject();
                            JsonObject.get('trackingNumber', JsonToken);
                            if rParcel.ParcelNumber = copystr(JsonToken.AsValue().AsText(), 1, MaxStrLen(rParcel.ParcelNumber)) then
                                if JsonObject.get('cancelled', JsonToken) then
                                    if JsonToken.AsValue().AsBoolean() = true then begin
                                        rParcel.Status := rParcel.Status::Cancelled;
                                        rParcel.StatusDateTime := CurrentDateTime();
                                        rParcel.Modify();
                                    end;
                        end;
                    end;

            if rParcel.Status <> rParcel.Status::Cancelled then
                if FromJsonObject.Get('trackingNumberTrackingResponses', JsonToken) then
                    if JsonToken.IsArray then begin
                        JsonArray := JsonToken.AsArray();
                        for c1 := 0 to (JsonArray.Count - 1) do begin
                            JsonArray.Get(c1, JsonToken);
                            JsonObject := JsonToken.AsObject();

                            JsonObject.get('trackingNumber', JsonToken);
                            if rParcel.ParcelNumber = copystr(JsonToken.AsValue().AsText(), 1, MaxStrLen(rParcel.ParcelNumber)) then
                                if JsonObject.Get('trackingEvents', JsonToken) then
                                    if JsonToken.IsArray then begin
                                        JsonArray2 := JsonToken.AsArray();
                                        for c2 := 0 to (JsonArray2.Count - 1) do begin
                                            JsonArray2.Get(c2, JsonToken);
                                            JsonObject := JsonToken.AsObject();

                                            clear(eventDT);
                                            if JsonObject.get('trackingDate', JsonToken) then
                                                eventDT := JsonToken.AsValue().AsDateTime();
                                            if eventDT > rParcel.StatusDateTime then begin
                                                rParcel.StatusDateTime := eventDT;
                                                if JsonObject.get('eventCode', JsonToken) then
                                                    rParcel.StatusCode := COPYSTR(JsonToken.AsValue().AsText(), 1, MaxStrLen(rParcel.StatusCode));
                                                if JsonObject.get('eventDescription', JsonToken) then
                                                    rParcel.StatusDescription := COPYSTR(JsonToken.AsValue().AsText(), 1, MaxStrLen(rParcel.StatusDescription));
                                                rParcel.Validate(StatusCode);
                                                rParcel.Modify();
                                            end;
                                        end;
                                    end;
                        end;
                    end;
        end;
    end;

    /// <summary>
    /// procedure SetStatus update Status depending on StatusCode.
    /// </summary>
    /// <param name="rParcel">VAR Record "Parcels Info".</param>
    procedure SetStatus(var rParcel: Record "PDC Parcels Info")
    var
        SalesShipHdr: Record "Sales Shipment Header";
        ShippingAgent: Record "Shipping Agent";
        StatCode: Text;
    begin
        SalesShipHdr.get(rParcel.SalesShipmentNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");
        if not (ShippingAgent."PDC Connection Type" = ShippingAgent."PDC Connection Type"::DX) then
            exit;

        StatCode := rParcel.StatusCode;
        if STRPOS(StatCode, 'CEC-') = 1 then //prefix for test environment
            StatCode := CopyStr(StatCode, 5);

        rParcel."Delivered Date" := 0D;
        Clear(rParcel.Status);

        if (StatCode <> '') then
            if StatCode in
              ['IR', 'J', 'OR', 'R', 'RC', 'RX', 'T', 'TM', 'TN', 'TS', 'TSC', 'TY', 'TZ'] then
                rParcel.Status := rParcel.Status::"In transit"
            else
                if StatCode in
                  ['A', 'AA', 'B', 'BB', 'C', 'D', 'DC', 'DD', 'DIS', 'DK', 'DUP', 'E', 'F', 'FM', 'G', 'HE', 'K', 'LS', 'M', 'MM',
                    'MR', 'NC', 'NN', 'RG', 'RH', 'RHU', 'S', 'TB', 'TU', 'UITU', 'VM', 'X'] then
                    rParcel.Status := rParcel.Status::Exception
                else
                    if StatCode in ['CCD', 'IC', 'P', 'P2', 'P3', 'V', 'VA', 'VG', 'VL', 'VN', 'VP', 'VR', 'W', 'Y'] then begin
                        rParcel.Status := rParcel.Status::Delivered;
                        rParcel."Delivered Date" := Dt2Date(rParcel.StatusDateTime);
                    end else
                        if (StatCode in ['RTS', 'WRTS']) then
                            rParcel.Status := rParcel.Status::Returned
                        else
                            if not (StatCode in ['ORDRCVD', 'TC', 'VS']) then
                                rParcel.Status := rParcel.Status::Exception;
    end;

    local procedure UpdateWithErr(var SalesShipHdr: Record "Sales Shipment Header"; errorcode: code[100]; errorText: Text)
    var
        rShipHeader: Record PDCCourierShipmentHeader;
    begin
        rShipHeader.Reset();
        rShipHeader.SetRange(SalesShipmentHeaderNo, SalesShipHdr."No.");
        rShipHeader.SetRange("Sent to Courier", false);
        rShipHeader.SetRange(Deleted, false);
        if rShipHeader.FindFirst() then begin
            rShipHeader.errorCode := errorcode;
            rShipHeader.errorMessage := copystr(errorText, 1, 250);
            rShipHeader.Modify();
        end;
    end;
}
