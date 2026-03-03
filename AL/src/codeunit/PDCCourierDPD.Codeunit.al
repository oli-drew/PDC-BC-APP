/// <summary>
/// Codeunit PDCCourierDPD (ID 50002) handles communication with DPD api.
/// </summary>
codeunit 50002 PDCCourierDPD
{
    var
        GeoSession: Text;
        LoginURLTxt: label '/user/?action=login', Locked = true;
        ShipmentURLTxt: label '/shipping/shipment', Locked = true;
        LabelUrlTxt: label '/label/', Locked = true;
        TrackingURLTxt: Label 'https://apps.geopostuk.com/trackingcore/dpd/parcels', Locked = true;
        DPDSuccessMsg: label 'SUCCESSFUL: DPD Shipment ID: "%1" ', Locked = true;


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
        JsonObject: JsonObject;
        JsonText: text;
    begin
        SalesShipHdr.get(SalesShipNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");

        GeoSession := Send_Login(ShippingAgent); //Login in DPD Api    
        headersRequest := client.DefaultRequestHeaders;
        headersRequest.Add('GeoClient', 'Account/' + ShippingAgent."PDC Account");
        headersRequest.Add('GeoSession', GeoSession);

        requestBodyText := Body_InsertShipment(SalesShipHdr);
        content.WriteFrom(requestBodyText);
        content.GetHeaders(headersContent);
        headersContent.Remove('Content-Type');
        headersContent.Add('Content-Type', 'application/json');
        headersContent.Remove('Return-Type');
        headersContent.Add('Return-Type', 'application/json');

        requestURL := ShippingAgent."PDC Main URL" + ShipmentURLTxt;
        if not client.Post(requestURL, content, response) then exit;
        if not response.IsSuccessStatusCode then exit;
        response.Content().ReadAs(JsonText);
        JsonObject.ReadFrom(JsonText);
        Parse_InsertShipment(JsonObject, SalesShipHdr);
    end;

    /// <summary>
    /// Requests labels from DPD API and prints or previews them.
    /// </summary>
    /// <param name="SalesShipNo">Sales Shipment No.</param>
    /// <param name="preview">True to preview, false to print directly.</param>
    procedure LabelRequest(SalesShipNo: Code[20]; preview: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ShippingAgent: Record "Shipping Agent";
        UserSetup: Record "User Setup";
        rShipHeader: Record PDCCourierShipmentHeader;
        IWXPrintNodePrinter: Record "IWX PrintNode Printer";
        PrintNodeAPIMgt: Codeunit "IWX PrintNode API Mgt.";
        // CourierPrintLabel: Report "PDC Courier Print Label";
        // TempBlob: Codeunit "Temp Blob";
        // CourierEvents: Codeunit "PDC Courier Events";
        //Base64Convert: Codeunit "Base64 Convert";
        // LabelPrinterPage: Page "PDC Label Printer Hidden";
        client: HttpClient;
        response: HttpResponseMessage;
        headersRequest: HttpHeaders;
        requestURL: Text;
        // InStr: InStream;
        // OutStr: OutStream;
        // htmlText: Text;
        PrinterName: Text;
        // base64pdfText: Text;
        printData: Text;
        JobNameTxt: label 'DPD Label %1', Comment = '%1 = Shipment ID';
    begin

        SalesReceivablesSetup.Get();

        rShipHeader.Reset();
        rShipHeader.SetRange(SalesShipmentHeaderNo, SalesShipNo);
        rShipHeader.SetRange(Deleted, false);
        if rShipHeader.FindFirst() then begin
            ShippingAgent.get(rShipHeader."Shipping Agent Code");
            rShipHeader.testfield(shipmentId);

            GeoSession := Send_Login(ShippingAgent); //Login in DPD Api

            requestURL := ShippingAgent."PDC Main URL" + ShipmentURLTxt + '/' + rShipHeader.shipmentId + LabelUrlTxt;

            headersRequest := client.DefaultRequestHeaders;
            headersRequest.Add('GeoClient', 'Account/' + ShippingAgent."PDC Account");
            headersRequest.Add('GeoSession', GeoSession);
            //headersRequest.Add('Accept', 'text/vnd.citizen-clp'); text/vnd.citizen-clp; text/vnd.eltron-epl; text/html
            headersRequest.Add('Accept', 'text/vnd.eltron-epl');

            if not client.Get(requestURL, response) then exit;
            if not response.IsSuccessStatusCode then begin
                if guiAllowed then
                    Message('ERROR: ' + response.ReasonPhrase());
                exit;
            end;
            if response.Content().ReadAs(printData) then begin
                if UserSetup.Get(UserId) and (UserSetup."PDC Label Printer" <> '') then
                    PrinterName := UserSetup."PDC Label Printer"
                else
                    if ShippingAgent."PDC Label Printer" <> '' then
                        PrinterName := ShippingAgent."PDC Label Printer"
                    else
                        if SalesReceivablesSetup."PDC Label Printer" <> '' then
                            PrinterName := SalesReceivablesSetup."PDC Label Printer";

                IWXPrintNodePrinter.setrange(Name, PrinterName);
                if not IWXPrintNodePrinter.findfirst() then exit;

                PrintNodeAPIMgt.PrintDirect(
                        IWXPrintNodePrinter.ID,                          // PrintNode Printer ID
                        StrSubstNo(JobNameTxt, rShipHeader.shipmentId),  // Job title
                        "IWX PrintNode Print Type"::RAW,                 // Type for ZPL/EPL
                        printData,                                       // Raw printer data
                        1                                                // Quantity
                );
            end;
        end;


        // headersRequest.Add('Accept', 'text/html');

        // if not client.Get(requestURL, response) then exit;
        // if not response.IsSuccessStatusCode then begin
        //     if guiAllowed then
        //         Message('ERROR: ' + response.ReasonPhrase());
        //     exit;
        // end;
        // if response.Content().ReadAs(htmlText) then begin
        //     LabelPrinterPage.SetHtmlContent(htmlText);
        //     LabelPrinterPage.RunModal();
        //     LabelPrinterPage.GetPDFContent(base64pdfText);

        //     if base64pdfText = '' then begin
        //         if GuiAllowed then
        //             Message('PDF conversion failed. No label data received.');
        //         exit;
        //     end;

        //     Clear(TempBlob);
        //     TempBlob.CreateOutStream(OutStr);
        //     Base64Convert.FromBase64(base64pdfText, OutStr);

        //     if UserSetup.Get(UserId) and (UserSetup."PDC Label Printer" <> '') then
        //         PrinterName := UserSetup."PDC Label Printer"
        //     else
        //         if ShippingAgent."PDC Label Printer" <> '' then
        //             PrinterName := ShippingAgent."PDC Label Printer"
        //         else
        //             if SalesReceivablesSetup."PDC Label Printer" <> '' then
        //                 PrinterName := SalesReceivablesSetup."PDC Label Printer";

        //     UnBindSubscription(CourierEvents);
        //     BindSubscription(CourierEvents);
        //     TempBlob.CreateInStream(InStr);
        //     CourierEvents.Clean();
        //     CourierEvents.SetReportBlob(InStr);
        //     CourierEvents.SetRepId(Report::"PDC Courier Print Label");
        //     if preview then
        //         CourierPrintLabel.Run()
        //     else
        //         CourierPrintLabel.Print('', PrinterName);
        //     CourierEvents.Clean();
        //     UnBindSubscription(CourierEvents);
        // end;
        // end;
    end;

    local procedure Send_Login(var ShippingAgent: Record "Shipping Agent"): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
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
        ShippingAgent.TestField("PDC Connection Type", ShippingAgent."PDC Connection Type"::DPD);
        ShippingAgent.TestField("PDC Main URL");
        ShippingAgent.TestField("PDC Login");
        ShippingAgent.TestField("PDC Password");
        ShippingAgent.TestField("PDC Account");

        requestURL := ShippingAgent."PDC Main URL" + LoginURLTxt;

        headersRequest := client.DefaultRequestHeaders;
        headersRequest.Add('Authorization', 'Basic ' + Base64Convert.ToBase64(ShippingAgent."PDC Login" + ':' + ShippingAgent."PDC Password", TextEncoding::UTF8));
        content.GetHeaders(headersContent);
        headersContent.Remove('Content-Type');
        headersContent.Add('Content-Type', 'application/json');
        headersContent.Remove('Return-Type');
        headersContent.Add('Return-Type', 'application/json');

        if not client.Post(requestURL, content, response) then exit;
        if not response.IsSuccessStatusCode then exit;
        response.Content().ReadAs(JsonText);
        JsonObject.ReadFrom(JsonText);
        if JsonObject.Get('data', JsonToken) then begin
            JsonObject := JsonToken.AsObject();
            if JsonObject.Get('geoSession', JsonToken) then
                GeoSession := JsonToken.AsValue().AsText();
        end;

        exit(GeoSession);
    end;

    local procedure Body_InsertShipment(var SalesShipHdr: Record "Sales Shipment Header") RequestTxt: Text
    var
        rShipHeader: Record PDCCourierShipmentHeader;
        rComInfo: Record "Company Information";
        SalesShipLine: Record "Sales Shipment Line";
        ShippingAgentServices: Record "Shipping Agent Services";
        DocObj: JsonObject;
        AddressObj: JsonObject;
        consignmentArray: JsonArray;
        consignmentObj: JsonObject;
        consignmentDetObj: JsonObject;
        ParcelsArray: JsonArray;
        BoolVal: Boolean;
        ShippingAgentServiceCode: Text;
    begin
        RequestTxt := '';
        rComInfo.Get();

        SalesShipLine.SetRange(SalesShipLine."Document No.", SalesShipHdr."No.");
        SalesShipLine.SetFilter("PDC Wearer Name", '<>%1', '');
        if not SalesShipLine.FindFirst() then
            Clear(SalesShipLine);

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

            DocObj.Add('collectionDate', CreateDatetime(rShipHeader.ShipmentDate, Time));
            BoolVal := false;
            DocObj.Add('consolidate', BoolVal);

            clear(consignmentObj);
            consignmentObj.Add('parcels', ParcelsArray); //empty array

            clear(consignmentDetObj);
            clear(AddressObj);
            AddressObj.Add('contactName', CopyStr(rComInfo.Name, 1, 35));
            AddressObj.Add('telephone', CopyStr(rComInfo."Phone No.", 1, 15));
            consignmentDetObj.Add('contactDetails', AddressObj);
            clear(AddressObj);
            AddressObj.Add('organisation', CopyStr(rComInfo.Name, 1, 35));
            AddressObj.Add('countryCode', rComInfo."Country/Region Code");
            AddressObj.Add('postcode', rComInfo."Post Code");
            AddressObj.Add('street', CopyStr(rComInfo.Address, 1, 35));
            AddressObj.Add('locality', CopyStr(rComInfo."Address 2", 1, 35));
            AddressObj.Add('town', CopyStr(rComInfo.City, 1, 35));
            AddressObj.Add('county', CopyStr(rComInfo.County, 1, 35));
            consignmentDetObj.Add('address', AddressObj);
            consignmentObj.Add('collectionDetails', consignmentDetObj);

            clear(consignmentDetObj);
            clear(AddressObj);
            AddressObj.Add('contactName', CopyStr(rShipHeader.ShipToContact, 1, 35));
            AddressObj.Add('telephone', CopyStr(rShipHeader."Ship-to Mobile Phone No.", 1, 15));
            consignmentDetObj.Add('contactDetails', AddressObj);
            clear(AddressObj);
            AddressObj.Add('organisation', CopyStr(rShipHeader.ShipToName, 1, 35));
            AddressObj.Add('countryCode', rShipHeader.ShipToCountryRegionCode);
            AddressObj.Add('postcode', rShipHeader.ShipToPostCode);
            AddressObj.Add('street', CopyStr(rShipHeader.ShipToAddress, 1, 35));
            AddressObj.Add('locality', CopyStr(rShipHeader.ShipToAddress2, 1, 35));
            AddressObj.Add('town', CopyStr(rShipHeader.ShipToCity, 1, 35));
            AddressObj.Add('county', CopyStr(rShipHeader.ShipToCounty, 1, 35));
            consignmentDetObj.Add('address', AddressObj);
            clear(AddressObj);
            AddressObj.Add('email', CopyStr(rShipHeader."Ship-to E-Mail", 1, 50));
            AddressObj.Add('mobile', CopyStr(rShipHeader."Ship-to Mobile Phone No.", 1, 15));
            consignmentDetObj.Add('notificationDetails', AddressObj);
            consignmentObj.Add('deliveryDetails', consignmentDetObj);

            consignmentObj.Add('networkCode', '1^' + ShippingAgentServiceCode);
            consignmentObj.Add('numberOfParcels', rShipHeader.NumberOfPackages);
            consignmentObj.Add('totalWeight', rShipHeader.Weight);
            consignmentObj.Add('shippingRef1', CopyStr(rShipHeader.SalesShipmentHeaderNo + ' ' + rShipHeader.ShipToPostCode, 1, 25));
            consignmentObj.Add('shippingRef2', CopyStr(SalesShipLine."PDC Customer Reference", 1, 25));
            consignmentObj.Add('shippingRef3', CopyStr(SalesShipLine."PDC Wearer Name", 1, 25));
            consignmentObj.Add('deliveryInstructions', SalesShipHdr."PDC Delivery Instruction");
            consignmentObj.Add('parcelDescription', CopyStr(rShipHeader.Description, 1, 50));

            consignmentArray.Add(consignmentObj);
            DocObj.Add('consignment', consignmentArray);
            DocObj.AsToken().WriteTo(RequestTxt);
        end;
    end;

    local procedure Parse_InsertShipment(FromJsonObject: JsonObject; var SalesShipHdr: Record "Sales Shipment Header")
    var
        rShipHeader: Record PDCCourierShipmentHeader;
        rParcel: Record "PDC Parcels Info";
        PDCFunctions: Codeunit "PDC Functions";
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonArray2: JsonArray;
        c1: Integer;
        c2: Integer;
    begin
        rShipHeader.Reset();
        rShipHeader.SetRange(SalesShipmentHeaderNo, SalesShipHdr."No.");
        rShipHeader.SetRange("Sent to Courier", false);
        rShipHeader.SetRange(Deleted, false);
        if rShipHeader.FindFirst() then
            if FromJsonObject.Get('data', JsonToken) then
                if JsonToken.IsObject then begin
                    JsonObject := JsonToken.AsObject();
                    if JsonObject.Get('shipmentId', JsonToken) then
                        Evaluate(rShipHeader.shipmentId, copystr(JsonToken.AsValue().AsText(), 1, MaxStrLen(rShipHeader.shipmentId)));

                    if JsonObject.Get('consignmentDetail', JsonToken) then
                        if JsonToken.IsArray then begin
                            JsonArray := JsonToken.AsArray();
                            for c1 := 0 to (JsonArray.Count - 1) do begin
                                JsonArray.Get(c1, JsonToken);
                                JsonObject := JsonToken.AsObject();
                                if JsonObject.Get('consignmentNumber', JsonToken) then
                                    rShipHeader.consignmentNumber := copystr(JsonToken.AsValue().AsText(), 1, MaxStrLen(rShipHeader.consignmentNumber));

                                rShipHeader."Sent to Courier" := true;
                                rShipHeader.errorCode := '';
                                rShipHeader.errorMessage := '';
                                rShipHeader.errorObject := '';

                                if JsonObject.Get('parcelNumbers', JsonToken) then begin
                                    JsonArray2 := JsonToken.AsArray();
                                    for c2 := 0 to (JsonArray2.Count - 1) do begin
                                        JsonArray2.Get(c2, JsonToken);

                                        rParcel.Init();
                                        rParcel.SalesShipmentNo := rShipHeader.SalesShipmentHeaderNo;
                                        rParcel.ConsignmentNumber := rShipHeader.consignmentNumber;
                                        rParcel.ParcelNumber := copystr(JsonToken.AsValue().AsText(), 1, 20);
                                        rParcel.Insert();
                                    end;
                                end;

                                PDCFunctions.UpdateDocConsignmentNo(rShipHeader.SalesShipmentHeaderNo, rShipHeader.consignmentNumber);

                                Message(DPDSuccessMsg, rShipHeader.shipmentId);
                            end;
                        end;
                end;

        if FromJsonObject.Get('error', JsonToken) then
            if JsonToken.IsArray then begin
                JsonArray2 := JsonToken.AsArray();
                for c2 := 0 to (JsonArray2.Count - 1) do begin
                    JsonArray2.Get(c2, JsonToken);
                    JsonObject := JsonToken.AsObject();

                    if JsonObject.Get('errorCode', JsonToken) then
                        rShipHeader.errorCode := copystr(JsonToken.AsValue().AsText(), 1, 100);
                    if JsonObject.Get('errorMessage', JsonToken) then
                        rShipHeader.errorMessage := copystr(JsonToken.AsValue().AsText(), 1, 250);
                    // if JsonObject.Get('obj', JsonToken) then
                    //     rShipHeader.errorObject := copystr(JsonToken.AsValue().AsText(), 1, 250);
                end;
            end;

        rShipHeader.Modify();
    end;

    /// <summary>
    /// procedure TrackingRequest run tracking request for consignment.
    /// </summary>
    /// <param name="ConsigNumber">Consignment Noo. of type Code[10].</param>
    procedure TrackingRequest(ConsigNumber: Code[10])
    var
        SalesShipHdr: Record "Sales Shipment Header";
        rShipHeader: Record PDCCourierShipmentHeader;
        ShippingAgent: Record "Shipping Agent";
        rParcel: Record "PDC Parcels Info";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headersContent: HttpHeaders;
        headersRequest: HttpHeaders;
        requestBodyText: Text;
        responseBodyText: Text;
        requestURL: Text;
        xmlDoc: XmlDocument;
    begin
        rShipHeader.setrange(consignmentNumber, ConsigNumber);
        rShipHeader.FindFirst();
        SalesShipHdr.get(rShipHeader.SalesShipmentHeaderNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");
        if not (ShippingAgent."PDC Connection Type" = ShippingAgent."PDC Connection Type"::DPD) then
            exit;

        rParcel.Reset();
        rParcel.SetRange(ConsignmentNumber, ConsigNumber);
        if rParcel.FindSet() then
            repeat
                requestBodyText := TrackingRequestBody(ShippingAgent, ConsigNumber, rParcel.ParcelNumber);
                if requestBodyText <> '' then begin
                    requestURL := TrackingURLTxt;
                    headersRequest := client.DefaultRequestHeaders;
                    content.WriteFrom(requestBodyText);
                    content.GetHeaders(headersContent);
                    headersContent.Remove('Content-Type');
                    headersContent.Add('Content-Type', 'application/xml');
                    if not client.Post(requestURL, content, response) then exit;
                    response.Content().ReadAs(responseBodyText);
                    clear(xmlDoc);
                    XmlDocument.ReadFrom(responseBodyText, xmlDoc);
                    TrackingRequestParse(xmlDoc);

                    clear(client);
                    clear(response);
                    clear(requestBodyText);
                    clear(responseBodyText);
                end;
            until rParcel.Next() = 0;
    end;

    local procedure TrackingRequestBody(var ShippingAgent: Record "Shipping Agent"; ConsigNumber: Code[10]; ParcelNumber: Code[20]): Text
    var
        rParcel: Record "PDC Parcels Info";
        xmlDoc: XmlDocument;
        XmlDecl: XmlDeclaration;
        root: XmlElement;
        rootNode: XmlNode;
        node: XmlNode;
        trackingnumbersNode: XmlNode;
        xmlContent: text;
    begin
        rParcel.Reset();
        rParcel.SetRange(ConsignmentNumber, ConsigNumber);
        if ParcelNumber <> '' then rParcel.SetRange(ParcelNumber, ParcelNumber);
        if rParcel.FindSet() then begin
            xmlDoc := XmlDocument.create();
            XmlDecl := XmlDeclaration.Create('1.0', 'utf-8', 'yes');
            xmlDoc.SetDeclaration(XmlDecl);
            root := XmlElement.Create('trackingrequest');
            xmlDoc.AddFirst(root);
            rootNode := root.AsXmlNode();
            AddElement(rootNode, 'user', ShippingAgent."PDC Login", '', node);
            AddElement(rootNode, 'password', ShippingAgent."PDC Password", '', node);
            AddElement(rootNode, 'trackingnumbers', '', '', trackingnumbersNode);

            repeat
                AddElement(trackingnumbersNode, 'trackingnumber', rParcel.ParcelNumber, '', node);
            until rParcel.Next() = 0;

            xmlDoc.WriteTo(xmlContent);
            exit(xmlContent);
        end;
    end;

    local procedure TrackingRequestParse(xmlDoc: XmlDocument)
    var
        rParcel: Record "PDC Parcels Info";
        root: XmlElement;
        rootNode: XmlNode;
        trackingDetailsNode: XmlNode;
        nodeList1: XmlNodeList;
        nodeList2: XmlNodeList;
        trackingNode: XmlNode;
        eventNode: XmlNode;
        node: XmlNode;
        trackingnumber: Code[20];
        consignmentnumberVal: Code[10];
        parcelnumberVal: Code[20];
        eventDT: DateTime;
    begin
        if not xmlDoc.GetRoot(root) then exit;
        RootNode := root.AsXmlNode();
        if FindNode(RootNode, 'trackingdetails', trackingDetailsNode) then
            if trackingDetailsNode.SelectNodes('trackingdetail', NodeList1) then
                foreach trackingNode in NodeList1 do
                    if trackingNode.SelectSingleNode('trackingnumber', node) then begin
                        trackingnumber := COPYSTR(node.AsXmlElement().InnerText(), 1, 20);
                        if not trackingNode.SelectSingleNode('error', node) then begin
                            clear(parcelnumberVal);
                            if trackingNode.SelectSingleNode('parcelnumber', node) then
                                parcelnumberVal := COPYSTR(node.AsXmlElement().InnerText(), 1, 20);
                            clear(consignmentnumberVal);
                            if trackingNode.SelectSingleNode('consignmentnumber', node) then
                                consignmentnumberVal := COPYSTR(node.AsXmlElement().InnerText(), 1, 10);
                            if rParcel.Get(consignmentnumberVal, parcelnumberVal) then begin
                                if trackingNode.SelectSingleNode('parcelcode', node) then
                                    rParcel.ParcelCode := COPYSTR(node.AsXmlElement().InnerText(), 1, 20);
                                if trackingNode.SelectSingleNode('trackingevents', node) then
                                    if node.SelectNodes('trackingevent', NodeList2) then
                                        foreach eventNode in NodeList2 do begin
                                            clear(eventDT);
                                            if eventNode.SelectSingleNode('date', node) then
                                                evaluate(eventDT, node.AsXmlElement().InnerText(), 9);
                                            if eventDT > rParcel.StatusDateTime then begin
                                                rParcel.StatusDateTime := eventDT;
                                                if eventNode.SelectSingleNode('code', node) then
                                                    rParcel.StatusCode := COPYSTR(node.AsXmlElement().InnerText(), 1, 10);
                                                if eventNode.SelectSingleNode('description', node) then
                                                    rParcel.StatusDescription := COPYSTR(node.AsXmlElement().InnerText(), 1, 250);
                                                rParcel.Validate(StatusCode);
                                            end;
                                        end;
                                rParcel.Modify();
                            end;
                        end
                        else  //ERROR TEXT
                            if trackingnumber <> '' then begin
                                rParcel.Reset();
                                rParcel.SetRange(ParcelNumber, trackingnumber);
                                if rParcel.FindFirst() then begin
                                    rParcel.ErrorText := COPYSTR(node.AsXmlElement().InnerText(), 1, 50);
                                    rParcel.Status := rParcel.Status::Exception;
                                    rParcel."Stop Tracking" := StatusCheck(rParcel.StatusCode);
                                    rParcel."Last Track DT" := CurrentDatetime;
                                    rParcel.Modify();
                                end;
                            end;
                    end;

    end;

    local procedure StatusCheck(StatCode: Code[10]): Boolean
    begin
        case StatCode of
            '418', '001':
                exit(true);
            else
                exit(false)
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
    begin
        SalesShipHdr.get(rParcel.SalesShipmentNo);
        ShippingAgent.get(SalesShipHdr."Shipping Agent Code");
        if not (ShippingAgent."PDC Connection Type" = ShippingAgent."PDC Connection Type"::DPD) then
            exit;

        rParcel."Delivered Date" := 0D;
        if rParcel.StatusCode in
          ['0', '4', '6', '9', '10', '12', '13', '15', '16', '37', '39', '40', '41', '42', '43', '52', '55', '60', '62', '70', '73', '74', '75', '76', '78',
           '80', '82', '84', '85', '87', '97', '406', '416', '442', '458', '459', '461', '467', '471'] then
            rParcel.Status := rParcel.Status::"In transit"
        else
            if rParcel.StatusCode in
              ['2', '3', '8', '14', '19', '20', '21', '22', '23', '27', '31', '32', '33', '44', '45', '46', '47', '48', '49', '57', '58', '66', '68', '71', '72', '77',
               '79', '83', '86', '88', '89', '90', '91', '92', '93', '95', '402', '403', '404', '407', '409/410', '411', '412', '413', '414', '417', '418', '449', '453', '454',
               '455', '456', '464', '465', '466', '472', '473', '474'] then
                rParcel.Status := rParcel.Status::Exception
            else
                if rParcel.StatusCode in ['1', '56', '65', '17', '451', '463'] then begin
                    rParcel.Status := rParcel.Status::Delivered;
                    rParcel."Delivered Date" := Dt2Date(rParcel.StatusDateTime);
                end else
                    if (rParcel.StatusCode = '53') then
                        if (STRPOS(rParcel.StatusDescription, 'Return To') <> 0) then
                            rParcel.Status := rParcel.Status::Returned
                        else
                            rParcel.Status := rParcel.Status::Exception;
    end;

    local procedure AddElement(var pXMLNode: XmlNode; pNodeName: Text; pNodeText: Text; pNameSpace: Text; var pCreatedNode: XmlNode): Boolean
    var
        lNewChildNode: XmlNode;
    begin
        if pNodeText <> '' then
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace, pNodeText).AsXmlNode()
        else
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace).AsXmlNode();
        if pXMLNode.AsXmlElement().Add(lNewChildNode) then begin
            pCreatedNode := lNewChildNode;
            exit(true);
        end;
    end;

    local procedure FindNode(pXMLRootNode: XmlNode; pNodePath: Text; var pFoundXMLNode: XmlNode): Boolean
    begin
        if pXMLRootNode.AsXmlElement().IsEmpty then
            exit(false);
        if pXMLRootNode.SelectSingleNode(pNodePath, pFoundXMLNode) then
            exit(true);
    end;

    // local procedure FindNode(var XMLRootNode: XmlNode; NodePath: Text[250]; var FoundXMLNode: XmlNode): Boolean
    // var
    //     NodeList: XmlNodeList;
    //     l_intI: Integer;
    // begin
    //     if XMLRootNode.AsXMLElement().IsEmpty then
    //         exit(false);

    //     NodeList := XMLRootNode.AsXMLElement().GetChildNodes();
    //     l_intI := 0;
    //     while l_intI < NodeList.Count do begin
    //         foreach FoundXMLNode in NodeList do
    //             if FoundXMLNode.AsXMLElement().Name = NodePath then
    //                 exit(true);

    //         if FindNode(FoundXMLNode, NodePath, FoundXMLNode) = true then exit(true);

    //         l_intI := l_intI + 1;
    //     end;

    //     exit(false);
    // end;

}

