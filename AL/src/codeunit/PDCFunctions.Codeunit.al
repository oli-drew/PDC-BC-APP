/// <summary>
/// Codeunit PDC Functions (ID 50001) handles miscelanous procedures for PDC app.
/// </summary>
Codeunit 50001 "PDC Functions"
{

    Permissions = TableData 32 = rm, TableData 110 = rm, TableData 111 = rm, TableData 113 = rm, TableData 5802 = rm;

    /// <summary>
    /// procedure SO_CheckMandatoryFields check all needed fields in Sales Order.
    /// </summary>
    /// <param name="SalesHeader">Source Record "Sales Header".</param>
    /// <param name="ShowWarning">To show error message, of type Boolean.</param>
    /// <returns>Return variable isOK of type Boolean.</returns>
    procedure SO_CheckMandatoryFields(SalesHeader: Record "Sales Header"; ShowWarning: Boolean) isOK: Boolean
    var
        SalesLine1: Record "Sales Line";
        FieldNames: Text;
        ConfMsg: Label 'Warning - 1 or more lines are missing data in the fields [%1], are you sure you want to release this document?', comment = '%1=field names';
    begin
        isOK := TRUE;

        if SalesHeader."PDC Ship-to E-Mail" = '' then begin
            isOK := FALSE;
            if STRPOS(FieldNames, SalesHeader.FIELDCAPTION("PDC Ship-to E-Mail")) = 0 then
                FieldNames += ',' + SalesHeader.FIELDCAPTION("PDC Ship-to E-Mail");
        end;

        // if SalesHeader."PDC Ship-to Mobile Phone No." = '' then begin
        //     isOK := FALSE;
        //     if STRPOS(FieldNames, SalesHeader.FIELDCAPTION("PDC Ship-to Mobile Phone No.")) = 0 then
        //         FieldNames += ',' + SalesHeader.FIELDCAPTION("PDC Ship-to Mobile Phone No.");
        // end;

        SalesLine1.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine1.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine1.SETRANGE(Type, SalesLine1.Type::Item);
        SalesLine1.SETFILTER("No.", '<>%1', '');
        if SalesLine1.Findset() then
            repeat
                if SalesLine1."PDC Customer Reference" = '' then begin
                    isOK := FALSE;
                    if STRPOS(FieldNames, SalesLine1.FIELDCAPTION("PDC Customer Reference")) = 0 then
                        FieldNames += ',' + SalesLine1.FIELDCAPTION("PDC Customer Reference");
                end;
                if SalesLine1."Unit Price" = 0 then begin
                    isOK := FALSE;
                    if STRPOS(FieldNames, SalesLine1.FIELDCAPTION("Unit Price")) = 0 then
                        FieldNames += ',' + SalesLine1.FIELDCAPTION("Unit Price");
                end;
            until SalesLine1.next() = 0;

        if ShowWarning then
            if NOT isOK then begin
                FieldNames := COPYSTR(FieldNames, 2);
                isOK := CONFIRM(ConfMsg, FALSE, FieldNames);
            end;
    end;

    /// <summary>
    /// procedure PurchPostReceiveToday print labels, set receipt date = today and post Purchase Receipt.
    /// </summary>
    /// <param name="VAR FromPurchHeader">Source Record "Purchase Header".</param>
    /// <param name="Print">To print labels, of type Boolean.</param>
    procedure PurchPostReceiveToday(VAR FromPurchHeader: Record "Purchase Header"; Print: Boolean);
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Vendor: Record Vendor;
        PurchPostViaJobQueue: Codeunit "Purchase Post via Job Queue";
        PDCEventsManual: Codeunit PDCEventsManual;
        ConfPostQst: Label 'Do you want to post the %1?', Comment = '%1=document type';
        ToPrint: Boolean;
        LabelCnt: Decimal;
    begin
        PurchHeader.COPY(FromPurchHeader);
        PurchHeader.TESTFIELD("Document Type", PurchHeader."Document Type"::Order);

        if not
           CONFIRM(
             ConfPostQst, FALSE,
             PurchHeader."Document Type")
        then
            exit;

        PurchSetup.GET();

        PurchHeader.VALIDATE("Posting Date", WORKDATE());
        PurchHeader.Receive := TRUE;
        PurchHeader.Invoice := FALSE;
        PurchHeader."Print Posted Documents" := FALSE;

        if Print then begin
            Vendor.get(PurchHeader."Buy-from Vendor No.");
            if Vendor."PDC Print Purch. Order Labels" then begin
                ToPrint := true;
                if PurchSetup."PDC Def. Purch. Labels Cnt." > 0 then begin
                    PurchLine.setrange("Document Type", PurchHeader."Document Type");
                    PurchLine.setrange("Document No.", PurchHeader."No.");
                    PurchLine.setrange(Type, PurchLine.Type::Item);
                    if PurchLine.FindSet() then
                        repeat
                            LabelCnt += round(PurchLine."Qty. to Receive", 1, '>');
                        until PurchLine.Next() = 0;
                    if LabelCnt > PurchSetup."PDC Def. Purch. Labels Cnt." then
                        ToPrint := false;
                end;
                if ToPrint then
                    BindSubscription(PDCEventsManual);
            end;
        end;

        if PurchSetup."Post with Job Queue" then
            PurchPostViaJobQueue.EnqueuePurchDoc(PurchHeader)
        else
            CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PurchHeader);

        if ToPrint then
            UnbindSubscription(PDCEventsManual);
    end;

    /// <summary>
    /// procedure PurchPostReceiveTodayAndProduction receive PO, print labels, process production orders, and print production labels.
    /// </summary>
    /// <param name="VAR FromPurchHeader">Source Record "Purchase Header".</param>
    /// <param name="Print">To print labels, of type Boolean.</param>
    procedure PurchPostReceiveTodayAndProduction(VAR FromPurchHeader: Record "Purchase Header"; Print: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ProdOrder: Record "Production Order";
        TempReleasedProdOrders: Record "Production Order" temporary;
        TempUnreleasedProdOrders: Record "Production Order" temporary;
        ConfViewProdOrdersQst: Label 'Some Firm Planned Production Orders could not be released due to insufficient stock.\\Do you want to view the related production orders?';
        ConfViewReleasedQst: Label 'Do you want to view the released production orders?';
        ProdOrderFilter: Text;
        ShowProdOrders: Boolean;
    begin
        PurchHeader.COPY(FromPurchHeader);

        // Step 1: Receive the Purchase Order and print PO labels (reuse existing function)
        PurchPostReceiveToday(PurchHeader, Print);

        // Step 2: Find the posted receipt
        PurchRcptHeader.SETCURRENTKEY("Order No.");
        PurchRcptHeader.SETRANGE("Order No.", PurchHeader."No.");
        if not PurchRcptHeader.FINDLAST() then
            exit; // No receipt found, exit

        // Step 3: Find production orders related to this PO receipt
        FindRelatedProductionOrders(PurchRcptHeader, TempReleasedProdOrders, TempUnreleasedProdOrders);

        // Exit if no production orders are related to this PO
        if TempReleasedProdOrders.IsEmpty() and TempUnreleasedProdOrders.IsEmpty() then
            exit;

        // Step 4: Reserve and Release Firm Planned production orders (all orders, not just this PO)
        FirmProdOrderAutoReserve();
        FirmProdOrderAutoRelease();

        // Step 5: Refresh status of production orders (some may have been released)
        RefreshProductionOrderStatus(TempReleasedProdOrders, TempUnreleasedProdOrders);

        // Step 6: Print production labels for released orders
        PrintProductionLabelsForOrders(TempReleasedProdOrders);

        // Step 7: Ask user if they want to view production orders
        if not TempUnreleasedProdOrders.IsEmpty() then begin
            if CONFIRM(ConfViewProdOrdersQst, TRUE) then
                ShowProdOrders := true;
        end else
            if not TempReleasedProdOrders.IsEmpty() then
                if CONFIRM(ConfViewReleasedQst, FALSE) then
                    ShowProdOrders := true;

        if ShowProdOrders then begin
            // Build filter of all production orders (released and unreleased)
            ProdOrderFilter := BuildProductionOrderFilter(TempReleasedProdOrders, TempUnreleasedProdOrders);

            if ProdOrderFilter <> '' then begin
                ProdOrder.SETFILTER("No.", ProdOrderFilter);
                PAGE.RUNMODAL(PAGE::"Released Production Orders", ProdOrder);
            end;
        end;
    end;

    local procedure FindRelatedProductionOrders(PurchRcptHeader: Record "Purch. Rcpt. Header"; var TempReleasedOrders: Record "Production Order" temporary; var TempUnreleasedOrders: Record "Production Order" temporary)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrder: Record "Production Order";
        TempProdOrderNos: Record "Production Order" temporary;
    begin
        // Find all production orders that have components reserved from this receipt
        PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SETFILTER("No.", '<>%1', '');
        PurchRcptLine.SETFILTER(Quantity, '<>%1', 0);
        if not PurchRcptLine.FINDSET() then
            exit;

        repeat
            // Find item ledger entries for this receipt line
            ItemLedgEntry.RESET();
            ItemLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
            ItemLedgEntry.SETRANGE("Document No.", PurchRcptLine."Document No.");
            ItemLedgEntry.SETRANGE("Document Type", ItemLedgEntry."Document Type"::"Purchase Receipt");
            ItemLedgEntry.SETRANGE("Document Line No.", PurchRcptLine."Line No.");
            if ItemLedgEntry.FINDSET() then
                repeat
                    // Find reservations from this item ledger entry to production order components
                    ReservEntry.RESET();
                    ReservEntry.SETCURRENTKEY("Item Ledger Entry No.");
                    ReservEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                    ReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
                    ReservEntry.SETFILTER("Quantity (Base)", '<>%1', 0);
                    if ReservEntry.FINDSET() then
                        repeat
                            // Get the production order component
                            if ProdOrderComp.GET(
                                ReservEntry."Source Subtype",
                                ReservEntry."Source ID",
                                ReservEntry."Source Prod. Order Line",
                                ReservEntry."Source Ref. No.")
                            then begin
                                // Check if we've already added this production order
                                TempProdOrderNos.RESET();
                                TempProdOrderNos.SETRANGE(Status, ProdOrderComp.Status);
                                TempProdOrderNos.SETRANGE("No.", ProdOrderComp."Prod. Order No.");
                                if TempProdOrderNos.IsEmpty() then begin
                                    // Track this production order
                                    TempProdOrderNos.INIT();
                                    TempProdOrderNos.Status := ProdOrderComp.Status;
                                    TempProdOrderNos."No." := ProdOrderComp."Prod. Order No.";
                                    TempProdOrderNos.INSERT();

                                    // Add to appropriate list based on status
                                    if ProdOrder.GET(ProdOrderComp.Status, ProdOrderComp."Prod. Order No.") then
                                        if ProdOrder.Status = ProdOrder.Status::"Firm Planned" then begin
                                            TempUnreleasedOrders := ProdOrder;
                                            if not TempUnreleasedOrders.INSERT() then
                                                TempUnreleasedOrders.MODIFY();
                                        end else
                                            if ProdOrder.Status = ProdOrder.Status::Released then begin
                                                TempReleasedOrders := ProdOrder;
                                                if not TempReleasedOrders.INSERT() then
                                                    TempReleasedOrders.MODIFY();
                                            end;
                                end;
                            end;
                        until ReservEntry.NEXT() = 0;
                until ItemLedgEntry.NEXT() = 0;
        until PurchRcptLine.NEXT() = 0;
    end;

    local procedure RefreshProductionOrderStatus(var TempReleasedOrders: Record "Production Order" temporary; var TempUnreleasedOrders: Record "Production Order" temporary)
    var
        ProdOrder: Record "Production Order";
        ProdOrderNo: Code[20];
    begin
        // Check if any unreleased orders have been released
        if TempUnreleasedOrders.FINDSET() then
            repeat
                ProdOrderNo := TempUnreleasedOrders."No.";
                // Try to find as released
                if ProdOrder.GET(ProdOrder.Status::Released, ProdOrderNo) then begin
                    // Move from unreleased to released
                    TempReleasedOrders := ProdOrder;
                    if not TempReleasedOrders.INSERT() then
                        TempReleasedOrders.MODIFY();
                    TempUnreleasedOrders.DELETE();
                end;
            until TempUnreleasedOrders.NEXT() = 0;
    end;

    local procedure PrintProductionLabelsForOrders(var TempProdOrders: Record "Production Order" temporary)
    var
        ProdOrder: Record "Production Order";
    begin
        if TempProdOrders.FINDSET() then
            repeat
                if ProdOrder.GET(TempProdOrders.Status, TempProdOrders."No.") then begin
                    ProdOrder.SETRECFILTER();
                    REPORT.RUN(REPORT::"PDC Production Order Labels", FALSE, FALSE, ProdOrder);
                end;
            until TempProdOrders.NEXT() = 0;
    end;

    local procedure BuildProductionOrderFilter(var TempReleasedOrders: Record "Production Order" temporary; var TempUnreleasedOrders: Record "Production Order" temporary) FilterText: Text
    begin
        FilterText := '';
        if TempReleasedOrders.FINDSET() then
            repeat
                if FilterText <> '' then
                    FilterText += '|';
                FilterText += TempReleasedOrders."No.";
            until TempReleasedOrders.NEXT() = 0;

        if TempUnreleasedOrders.FINDSET() then
            repeat
                if FilterText <> '' then
                    FilterText += '|';
                FilterText += TempUnreleasedOrders."No.";
            until TempUnreleasedOrders.NEXT() = 0;
    end;

    /// <summary>
    /// PrintPurchReceiptLabelsBackground.
    /// </summary>
    /// <param name="PurchRcptHeader">Record "Purch. Rcpt. Header".</param>
    procedure PrintPurchReceiptLabelsBackground(PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        XmlDoc: XmlDocument;
        Root: XmlElement;
        RootNode: XmlNode;
        DataNode: XmlNode;
        Node: XmlNode;
        xmlTxt: Text;
        ReqPageXmlTxt: label '<?xml version="1.0" standalone="yes"?><ReportParameters />', Locked = true;
    begin
        if PurchRcptHeader."No." = '' then
            exit;

        XmlDocument.ReadFrom(ReqPageXmlTxt, XMLDoc);
        if not XMLDoc.GetRoot(Root) then exit;
        RootNode := Root.AsXmlNode();
        AddAttribute(RootNode, 'name', 'PDC Purchase Receipt Labels');
        AddAttribute(RootNode, 'id', format(Report::"PDC Purchase Receipt Labels"));
        AddElement(RootNode, 'DataItems', '', '', DataNode);
        AddElement(DataNode, 'DataItem', StrSubstNo('VERSION(1) SORTING(Field3) WHERE(Field3=1(%1))', PurchRcptHeader."No."), '', Node);
        AddAttribute(Node, 'name', 'Order');
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1,Field3,Field4)', '', Node);
        AddAttribute(Node, 'name', 'Line');
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1)', '', Node);
        AddAttribute(Node, 'name', 'LabelLoop');
        XmlDoc.WriteTo(xmlTxt);

        ReportBackgroundPrint(Report::"PDC Purchase Receipt Labels", xmlTxt);
    end;

    /// <summary>
    /// procedure FindDraftOrderItemLinePrice find Sales Price for Drafot Order line.
    /// </summary>
    /// <param name="VAR DraftOrderItemLine">Source Record "PDC Draft Order Item Line".</param>
    procedure FindDraftOrderItemLinePrice(VAR DraftOrderItemLine: Record "PDC Draft Order Item Line")
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        Customer: Record Customer;
        Item: Record Item;
        TempSalesPrice: Record "Sales Price" temporary;
        SalesPriceMgt: Codeunit "Sales Price Calc. Mgt.";
    begin
        DraftOrderHeader.GET(DraftOrderItemLine."Document No.");
        Customer.GET(DraftOrderHeader."Sell-to Customer No.");
        Item.GET(DraftOrderItemLine."Item No.");
        SalesPriceMgt.FindSalesPrice(TempSalesPrice, DraftOrderHeader."Sell-to Customer No.", '', Customer."Customer Price Group", '', DraftOrderItemLine."Item No.", '', DraftOrderItemLine."Unit Of Measure Code", '', WORKDATE, TRUE);
        SalesPriceMgt.CalcBestUnitPrice(TempSalesPrice);
        DraftOrderItemLine."Unit Price" := TempSalesPrice."Unit Price";
    end;

    /// <summary>
    /// procedure InvPickPostAndPrintAndEmail run Post+Print+Email for Inventory Pick.
    /// </summary>
    /// <param name="WhseActivLine">Source record VAR Record "Warehouse Activity Line".</param>
    procedure InvPickPostAndPrintAndEmail(var WhseActivLine: Record "Warehouse Activity Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShptHeader: Record "Sales Shipment Header";
        WhseActivPostYesNo: Codeunit "Whse.-Act.-Post (Yes/No)";
    begin
        WhseActivPostYesNo.PrintDocument(false);
        WhseActivLine."PDC Hide Posting Dialog" := true;
        WhseActivPostYesNo.Run(WhseActivLine);

        SalesShptHeader.SETRANGE("Order No.", WhseActivLine."Source No.");
        if SalesShptHeader.FINDlast() then begin
            SalesShptHeader.SETRECFILTER();
            SalesShptHeader.PrintRecords(FALSE);
        end;

        SalesInvoiceHeader.RESET();
        SalesInvoiceHeader.SETRANGE("Order No.", WhseActivLine."Source No.");
        if SalesInvoiceHeader.FINDSET() then
            repeat
                if SalesInvoiceHeader."No. Printed" = 0 then
                    SalesInvoiceHeader.SendEmailSilent();
            until SalesInvoiceHeader.next() = 0;
    end;

    /// <summary>
    /// procedure SalesCrMemoPrintAndEmail print and email Sales Credit Memo.
    /// </summary>
    /// <param name="SalesHeader">Source record VAR Record "Sales Header".</param>
    procedure SalesCrMemoPrintAndEmail(var SalesHeader: Record "Sales Header")
    var
        SalesCrMemo: Record "Sales Cr.Memo Header";
        PostPrintAndEmailQst: Label 'Do you want to post, print and email the %1?', Comment = '%1=document type';
    begin
        if not CONFIRM(PostPrintAndEmailQst, FALSE, SalesHeader."Document Type") then
            exit;

        CODEUNIT.RUN(CODEUNIT::"Sales-Post", SalesHeader);
        if SalesCrMemo.GET(SalesHeader."No.") then
            SalesCrMemo.SendEmailSilent();
    end;

    /// <summary>
    /// procedure SalesShipmentSendToUPSTable on post Sales shipment creates records in CourierShipmentHeader.
    /// </summary>
    /// <param name="SalesShipmentHdr">Source record VAR Record "Sales Shipment Header".</param>
    procedure SalesShipmentSendToUPSTable(var SalesShipmentHdr: Record "Sales Shipment Header")
    var
        UPSSH: Record PDCCourierShipmentHeader;
        SalesSetup: Record "Sales & Receivables Setup";
        ShipToAddr: Record "Ship-to Address";
        ShipmentLine: Record "Sales Shipment Line";
        NoSeries: Codeunit "No. Series";
        OrdererName: Text;
        rWearerNames: Text;
    begin
        if SalesShipmentHdr."PDC Released" then
            Error('This order is alread released');

        UPSSH.SetRange(SalesShipmentHeaderNo, SalesShipmentHdr."No.");
        UPSSH.SetRange(Deleted, false);
        if not UPSSH.IsEmpty() then
            Error('This order is alread released');
        SalesSetup.Get();

        if not ShipToAddr.Get(SalesShipmentHdr."Sell-to Customer No.", SalesShipmentHdr."Ship-to Code") then
            ShipToAddr.Init();

        UPSSH.Init();
        UPSSH.ConsignmentNo := copystr(NoSeries.GetNextNo(SalesSetup."PDC Consignment Nos.", WorkDate()), 1, MaxStrLen(UPSSH.ConsignmentNo));
        UPSSH.SalesShipmentHeaderNo := SalesShipmentHdr."No.";
        UPSSH.SellToCustomerNo := SalesShipmentHdr."Sell-to Customer No.";
        UPSSH.OrderDate := SalesShipmentHdr."Order Date";
        UPSSH.ShipmentDate := SalesShipmentHdr."Shipment Date";
        UPSSH.ShipToCode := SalesShipmentHdr."Ship-to Code";
        UPSSH.ShipmentMethodCode := SalesShipmentHdr."Shipment Method Code";
        UPSSH.ShipToName := SalesShipmentHdr."Ship-to Name";
        UPSSH.ShipToName2 := SalesShipmentHdr."Ship-to Name 2";
        UPSSH.ShipToAddress := SalesShipmentHdr."Ship-to Address";
        UPSSH.ShipToAddress2 := SalesShipmentHdr."Ship-to Address 2";
        UPSSH.ShipToCity := SalesShipmentHdr."Ship-to City";
        UPSSH.ShipToContact := SalesShipmentHdr."Ship-to Contact";
        UPSSH.ShipToPostCode := SalesShipmentHdr."Ship-to Post Code";
        UPSSH.ShipToCounty := SalesShipmentHdr."Ship-to County";
        UPSSH.ShipToCountryRegionCode := SalesShipmentHdr."Ship-to Country/Region Code";
        UPSSH.EmployeeName := SalesShipmentHdr."PDC Employee Name";
        UPSSH.CustomerReference := SalesShipmentHdr."PDC Customer Reference";
        UPSSH.WebOrderNo := SalesShipmentHdr."PDC WebOrder No.";
        UPSSH.EmployeeID := SalesShipmentHdr."PDC Employee ID";
        UPSSH.PLSNO := SalesShipmentHdr."PDC PLSNO";
        UPSSH.Notes := SalesShipmentHdr."PDC Notes";
        UPSSH.Phone := ShipToAddr."Phone No.";
        UPSSH.OriginalOrderNo := SalesShipmentHdr."Order No.";
        UPSSH."Shipping Agent Code" := SalesShipmentHdr."Shipping Agent Code";
        UPSSH."Shipping Agent Service Code" := SalesShipmentHdr."Shipping Agent Service Code";
        UPSSH."Ship-to E-Mail" := SalesShipmentHdr."PDC Ship-to E-Mail";
        UPSSH."Ship-to Mobile Phone No." := SalesShipmentHdr."PDC Ship-to Mobile Phone No.";

        ShipmentLine.SetRange("Document No.", SalesShipmentHdr."No.");
        if ShipmentLine.FindFirst() then
            if ShipmentLine."PDC Ordered By Phone" <> '' then
                UPSSH.Phone := ShipmentLine."PDC Ordered By Phone";

        case SalesShipmentHdr."PDC Package Type" of
            SalesShipmentHdr."PDC Package Type"::Box:
                UPSSH.PackageType := 'BX';
            SalesShipmentHdr."PDC Package Type"::Bag:
                UPSSH.PackageType := 'PCH';
            else
                UPSSH.PackageType := 'CP';
        end;

        UPSSH.Description := 'Uniforms';
        UPSSH.Bill := 'SHP';
        UPSSH.Weight := 1;
        UPSSH.NumberOfPackages := SalesShipmentHdr."PDC Number Of Packages";
        CreateMemo(SalesShipmentHdr."No.", OrdererName, rWearerNames);

        UPSSH.Memo := copystr(rWearerNames, 1, 250);
        UPSSH.OrdererName := copystr(OrdererName, 1, 30);
        UPSSH.Insert();

        SalesShipmentHdr."PDC Released" := true;
        SalesShipmentHdr.Modify();
    end;

    local procedure CreateMemo(ShipmentNo: Code[20]; var OrdererName: Text; rWearerNames: Text)
    var
        ShipmentLine: Record "Sales Shipment Line";
        TempArea: Record "Area" temporary;
        AreaCode: Code[10];
    begin
        TempArea.DeleteAll(false);
        ShipmentLine.SetRange("Document No.", ShipmentNo);
        ShipmentLine.SetFilter(Quantity, '>%1', 0);
        ShipmentLine.SetFilter("PDC Wearer Name", '<>%1', '');
        if ShipmentLine.FindSet() then
            repeat
                TempArea.SetRange(Text, ShipmentLine."PDC Wearer Name");
                if not TempArea.FindFirst() then begin
                    TempArea.SetRange(Text);

                    if TempArea.FindLast() then
                        AreaCode := IncStr(TempArea.Code)
                    else
                        AreaCode := 'A001';

                    TempArea.Code := AreaCode;
                    TempArea.Text := CopyStr(ShipmentLine."PDC Wearer Name", 1, MaxStrLen(TempArea.Text));
                    TempArea.Insert();
                end;
            until ShipmentLine.Next() = 0;

        ShipmentLine.SetRange("PDC Wearer Name");
        if ShipmentLine.FindFirst() then
            OrdererName := ShipmentLine."PDC Ordered By Name";

        if (ShipmentLine."PDC Ordered By Name" + ShipmentLine."PDC Customer Reference") <> '' then
            rWearerNames := 'To ' + ShipmentLine."PDC Ordered By Name" + ' ' + ShipmentLine."PDC Customer Reference" + '.';

        if TempArea.FindSet() then
            repeat
                rWearerNames += ' ' + TempArea.Text + ',';
            until (TempArea.Next() = 0) or (StrLen(rWearerNames) > 150);

        rWearerNames := DelChr(rWearerNames, '>', ',');
        rWearerNames := CopyStr(rWearerNames, 1, 150); // 150 UPS limit        
    end;

    /// <summary>
    /// procedure UpdateDocConsignmentNo save consignment no into Sales Shipment lines and Sales Invoice Lines.
    /// </summary>
    /// <param name="SalesShipNo">Sales Shipment No., of type code[20].</param>
    /// <param name="consignmentNumber">Consigment No, of type code[10].</param>
    procedure UpdateDocConsignmentNo(SalesShipNo: code[20]; consignmentNumber: code[10])
    var
        rShipHeader: Record "Sales Shipment Header";
        rShipLine: Record "Sales Shipment Line";
        rInvLine: Record "Sales Invoice Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        if rShipHeader.get(SalesShipNo) then begin
            rShipHeader."PDC Consignment No." := consignmentNumber;
            rShipHeader.Modify();

            rShipLine.SetRange("Document No.", rShipHeader."No.");
            rShipLine.SetRange(Type, rShipLine.Type::Item);
            rShipLine.SetFilter("No.", '<>%1', '');
            rShipLine.SetFilter(Quantity, '<>%1', 0);
            if rShipLine.FindSet(true) then
                repeat
                    rShipLine."PDC Consignment No." := consignmentNumber;
                    rShipLine.Modify();

                    ItemLedgEntry.Reset();
                    rShipLine.FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                    if ItemLedgEntry.FindSet() then begin
                        ValueEntry.SetCurrentkey("Item Ledger Entry No.", "Entry Type");
                        ValueEntry.SetRange("Entry Type", ValueEntry."entry type"::"Direct Cost");
                        ValueEntry.SetFilter("Invoiced Quantity", '<>0');
                        repeat
                            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                            if ValueEntry.FindSet() then
                                repeat
                                    if ValueEntry."Document Type" = ValueEntry."document type"::"Sales Invoice" then
                                        if rInvLine.Get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                                            rInvLine."PDC Consignment No." := consignmentNumber;
                                            rInvLine.Modify();
                                        end;
                                until ValueEntry.Next() = 0;
                        until ItemLedgEntry.Next() = 0;
                    end;
                until rShipLine.Next() = 0;
        end;
    end;

    /// <summary>
    /// SalesOrderAutoReserve run autoreserve procedure for all Sales Order lines.
    /// </summary>    
    procedure SalesOrderAutoReserve()
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        ReservMgt: Codeunit "Reservation Management";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        window: Dialog;
        RecCnt: Integer;
        TotRecCnt: Integer;
        FullAutoReservation: Boolean;
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        WindowsTxt: label '#1######### from #2#########', Locked = true;
    begin
        SalesHeader.setrange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.setrange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet() then begin
            TotRecCnt := SalesHeader.Count();
            if GuiAllowed then begin
                window.Open(WindowsTxt);
                window.Update(2, TotRecCnt);
            end;
            repeat
                RecCnt += 1;
                if GuiAllowed then
                    window.Update(1, RecCnt);

                SalesLines.setrange("Document Type", SalesHeader."Document Type");
                SalesLines.setrange("Document No.", SalesHeader."No.");
                SalesLines.setrange(Type, SalesLines.Type::Item);
                SalesLines.setfilter("Outstanding Quantity", '<>%1', 0);
                if SalesLines.FindSet(true) then
                    repeat
                        ReserveSalesLine.ReservQuantity(SalesLines, QtyToReserve, QtyToReserveBase);
                        if QtyToReserveBase <> 0 then begin
                            clear(ReservMgt);
                            ReservMgt.SetReservSource(SalesLines);
                            ReservMgt.AutoReserve(FullAutoReservation, '', SalesLines."Shipment Date", QtyToReserve, QtyToReserveBase);
                        end;
                    until SalesLines.Next() = 0;
            until SalesHeader.next() = 0;
            if GuiAllowed then
                window.close();
        end;
    end;


    /// <summary>
    /// procedure ReleasedProdOrderAutoReserve run autoreserve procedure for all Released Production order conponents.
    /// </summary>
    procedure FirmProdOrderAutoReserve()
    var
        ProdOrder: Record "Production Order";
        ProdComponentsLines: Record "Prod. Order Component";
        ReservMgt: Codeunit "Reservation Management";
        window: Dialog;
        RecCnt: Integer;
        TotRecCnt: Integer;
        FullAutoReservation: Boolean;
        WindowsTxt: label '#1######### from #2#########', Locked = true;
    begin
        ProdOrder.SetCurrentKey("Starting Date");
        ProdOrder.setrange(Status, ProdOrder.Status::"Firm Planned");
        if ProdOrder.FindSet() then begin
            TotRecCnt := ProdOrder.Count();
            if GuiAllowed then begin
                window.Open(WindowsTxt);
                window.Update(2, TotRecCnt);
            end;
            repeat
                RecCnt += 1;
                if GuiAllowed then
                    window.Update(1, RecCnt);

                ProdComponentsLines.setrange(Status, ProdOrder.Status);
                ProdComponentsLines.setrange("Prod. Order No.", ProdOrder."No.");
                ProdComponentsLines.setfilter("Remaining Qty. (Base)", '<>%1', 0);
                if ProdComponentsLines.FindSet(true) then
                    repeat
                        ProdComponentsLines.CalcFields("Reserved Qty. (Base)");
                        if ProdComponentsLines."Remaining Qty. (Base)" > ProdComponentsLines."Reserved Qty. (Base)" then begin
                            clear(ReservMgt);
                            ReservMgt.SetReservSource(ProdComponentsLines);
                            ReservMgt.AutoReserve(FullAutoReservation, '', ProdComponentsLines."Due Date", ProdComponentsLines."Remaining Quantity", ProdComponentsLines."Remaining Qty. (Base)");
                        end;
                    until ProdComponentsLines.Next() = 0;
            until ProdOrder.next() = 0;
            if GuiAllowed then
                window.close();
        end;
    end;

    /// <summary>
    /// procedure FirmProdOrderAutoRelease release production order if all components are reseved from Item ledger entry.
    /// </summary>
    procedure FirmProdOrderAutoRelease()
    var
        ProdOrder: Record "Production Order";
        ProdOrder2: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdComponentsLines: Record "Prod. Order Component";
        ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        window: Dialog;
        RecCnt: Integer;
        TotRecCnt: Integer;
        IsReady: Boolean;
        WindowsTxt: label '#1######### from #2#########', Locked = true;
    begin
        ProdOrder.SetCurrentKey("Starting Date");
        ProdOrder.setrange(Status, ProdOrder.Status::"Firm Planned");
        if ProdOrder.FindSet() then begin
            TotRecCnt := ProdOrder.Count();
            if GuiAllowed then begin
                window.Open(WindowsTxt);
                window.Update(2, TotRecCnt);
            end;
            repeat
                RecCnt += 1;
                if GuiAllowed then
                    window.Update(1, RecCnt);

                clear(IsReady);
                ProdComponentsLines.setrange(Status, ProdOrder.Status);
                ProdComponentsLines.setrange("Prod. Order No.", ProdOrder."No.");
                ProdComponentsLines.setfilter("Remaining Qty. (Base)", '<>%1', 0);
                if ProdComponentsLines.FindSet(true) then begin
                    IsReady := true;
                    repeat
                        if ProdComponentsLines."Remaining Quantity" > ProdComponentsLines.ReservedFromItemLedger() then
                            IsReady := false;
                    until ProdComponentsLines.Next() = 0;
                end;

                if IsReady then begin
                    ProdOrder2.get(ProdOrder.Status, ProdOrder."No.");
                    clear(ProdOrderStatusMgt);
                    ProdOrderStatusMgt.ChangeProdOrderStatus(ProdOrder2, Enum::"Production Order Status"::Released, 0D, false);
                    ProdOrder2.get(ProdOrder.Status, ProdOrder."No.");
                    if ProdOrder2.Status = ProdOrder2.Status::Released then begin
                        ProdOrderLine.setrange(Status, ProdOrder2.Status);
                        ProdOrderLine.setrange("Prod. Order No.", ProdOrder2."No.");
                        if ProdOrderLine.FindSet() then
                            repeat
                                if ProdOrderLine."Planning Flexibility" <> ProdOrderLine."Planning Flexibility"::"None" then begin
                                    ProdOrderLine.validate("Planning Flexibility", ProdOrderLine."Planning Flexibility"::None);
                                    ProdOrderLine.Modify();
                                end
                            until ProdOrderLine.Next() = 0;
                    end;

                end;
            until ProdOrder.next() = 0;
            if GuiAllowed then
                window.close();
        end;
    end;

    /// <summary>
    /// procedure ProdOrderHasShortage check if all consumption lines in Production Order have stock.
    /// </summary>
    /// <param name="ProdOrder">Source record VAR Record "Production Order".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ProdOrderHasShortage(var ProdOrder: Record "Production Order"): Boolean
    var
        ProdOrderComp: Record "Prod. Order Component";
        HasShortage: Boolean;
    begin
        clear(HasShortage);
        ProdOrderComp.setrange(Status, ProdOrder.Status);
        ProdOrderComp.setrange("Prod. Order No.", ProdOrder."No.");
        if ProdOrderComp.Findset() then
            repeat
                ProdOrderComp.CalcFields("Reserved Quantity");
                if ProdOrderComp."Reserved Quantity" < ProdOrderComp."Remaining Quantity" then
                    HasShortage := true;
            until ProdOrderComp.next() = 0;
        exit(HasShortage);
    end;

    /// <summary>
    /// RegisterUserTaskFromNote.
    /// </summary>
    /// <param name="RecordLink">Record "Record Link".</param>
    /// <param name="UserName">code[50].</param>
    procedure RegisterUserTaskFromNote(RecordLink: Record "Record Link"; UserName: code[50])
    var
        UserTask: Record "User Task";
        Users: Record User;
        TempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        DescriptionText: Text;
        charInt: Integer;
    begin
        if UserName = '' then
            exit;
        Users.setrange("User Name", UserName);
        Users.FindFirst();
        clear(UserTask);
        UserTask.Init();
        UserTask.Title := format(RecordLink."Record ID");
        UserTask."Created By" := UserSecurityId();
        UserTask."Created By User Name" := copystr(UserId, 1, MaxStrLen(UserTask."Created By User Name"));
        UserTask."Created DateTime" := CurrentDateTime();
        UserTask."Assigned To" := Users."User Security ID";
        UserTask."Assigned To User Name" := Users."User Name";
        UserTask."Object Type" := UserTask."Object Type"::Page;
        UserTask."PDC Record ID" := RecordLink."Record ID";
        UserTask.Insert();

        TempBlob.FromRecord(RecordLink, RecordLink.FieldNo(Note));
        TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
        DescriptionText := TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator());
        charInt := DescriptionText[1];
        if charInt in [1 .. 10] then
            DescriptionText := CopyStr(DescriptionText, 2);
        UserTask.SetDescription(DescriptionText);
        UserTask.Modify();
    end;

    /// <summary>
    /// PrintInvPickLabelsBackground.
    /// </summary>
    /// <param name="WhseActivHeader">VAR Record "Warehouse Activity Header".</param>
    procedure PrintInvPickLabelsBackground(var WhseActivHeader: Record "Warehouse Activity Header")
    var

        XmlDoc: XmlDocument;
        Root: XmlElement;
        RootNode: XmlNode;
        DataNode: XmlNode;
        Node: XmlNode;
        xmlTxt: Text;
        ReqPageXmlTxt: label '<?xml version="1.0" standalone="yes"?><ReportParameters />', Locked = true;
    begin
        if WhseActivHeader."No." = '' then
            exit;
        if WhseActivHeader.IsTemporary then
            exit;

        XmlDocument.ReadFrom(ReqPageXmlTxt, XMLDoc);
        if not XMLDoc.GetRoot(Root) then exit;
        RootNode := Root.AsXmlNode();
        AddAttribute(RootNode, 'name', 'PDC Pick List');
        AddAttribute(RootNode, 'id', format(Report::"PDC Pick List"));
        AddElement(RootNode, 'Options', '', '', DataNode);
        AddElement(DataNode, 'Field', '0', '', Node);
        AddAttribute(Node, 'name', 'NoOfCopies');
        AddElement(RootNode, 'DataItems', '', '', DataNode);
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1)', '', Node);
        AddAttribute(Node, 'name', 'CopyLoop');
        AddElement(DataNode, 'DataItem', StrSubstNo('VERSION(1) SORTING(Field1,Field2) WHERE(Field1=1(%1),Field2=1(%2))', WhseActivHeader.Type, WhseActivHeader."No."), '', Node);
        AddAttribute(Node, 'name', 'Warehouse Activity Header');
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1,Field2,Field3)', '', Node);
        AddAttribute(Node, 'name', 'Warehouse Activity Line');
        XmlDoc.WriteTo(xmlTxt);

        ReportBackgroundPrint(Report::"PDC Pick List", xmlTxt);
    end;

    /// <summary>
    /// PrintInvPickInstructionBackground.
    /// </summary>
    /// <param name="WhseActivHeader">VAR Record "Warehouse Activity Header".</param>
    procedure PrintInvPickInstructionBackground(var WhseActivHeader: Record "Warehouse Activity Header")
    var

        XmlDoc: XmlDocument;
        Root: XmlElement;
        RootNode: XmlNode;
        DataNode: XmlNode;
        Node: XmlNode;
        xmlTxt: Text;
        ReqPageXmlTxt: label '<?xml version="1.0" standalone="yes"?><ReportParameters />', Locked = true;
    begin
        if WhseActivHeader."No." = '' then
            exit;
        if WhseActivHeader.IsTemporary then
            exit;

        XmlDocument.ReadFrom(ReqPageXmlTxt, XMLDoc);
        if not XMLDoc.GetRoot(Root) then exit;
        RootNode := Root.AsXmlNode();
        AddAttribute(RootNode, 'name', 'PDC Pick Instruction2');
        AddAttribute(RootNode, 'id', format(Report::"PDC Pick Instruction2"));
        AddElement(RootNode, 'Options', '', '', DataNode);
        AddElement(DataNode, 'Field', '0', '', Node);
        AddAttribute(Node, 'name', 'NoOfCopies');
        AddElement(RootNode, 'DataItems', '', '', DataNode);
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1)', '', Node);
        AddAttribute(Node, 'name', 'CopyLoop');
        AddElement(DataNode, 'DataItem', StrSubstNo('VERSION(1) SORTING(Field1,Field2) WHERE(Field1=1(%1),Field2=1(%2))', WhseActivHeader.Type, WhseActivHeader."No."), '', Node);
        AddAttribute(Node, 'name', 'Header');
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1,Field2,Field3)', '', Node);
        AddAttribute(Node, 'name', 'Line');
        AddElement(DataNode, 'DataItem', 'VERSION(1) SORTING(Field1,Field2,Field7,Field3)', '', Node);
        AddAttribute(Node, 'name', 'Sales Comment Line');
        XmlDoc.WriteTo(xmlTxt);

        ReportBackgroundPrint(Report::"PDC Pick Instruction2", xmlTxt);
    end;

    local procedure ReportBackgroundPrint(ReportId: Integer; requestpageXml: Text)
    var
        JobQueueEntry: Record "Job Queue Entry";
        TempJobQueueEntry: Record "Job Queue Entry" temporary;
        InitServerPrinterTable: Codeunit "Init. Server Printer Table";
    begin
        TempJobQueueEntry.init();
        TempJobQueueEntry."Object Type to Run" := TempJobQueueEntry."Object Type to Run"::Report;
        TempJobQueueEntry."Object ID to Run" := ReportId;
        TempJobQueueEntry.CalcFields("Object Caption to Run");
        TempJobQueueEntry.Description := CopyStr(TempJobQueueEntry."Object Caption to Run", 1, MaxStrLen(TempJobQueueEntry.Description));
        TempJobQueueEntry."Report Request Page Options" := true;
        TempJobQueueEntry."Report Output Type" := TempJobQueueEntry."Report Output Type"::Print;
        TempJobQueueEntry."Printer Name" := InitServerPrinterTable.FindClosestMatchToClientDefaultPrinter(TempJobQueueEntry."Object ID to Run");
        TempJobQueueEntry."PDC Force Running In Error" := true;
        TempJobQueueEntry.Insert();
        TempJobQueueEntry.SetReportParameters(requestpageXml);

        TempJobQueueEntry.CalcFields(XML);
        JobQueueEntry := TempJobQueueEntry;
        Clear(JobQueueEntry.ID); // "Job Queue - Enqueue" defines it on the real record insert
        JobQueueEntry."Run in User Session" := not JobQueueEntry.IsNextRunDateFormulaSet();
        CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
    end;

    local procedure AddElement(var pXMLNode: XmlNode; pNodeName: Text; pNodeText: Text; pNameSpace: Text; var pCreatedNode: XmlNode): Boolean
    var
        lNewChildNode: XmlNode;
    begin
        IF pNodeText <> '' then
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace, pNodeText).AsXmlNode()
        else
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace).AsXmlNode();
        if pXMLNode.AsXmlElement().Add(lNewChildNode) then begin
            pCreatedNode := lNewChildNode;
            exit(true);
        end;
    end;

    local procedure AddAttribute(var pXMLNode: XmlNode; pName: Text; pValue: Text): Boolean
    begin
        pXMLNode.AsXmlElement().SetAttribute(pName, pValue);
        exit(true);
    end;
}

