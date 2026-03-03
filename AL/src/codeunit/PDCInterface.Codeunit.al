/// <summary>
/// Codeunit PDCInterface (ID 50015) published as webservice.
/// </summary>
Codeunit 50015 "PDC Interface"
{
    // 10.09.2020 JEMEL J.Jemeljanovs #3423 * Created

    Permissions = tabledata "Sales Shipment Header" = rm;

    trigger OnRun()
    begin
    end;


    /// <summary>
    /// procedure ImportInvPickInfo called with soap, sets values in Inventory Pick
    /// </summary>
    /// <param name="SourceText">XML data as Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ImportInvPickInfo(SourceText: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        XmlDoc: XmlDocument;
        XmlRoot: XmlElement;
        RootNode: XmlNode;
        NodeList: XmlNodeList;
        DocNode: XmlNode;
        Node: XmlNode;
    begin
        CleanSourceText(SourceText);

        XmlDocument.ReadFrom(SourceText, xmlDoc);
        xmlDoc.GetRoot(xmlRoot);
        RootNode := xmlRoot.AsXmlNode();
        RootNode.AsXMLElement().SelectNodes('pick', NodeList);
        foreach DocNode in NodeList do begin
            Clear(Node);
            if FindNode(DocNode, 'no', Node) then
                if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", Node.AsXMLElement().InnerText) then begin
                    if FindNode(DocNode, 'shipAgent', Node) then
                        WarehouseActivityHeader."PDC Shipping Agent Code" := copystr(Node.AsXMLElement().InnerText, 1, MaxStrLen(WarehouseActivityHeader."PDC Shipping Agent Code"));
                    if FindNode(DocNode, 'shipService', Node) then
                        WarehouseActivityHeader."PDC Shipping Agent Serv. Code" := copystr(Node.AsXMLElement().InnerText, 1, MaxStrLen(WarehouseActivityHeader."PDC Shipping Agent Serv. Code"));
                    if FindNode(DocNode, 'NoOfPackages', Node) then
                        Evaluate(WarehouseActivityHeader."PDC Number Of Packages", Node.AsXMLElement().InnerText);
                    WarehouseActivityHeader.Modify(true);
                end;
        end;

        exit('OK');
    end;

    /// <summary>
    /// procedure ImportInvPickInfoJSON called with odata.
    /// </summary>
    /// <param name="pickNo">Inventory Pyck No. of type Text.</param>
    /// <param name="shipAgent">Shipping agent code, of type Text.</param>
    /// <param name="shipService">Shipping agent service code, of type Text.</param>
    /// <param name="noOfPackages">No of packages, of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ImportInvPickInfoJSON(pickNo: Text; shipAgent: Text; shipService: Text; noOfPackages: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", copystr(pickNo, 1, MaxStrLen(WarehouseActivityHeader."No."))) then begin
            WarehouseActivityHeader."PDC Shipping Agent Code" := copystr(shipAgent, 1, MaxStrLen(WarehouseActivityHeader."PDC Shipping Agent Code"));
            WarehouseActivityHeader."PDC Shipping Agent Serv. Code" := copystr(shipService, 1, MaxStrLen(WarehouseActivityHeader."PDC Shipping Agent Serv. Code"));
            Evaluate(WarehouseActivityHeader."PDC Number Of Packages", NoOfPackages);
            WarehouseActivityHeader.Modify(true);
        end;

        exit('OK');
    end;

    /// <summary>
    /// procedure InvPickPostPrint call with soap, post and print Inventory Pick.
    /// </summary>
    /// <param name="SourceText">XML data as Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure InvPickPostPrint(SourceText: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        PostedInvtPickHeader: Record "Posted Invt. Pick Header";
        PDCFunctions: Codeunit "PDC Functions";
        XmlDoc: XmlDocument;
        XmlRoot: XmlElement;
        RootNode: XmlNode;
        NodeList: XmlNodeList;
        DocNode: XmlNode;
        Node: XmlNode;
    begin
        CleanSourceText(SourceText);

        XmlDocument.ReadFrom(SourceText, xmlDoc);
        xmlDoc.GetRoot(xmlRoot);
        RootNode := xmlRoot.AsXmlNode();
        RootNode.AsXMLElement().SelectNodes('pick', NodeList);
        foreach DocNode in NodeList do
            if FindNode(DocNode, 'no', Node) then
                if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", Node.AsXMLElement().InnerText) then begin
                    WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityHeader.Type);
                    WarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
                    if WarehouseActivityLine.FindSet(true) then
                        WarehouseActivityLine.AutofillQtyToHandle(WarehouseActivityLine);

                    PDCFunctions.InvPickPostAndPrintAndEmail(WarehouseActivityLine);

                    PostedInvtPickHeader.Reset();
                    PostedInvtPickHeader.SetRange("Invt Pick No.", Node.AsXMLElement().InnerText);
                    if PostedInvtPickHeader.FindLast() then
                        exit(PostedInvtPickHeader."Source No.");
                end;


        exit('Invt. Pick not found');
    end;

    /// <summary>
    /// procedure InvPickPostPrintJSON call with odata, post and print Inventory Pick.
    /// </summary>
    /// <param name="pickNo">Pick No. of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure InvPickPostPrintJSON(pickNo: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        PostedInvtPickHeader: Record "Posted Invt. Pick Header";
        PDCFunctions: Codeunit "PDC Functions";
    begin
        if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", copystr(pickNo, 1, MaxStrLen(WarehouseActivityHeader."No."))) then begin
            WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityHeader.Type);
            WarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
            if WarehouseActivityLine.FindSet(true) then
                WarehouseActivityLine.AutofillQtyToHandle(WarehouseActivityLine);

            PDCFunctions.InvPickPostAndPrintAndEmail(WarehouseActivityLine);

            PostedInvtPickHeader.Reset();
            PostedInvtPickHeader.SetRange("Invt Pick No.", copystr(pickNo, 1, MaxStrLen(WarehouseActivityHeader."No.")));
            if PostedInvtPickHeader.FindLast() then
                exit(PostedInvtPickHeader."Source No.");
        end;


        exit('Invt. Pick not found');
    end;

    /// <summary>
    /// procedure InvPickPrintPickNote call with soap, prints pick list for Inventory Pick.
    /// </summary>
    /// <param name="SourceText">XML data as Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure InvPickPrintPickNote(SourceText: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        PrinterSelection: Record "Printer Selection";
        TempOldPrinterSelection: Record "Printer Selection" temporary;
        TempNewPrinterSelection: Record "Printer Selection" temporary;
        XmlDoc: XmlDocument;
        XmlRoot: XmlElement;
        RootNode: XmlNode;
        NodeList: XmlNodeList;
        DocNode: XmlNode;
        Node: XmlNode;
    begin
        CleanSourceText(SourceText);

        XmlDocument.ReadFrom(SourceText, xmlDoc);
        xmlDoc.GetRoot(xmlRoot);
        RootNode := xmlRoot.AsXmlNode();
        RootNode.AsXMLElement().SelectNodes('pick', NodeList);
        foreach DocNode in NodeList do begin
            Clear(Node);
            if FindNode(DocNode, 'no', Node) then
                if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", Node.AsXMLElement().InnerText) then begin
                    if FindNode(DocNode, 'user', Node) then
                        if UserId <> UpperCase(Node.AsXMLElement().InnerText) then begin
                            PrinterSelection.SetRange("User ID", UserId);
                            PrinterSelection.SetRange("Report ID", Report::"PDC Pick List");
                            if PrinterSelection.FindFirst() then
                                TempOldPrinterSelection := PrinterSelection;

                            PrinterSelection.SetRange("User ID", UpperCase(Node.AsXMLElement().InnerText));
                            PrinterSelection.SetRange("Report ID", Report::"PDC Pick List");
                            if PrinterSelection.FindFirst() then begin
                                TempNewPrinterSelection := PrinterSelection;

                                PrinterSelection.Reset();
                                PrinterSelection.Init();
                                PrinterSelection."User ID" := copystr(UserId, 1, MaxStrLen(PrinterSelection."User ID"));
                                PrinterSelection."Report ID" := Report::"PDC Pick List";
                                if PrinterSelection.Insert() then;
                                PrinterSelection."Printer Name" := TempNewPrinterSelection."Printer Name";
                                PrinterSelection.Modify();
                            end;
                        end;

                    WarehouseActivityHeader.SetRecfilter();
                    Report.RunModal(Report::"PDC Pick List", false, false, WarehouseActivityHeader);

                    if UserId <> UpperCase(Node.AsXMLElement().InnerText) then
                        if TempOldPrinterSelection."User ID" <> '' then begin
                            PrinterSelection.Reset();
                            PrinterSelection.Init();
                            PrinterSelection := TempOldPrinterSelection;
                            if PrinterSelection.Insert() then;
                            PrinterSelection."Printer Name" := TempOldPrinterSelection."Printer Name";
                            PrinterSelection.Modify();
                        end
                        else begin
                            PrinterSelection.Get(UserId, Report::"PDC Pick List");
                            PrinterSelection.Delete();
                        end;

                    exit('OK');
                end;
        end;

        exit('Invt. Pick not found');
    end;


    /// <summary>
    /// procedure InvPickPrintPickNoteJSON call with odata, prints pick list for Inventory Pick.
    /// </summary>
    /// <param name="pickNo">Pick No, of type Text.</param>
    /// <param name="user">UserId, of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure InvPickPrintPickNoteJSON(pickNo: Text; user: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        PrinterSelection: Record "Printer Selection";
        TempOldPrinterSelection: Record "Printer Selection" temporary;
        TempNewPrinterSelection: Record "Printer Selection" temporary;
    begin
        if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", copystr(pickNo, 1, MaxStrLen(WarehouseActivityHeader."No."))) then begin

            if UserId <> UpperCase(user) then begin
                PrinterSelection.SetRange("User ID", UserId);
                PrinterSelection.SetRange("Report ID", Report::"PDC Pick List");
                if PrinterSelection.FindFirst() then
                    TempOldPrinterSelection := PrinterSelection;

                PrinterSelection.SetRange("User ID", UpperCase(user));
                PrinterSelection.SetRange("Report ID", Report::"PDC Pick List");
                if PrinterSelection.FindFirst() then begin
                    TempNewPrinterSelection := PrinterSelection;

                    PrinterSelection.Reset();
                    PrinterSelection.Init();
                    PrinterSelection."User ID" := copystr(UserId, 1, MaxStrLen(PrinterSelection."User ID"));
                    PrinterSelection."Report ID" := Report::"PDC Pick List";
                    if PrinterSelection.Insert() then;
                    PrinterSelection."Printer Name" := TempNewPrinterSelection."Printer Name";
                    PrinterSelection.Modify();
                end;
            end;

            WarehouseActivityHeader.SetRecfilter();
            Report.RunModal(Report::"PDC Pick List", false, false, WarehouseActivityHeader);

            if UserId <> UpperCase(user) then
                if TempOldPrinterSelection."User ID" <> '' then begin
                    PrinterSelection.Reset();
                    PrinterSelection.Init();
                    PrinterSelection := TempOldPrinterSelection;
                    if PrinterSelection.Insert() then;
                    PrinterSelection."Printer Name" := TempOldPrinterSelection."Printer Name";
                    PrinterSelection.Modify();
                end
                else begin
                    PrinterSelection.Get(UserId, Report::"PDC Pick List");
                    PrinterSelection.Delete();
                end;

            exit('OK');
        end;

        exit('Invt. Pick not found');
    end;

    /// <summary>
    /// InvPickPrintPickInstructionJSON.
    /// </summary>
    /// <param name="pickNo">Text.</param>
    /// <param name="user">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure InvPickPrintPickInstructionJSON(pickNo: Text; user: Text): Text
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        PrinterSelection: Record "Printer Selection";
        TempOldPrinterSelection: Record "Printer Selection" temporary;
        TempNewPrinterSelection: Record "Printer Selection" temporary;
    begin
        if WarehouseActivityHeader.Get(WarehouseActivityHeader.Type::"Invt. Pick", copystr(pickNo, 1, MaxStrLen(WarehouseActivityHeader."No."))) then begin

            if UserId <> UpperCase(user) then begin
                PrinterSelection.SetRange("User ID", UserId);
                PrinterSelection.SetRange("Report ID", Report::"PDC Pick Instruction2");
                if PrinterSelection.FindFirst() then
                    TempOldPrinterSelection := PrinterSelection;

                PrinterSelection.SetRange("User ID", UpperCase(user));
                PrinterSelection.SetRange("Report ID", Report::"PDC Pick Instruction2");
                if PrinterSelection.FindFirst() then begin
                    TempNewPrinterSelection := PrinterSelection;

                    PrinterSelection.Reset();
                    PrinterSelection.Init();
                    PrinterSelection."User ID" := copystr(UserId, 1, MaxStrLen(PrinterSelection."User ID"));
                    PrinterSelection."Report ID" := Report::"PDC Pick Instruction2";
                    if PrinterSelection.Insert() then;
                    PrinterSelection."Printer Name" := TempNewPrinterSelection."Printer Name";
                    PrinterSelection.Modify();
                end;
            end;

            WarehouseActivityHeader.SetRecfilter();
            Report.RunModal(Report::"PDC Pick Instruction2", false, false, WarehouseActivityHeader);

            if UserId <> UpperCase(user) then
                if TempOldPrinterSelection."User ID" <> '' then begin
                    PrinterSelection.Reset();
                    PrinterSelection.Init();
                    PrinterSelection := TempOldPrinterSelection;
                    if PrinterSelection.Insert() then;
                    PrinterSelection."Printer Name" := TempOldPrinterSelection."Printer Name";
                    PrinterSelection.Modify();
                end
                else begin
                    PrinterSelection.Get(UserId, Report::"PDC Pick Instruction2");
                    PrinterSelection.Delete();
                end;

            exit('OK');

        end;

        exit('Invt. Pick not found');
    end;

    /// <summary>
    /// procedure ShipmentCourierSendPrint call with soap, prints shipment label and send info to shipping agent.
    /// </summary>
    /// <param name="SourceText">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ShipmentCourierSendPrint(SourceText: Text): Text
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        PostedInvtPickHeader: Record "Posted Invt. Pick Header";
        PDCCourierShipmentHeader: Record PDCCourierShipmentHeader;
        UserSetup: Record "User Setup";
        TempOldUserSetup: Record "User Setup" temporary;
        TempNewUserSetup: Record "User Setup" temporary;
        XmlDoc: XmlDocument;
        XmlRoot: XmlElement;
        RootNode: XmlNode;
        NodeList: XmlNodeList;
        DocNode: XmlNode;
        Node: XmlNode;
        RespText: Text;
    begin
        CleanSourceText(SourceText);

        XmlDocument.ReadFrom(SourceText, xmlDoc);
        xmlDoc.GetRoot(xmlRoot);
        RootNode := xmlRoot.AsXmlNode();
        RootNode.AsXMLElement().SelectNodes('pick', NodeList);
        if NodeList.Get(1, DocNode) then begin
            Clear(SalesShipmentHeader);
            Clear(Node);
            if FindNode(DocNode, 'shipmentNo', Node) then
                if SalesShipmentHeader.Get(Node.AsXMLElement().InnerText) then;
            if SalesShipmentHeader."No." = '' then
                if FindNode(DocNode, 'no', Node) then begin
                    PostedInvtPickHeader.Reset();
                    PostedInvtPickHeader.SetRange("Invt Pick No.", Node.AsXMLElement().InnerText);
                    if PostedInvtPickHeader.FindLast() then
                        if SalesShipmentHeader.Get(PostedInvtPickHeader."Source No.") then;
                end;

            if SalesShipmentHeader."No." <> '' then begin
                if FindNode(DocNode, 'user', Node) then
                    if UserId <> UpperCase(Node.AsXMLElement().InnerText) then begin
                        if UserSetup.Get(UserId) and (UserSetup."PDC Label Printer" <> '') then
                            TempOldUserSetup := UserSetup;
                        if UserSetup.Get(UpperCase(Node.AsXMLElement().InnerText)) and (UserSetup."PDC Label Printer" <> '') then begin
                            TempNewUserSetup := UserSetup;

                            UserSetup."User ID" := copystr(UserId, 1, MaxStrLen(UserSetup."User ID"));
                            if UserSetup.Insert() then;
                            UserSetup."PDC Label Printer" := TempNewUserSetup."PDC Label Printer";
                            UserSetup.Modify(false);
                        end;
                    end;

                RespText := 'OK';

                SalesShipmentHeader.SendToUPSTable();
                PDCCourierShipmentHeader.Send_InsertShipment(SalesShipmentHeader."No.");

                PDCCourierShipmentHeader.Reset();
                PDCCourierShipmentHeader.SetRange(SalesShipmentHeaderNo, SalesShipmentHeader."No.");
                PDCCourierShipmentHeader.SetRange("Shipping Agent Code", SalesShipmentHeader."Shipping Agent Code");
                PDCCourierShipmentHeader.SetRange(Deleted, false);
                if PDCCourierShipmentHeader.FindLast() then
                    if PDCCourierShipmentHeader.errorMessage <> '' then
                        RespText := PDCCourierShipmentHeader.errorMessage
                    else
                        PDCCourierShipmentHeader.LabelRequest(SalesShipmentHeader."No.");

                if UserId <> UpperCase(Node.AsXMLElement().InnerText) then
                    if TempOldUserSetup."User ID" <> '' then begin
                        UserSetup.Get(UserId);
                        UserSetup."PDC Label Printer" := TempOldUserSetup."PDC Label Printer";
                        UserSetup.Modify(false);
                    end
                    else
                        if UserSetup.Get(UserId) then
                            UserSetup.Delete();
                exit(RespText);
            end;
        end;

        exit('Invt. Pick not found');
    end;

    /// <summary>
    /// porcedure ShipmentCourierSendPrintJSON call with odata, prints shipment label and send info to shipping agent.
    /// </summary>
    /// <param name="shipmentNo">Shipment No. of type Text.</param>
    /// <param name="pickNo">Pick No. of type Text.</param>
    /// <param name="user">User ID of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ShipmentCourierSendPrintJSON(shipmentNo: Text; pickNo: Text; user: Text): Text
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        PostedInvtPickHeader: Record "Posted Invt. Pick Header";
        PDCCourierShipmentHeader: Record PDCCourierShipmentHeader;
        UserSetup: Record "User Setup";
        TempOldUserSetup: Record "User Setup" temporary;
        TempNewUserSetup: Record "User Setup" temporary;
        RespText: Text;
    begin
        if not SalesShipmentHeader.Get(copystr(shipmentNo, 1, MaxStrLen(SalesShipmentHeader."No."))) then begin
            PostedInvtPickHeader.Reset();
            PostedInvtPickHeader.SetRange("Invt Pick No.", copystr(pickNo, 1, MaxStrLen(PostedInvtPickHeader."Invt Pick No.")));
            if PostedInvtPickHeader.FindLast() then
                if SalesShipmentHeader.Get(PostedInvtPickHeader."Source No.") then;
        end;

        if SalesShipmentHeader."No." <> '' then begin
            if UserId <> UpperCase(user) then begin
                if UserSetup.Get(UserId) and (UserSetup."PDC Label Printer" <> '') then
                    TempOldUserSetup := UserSetup;
                if UserSetup.Get(UpperCase(user)) and (UserSetup."PDC Label Printer" <> '') then begin
                    TempNewUserSetup := UserSetup;

                    UserSetup."User ID" := copystr(UserId, 1, MaxStrLen(UserSetup."User ID"));
                    if UserSetup.Insert() then;
                    UserSetup."PDC Label Printer" := TempNewUserSetup."PDC Label Printer";
                    UserSetup.Modify(false);
                end;
            end;

            RespText := 'OK';

            SalesShipmentHeader.SendToUPSTable();
            PDCCourierShipmentHeader.Send_InsertShipment(SalesShipmentHeader."No.");

            PDCCourierShipmentHeader.Reset();
            PDCCourierShipmentHeader.SetRange(SalesShipmentHeaderNo, SalesShipmentHeader."No.");
            PDCCourierShipmentHeader.SetRange("Shipping Agent Code", SalesShipmentHeader."Shipping Agent Code");
            PDCCourierShipmentHeader.SetRange(Deleted, false);
            if PDCCourierShipmentHeader.FindLast() then
                if PDCCourierShipmentHeader.errorMessage <> '' then
                    RespText := PDCCourierShipmentHeader.errorMessage
                else
                    PDCCourierShipmentHeader.LabelRequest(SalesShipmentHeader."No.");

            if UserId <> UpperCase(user) then
                if TempOldUserSetup."User ID" <> '' then begin
                    UserSetup.Get(UserId);
                    UserSetup."PDC Label Printer" := TempOldUserSetup."PDC Label Printer";
                    UserSetup.Modify(false);
                end
                else
                    if UserSetup.Get(UserId) then
                        UserSetup.Delete();
            exit(RespText);
        end;

        exit('Invt. Pick not found');
    end;

    /// <summary>
    /// procedure ProdOrderPrint call with soap, prints production order.
    /// </summary>
    /// <param name="SourceText">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ProdOrderPrint(SourceText: Text): Text
    var
        ProductionOrder: Record "Production Order";
        ProductionOrder1: Record "Production Order";
        XmlDoc: XmlDocument;
        XmlRoot: XmlElement;
        RootNode: XmlNode;
        NodeList: XmlNodeList;
        DocNode: XmlNode;
        Node: XmlNode;
    begin
        CleanSourceText(SourceText);

        XmlDocument.ReadFrom(SourceText, xmlDoc);
        xmlDoc.GetRoot(xmlRoot);
        RootNode := xmlRoot.AsXmlNode();
        RootNode.AsXMLElement().SelectNodes('productionOrder', NodeList);
        foreach DocNode in NodeList do
            if FindNode(DocNode, 'no', Node) then
                if ProductionOrder.Get(ProductionOrder.Status::Released, Node.AsXMLElement().InnerText) then begin
                    ProductionOrder1.Get(ProductionOrder.Status, ProductionOrder."No.");
                    ProductionOrder1.SetRecfilter();
                    Report.RunModal(Report::"PDC Production Order Labels", false, false, ProductionOrder1);
                end;

        exit('Production Order not found');
    end;

    /// <summary>
    /// procedure ProdOrderPrintJSON call with odata, prints production order.
    /// </summary>
    /// <param name="productionOrderNo">Production Order No., of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ProdOrderPrintJSON(productionOrderNo: Text): Text
    var
        ProductionOrder: Record "Production Order";
        ProductionOrder1: Record "Production Order";
    begin
        if ProductionOrder.Get(ProductionOrder.Status::Released, copystr(productionOrderNo, 1, MaxStrLen(ProductionOrder."No."))) then begin
            ProductionOrder1.Get(ProductionOrder.Status, ProductionOrder."No.");
            ProductionOrder1.SetRecfilter();
            Report.RunModal(Report::"PDC Production Order Labels", false, false, ProductionOrder1);
            exit('OK');
        end;

        exit('Production Order not found');
    end;

    /// <summary>
    /// FinishProductionOrder.
    /// </summary>
    /// <param name="productionOrderNo">Text.</param>
    /// <param name="updateUnitCost">Boolean.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FinishProductionOrder(productionOrderNo: Text; updateUnitCost: Boolean): Text
    var
        ProductionOrder: Record "Production Order";
        ProdOrderStatusManagement: codeunit "Prod. Order Status Management";
    begin
        if (ProductionOrder.Get(ProductionOrder.Status::Released, copystr(productionOrderNo, 1, MaxStrLen(ProductionOrder."No.")))) then begin
            ProdOrderStatusManagement.ChangeProdOrderStatus(ProductionOrder, ProductionOrder.Status::Finished, WorkDate(), updateUnitCost);
            exit('OK');
        end;
        exit('Production Order not found');
    end;

    local procedure CleanSourceText(var SourceText: Text)
    begin
        while CopyStr(SourceText, 1, 1) <> '<' do
            SourceText := CopyStr(SourceText, 2);
        while CopyStr(SourceText, StrLen(SourceText), 1) <> '>' do
            SourceText := CopyStr(SourceText, 1, StrLen(SourceText) - 1);
    end;

    local procedure FindNode(var XMLRootNode: XmlNode; NodePath: Text[250]; var FoundXMLNode: XmlNode): Boolean
    var
        NodeList: XmlNodeList;
        l_intI: Integer;
    begin
        if XMLRootNode.AsXMLElement().IsEmpty then
            exit(false);

        NodeList := XMLRootNode.AsXMLElement().GetChildNodes();
        l_intI := 0;
        while l_intI < NodeList.Count do begin
            foreach FoundXMLNode in NodeList do
                if FoundXMLNode.AsXMLElement().Name = NodePath then
                    exit(true);

            if FindNode(FoundXMLNode, NodePath, FoundXMLNode) = true then exit(true);

            l_intI := l_intI + 1;
        end;

        exit(false);
    end;
}

