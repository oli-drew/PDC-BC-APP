/// <summary>
/// Codeunit PDCEventsHandler (ID 50003) handles events subscriptions for PDC app.
/// </summary>
codeunit 50003 PDCEventsHandler
{
    [EventSubscriber(ObjectType::Table, database::Contact, 'OnCreateCustomerFromTemplateOnAfterApplyCustomerTemplate', '', false, false)]
    local procedure ContactOnCreateCustomerOnTransferFieldsFromTemplate(var Customer: Record Customer; CustomerTemplate: Record "Customer Templ.")
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    begin
        if ConfigTemplateHeader.GET(CustomerTemplate."PDC Config. Template Code") then begin
            RecRef.GETTABLE(Customer);
            ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader, RecRef);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure ReleaseSalesDocumentOnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; SkipCheckReleaseRestrictions: Boolean)
    var
        rCustomer: Record Customer;
        SalesLine: Record "Sales Line";
        PDCFunctions: Codeunit "PDC Functions";
        CustBlockQst: Label '%1 %2 is currently blocked.', Comment = '%1=table name, %2=record no.';
        ConfirmReleaseQst: Label 'Please confirm you wish to Release this order.';
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
            if SalesHeader."PDC Return From Invoice No." <> '' then
                SalesHeader.TESTFIELD("PDC Return Submitted");

        if SalesHeader."Sell-to Customer No." <> '' then begin
            rCustomer.RESET();
            rCustomer.GET(SalesHeader."Sell-to Customer No.");
            if rCustomer."PDC Block Release" then
                if NOT GUIALLOWED then
                    EXIT
                else
                    if NOT CONFIRM(STRSUBSTNO(CustBlockQst + ' ' + ConfirmReleaseQst, rCustomer.TABLECAPTION, rCustomer."No.")) then
                        error(CustBlockQst, rCustomer.TABLECAPTION, rCustomer."No.");

            if rCustomer."PDC Branch Mandatory" then begin
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                SalesLine.setrange("Document No.", SalesHeader."No.");
                SalesLine.setrange(Type, SalesLine.Type::Item);
                if SalesLine.FINDSET() then
                    repeat
                        SalesLine.TESTFIELD("PDC Branch No.");
                    until SalesLine.next() = 0;
            end;
        end;

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            if not GUIALLOWED then
                IsHandled := not PDCFunctions.SO_CheckMandatoryFields(SalesHeader, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeManualReleaseSalesDoc', '', true, true)]
    local procedure ReleaseSalesDocumentOnBeforeManualReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        PDCFunctions: Codeunit "PDC Functions";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            if not PDCFunctions.SO_CheckMandatoryFields(SalesHeader, TRUE) then
                error('');
    end;

    [EventSubscriber(ObjectType::table, database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', true, true)]
    local procedure CustLedgerEntryOnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."PDC Branch No." := GenJournalLine."PDC Branch No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostItemJnlLine', '', true, true)]
    local procedure ItemJnlPostLineOnBeforePostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean)
    var
        Item: Record Item;
    begin
        if (ItemJournalLine."PDC Product Code" = '') or (ItemJournalLine."PDC Colour Code" = '') then
            if Item.get(ItemJournalLine."Item No.") then begin
                ItemJournalLine."PDC Product Code" := item."PDC Product Code";
                ItemJournalLine."PDC Colour Code" := Item."PDC Colour";
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', true, true)]
    local procedure ItemJnlPostLineOnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean)
    begin
        ItemLedgerEntry."PDC Product Code" := ItemJournalLine."PDC Product Code";
        ItemLedgerEntry."PDC Branch No." := ItemJournalLine."PDC Branch No.";
        ItemLedgerEntry."PDC Staff ID" := ItemJournalLine."PDC Staff ID";
        ItemLedgerEntry."PDC Wardrobe ID" := ItemJournalLine."PDC Wardrobe ID";
        ItemLedgerEntry."PDC Colour Code" := ItemJournalLine."PDC Colour Code";
        ItemLedgerEntry."PDC Wearer ID" := ItemJournalLine."PDC Wearer ID";
        ItemLedgerEntry."PDC Wearer Name" := ItemJournalLine."PDC Wearer Name";
        ItemLedgerEntry."PDC Customer Reference" := ItemJournalLine."PDC Customer Reference";
        ItemLedgerEntry."PDC Web Order No." := ItemJournalLine."PDC Web Order No.";
        ItemLedgerEntry."PDC Ordered By ID" := ItemJournalLine."PDC Ordered By ID";
        ItemLedgerEntry."PDC Ordered By Name" := ItemJournalLine."PDC Ordered By Name";
        ItemLedgerEntry."PDC Draft Order No." := ItemJournalLine."PDC Draft Order No.";
        ItemLedgerEntry."PDC Draft Order Staff Line No." := ItemJournalLine."PDC Draft Order Staff Line No.";
        ItemLedgerEntry."PDC Draft Order Item Line No." := ItemJournalLine."PDC Draft Order Item Line No.";
        ItemLedgerEntry."PDC Order Reason Code" := ItemJournalLine."PDC Order Reason Code";
        ItemLedgerEntry."PDC Contract No." := ItemJournalLine."PDC Contract No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertPhysInvtLedgEntry', '', true, true)]
    local procedure ItemJnlPostLineOnBeforeInsertPhysInvtLedgEntry(var PhysInventoryLedgerEntry: Record "Phys. Inventory Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        PhysInventoryLedgerEntry."PDC Product Code" := ItemJournalLine."PDC Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertValueEntry', '', true, true)]
    local procedure ItemJnlPostLineOnBeforeInsertValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        ValueEntry."PDC Product Code" := ItemJournalLine."PDC Product Code";
        ValueEntry."PDC Branch No." := ItemJournalLine."PDC Branch No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', true, true)]
    local procedure SalesPostOnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        Cust: Record Customer;
        Contact: Record Contact;
    begin
        SalesShptHeader."PDC Number Of Packages" := SalesHeader."PDC Number Of Packages";

        if SalesShptHeader."PDC Ship-to Mobile Phone No." = '' then
            if Cust.GET(SalesShptHeader."Sell-to Customer No.") then
                if Contact.GET(Cust."Primary Contact No.") then
                    if Contact."Mobile Phone No." <> '' then
                        SalesShptHeader."PDC Ship-to Mobile Phone No." := Contact."Mobile Phone No."
                    else
                        SalesShptHeader."PDC Ship-to Mobile Phone No." := Contact."Phone No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', true, true)]
    local procedure SalesPostInvoiceEventsOnPostLinesOnBeforeGenJnlLinePost(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header")
    begin
        GenJnlLine."PDC Branch No." := SalesHeader."PDC Branch No.";
    end;

    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', true, true)]
    local procedure ItemJournalLineOnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        ItemJnlLine."PDC Branch No." := SalesHeader."PDC Branch No.";
    end;

    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', true, true)]
    local procedure ItemJournalLineOnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        ItemJnlLine."PDC Product Code" := SalesLine."PDC Product Code";
        ItemJnlLine."PDC Staff ID" := SalesLine."PDC Staff ID";
        ItemJnlLine."PDC Wardrobe ID" := SalesLine."PDC Wardrobe ID";
        Item.GET(SalesLine."No.");
        ItemJnlLine."PDC Colour Code" := Item."PDC Colour";
        ItemJnlLine."PDC Wearer ID" := SalesLine."PDC Wearer ID";
        ItemJnlLine."PDC Wearer Name" := SalesLine."PDC Wearer Name";
        ItemJnlLine."PDC Customer Reference" := SalesLine."PDC Customer Reference";
        ItemJnlLine."PDC Web Order No." := SalesLine."PDC Web Order No.";
        ItemJnlLine."PDC Ordered By ID" := SalesLine."PDC Ordered By ID";
        ItemJnlLine."PDC Ordered By Name" := SalesLine."PDC Ordered By Name";
        ItemJnlLine."PDC Draft Order No." := SalesLine."PDC Draft Order No.";
        ItemJnlLine."PDC Draft Order Staff Line No." := SalesLine."PDC Draft Order Staff Line No.";
        ItemJnlLine."PDC Draft Order Item Line No." := SalesLine."PDC Draft Order Item Line No.";
        ItemJnlLine."PDC Order Reason Code" := SalesLine."PDC Order Reason Code";
        ItemJnlLine."PDC Contract No." := SalesLine."PDC Contract No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostItemLine', '', true, true)]
    local procedure SalesPostOnAfterPostItemLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        StaffSize: Record "PDC Staff Size";
        PortalUser: Record "PDC Portal User";
        PortalUserShipToAddrs: Record "PDC Portal User Ship-to Addrs";
    begin
        Item.GET(SalesLine."No.");

        StaffSize.SETRANGE("Staff ID", SalesLine."PDC Staff ID");
        StaffSize.SETRANGE("Size Scale Code", Item."PDC Size Scale Code");
        if not StaffSize.FINDFIRST() then begin
            StaffSize.INIT();
            StaffSize."Staff ID" := SalesLine."PDC Staff ID";
            StaffSize."Size Scale Code" := Item."PDC Size Scale Code";
            StaffSize.INSERT();
        end;
        StaffSize.Fit := Item."PDC Fit";
        StaffSize.Size := Item."PDC Size";
        StaffSize."Created By Item No." := Item."No.";
        StaffSize."Created By" := SalesLine."PDC Ordered By ID";
        StaffSize."Created At" := WORKDATE();
        StaffSize.MODifY();

        if (SalesHeader."Ship-to Code" <> '') and (SalesLine."PDC Ordered By ID" <> '') then begin
            PortalUser.setrange("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
            PortalUser.setrange("Contact No.", SalesLine."PDC Ordered By ID");
            if PortalUser.FindFirst() then
                if not PortalUserShipToAddrs.get(PortalUser.Id, PortalUser."Customer No.", SalesHeader."Ship-to Code") then begin
                    PortalUserShipToAddrs.init();
                    PortalUserShipToAddrs."Portal User ID" := PortalUser.Id;
                    PortalUserShipToAddrs."Customer No." := PortalUser."Customer No.";
                    PortalUserShipToAddrs."Ship-to Code" := SalesHeader."Ship-to Code";
                    PortalUserShipToAddrs.Insert();
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemJnlLineOnBeforePostItemJnlLineWhseLine', '', true, true)]
    local procedure SalesPostOnPostItemJnlLineOnBeforePostItemJnlLineWhseLine(var TempWhseJnlLine: Record "Warehouse Journal Line"; var TempTrackingSpecification: Record "Tracking Specification"; var TempWhseTrackingSpecification: Record "Tracking Specification"; var ItemJnlLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        TempWhseJnlLine."PDC Product Code" := ItemJnlLine."PDC Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', true, true)]
    local procedure SalesPostInvoiceEventsOnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header")
    begin
        GenJnlLine."PDC Branch No." := SalesHeader."PDC Branch No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeModifySalesOrderHeader', '', true, true)]
    local procedure SalesQuoteToOrderOnBeforeModifySalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
        SalesOrderHeader."Order Date" := WORKDATE();
        SalesOrderHeader."Posting Date" := WORKDATE();
        SalesOrderHeader."Document Date" := WORKDATE();
        SalesOrderHeader."Shipment Date" := WORKDATE();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderLine', '', true, true)]
    local procedure SalesQuoteToOrderOnBeforeInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line")
    begin
        SalesOrderLine."Shipment Date" := SalesOrderHeader."Shipment Date";
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', true, true)]
    local procedure ItemJournalLineOnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."PDC Product Code" := PurchLine."PDC Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvLineInsert', '', true, true)]
    local procedure PurchPostOnBeforePurchInvLineInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseLine: Record "Purchase Line"; var PurchInvLine: Record "Purch. Inv. Line"; CommitIsSupressed: Boolean)
    begin
        PurchInvLine."PDC Special Order" := PurchaseLine."Special Order";
        PurchInvLine."PDC Special Order Sales No." := PurchaseLine."Special Order Sales No.";
        PurchInvLine."PDC Spec. Order Sales Line No." := PurchaseLine."Special Order Sales Line No.";
    end;

    [EventSubscriber(ObjectType::Table, database::"Report Selections", 'OnBeforeGetCustEmailAddress', '', true, true)]
    local procedure ReportSelectionsOnBeforeGetCustEmailAddress(BillToCustomerNo: Code[20]; ReportUsage: Option; var ToAddress: Text; var IsHandled: Boolean)
    var
        Customer: Record Customer;
    begin
        if ReportUsage = 2 then //S.Invoice
            if Customer.GET(BillToCustomerNo) and (Customer."PDC Invoice E-Mail" <> '') then begin
                ToAddress := Customer."PDC Invoice E-Mail";
                IsHandled := true;
            end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Exp. Pre-Mapping Gen. Jnl.", 'OnBeforeInsertPaymentExoprtData', '', true, true)]
    local procedure ExpPreMappingGenJnlMyProcedureOnBeforeInsertPaymentExoprtData(var PaymentExportData: Record "Payment Export Data"; GenJournalLine: Record "Gen. Journal Line"; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        if VendorBankAccount.GET(GenJournalLine."Account No.", GenJournalLine."Recipient Bank Account") then
            PaymentExportData."PDC Recipient Reference No." := VendorBankAccount."Reference No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnCopyFromProdOrder', '', true, true)]
    local procedure ProdOrderStatusManagementOnCopyFromProdOrder(var ToProdOrder: Record "Production Order"; FromProdOrder: Record "Production Order")
    begin
        if ToProdOrder.Status = ToProdOrder.Status::Released then
            ToProdOrder."PDC Released D/T" := CREATEDATETIME(TODAY, TIME);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertToSalesLine', '', true, true)]
    local procedure CopyDocumentMgtOnBeforeInsertToSalesLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line"; RecalcLines: Boolean)
    begin
        if RecalcLines and (not FromSalesLine."System-Created Entry") then begin
            ToSalesLine."PDC Product Code" := FromSalesLine."PDC Product Code";
            ToSalesLine."PDC Wearer ID" := FromSalesLine."PDC Wearer ID";
            ToSalesLine."PDC Wearer Name" := FromSalesLine."PDC Wearer Name";
            ToSalesLine."PDC Customer Reference" := FromSalesLine."PDC Customer Reference";
            ToSalesLine."PDC Web Order No." := FromSalesLine."PDC Web Order No.";
            ToSalesLine."PDC Ordered By ID" := FromSalesLine."PDC Ordered By ID";
            ToSalesLine."PDC Ordered By Name" := FromSalesLine."PDC Ordered By Name";
            ToSalesLine."PDC Branch No." := FromSalesLine."PDC Branch No.";
            ToSalesLine."PDC Ordered By Phone" := FromSalesLine."PDC Ordered By Phone";
            ToSalesLine."PDC Wardrobe ID" := FromSalesLine."PDC Wardrobe ID";
            ToSalesLine."PDC Staff ID" := FromSalesLine."PDC Staff ID";
            ToSalesLine."PDC SLA Date" := FromSalesLine."PDC SLA Date";
            ToSalesLine."PDC Draft Order No." := FromSalesLine."PDC Draft Order No.";
            ToSalesLine."PDC Draft Order Staff Line No." := FromSalesLine."PDC Draft Order Staff Line No.";
            ToSalesLine."PDC Draft Order Item Line No." := FromSalesLine."PDC Draft Order Item Line No.";
            ToSalesLine."PDC Order Reason Code" := FromSalesLine."PDC Order Reason Code";
            ToSalesLine."PDC Contract No." := FromSalesLine."PDC Contract No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Warehouse Document-Print", 'OnBeforePrintInvtPickHeader', '', true, true)]
    local procedure WarehouseDocumentPrintOnBeforePrintInvtPickHeader(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var HideDialog: Boolean; var IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        WhseActivHeader: Record "Warehouse Activity Header";
        ReportSelectionWhse: Record "Report Selection Warehouse";
    begin
        //if HideDialog then begin
        SalesSetup.GET();
        if SalesSetup."PDC Inv.Pick Print Labels" then begin
            WhseActivHeader.get(WarehouseActivityHeader.Type, WarehouseActivityHeader."No.");
            WhseActivHeader.SetRecFilter();
            Report.Run(REPORT::"PDC Pick List", not HideDialog, false, WhseActivHeader);
        end;
        //end;
        WhseActivHeader.SETRANGE(Type, WhseActivHeader.Type::"Invt. Pick");
        WhseActivHeader.SETRANGE("No.", WarehouseActivityHeader."No.");
        ReportSelectionWhse.PrintWhseActivityHeader(WhseActivHeader, ReportSelectionWhse.Usage::"Invt. Pick", false);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesPrice', '', true, true)]
    local procedure SalesPriceCalcMgtOnAfterFindSalesPrice(var ToSalesPrice: Record "Sales Price"; CustNo: Code[20])
    begin
        if CustNo <> '' then begin
            ToSalesPrice.setrange("Sales Type", ToSalesPrice."Sales Type"::Customer);
            if not ToSalesPrice.IsEmpty then begin
                ToSalesPrice.setfilter("Sales Type", '<>%1', ToSalesPrice."Sales Type"::Customer);
                ToSalesPrice.DeleteAll();
            end;
            ToSalesPrice.setrange("Sales Type");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnInitWhseEntryCopyFromWhseJnlLine', '', true, true)]
    local procedure WhseJnlRegisterLineOnInitWhseEntryCopyFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; WarehouseJournalLine: Record "Warehouse Journal Line"; OnMovement: Boolean; Sign: Integer)
    begin
        WarehouseEntry."PDC Product Code" := WarehouseJournalLine."PDC Product Code";
        WarehouseEntry."PDC Comment" := WarehouseJournalLine."PDC Comment";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnAfterCreateWhseJnlLine', '', true, true)]
    local procedure WMSManagementOnAfterCreateWhseJnlLine(var WhseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line"; ToTransfer: Boolean)
    begin
        WhseJournalLine."PDC Comment" := ItemJournalLine."PDC Comment";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivLineInsert', '', true, true)]
    local procedure CreatePickOnBeforeWhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; WarehouseActivityHeader: Record "Warehouse Activity Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if WarehouseActivityLine."Source Type" = 37 then
            if WarehouseActivityLine."Source Subtype" = WarehouseActivityLine."Source Subtype"::"1" then
                if WarehouseActivityLine."Source Document" = WarehouseActivityLine."Source Document"::"Sales Order" then
                    if SalesLine.GET(SalesLine."Document Type"::Order, WarehouseActivityLine."Source No.", WarehouseActivityLine."Source Line No.") then begin
                        WarehouseActivityLine."PDC Product Code" := SalesLine."PDC Product Code";
                        WarehouseActivityLine."PDC Wearer ID" := SalesLine."PDC Wearer ID";
                        WarehouseActivityLine."PDC Wearer Name" := SalesLine."PDC Wearer Name";
                        WarehouseActivityLine."PDC Customer Reference" := SalesLine."PDC Customer Reference";
                        WarehouseActivityLine."PDC Web Order No." := SalesLine."PDC Web Order No.";
                        WarehouseActivityLine."PDC Ordered By ID" := SalesLine."PDC Ordered By ID";
                        WarehouseActivityLine."PDC Ordered By Name" := SalesLine."PDC Ordered By Name";
                    end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeCreatePickOrMoveLines', '', true, true)]
    local procedure CreateInventoryPickMovementOnBeforeCreatePickOrMoveLines(WarehouseRequest: Record "Warehouse Request")
    var
        SalesHeader: Record "Sales Header";
        TempSalesHeader: Record "Sales Header" temporary;
    begin
        if WarehouseRequest."Source Document" in
            [WarehouseRequest."Source Document"::"Sales Order",
             WarehouseRequest."Source Document"::"Sales Return Order"]
        then begin
            if WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Sales Order" then
                SalesHeader.GET(SalesHeader."Document Type"::Order, WarehouseRequest."Source No.")
            else
                SalesHeader.GET(SalesHeader."Document Type"::"Return Order", WarehouseRequest."Source No.");
            TempSalesHeader := SalesHeader;
            SalesHeader.VALIDATE("Posting Date", WORKDATE());
            SalesHeader."Shipment Date" := TempSalesHeader."Shipment Date";
            SalesHeader."Due Date" := TempSalesHeader."Due Date";
            SalesHeader.MODifY();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnAfterUpdateWhseActivHeader', '', true, true)]
    local procedure CreateInventoryPickMovementOnAfterUpdateWhseActivHeader(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var WarehouseRequest: Record "Warehouse Request")
    var
        SalesHeader: Record "Sales Header";
    begin
        WarehouseActivityHeader."Shipment Date" := WORKDATE();
        WarehouseActivityHeader."Posting Date" := WORKDATE();

        if WarehouseRequest."Source Document" in
          [WarehouseRequest."Source Document"::"Sales Order",
           WarehouseRequest."Source Document"::"Sales Return Order"] then begin
            if WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Sales Order" then
                SalesHeader.GET(SalesHeader."Document Type"::Order, WarehouseRequest."Source No.")
            else
                SalesHeader.GET(SalesHeader."Document Type"::"Return Order", WarehouseRequest."Source No.");
            WarehouseActivityHeader."PDC Shipping Agent Code" := SalesHeader."Shipping Agent Code";
            WarehouseActivityHeader."PDC Shipping Agent Serv. Code" := SalesHeader."Shipping Agent Service Code";
        end;
        WarehouseActivityHeader."PDC Sales Doc. Created At" := SalesHeader."PDC Created At";
        WarehouseActivityHeader."PDC Ship-to Post Code" := SalesHeader."Ship-to Post Code";
        WarehouseActivityHeader."PDC Ship-to Country/Reg. Code" := SalesHeader."Ship-to Country/Region Code";
        WarehouseActivityHeader."PDC Urgent" := SalesHeader."PDC Urgent";
        WarehouseActivityHeader.Modify();

        SalesHeader."PDC Last Picking No." := WarehouseActivityHeader."No.";
        SalesHeader.Modify(FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnBeforeNewWhseActivLineInsertFromSales', '', true, true)]
    local procedure CreateInventoryPickMovementOnBeforeNewWhseActivLineInsertFromSales(var WarehouseActivityLine: Record "Warehouse Activity Line"; SalesLine: Record "Sales Line")
    var
    begin
        WarehouseActivityLine."PDC Product Code" := SalesLine."PDC Product Code";
        WarehouseActivityLine."PDC Wearer ID" := SalesLine."PDC Wearer ID";
        WarehouseActivityLine."PDC Wearer Name" := SalesLine."PDC Wearer Name";
        WarehouseActivityLine."PDC Customer Reference" := SalesLine."PDC Customer Reference";
        WarehouseActivityLine."PDC Web Order No." := SalesLine."PDC Web Order No.";
        WarehouseActivityLine."PDC Ordered By ID" := SalesLine."PDC Ordered By ID";
        WarehouseActivityLine."PDC Ordered By Name" := SalesLine."PDC Ordered By Name";
        WarehouseActivityLine."PDC Branch No." := SalesLine."PDC Branch No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Act.-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
    local procedure WhseActPostYesNoOnBeforeConfirmPost(var WhseActivLine: Record "Warehouse Activity Line"; var Selection: Integer; var DefaultOption: Integer; var HideDialog: Boolean; var IsHandled: Boolean)
    begin
        if WhseActivLine."PDC Hide Posting Dialog" then begin
            Selection := 2;
            HideDialog := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterPostWhseActivHeader', '', true, true)]
    local procedure WhseActivityPostOnAfterPostWhseActivHeader(WhseActivHeader: Record "Warehouse Activity Header")
    var
        PostedInvtPickHeader: Record "Posted Invt. Pick Header";
        SalesShipment: Record "Sales Shipment Header";
    begin
        if not GuiAllowed then
            exit;
        PostedInvtPickHeader.setrange("Invt Pick No.", WhseActivHeader."No.");
        if PostedInvtPickHeader.findlast() then
            if SalesShipment.GET(PostedInvtPickHeader."Source No.") then begin
                SalesShipment.SETRECFILTER();
                PAGE.RUN(PAGE::"PDC Sales Shipments", SalesShipment);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeCode', '', true, true)]
    local procedure WhseActivityPostOnBeforeCode(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        WhseActivHeader: Record "Warehouse Activity Header";
    begin
        WhseActivHeader.GET(WarehouseActivityLine."Activity Type", WarehouseActivityLine."No.");
        WhseActivHeader.VALIDATE("Posting Date", WORKDATE());
        WhseActivHeader.VALIDATE("Shipment Date", WORKDATE());
        WhseActivHeader.MODifY();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeInitSourceDocument', '', true, true)]
    local procedure WhseActivityPostOnBeforeInitSourceDocument(var WhseActivityHeader: Record "Warehouse Activity Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        if WhseActivityHeader."Source Type" = DATABASE::"Sales Line" then begin
            SalesHeader.GET(WhseActivityHeader."Source Subtype", WhseActivityHeader."Source No.");

            SalesHeader."Shipment Date" := WORKDATE();
            SalesHeader."Posting Date" := WORKDATE();
            SalesHeader.validate("Document Date", WorkDate());
            if (WhseActivityHeader."PDC Shipping Agent Code" <> '') AND (WhseActivityHeader."PDC Shipping Agent Code" <> SalesHeader."Shipping Agent Code") then
                SalesHeader."Shipping Agent Code" := WhseActivityHeader."PDC Shipping Agent Code";
            if (WhseActivityHeader."PDC Shipping Agent Serv. Code" <> '') AND (WhseActivityHeader."PDC Shipping Agent Serv. Code" <> SalesHeader."Shipping Agent Service Code") then
                SalesHeader."Shipping Agent Service Code" := WhseActivityHeader."PDC Shipping Agent Serv. Code";
            SalesHeader."PDC Number Of Packages" := WhseActivityHeader."PDC Number Of Packages";
            SalesHeader."PDC Package Type" := WhseActivityHeader."PDC Package Type";
            SalesHeader.MODifY();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterInitSourceDocument', '', true, true)]
    local procedure WhseActivityPostOnAfterInitSourceDocument(var WhseActivityHeader: Record "Warehouse Activity Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if WhseActivityHeader."Source Type" = DATABASE::"Sales Line" then begin
            SalesLine.SETRANGE("Document Type", WhseActivityHeader."Source Subtype");
            SalesLine.SETRANGE("Document No.", WhseActivityHeader."Source No.");
            if SalesLine.FindSet(true) then
                repeat
                    if SalesLine.Type = SalesLine.Type::"G/L Account" then begin
                        if WhseActivityHeader."Source Document" = WhseActivityHeader."Source Document"::"Sales Order" then
                            SalesLine.VALIDATE("Qty. to Ship", SalesLine."Outstanding Quantity")
                        else
                            SalesLine.VALIDATE("Return Qty. to Receive", SalesLine."Outstanding Quantity");
                        SalesLine.VALIDATE("Qty. to Invoice", SalesLine."Outstanding Quantity");
                        SalesLine."Shipment Date" := WORKDATE();
                        SalesLine.MODifY();
                    end;
                until SalesLine.next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnUpdateSourceDocumentOnAfterSalesLineModify', '', false, false)]
    local procedure WhseActivityPostOnUpdateSourceDocumentOnAfterSalesLineModify(var SalesLine: Record "Sales Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        SalesLine."Shipment Date" := WORKDATE();
        SalesLine.MODifY();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnBeforeRecalculateWithOptionalModify', '', true, true)]
    local procedure PlanningLineManagementOnBeforeRecalculateWithOptionalModify(var RequisitionLine: Record "Requisition Line"; Direction: Option)
    var
        rItemForStatus: Record Item;
    begin
        if rItemForStatus.GET(RequisitionLine."No.") then
            RequisitionLine."PDC Source" := rItemForStatus."PDC Source";
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure ReportManagementOnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            // report::"Statement":
            //     NewReportId := report::"PDCStatement";
            report::"Sales - Shipment":
                NewReportId := report::"PDC Sales Shipment";
            report::"Pick Instruction":
                NewReportId := report::"PDC Pick Instruction";
            report::Order:
                NewReportId := report::"PDC Purchase Order";
            report::"Standard Sales - Invoice":
                NewReportId := report::"PDC Sales Invoice";
            report::"Standard Sales - Credit Memo":
                NewReportId := report::"PDC Credit Memo";
            report::"Return Order Confirmation":
                NewReportId := report::"PDC Return Order Confirmation";
            report::"Prod. Order - Mat. Requisition":
                NewReportId := report::"PDC ProdOrder Mat Requisition";
        end;
    end;

    [EventSubscriber(ObjectType::report, report::"Create Stockkeeping Unit", 'OnBeforeStockkeepingUnitInsert', '', true, true)]
    local procedure CreateStockkeepingUnitOnBeforeStockkeepingUnitInsert(var StockkeepingUnit: Record "Stockkeeping Unit"; Item: Record Item)
    var
        rBinCreationWorksheetLine: Record "Bin Creation Worksheet Line";
        LineNo: Integer;
    begin
        rBinCreationWorksheetLine.RESET();
        if rBinCreationWorksheetLine.FINDLAST() then
            LineNo := rBinCreationWorksheetLine."Line No." + 10000
        else
            LineNo := 10000;
        rBinCreationWorksheetLine.INIT();
        rBinCreationWorksheetLine."Line No." := LineNo;
        rBinCreationWorksheetLine.VALIDATE("Item No.", StockkeepingUnit."Item No.");
        rBinCreationWorksheetLine.Fixed := TRUE;
        rBinCreationWorksheetLine.Default := FALSE;
        rBinCreationWorksheetLine.Type := rBinCreationWorksheetLine.Type::"Bin Content";
        rBinCreationWorksheetLine.Name := 'DEFAULT';
        rBinCreationWorksheetLine."Worksheet Template Name" := 'BINCONTENT';
        rBinCreationWorksheetLine."Location Code" := 'BR';
        rBinCreationWorksheetLine."User ID" := COPYSTR(USERID, 1, 50);
        rBinCreationWorksheetLine.INSERT();
    end;

    // [EventSubscriber(ObjectType::Page, page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    // local procedure DocumentAttachmentFactboxOnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    // var
    //     Branding: Record "PDC Branding";
    // begin
    //     case DocumentAttachment."Table ID" OF
    //         database::"PDC Branding":
    //             begin
    //                 RecRef.OPEN(DATABASE::"PDC Branding");
    //                 if Branding.GET(DocumentAttachment."No.") then
    //                     RecRef.GETTABLE(Branding);
    //             end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Page, page::"Doc. Attachment List Factbox", 'OnAfterGetRecRefFail', '', true, true)]
    local procedure DocAttachmentListFactboxOnAfterGetRecRefFail(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        Branding: Record "PDC Branding";
    begin
        case DocumentAttachment."Table ID" OF
            database::"PDC Branding":
                begin
                    RecRef.OPEN(DATABASE::"PDC Branding");
                    if Branding.GET(DocumentAttachment."No.") then
                        RecRef.GETTABLE(Branding);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', true, true)]
    local procedure DocumentAttachmentDetailsOnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.NUMBER OF
            database::"PDC Branding":
                begin
                    FieldRef := RecRef.FIELD(1);
                    RecNo := FieldRef.VALUE;
                    DocumentAttachment.SETRANGE("No.", RecNo);
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', true, true)]
    local procedure PurchPostOnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PurchRcpHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; RetShptHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ProductionOrder: Record "Production Order";
        TempProductionOrder: Record "Production Order" temporary;
        ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        ConfFinishProdMsg: Label 'Do you want to finish %1 Production Orders?', comment = '%1=prod.orders count';
    begin
        if PurchRcpHdrNo = '' then
            exit;

        PurchRcptLine.setrange("Document No.", PurchRcpHdrNo);
        PurchRcptLine.setfilter("Prod. Order No.", '<>%1', '');
        if PurchRcptLine.findset() then
            repeat
                if ProductionOrder.get(ProductionOrder.Status::Released, PurchRcptLine."Prod. Order No.") then begin
                    TempProductionOrder.INIT();
                    TempProductionOrder := ProductionOrder;
                    if TempProductionOrder.insert() then;
                end
            until PurchRcptLine.Next() = 0;

        if TempProductionOrder.IsEmpty then
            exit;

        if confirm(ConfFinishProdMsg, false, TempProductionOrder.Count) then begin
            TempProductionOrder.FindSet();
            repeat
                ProductionOrder.get(TempProductionOrder.Status, TempProductionOrder."No.");
                clear(ProdOrderStatusMgt);
                ProdOrderStatusMgt.ChangeProdOrderStatus(ProductionOrder, Enum::"Production Order Status"::Finished, WORKDATE(), true);
            until TempProductionOrder.next() = 0;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeCheckInsertFinalizePurchaseOrderHeader', '', true, true)]
    local procedure ReqWkshMakeOrderOnBeforeCheckInsertFinalizePurchaseOrderHeader(RequisitionLine: Record "Requisition Line"; PurchaseHeader: Record "Purchase Header"; var CheckInsert: Boolean)
    var
        PurchLine: Record "Purchase Line";
        JrnBatch: Record "Requisition Wksh. Name";
    begin
        if CheckInsert then
            exit;
        if PurchaseHeader."No." = '' then
            exit;
        if RequisitionLine."Prod. Order No." = '' then
            exit;
        JrnBatch.get(RequisitionLine."Worksheet Template Name", RequisitionLine."Journal Batch Name");
        if JrnBatch.Description <> 'Created by rep. 50049 JQ' then
            exit;
        PurchLine.setrange("Document Type", PurchaseHeader."Document Type");
        PurchLine.setrange("Document No.", PurchaseHeader."No.");
        PurchLine.setrange(Type, PurchLine.Type::Item);
        if PurchLine.IsEmpty then
            exit;
        PurchLine.setrange("Prod. Order No.", RequisitionLine."Prod. Order No.");
        CheckInsert := PurchLine.IsEmpty;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnFinalizeOrderHeaderOnAfterSetFiltersForRecurringReqLine', '', true, true)]
    local procedure ReqWkshMakeOrderOnFinalizeOrderHeaderOnAfterSetFiltersForRecurringReqLine(var RequisitionLine: Record "Requisition Line"; PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.setrange("Document Type", PurchaseHeader."Document Type");
        PurchLine.setrange("Document No.", PurchaseHeader."No.");
        PurchLine.setrange(Type, PurchLine.Type::Item);
        PurchLine.setfilter("Prod. Order No.", '<>%1', '');
        if PurchLine.FindFirst() then begin
            RequisitionLine.setrange("Ref. Order Type", RequisitionLine."Ref. Order Type"::"Prod. Order");
            RequisitionLine.setrange("Ref. Order No.", PurchLine."Prod. Order No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnFinalizeOrderHeaderOnAfterSetFiltersForNonRecurringReqLine', '', true, true)]
    local procedure ReqWkshMakeOrderOnFinalizeOrderHeaderOnAfterSetFiltersForNonRecurringReqLine(var RequisitionLine: Record "Requisition Line"; PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.setrange("Document Type", PurchaseHeader."Document Type");
        PurchLine.setrange("Document No.", PurchaseHeader."No.");
        PurchLine.setrange(Type, PurchLine.Type::Item);
        PurchLine.setfilter("Prod. Order No.", '<>%1', '');
        if PurchLine.FindFirst() then begin
            RequisitionLine.setrange("Ref. Order Type", RequisitionLine."Ref. Order Type"::"Prod. Order");
            RequisitionLine.setrange("Ref. Order No.", PurchLine."Prod. Order No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcProdBOMCostOnAfterCalcCompItemQtyBase', '', true, false)]
    local procedure CalculateStandardCostOnCalcProdBOMCostOnAfterCalcCompItemQtyBase(CalculationDate: Date; MfgItem: Record Item; MfgItemQtyBase: Decimal; IsTypeItem: Boolean; VAR ProdBOMLine: Record "Production BOM Line"; VAR CompItemQtyBase: Decimal; RtngNo: Code[20]; UOMFactor: Decimal)
    var
        WorksheetName: Record "Standard Cost Worksheet Name";
        StdCostWksh: Record "Standard Cost Worksheet";
        Item: Record Item;
        PurchPrice: Record "Purchase Price";
    begin
        if WorksheetName.get('SALESPRICE') then begin
            Item.GET(ProdBOMLine."No.");
            if Item."Replenishment System" = Item."Replenishment System"::Purchase then begin
                PurchPrice.setrange("Item No.", Item."No.");
                PurchPrice.setrange("Vendor No.", Item."Vendor No.");
                PurchPrice.setfilter("Starting Date", '<=%1|%2', WORKDATE(), 0D);
                PurchPrice.setfilter("Ending Date", '<=%1|%2', WORKDATE(), 0D);
                if PurchPrice.findlast() then begin
                    if not StdCostWksh.GET(WorksheetName.Name, StdCostWksh.Type::Item, Item."No.") then begin
                        StdCostWksh.Init();
                        StdCostWksh."Standard Cost Worksheet Name" := WorksheetName.Name;
                        StdCostWksh.Type := StdCostWksh.Type::Item;
                        StdCostWksh.validate("No.", Item."No.");
                        StdCostWksh.insert();
                    end;
                    StdCostWksh."New Standard Cost" := PurchPrice."Direct Unit Cost";
                    StdCostWksh.Modify();
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Start Codeunit", 'OnAfterRun', '', true, true)]
    local procedure JobQueueStartCodeunitOnAfterRun(var JobQueueEntry: Record "Job Queue Entry")
    begin
        if (JobQueueEntry."Object Type to Run" = JobQueueEntry."Object Type to Run"::Report) and (JobQueueEntry."Notify On Success") then begin
            JobQueueEntry."Notify On Success" := false;
            JobQueueEntry.Modify();
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnAfterCalcAvailableInventory', '', true, true)]
    local procedure AvailableToPromiseOnAfterCalcAvailableInventory(VAR Item: Record Item; VAR AvailableInventory: Decimal)
    begin
        AvailableInventory := Item.Inventory;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Record Link", 'OnAfterInsertEvent', '', true, true)]
    local procedure RecordLinkOnAfterInsertEvent(var Rec: Record "Record Link"; RunTrigger: Boolean)
    var
        SelectAction: page PDCRegisterUserTaskFromNote;
    begin
        if Rec.IsTemporary() then
            exit;

        if not RunTrigger then
            exit;

        if Rec.Type <> Rec.Type::Note then
            exit;

        if not GuiAllowed then
            exit;

        SelectAction.SetRecord(Rec);
        SelectAction.Run();
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Task", 'OnBeforeRunReportOrPageLink', '', true, true)]
    local procedure UserTaskOnBeforeRunReportOrPageLink(var UserTask: Record "User Task"; var IsHandled: Boolean)
    var
        RecRef: RecordRef;
        VarRecRef: Variant;
    begin
        if UserTask."PDC Record ID".TableNo = 0 then
            exit;

        RecRef := UserTask."PDC Record ID".GetRecord();
        VarRecRef := RecRef;
        page.Run(0, VarRecRef);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure SalesLineOnAfterCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item; CurrentFieldNo: Integer; xSalesLine: Record "Sales Line")
    begin
        SalesLine."PDC Carbon Emissions CO2e" := Item."PDC Carbon Emissions CO2e";
    end;


}
