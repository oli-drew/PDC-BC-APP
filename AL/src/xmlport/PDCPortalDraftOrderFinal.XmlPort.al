/// <summary>
/// XmlPort PDC Portal Draft Order Final (ID 50027).
/// </summary>
xmlport 50027 "PDC Portal Draft Order Final"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                textelement(noFilter)
                {
                }
            }
            tableelement(draftorderheader; "PDC Draft Order Header")
            {
                MinOccurs = Zero;
                XmlName = 'header';
                UseTemporary = true;
                fieldelement(no; DraftOrderHeader."Document No.")
                {
                }
                textelement(poNo)
                {
                    MinOccurs = Once;

                    trigger OnBeforePassVariable()
                    begin
                        poNo := DraftOrderHeader."PO No.";
                    end;
                }
                textelement(branchname)
                {
                    MinOccurs = Zero;
                    XmlName = 'branch';
                }
                fieldelement(requestedShippingDate; DraftOrderHeader."Requested Shipment Date")
                {
                }
                textelement(deliveryname)
                {
                    MinOccurs = Zero;
                    XmlName = 'name';
                }
                fieldelement(address; DraftOrderHeader."Ship-to Address")
                {
                    MinOccurs = Zero;
                }
                fieldelement(address2; DraftOrderHeader."Ship-to Address 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(city; DraftOrderHeader."Ship-to City")
                {
                    MinOccurs = Zero;
                }
                fieldelement(county; DraftOrderHeader."Ship-to County")
                {
                    MinOccurs = Zero;
                }
                fieldelement(postCode; DraftOrderHeader."Ship-to Post Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(country; DraftOrderHeader."Ship-to Country/Region Code")
                {
                    MinOccurs = Zero;
                }
                textelement(shippingagentcode)
                {
                    MinOccurs = Zero;
                    XmlName = 'shippingAgentCode';
                }
                textelement(shippingchargecode)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'shippingChargeCode';
                }
                textelement(ordertotal)
                {
                    MinOccurs = Zero;
                    XmlName = 'orderTotal';
                }
                textelement(outofsla)
                {
                    XmlName = 'outOfSLA';
                }
                textelement(ordercutofftime)
                {
                    MinOccurs = Zero;
                    XmlName = 'cutOffTime';
                }
                textelement(awaitingApproval)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        awaitingApproval := Format(DraftOrderHeader."Awaiting Approval", 0, 9);
                    end;
                }

                textelement(minOrderValue)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        NavPortalUser1: Record "PDC Portal User";
                    begin
                        if NavPortalUser1.Get(g_PDCPortalUser.Id) then
                            minOrderValue := format(NavPortalUser1."Min Order Value", 0, 9);
                    end;
                }
                textelement(maxOrderValue)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        NavPortalUser1: Record "PDC Portal User";
                    begin
                        if NavPortalUser1.Get(g_PDCPortalUser.Id) then
                            maxOrderValue := format(NavPortalUser1."Max Order Value", 0, 9);
                    end;
                }
                textelement(seq)
                {
                    MinOccurs = Zero;
                }
                textelement(skip)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    PortalsMgt: Codeunit "PDC Portal Mgt";
                begin
                    orderTotal := Format(PortalsMgt.GetDraftOrderTotal(DraftOrderHeader), 0, 9);
                    if Customer.Get(DraftOrderHeader."Sell-to Customer No.") then skip := Format(Customer."PDC Portal Default Split Order");
                end;
            }
            tableelement(draftorderitemline; "PDC Draft Order Item Line")
            {
                MinOccurs = Zero;
                XmlName = 'lines';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(documentNo; DraftOrderItemLine."Document No.")
                {
                }
                fieldelement(lineNo; DraftOrderItemLine."Line No.")
                {
                }
                fieldelement(staffLineNo; DraftOrderItemLine."Staff Line No.")
                {
                }
                fieldelement(itemNo; DraftOrderItemLine."Item No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(productCode; DraftOrderItemLine."Product Code")
                {
                    MinOccurs = Zero;
                }
                textelement(productName)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item: Record Item;
                    begin
                        if Item.Get(DraftOrderItemLine."Item No.") then;
                        productName := Item.Description;
                    end;
                }
                fieldelement(colour; DraftOrderItemLine."Colour Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(size; DraftOrderItemLine."Size Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(fit; DraftOrderItemLine."Fit Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(entitlement; DraftOrderItemLine.Entitlement)
                {
                    MinOccurs = Zero;
                }
                fieldelement(qtyIssued; DraftOrderItemLine."Quantity Issued")
                {
                    MinOccurs = Zero;
                }
                textelement(cost)
                {
                    MinOccurs = Zero;
                    XmlName = 'cost';
                }
                fieldelement(quantity; DraftOrderItemLine.Quantity)
                {
                    MinOccurs = Zero;
                }
                textelement(type)
                {
                    MinOccurs = Zero;
                    XmlName = 'type';

                    trigger OnBeforePassVariable()
                    var
                        WardrobeLine: Record "PDC Wardrobe Line";
                    begin
                        DraftOrderItemLine.CalcFields("Wardrobe ID");

                        if not WardrobeLine.Get(DraftOrderItemLine."Wardrobe ID", DraftOrderItemLine."Product Code") then begin
                            type := '';
                            exit;
                        end;

                        type := Format(WardrobeLine."Item Type");
                    end;
                }
                fieldelement(totalcost; DraftOrderItemLine."Line Amount")
                {
                    MinOccurs = Zero;
                }
                textelement(sla_date)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item: Record Item;
                        CustomizedCalendarChange: Record "Customized Calendar Change";
                        PortalsMgt: Codeunit "PDC Portals Management";
                        CalendarManagement: Codeunit "Calendar Management";
                        NonWorking: Boolean;
                        slaNum: Integer;
                        ProposedDate: Date;
                        i: Integer;
                        CutOffTime1: Time;
                    begin
                        ProposedDate := WorkDate();

                        if orderCutOffTime <> '' then
                            if Evaluate(CutOffTime1, orderCutOffTime) then
                                if Dt2Time(CurrentDatetime) >= CutOffTime1 then
                                    ProposedDate += 1;

                        clear(sla);
                        //if draftorderitemline.Quantity > FreeStock then begin
                        if OrderItemQty > FreeStock then begin
                            Item.get(DraftOrderItemLine."Item No.");
                            if format(Item."Lead Time Calculation") <> '' then begin
                                slaNum := calcdate(Item."Lead Time Calculation", ProposedDate) - ProposedDate;
                                GetSalesSetup();
                                if format(SalesReceivablesSetup."PDC Despatch Date Buffer") <> '' then
                                    slaNum += calcdate(SalesReceivablesSetup."PDC Despatch Date Buffer", ProposedDate) - ProposedDate;

                                if slaNum > 0 then
                                    for i := 1 to slaNum do begin
                                        ProposedDate += 1;
                                        NonWorking := CalendarManagement.IsNonworkingDay(ProposedDate, CustomizedCalendarChange);
                                        while NonWorking do begin
                                            ProposedDate += 1;
                                            NonWorking := CalendarManagement.IsNonworkingDay(ProposedDate, CustomizedCalendarChange);
                                        end;
                                    end;
                            end;
                        end
                        else
                            sla := '1';

                        sla_date := PortalsMgt.FormatDate(ProposedDate);

                        if sla = '' then
                            sla := format(ProposedDate - WorkDate());
                    end;
                }
                textelement(sla)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                textelement(staffpoNo)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
                    begin
                        if DraftOrderStaffLine.Get(DraftOrderItemLine."Document No.", DraftOrderItemLine."Staff Line No.") then
                            staffpoNo := DraftOrderStaffLine."PO No.";
                    end;
                }
                textelement(returnPeriod)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item1: Record Item;
                    begin
                        if Item1.Get(DraftOrderItemLine."Item No.") then
                            returnPeriod := Format(Item1."PDC Return Period", 0, 9);
                    end;
                }
                textelement(freeStockQty)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        FreeStockQty := format(FreeStock, 0, 9);
                    end;
                }
                fieldelement(overEntitlementReason; DraftOrderItemLine."Over Entitlement Reason")
                {
                    MinOccurs = Zero;
                    XmlName = 'overEntitlementReason';
                }

                trigger OnAfterGetRecord()
                var
                    STA: Record "Ship-to Address";
                    CustPortalsMgt: Codeunit "PDC Portal Mgt";
                    NavPortalsMgt: Codeunit "PDC Portals Management";
                begin
                    cost := Format(CustPortalsMgt.GetDrafrOrderItemUnitPrices(DraftOrderHeader, DraftOrderItemLine), 0, 9);

                    clear(FreeStock);
                    if DraftOrderItemLine."Item No." <> '' then begin
                        if Customer.Get(DraftOrderHeader."Sell-to Customer No.") then
                            if STA.get(DraftOrderHeader."Sell-to Customer No.", DraftOrderHeader."Ship-to Code") and
                              (sta."Location Code" <> '') then
                                Customer."Location Code" := sta."Location Code";
                        FreeStock := NavPortalsMgt.CalcItemFreeStock(DraftOrderItemLine."Item No.", '', Customer."Location Code", WorkDate());
                    end;

                    OrderItemQty := NavPortalsMgt.CalcDraftOrderLineItemQuantity(DraftOrderItemLine);
                end;
            }
            tableelement(draftorderstaffline; "PDC Draft Order Staff Line")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                textattribute(jsonarray2)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; DraftOrderStaffLine."Staff ID")
                {
                }
                fieldelement(staffLineNo; DraftOrderStaffLine."Line No.")
                {
                }
                fieldelement(name; DraftOrderStaffLine."Staff Name")
                {
                }
                fieldelement(gender; DraftOrderStaffLine."Body Type/Gender")
                {
                }
                fieldelement(yourId; DraftOrderStaffLine."Wearer ID")
                {
                }
                fieldelement(branch; DraftOrderStaffLine."Branch Name")
                {
                }
                fieldelement(uniform; DraftOrderStaffLine."Wardrobe Name")
                {
                }
                fieldelement(uniformid; DraftOrderStaffLine."Wardrobe ID")
                {
                }
            }
            tableelement(shippingagentservices; "Shipping Agent Services")
            {
                MinOccurs = Zero;
                XmlName = 'shippingServices';
                textattribute(jsonarray3)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(shippingAgentCode; ShippingAgentServices."Shipping Agent Code")
                {
                }
                fieldelement(code; ShippingAgentServices.Code)
                {
                }
                fieldelement(description; ShippingAgentServices.Description)
                {
                }
                fieldelement(carriageCharge; ShippingAgentServices."PDC Carriage Charge")
                {
                }
                fieldelement(carriageChargeLimit; ShippingAgentServices."PDC Carriage Charge Limit")
                {
                }

                trigger OnAfterGetRecord()
                var
                    ShipAgentServPerCustomer: Record "PDC Ship.Agent Serv. Per Cust.";
                begin
                    if DraftOrderHeader."Sell-to Customer No." <> '' then begin
                        g_ShippingAgentServices.Reset();
                        g_ShippingAgentServices.SetRange("Shipping Agent Code", ShippingAgentServices."Shipping Agent Code");
                        g_ShippingAgentServices.SetRange("PDC Check Carriage Limit", true);
                        if g_ShippingAgentServices.FindFirst() then
                            if g_ShippingAgentServices.Code = ShippingAgentServices.Code then begin
                                Customer.Get(DraftOrderHeader."Sell-to Customer No.");
                                if Customer."PDC Carriage Charge Limit" > 0 then
                                    ShippingAgentServices."PDC Carriage Charge Limit" := Customer."PDC Carriage Charge Limit";
                            end;
                    end;

                    ShipAgentServPerCustomer.Reset();
                    ShipAgentServPerCustomer.SetRange("Shipping Agent Code", ShippingAgentServices."Shipping Agent Code");
                    ShipAgentServPerCustomer.SetRange("Shipping Agent Service Code", ShippingAgentServices.Code);
                    ShipAgentServPerCustomer.SetRange("Customer No.", DraftOrderHeader."Sell-to Customer No.");
                    if ShipAgentServPerCustomer.FindFirst() then
                        ShippingAgentServices."PDC Carriage Charge" := ShipAgentServPerCustomer."Carriage Charge";
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
        jsonArray2 := 'true';
        jsonArray3 := 'true';
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";

        Customer: Record Customer;
        g_ShippingAgentServices: Record "Shipping Agent Services";
        g_PDCPortalUser: Record "PDC Portal User";
        FreeStock: Decimal;
        OrderItemQty: Decimal;
        SalesSetupFound: boolean;

    /// <summary>
    /// procedure FilterData set filter on data before export to portal.
    /// </summary>
    /// <param name="PDCPortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="PDCDraftOrderHeaderDb">VAR Record "PDC Draft Order Header".</param>
    procedure FilterData(var PDCPortalUser: Record "PDC Portal User"; var PDCDraftOrderHeaderDb: Record "PDC Draft Order Header")
    var
        PDCDraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
        PDCDraftOrderItemLineDb: Record "PDC Draft Order Item Line";
    begin
        g_PDCPortalUser := PDCPortalUser;

        PDCDraftOrderHeaderDb.SetRange("Document No.", noFilter);

        if not PDCDraftOrderHeaderDb.FindFirst() then exit;

        deliveryName := PDCDraftOrderHeaderDb."Ship-to Name" + ' ' + PDCDraftOrderHeaderDb."Ship-to Name 2";

        DraftOrderHeader.TransferFields(PDCDraftOrderHeaderDb);
        DraftOrderHeader.Insert();

        PDCDraftOrderStaffLineDb.Reset();
        PDCDraftOrderStaffLineDb.SetRange("Document No.", noFilter);

        if not PDCDraftOrderStaffLineDb.FindSet() then exit;

        DraftOrderStaffLine.DeleteAll();

        repeat
            DraftOrderStaffLine.TransferFields(PDCDraftOrderStaffLineDb);
            DraftOrderStaffLine.Insert();
        until PDCDraftOrderStaffLineDb.Next() = 0;

        PDCDraftOrderItemLineDb.Reset();
        PDCDraftOrderItemLineDb.SetRange("Document No.", noFilter);
        PDCDraftOrderItemLineDb.SetFilter(Quantity, '>%1', 0);

        if PDCDraftOrderStaffLineDb.IsEmpty then exit;
        DraftOrderItemLine.DeleteAll();
        repeat
            if PDCDraftOrderItemLineDb."Staff Line No." <> 0 then begin
                DraftOrderItemLine.TransferFields(PDCDraftOrderItemLineDb);
                DraftOrderItemLine.Insert();
            end;
        until PDCDraftOrderItemLineDb.Next() = 0;

        ShippingAgentServices.Reset();
        if Customer.get(PDCDraftOrderHeaderDb."Sell-to Customer No.") and (Customer."Shipping Agent Code" <> '') then
            ShippingAgentServices.setrange("Shipping Agent Code", Customer."Shipping Agent Code");
        ShippingAgentServices.SetFilter("PDC Carriage Charge Limit", '>%1', 0.0);
        ShippingAgentServices.SetRange("PDC Show On Portal", true);
        ShippingAgentServices.SetCurrentkey("Shipping Agent Code", "PDC Country/Region Code", "PDC Portal Sequence");
        ShippingAgentServices.SetFilter("PDC Country/Region Code", '%1|%2', DraftOrderHeader."Ship-to Country/Region Code", '');
    end;

    /// <summary>
    /// procedure SaveData save data to database and run processing of order.
    /// </summary>
    /// <param name="PDCPortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="PDCDraftOrderHeaderDb">VAR Record "PDC Draft Order Header".</param>
    procedure SaveData(var PDCPortalUser: Record "PDC Portal User"; var PDCDraftOrderHeaderDb: Record "PDC Draft Order Header")
    var
        PDCDraftOrderItemLineDb: Record "PDC Draft Order Item Line";
        PDCDraftOrderProcessJQ: Codeunit "PDC Draft Order Process JQ";
        OrderSeqNo: Integer;
        OrderNotFoundErr: label 'Order number %1 not found.', Comment = '%1=document no.';
        NoLinesErr: label 'This draft order contains no lines';
        NoShippingChargeErr: label 'Shipping charge code must be supplied';
        InvalidShippingChargeErr: label 'Shipping charge %1 is invalid.', comment = '%1=chanrge no.';
    begin
        if (shippingChargeCode = '') or (shippingAgentCode = '') then Error(NoShippingChargeErr);

        if not ShippingAgentServices.Get(shippingAgentCode, shippingChargeCode) then
            Error(InvalidShippingChargeErr, shippingChargeCode);

        DraftOrderItemLine.SetFilter(Quantity, '>%1', 0);
        if not DraftOrderItemLine.FindSet() then Error(NoLinesErr);

        PDCDraftOrderHeaderDb.SetRange("Document No.", noFilter);
        if not PDCDraftOrderHeaderDb.FindFirst() then Error(OrderNotFoundErr, noFilter);

        if (poNo <> '') and (PDCDraftOrderHeaderDb."PO No." <> poNo) then begin
            PDCDraftOrderHeaderDb."PO No." := poNo;
            PDCDraftOrderHeaderDb.Modify();
            Commit();
        end;

        Evaluate(OrderSeqNo, seq);

        DraftOrderHeader.FindFirst();

        repeat
            PDCDraftOrderItemLineDb.Get(noFilter, DraftOrderItemLine."Staff Line No.", DraftOrderItemLine."Line No.");
            PDCDraftOrderItemLineDb."Create Order No." := OrderSeqNo;
            PDCDraftOrderItemLineDb."Requested Shipment Date" := DraftOrderHeader."Requested Shipment Date";
            PDCDraftOrderItemLineDb."Shipping Agent Code" := ShippingAgentServices."Shipping Agent Code";
            PDCDraftOrderItemLineDb."Shipping Agent Service Code" := ShippingAgentServices.Code;
            PDCDraftOrderItemLineDb."Portal User Id" := PDCPortalUser.Id;
            PDCDraftOrderItemLineDb."Out Of SLA" := outOfSLA = 'true';
            PDCDraftOrderItemLineDb.Modify();
            Commit();
        until DraftOrderItemLine.Next() = 0;

        clear(PDCDraftOrderProcessJQ);
        PDCDraftOrderProcessJQ.EnqueueDraftOrder(PDCDraftOrderHeaderDb);
    end;

    /// <summary>
    /// procedure SetCutOffTime set order cut off time.
    /// </summary>
    /// <param name="CutOffTime">Time.</param>
    procedure SetCutOffTime(CutOffTime: Time)
    begin
        orderCutOffTime := Format(CutOffTime, 8, '<HOURS24,2>:<Minutes,2>:<Seconds,2>');
    end;

    /// <summary>
    /// procedure SendOrderConfirmEmail run sending of email.
    /// </summary>
    /// <param name="SalesHeader1">Record "Sales Header".</param>
    procedure SendOrderConfirmEmail(SalesHeader1: Record "Sales Header")
    var
        PDCPortalOrderConfirm: Report "PDC Portal - Order Confirm";
        PDCPortalOrderConfirm2: Report "PDC Portal - Order Confirm2";
    begin
        SalesHeader1.SetRecfilter();
        PDCPortalOrderConfirm.SetTableview(SalesHeader1);
        PDCPortalOrderConfirm.UseRequestPage(false);
        PDCPortalOrderConfirm.Run();

        PDCPortalOrderConfirm2.SetTableview(SalesHeader1);
        PDCPortalOrderConfirm2.UseRequestPage(false);
        PDCPortalOrderConfirm2.Run();
    end;

    local procedure GetSalesSetup()
    begin
        if not SalesSetupFound then begin
            SalesReceivablesSetup.get();
            SalesSetupFound := true;
        end;

    end;
}
