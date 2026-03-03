/// <summary>
/// XmlPort PDC Portal Sales Order Card (ID 50061).
/// </summary>
XmlPort 50061 "PDC Portal Sales Order Card"
{

    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            tableelement(compaddrbuff; "Name/Value Buffer")
            {
                MinOccurs = Zero;
                XmlName = 'companyAddr';
                UseTemporary = true;
                fieldelement(text; CompAddrBuff.Value)
                {
                }
            }
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(f_nofilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'noFilter';
                }
            }
            tableelement(orderheader; "Sales Header")
            {
                MinOccurs = Zero;
                XmlName = 'order';
                UseTemporary = true;
                fieldelement(no; OrderHeader."No.")
                {
                }
                tableelement(selltoaddrbuff; "Name/Value Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'sellToAddr';
                    UseTemporary = true;
                    fieldelement(text; SellToAddrBuff.Value)
                    {
                        MinOccurs = Zero;
                    }
                }
                tableelement(billtoaddrbuff; "Name/Value Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'billToAddr';
                    UseTemporary = true;
                    fieldelement(text; BillToAddrBuff.Value)
                    {
                    }
                }
                tableelement(shiptoaddrbuff; "Name/Value Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'shipToAddr';
                    UseTemporary = true;
                    fieldelement(text; ShipToAddrBuff.Value)
                    {
                    }
                }
                textelement(orderheader_postingdate)
                {
                    XmlName = 'postingDate';
                }
                textelement(orderheader_documentdate)
                {
                    XmlName = 'documentDate';
                }
                textelement(orderheader_shipmentdate)
                {
                    XmlName = 'shipmentDate';
                }
                textelement(orderheader_duedate)
                {
                    XmlName = 'dueDate';
                }
                fieldelement(amount; OrderHeader.Amount)
                {
                }
                fieldelement(amountInclVat; OrderHeader."Amount Including VAT")
                {
                }
                fieldelement(currencyCode; OrderHeader."Currency Code")
                {
                }
                fieldelement(paymentTermsCode; OrderHeader."Payment Terms Code")
                {
                }
                fieldelement(paymentMethodCode; OrderHeader."Payment Method Code")
                {
                }
                fieldelement(transactionType; OrderHeader."Transaction Type")
                {
                }
                fieldelement(status; OrderHeader.Status)
                {
                    MinOccurs = Zero;
                }
                fieldelement(customerNo; OrderHeader."Sell-to Customer No.")
                {
                    MinOccurs = Zero;
                }
                textelement(orderheader_paymenttype)
                {
                    MinOccurs = Zero;
                    XmlName = 'paymentType';

                    trigger OnBeforePassVariable()
                    var
                        paymentMethod: Record "Payment Method";
                    begin
                        paymentMethod.Reset();
                        paymentMethod.SetRange(Code, OrderHeader."Payment Method Code");
                        if paymentMethod.Findfirst() then
                            OrderHeader_PaymentType := paymentMethod.Description
                        else
                            OrderHeader_PaymentType := OrderHeader."Payment Method Code";
                    end;
                }
                fieldelement(yourReference; OrderHeader."Your Reference")
                {
                    MinOccurs = Zero;
                }
                textelement(orderheader_orderdate)
                {
                    MinOccurs = Zero;
                    XmlName = 'orderDate';
                }
                fieldelement(shiptoName; OrderHeader."Ship-to Name")
                {
                }
                fieldelement(shiptoAddrs1; OrderHeader."Ship-to Address")
                {
                }
                fieldelement(shiptoAddrs2; OrderHeader."Ship-to Address 2")
                {
                }
                fieldelement(shiptoCity; OrderHeader."Ship-to City")
                {
                }
                fieldelement(shiptoPostCode; OrderHeader."Ship-to Post Code")
                {
                }
                fieldelement(shiptoCounty; OrderHeader."Ship-to County")
                {
                }
                fieldelement(shiptoCountry; OrderHeader."Ship-to Country/Region Code")
                {
                }
                tableelement(orderline; "Sales Line")
                {
                    LinkFields = "Document No." = field("No.");
                    LinkTable = OrderHeader;
                    MinOccurs = Zero;
                    XmlName = 'line';
                    UseTemporary = true;
                    textattribute(jsonarray)
                    {
                        Occurrence = Optional;
                        XmlName = 'json_Array';
                    }
                    fieldelement(lineNumber; OrderLine."Line No.")
                    {
                    }
                    fieldelement(type; OrderLine.Type)
                    {
                    }
                    fieldelement(no; OrderLine."No.")
                    {
                    }
                    fieldelement(description; OrderLine.Description)
                    {
                    }
                    fieldelement(quantity; OrderLine.Quantity)
                    {
                    }
                    fieldelement(unitPrice; OrderLine."Unit Price")
                    {
                        MinOccurs = Zero;
                    }
                    textelement(orderline_discountedunitprice)
                    {
                        MinOccurs = Zero;
                        XmlName = 'discountedUnitPrice';

                        trigger OnBeforePassVariable()
                        begin
                            if OrderLine."Line Discount %" > 0 then
                                OrderLine_DiscountedUnitPrice := Format(OrderLine."Line Amount" / OrderLine.Quantity)
                            else
                                OrderLine_DiscountedUnitPrice := '';
                        end;
                    }
                    fieldelement(discountPct; OrderLine."Line Discount %")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(amount; OrderLine.Amount)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(amountInclVat; OrderLine."Amount Including VAT")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(unitOfMeasure; OrderLine."Unit of Measure")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(wearerId; OrderLine."PDC Wearer ID")
                    {
                    }
                    fieldelement(wearerName; OrderLine."PDC Wearer Name")
                    {
                    }
                    fieldelement(custReference; OrderLine."PDC Customer Reference")
                    {
                    }
                    fieldelement(orderedId; OrderLine."PDC Ordered By ID")
                    {
                    }
                    fieldelement(orderedName; OrderLine."PDC Ordered By Name")
                    {
                    }
                    fieldelement(branch; OrderLine."PDC Branch No.")
                    {
                    }
                    fieldelement(qtyShipped; OrderLine."Quantity Shipped")
                    {
                    }
                    fieldelement(qtyToShip; OrderLine."Qty. to Ship")
                    {
                    }
                    fieldelement(overEntitlementReason; OrderLine."PDC Over Entitlement Reason")
                    {
                    }

                    // trigger OnAfterGetRecord()
                    // begin
                    //     if OrderLine.Type = OrderLine.Type::Item then
                    //         GetItemPrevOrdQuantities(OrderLine."No.");
                    // end;
                }

                trigger OnAfterGetRecord()
                begin
                    FormatAddr.SalesHeaderSellTo(SellToAddr, OrderHeader);
                    SetAddress(SellToAddr, SellToAddrBuff);

                    FormatAddr.SalesHeaderBillTo(BillToAddr, OrderHeader);
                    SetAddress(BillToAddr, BillToAddrBuff);

                    FormatAddr.SalesHeaderShipTo(ShipToAddr, SellToAddr, OrderHeader);
                    SetAddress(ShipToAddr, ShipToAddrBuff);

                    OrderHeader_PostingDate := PortalsMgt.FormatDate(OrderHeader."Posting Date");
                    OrderHeader_DocumentDate := PortalsMgt.FormatDate(OrderHeader."Document Date");
                    OrderHeader_ShipmentDate := PortalsMgt.FormatDate(OrderHeader."Shipment Date");
                    OrderHeader_DueDate := PortalsMgt.FormatDate(OrderHeader."Due Date");
                    OrderHeader_OrderDate := PortalsMgt.FormatDate(OrderHeader."Order Date");
                end;
            }

            trigger OnBeforePassVariable()
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                SetAddress(CompanyAddr, CompAddrBuff);
            end;
        }
    }


    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        CompanyInfo: Record "Company Information";
        PortalsMgt: Codeunit "PDC Portals Management";
        CustPortalMgt: Codeunit "PDC Portal Mgt";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[80];
        SellToAddr: array[8] of Text[80];
        BillToAddr: array[8] of Text[80];
        ShipToAddr: array[8] of Text[80];
        LastOrderNo: Code[20];

    procedure InitData()
    begin
    end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User")
    var
        OrderHeaderDb: Record "Sales Header";
        OrderLineDb: Record "Sales Line";
    begin
        OrderHeaderDb.Reset();
        CustPortalMgt.FilterOrders(PortalUser, OrderHeaderDb, false);
        OrderHeaderDb.SetRange("No.", f_noFilter);

        if (OrderHeaderDb.FindFirst()) then begin
            OrderHeader.TransferFields(OrderHeaderDb);
            OrderHeader.Insert();

            OrderLineDb.SetRange("Document No.", OrderHeaderDb."No.");
            if OrderLineDb.Findset() then
                repeat
                    OrderLine.TransferFields(OrderLineDb);
                    OrderLine.Insert();
                until OrderLineDb.next() = 0;
        end;
    end;

    /// <summary>
    /// FilterData2.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="OrderNo">Code[20].</param>
    procedure FilterData2(var PortalUser: Record "PDC Portal User"; OrderNo: Code[20])
    var
        OrderHeaderDb: Record "Sales Header";
        OrderLineDb: Record "Sales Line";
    begin
        OrderHeaderDb.Reset();
        CustPortalMgt.FilterOrders(PortalUser, OrderHeaderDb, false);
        OrderHeaderDb.SetRange("No.", OrderNo);

        if (OrderHeaderDb.FindFirst()) then begin
            OrderHeader.TransferFields(OrderHeaderDb);
            OrderHeader.Insert();

            OrderLineDb.SetRange("Document No.", OrderHeaderDb."No.");
            if OrderLineDb.Findset() then
                repeat
                    OrderLine.TransferFields(OrderLineDb);
                    OrderLine.Insert();
                until OrderLineDb.next() = 0;
        end;
    end;

    local procedure SetAddress(var AddressData: array[8] of Text[80]; var AddressBuffer: Record "Name/Value Buffer" temporary)
    var
        i: Integer;
    begin
        AddressBuffer.Reset();
        AddressBuffer.DeleteAll();
        for i := 1 to 8 do
            if (AddressData[i] <> '') then begin
                AddressBuffer.Init();
                AddressBuffer.ID := i;
                AddressBuffer.Name := AddressData[i];
                AddressBuffer.Value := AddressData[i];
                AddressBuffer.Insert();
            end;
    end;

    /// <summary>
    /// SaveData.
    /// </summary>
    /// <param name="PortalUser">Record "PDC Portal User".</param>
    procedure SaveData(PortalUser: Record "PDC Portal User")
    var
        OrderHeaderDb: Record "Sales Header";
        OrderLineDb: Record "Sales Line";
        LineNo: Integer;
    begin
        OrderHeader.Reset();
        if OrderHeader.FindSet() then
            repeat
                LineNo := 0;

                if OrderHeader."No." = '' then begin
                    OrderHeaderDb.Init();
                    OrderHeaderDb."No." := '';
                    OrderHeaderDb.Validate("Document Type", OrderHeaderDb."document type"::Order);
                    OrderHeaderDb.Insert(true);
                    OrderHeaderDb.Validate("Sell-to Customer No.", PortalUser."Customer No.");
                    if OrderHeader."Posting Date" <> 0D then
                        OrderHeaderDb.Validate("Posting Date", OrderHeader."Posting Date");
                    if OrderHeader."Document Date" <> 0D then
                        OrderHeaderDb.Validate("Document Date", OrderHeader."Document Date");
                    if OrderHeader."Shipment Date" <> 0D then
                        OrderHeaderDb.Validate("Shipment Date", OrderHeader."Shipment Date");
                    if OrderHeader."Due Date" <> 0D then
                        OrderHeaderDb.Validate("Due Date", OrderHeader."Due Date");
                    if OrderHeader."Currency Code" <> '' then
                        OrderHeaderDb.Validate("Currency Code", OrderHeader."Currency Code");
                    if OrderHeader."Payment Terms Code" <> '' then
                        OrderHeaderDb.Validate("Payment Terms Code", OrderHeader."Payment Terms Code");
                    if OrderHeader."Payment Method Code" <> '' then
                        OrderHeaderDb.Validate("Payment Method Code", OrderHeader."Payment Method Code");
                    if OrderHeader."Transaction Type" <> '' then
                        OrderHeaderDb.Validate("Transaction Type", OrderHeader."Transaction Type");
                    OrderHeaderDb.Modify(true);
                end else
                    OrderHeaderDb.Get(OrderHeaderDb."document type"::Order, OrderHeader."No.");

                if OrderLine.FindSet() then
                    repeat
                        LineNo += 10000;

                        OrderLineDb.Init();
                        if not OrderLineDb.Get(OrderHeaderDb."Document Type", OrderHeaderDb."No.", LineNo) then begin
                            OrderLineDb.Validate("Document Type", OrderHeaderDb."Document Type");
                            OrderLineDb.Validate("Document No.", OrderHeaderDb."No.");
                            OrderLineDb.Validate("Line No.", LineNo);
                            OrderLineDb.Insert(true);
                            OrderLineDb.Validate("Sell-to Customer No.", OrderHeaderDb."Sell-to Customer No.");
                            OrderLineDb.Validate(Type, OrderLineDb.Type::Item);
                            OrderLineDb.Validate("No.", OrderLine."No.");
                            OrderLineDb.Validate(Description, OrderLine.Description);
                            if OrderLine."Unit of Measure" <> '' then
                                OrderLineDb.Validate("Unit of Measure", OrderLine."Unit of Measure");
                        end;
                        if OrderLine.Quantity <> 0 then
                            OrderLineDb.Validate(Quantity, OrderLine.Quantity);
                        if OrderLine."Unit Price" <> 0 then
                            OrderLineDb.Validate("Unit Price", OrderLine."Unit Price");
                        OrderLineDb.Modify(true);
                    until OrderLine.next() = 0;

                LastOrderNo := OrderHeaderDb."No.";
            until OrderHeader.Next() = 0;
    end;

    /// <summary>
    /// GetOrderNo.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetOrderNo(): Code[20]
    begin
        exit(LastOrderNo);
    end;

    // local procedure GetItemPrevOrdQuantities(ItemNo: Code[20])
    // var
    //     SalesHeader: Record "Sales Header";
    //     SalesLine: Record "Sales Line";
    //     Week1: Date;
    //     Week2: Date;
    //     Week3: Date;
    //     Week4: Date;
    //     Week5: Date;
    //     Week6: Date;
    //     Week1Qty: Decimal;
    //     Week2Qty: Decimal;
    //     Week3Qty: Decimal;
    //     Week4Qty: Decimal;
    //     Week5Qty: Decimal;
    //     Week6Qty: Decimal;
    // begin
    //     Week1 := WorkDate() - 6;
    //     Week2 := WorkDate() - 13;
    //     Week3 := WorkDate() - 20;
    //     Week4 := WorkDate() - 27;
    //     Week5 := WorkDate() - 34;
    //     Week6 := WorkDate() - 41;

    //     Clear(SalesLine);
    //     SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
    //     SalesLine.SetRange(Type, SalesLine.Type::Item);
    //     SalesLine.SetRange("No.", ItemNo);
    //     if SalesLine.FindSet(false, false) then
    //         repeat
    //             Clear(SalesHeader);
    //             if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
    //                 if SalesHeader.Status = SalesHeader.Status::Released then
    //                     case true of
    //                         (SalesHeader."Order Date" <= WorkDate()) and (SalesHeader."Order Date" >= Week1):
    //                             Week1Qty += SalesLine.Quantity;
    //                         (SalesHeader."Order Date" < Week1) and (SalesHeader."Order Date" >= Week2):
    //                             Week2Qty += SalesLine.Quantity;
    //                         (SalesHeader."Order Date" < Week2) and (SalesHeader."Order Date" >= Week3):
    //                             Week3Qty += SalesLine.Quantity;
    //                         (SalesHeader."Order Date" < Week3) and (SalesHeader."Order Date" >= Week4):
    //                             Week4Qty += SalesLine.Quantity;
    //                         (SalesHeader."Order Date" < Week4) and (SalesHeader."Order Date" >= Week5):
    //                             Week5Qty += SalesLine.Quantity;
    //                         (SalesHeader."Order Date" < Week5) and (SalesHeader."Order Date" >= Week6):
    //                             Week6Qty += SalesLine.Quantity;
    //                     end;
    //         until SalesLine.next() = 0;
    // end;
}

