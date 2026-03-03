/// <summary>
/// XmlPort PDC Portal Recvd Return Card (ID 50021).
/// </summary>
XmlPort 50021 "PDC Portal Recvd Return Card"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(noFilter)
                {
                }
            }
            tableelement(salesheader; "Sales Header")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'returnOrder';
                UseTemporary = true;
                fieldelement(no; SalesHeader."No.")
                {
                }
                fieldelement(contact; SalesHeader."Ship-to Contact")
                {
                }
                fieldelement(name; SalesHeader."Ship-to Name")
                {
                }
                fieldelement(address; SalesHeader."Ship-to Address")
                {
                }
                fieldelement(address2; SalesHeader."Ship-to Address 2")
                {
                }
                fieldelement(city; SalesHeader."Ship-to City")
                {
                }
                fieldelement(county; SalesHeader."Ship-to County")
                {
                }
                fieldelement(postCode; SalesHeader."Ship-to Post Code")
                {
                }
                fieldelement(country; SalesHeader."Ship-to Country/Region Code")
                {
                }
                fieldelement(status; SalesHeader.Status)
                {
                }
                fieldelement(yourRef; SalesHeader."Your Reference")
                {
                }
                fieldelement(branchNo; SalesHeader."PDC Branch No.")
                {
                }
                textelement(salesheader_branchname)
                {
                    XmlName = 'branchName';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();
                        Branch.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                        Branch.SetRange("Branch No.", SalesHeader."PDC Branch No.");

                        if not Branch.FindFirst() then exit;

                        SalesHeader_BranchName := Branch.Name;
                    end;
                }
                textelement(shipmentDate)
                {
                }
                textelement(postingDate)
                {
                }
                textelement(salesheader_pono)
                {
                    XmlName = 'poNo';

                    trigger OnBeforePassVariable()
                    var
                        SalesLine1: Record "Sales Line";
                    begin
                        SalesLine1.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLine1.SetRange("Document No.", SalesHeader."No.");
                        SalesLine1.SetRange(Type, SalesLine1.Type::Item);
                        SalesLine1.SetFilter("No.", '<>%1', '');
                        SalesLine1.SetFilter(Quantity, '<>%1', 0);
                        if SalesLine1.FindFirst() then
                            SalesHeader_PONo := SalesLine1."PDC Customer Reference";
                    end;
                }
                fieldelement(amount; SalesHeader.Amount)
                {
                }
                fieldelement(code; SalesHeader."Ship-to Code")
                {
                }
                textelement(homeaddress)
                {
                }
                fieldelement(email; SalesHeader."PDC Ship-to E-Mail")
                {
                    MinOccurs = Zero;
                }
                fieldelement(mobileNo; SalesHeader."PDC Ship-to Mobile Phone No.")
                {
                    MinOccurs = Zero;
                }
                textelement(orderDate)
                {
                    MinOccurs = Zero;
                }
                textelement(availToReturn)
                {
                    MinOccurs = Zero;
                }
                textelement(packType)
                {
                    MinOccurs = Zero;
                    trigger OnBeforePassVariable()
                    begin
                        packType := format(salesheader."PDC Package Type")
                    end;
                }
                fieldelement(packNo; SalesHeader."PDC Number Of Packages")
                {
                    MinOccurs = Zero;
                }
                fieldelement(returnRef; SalesHeader."PDC Collection Reference")
                {
                    MinOccurs = Zero;
                }
                fieldelement(dropOff; salesheader."PDC Drop-Off")
                {
                    MinOccurs = Zero;
                }
                fieldelement(dropEmail; SalesHeader."PDC Drop-Off Email")
                {
                    MinOccurs = Zero;
                }
                fieldelement(dropPostcode; SalesHeader."PDC Drop-Off Location")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    Line: Record "Sales Line";
                    Item: Record Item;
                    MaxRetDate: Date;
                begin
                    SalesHeader."PDC Branch No." := '';
                    Line.Reset();
                    Line.SetRange("Document Type", SalesHeader."Document Type");
                    Line.SetRange("Document No.", SalesHeader."No.");
                    Line.SetRange(Type, Line.Type::Item);
                    Line.SetFilter("No.", '<>%1', '');
                    if Line.Findset() then
                        repeat
                            SalesHeader."PDC Branch No." := Line."PDC Branch No.";
                        until (Line.next() = 0) or (SalesHeader."PDC Branch No." <> '');

                    shipmentDate := PortalsMgt.FormatDate(SalesHeader."Shipment Date");
                    postingDate := PortalsMgt.FormatDate(SalesHeader."Posting Date");

                    orderDate := PortalsMgt.FormatDate(SalesHeader."Order Date");

                    MaxRetDate := 0D;
                    Line.Reset();
                    Line.SetRange("Document Type", SalesHeader."Document Type");
                    Line.SetRange("Document No.", SalesHeader."No.");
                    Line.SetRange(Type, Line.Type::Item);
                    Line.SetFilter("No.", '<>%1', '');
                    if Line.Findset() then
                        repeat
                            Item.Get(Line."No.");
                            if (Line."Shipment Date" <> 0D) then
                                if MaxRetDate < CalcDate('+' + Format(Item."PDC Return Period") + 'D', Line."Shipment Date") then
                                    MaxRetDate := CalcDate('+' + Format(Item."PDC Return Period") + 'D', SalesLine."Shipment Date");
                        until (Line.next() = 0);
                    if MaxRetDate > WorkDate() then
                        availToReturn := 'true'
                    else
                        availToReturn := 'false';
                end;
            }
            tableelement(salesline; "Sales Line")
            {
                MinOccurs = Zero;
                XmlName = 'returnOrderLines';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(lineNo; SalesLine."Line No.")
                {
                }
                textelement(salesline_wearername)
                {
                    XmlName = 'wearerName';

                    trigger OnBeforePassVariable()
                    var
                        Staff: Record "PDC Branch Staff";
                    begin
                        Staff.SetRange("Staff ID", SalesLine."PDC Staff ID");

                        if not Staff.FindFirst() then exit;

                        SalesLine_WearerName := Staff.Name;
                    end;
                }
                fieldelement(description; SalesLine.Description)
                {
                }
                textelement(salesline_colour)
                {
                    XmlName = 'colour';
                }
                textelement(salesline_size)
                {
                    XmlName = 'size';
                }
                textelement(salesline_fit)
                {
                    XmlName = 'fit';
                }
                fieldelement(qtyOrdered; SalesLine.Quantity)
                {
                }
                fieldelement(qtyShipped; SalesLine."Quantity Shipped")
                {
                }
                fieldelement(qtyToShip; SalesLine."Qty. to Ship")
                {
                }
                fieldelement(total; SalesLine.Amount)
                {
                }
                fieldelement(commentLines; SalesLine."PDC Comment Lines")
                {
                }
                fieldelement(shippingDate; SalesLine."Shipment Date")
                {
                }
                textelement(salesline_returncomment)
                {
                    XmlName = 'returnComment';

                    trigger OnBeforePassVariable()
                    var
                        SalesCommentLine: Record "Sales Comment Line";
                    begin
                        SalesLine_ReturnComment := '';
                        SalesCommentLine.SetRange("Document Type", SalesLine."Document Type");
                        SalesCommentLine.SetRange("No.", SalesLine."Document No.");
                        SalesCommentLine.SetRange("Document Line No.", SalesLine."Line No.");
                        if SalesCommentLine.FindFirst() then
                            SalesLine_ReturnComment := SalesCommentLine.Comment;
                    end;
                }
                textelement(returnByDate)
                {
                    MinOccurs = Zero;
                }
                fieldelement(returnReason; SalesLine."PDC Order Reason Code")
                {
                }
                fieldelement(reason; SalesLine."PDC Order Reason")
                {
                    MinOccurs = Zero;
                }
                fieldelement(itemNo; SalesLine."No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(productCode; SalesLine."PDC Product Code")
                {
                    MinOccurs = Zero;
                }


                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    PortalsMgt: Codeunit "PDC Portals Management";
                    RetDate: Date;
                begin
                    if SalesLine.Type <> SalesLine.Type::Item then exit;

                    Item.Get(SalesLine."No.");
                    RetDate := CalcDate('+' + Format(Item."PDC Return Period") + 'D', SalesLine."Shipment Date");
                    returnByDate := PortalsMgt.FormatDate(RetDate);

                    SalesLine_Colour := Item."PDC Colour";
                    SalesLine_Fit := Item."PDC Fit";
                    SalesLine_Size := Item."PDC Size";
                end;
            }
            tableelement(reasoncode; "Reason Code")
            {
                MinOccurs = Zero;
                XmlName = 'reasonCode';
                UseTemporary = true;
                fieldelement(code; ReasonCode.Code)
                {
                }
                fieldelement(description; ReasonCode.Description)
                {
                }
                fieldelement(customerNo; ReasonCode."PDC Customer No.")
                {
                }
                fieldelement(type; ReasonCode."PDC Type")
                {
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        PortalsMgt: Codeunit "PDC Portals Management";
        OnConvertFromInvoice: Boolean;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="OrderHeaderDb">VAR Record "Sales Header".</param>
    /// <param name="OrderNo">Code[20].</param>
    procedure FilterData(var OrderHeaderDb: Record "Sales Header"; OrderNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        OrderLineDb: Record "Sales Line";
        ReasonCodeDb: Record "Reason Code";
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        OrderHeaderDb.Get(OrderHeaderDb."document type"::"Return Order", OrderNo);
        SalesHeader.TransferFields(OrderHeaderDb);
        if SalesInvHeader.Get(SalesHeader."PDC Return From Invoice No.") then
            SalesHeader."Shipment Date" := SalesInvHeader."Shipment Date";
        SalesHeader.Insert();

        OrderLineDb.Reset();
        OrderLineDb.SetRange("Document No.", OrderNo);
        OrderLineDb.SetFilter(Quantity, '>%1', 0);
        if not OrderLineDb.FindSet() then exit;
        repeat
            SalesLine.TransferFields(OrderLineDb);
            salesline."Shipment Date" := SalesHeader."Shipment Date";
            SalesLine.Insert();
        until OrderLineDb.Next() = 0;

        ReasonCodeDb.Reset();
        ReasonCodeDb.SetRange("PDC Type", ReasonCodeDb."PDC Type"::Return);
        ReasonCodeDb.SetRange("PDC Customer No.", OrderHeaderDb."Sell-to Customer No.");

        if not ReasonCodeDb.FindSet() then begin
            ReasonCodeDb.Reset();
            ReasonCodeDb.SetRange("PDC Type", ReasonCodeDb."PDC Type"::Return);
        end;

        if ReasonCodeDb.FindSet() then
            repeat
                ReasonCode.TransferFields(ReasonCodeDb);
                ReasonCode.Insert();
            until ReasonCodeDb.Next() = 0;

        //Carriage - remove to show on creation from invoice
        if OnConvertFromInvoice then begin
            ShippingAgentServices.Reset();
            ShippingAgentServices.SetRange("Shipping Agent Code", OrderHeaderDb."Shipping Agent Code");
            ShippingAgentServices.SetRange(Code, OrderHeaderDb."Shipping Agent Service Code");
            if ShippingAgentServices.FindFirst() then begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, ShippingAgentServices."PDC Carriage Charge Type");
                SalesLine.SetRange("No.", ShippingAgentServices."PDC Carriage Charge No.");
                if SalesLine.FindSet() then SalesLine.DeleteAll(true);
                SalesLine.Reset();
            end;
        end;
    end;

    /// <summary>
    /// GetNoFilter.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetNoFilter(): Code[20]
    begin
        exit(noFilter);
    end;

    /// <summary>
    /// SaveData.
    /// </summary>
    /// <param name="PortalUser">Record "PDC Portal User".</param>
    procedure SaveData(PortalUser: Record "PDC Portal User")
    var
        ReturnOrderHeaderDb: Record "Sales Header";
        ReturnOrderLineDb: Record "Sales Line";
        SalesCommentLineDb: Record "Sales Comment Line";
        ShippingAgentServices: Record "Shipping Agent Services";
        ReasonCode: Record "Reason Code";
        CarriageRefunded: Boolean;
        NextLineNo: Integer;
        tmpPrice: Decimal;
        tmpDisc: Decimal;
    begin
        SalesHeader.Reset();

        if (SalesHeader.FindFirst()) then begin
            ReturnOrderHeaderDb.Get(ReturnOrderHeaderDb."document type"::"Return Order", noFilter);
            ReturnOrderHeaderDb.Validate("Reason Code", SalesHeader."Reason Code");
            ReturnOrderHeaderDb."PDC Drop-Off" := salesheader."PDC Drop-Off";
            if not ReturnOrderHeaderDb."PDC Drop-Off" then begin
                ReturnOrderHeaderDb."Ship-to Code" := SalesHeader."Ship-to Code";
                ReturnOrderHeaderDb."Ship-to Contact" := SalesHeader."Ship-to Contact";
                ReturnOrderHeaderDb."Ship-to Name" := SalesHeader."Ship-to Name";
                ReturnOrderHeaderDb."Ship-to Address" := SalesHeader."Ship-to Address";
                ReturnOrderHeaderDb."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
                ReturnOrderHeaderDb."Ship-to City" := SalesHeader."Ship-to City";
                ReturnOrderHeaderDb."Ship-to County" := SalesHeader."Ship-to County";
                ReturnOrderHeaderDb."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
                ReturnOrderHeaderDb."Ship-to Country/Region Code" := SalesHeader."Ship-to Country/Region Code";
            end
            else
                ReturnOrderHeaderDb."Ship-to Name" := 'Returns Department';
            ReturnOrderHeaderDb."PDC Return Submitted" := true;
            ReturnOrderHeaderDb."PDC Ship-to E-Mail" := PortalUser."E-Mail";
            ReturnOrderHeaderDb."PDC Ship-to Mobile Phone No." := PortalUser."Phone No.";
            evaluate(ReturnOrderHeaderDb."PDC Package Type", packType);
            ReturnOrderHeaderDb."PDC Number Of Packages" := salesheader."PDC Number Of Packages";
            ReturnOrderHeaderDb."PDC Collection Reference" := salesheader."PDC Collection Reference";
            ReturnOrderHeaderDb."PDC Drop-Off Email" := SalesHeader."PDC Drop-Off Email";
            ReturnOrderHeaderDb."PDC Drop-Off Location" := SalesHeader."PDC Drop-Off Location";
            ReturnOrderHeaderDb.Modify(true);
        end;

        SalesLine.Reset();

        if SalesLine.FindSet() then
            repeat
                ReturnOrderLineDb.Init();

                if ReturnOrderLineDb.Get(ReturnOrderHeaderDb."Document Type", ReturnOrderHeaderDb."No.", SalesLine."Line No.") then begin
                    tmpPrice := ReturnOrderLineDb."Unit Price";
                    tmpDisc := ReturnOrderLineDb."Line Discount %";
                    ReturnOrderLineDb.Validate(Quantity, SalesLine.Quantity);
                    ReturnOrderLineDb.Validate("Quantity Shipped", 0);
                    ReturnOrderLineDb.Validate("Qty. to Ship", 0);
                    ReturnOrderLineDb.Validate("Unit Price", tmpPrice);
                    ReturnOrderLineDb.Validate("Line Discount %", tmpDisc);
                    ReturnOrderLineDb.Validate("PDC Order Reason Code", SalesLine."PDC Order Reason Code");
                    ReturnOrderLineDb."PDC Created By ID" := PortalUser."Contact No.";
                    ReturnOrderLineDb."PDC Created By Name" := PortalUser.Name;
                    ReturnOrderLineDb.Validate("Return Qty. to Receive", ReturnOrderLineDb.Quantity);
                    ReturnOrderLineDb."PDC Ordered By ID" := PortalUser."Contact No.";
                    ReturnOrderLineDb."PDC Ordered By Name" := PortalUser.Name;
                    ReturnOrderLineDb.Modify(true);
                    SalesCommentLineDb.Init();
                    SalesCommentLineDb.SetRange("Document Type", SalesCommentLineDb."document type"::"Return Order");
                    SalesCommentLineDb.SetRange("No.", ReturnOrderHeaderDb."No.");
                    SalesCommentLineDb.SetRange("Document Line No.", ReturnOrderLineDb."Line No.");

                    if SalesCommentLineDb.FindLast() then
                        NextLineNo := SalesCommentLineDb."Line No." + 10000
                    else
                        NextLineNo := 10000;

                    if (SalesLine.Description <> '') then begin
                        SalesCommentLineDb.Validate("Document Type", ReturnOrderHeaderDb."document type"::"Return Order");
                        SalesCommentLineDb.Validate("No.", ReturnOrderHeaderDb."No.");
                        SalesCommentLineDb.Validate("Line No.", NextLineNo);
                        SalesCommentLineDb.Validate(Date, Today);
                        SalesCommentLineDb.Validate("Document Line No.", SalesLine."Line No.");
                        SalesCommentLineDb.Validate(Comment, SalesLine.Description);
                        SalesCommentLineDb.Insert(true);
                    end;
                end;
            until SalesLine.next() = 0;

        // Now delete lines with no quantity.
        ReturnOrderLineDb.Reset();
        ReturnOrderLineDb.SetRange("Document Type", ReturnOrderHeaderDb."Document Type");
        ReturnOrderLineDb.SetRange("Document No.", ReturnOrderHeaderDb."No.");
        ReturnOrderLineDb.SetRange(Quantity, 0);
        ReturnOrderLineDb.SetFilter(Type, '%1|%2', ReturnOrderLineDb.Type::" ", ReturnOrderLineDb.Type::Item);

        if ReturnOrderLineDb.FindSet() then ReturnOrderLineDb.DeleteAll(true);

        CarriageRefunded := false;
        ReturnOrderLineDb.Reset();
        ReturnOrderLineDb.SetRange("Document Type", ReturnOrderHeaderDb."Document Type");
        ReturnOrderLineDb.SetRange("Document No.", ReturnOrderHeaderDb."No.");
        ReturnOrderLineDb.SetRange(Type, ReturnOrderLineDb.Type::Item);
        ReturnOrderLineDb.SetFilter("No.", '<>%1', '');
        ReturnOrderLineDb.SetFilter(Quantity, '<>%1', 0);
        if ReturnOrderLineDb.Findset() then
            repeat
                if ReasonCode.Get(ReturnOrderLineDb."PDC Order Reason Code") then
                    CarriageRefunded := ReasonCode."PDC Return Carriage Refunded";
            until (ReturnOrderLineDb.next() = 0) or (CarriageRefunded = true);

        ShippingAgentServices.Reset();
        ShippingAgentServices.SetRange("Shipping Agent Code", ReturnOrderHeaderDb."Shipping Agent Code");
        ShippingAgentServices.SetRange(Code, ReturnOrderHeaderDb."Shipping Agent Service Code");
        if ShippingAgentServices.FindFirst() then begin
            ReturnOrderLineDb.Reset();
            ReturnOrderLineDb.SetRange("Document Type", ReturnOrderHeaderDb."Document Type");
            ReturnOrderLineDb.SetRange("Document No.", ReturnOrderHeaderDb."No.");
            ReturnOrderLineDb.SetRange(Type, ShippingAgentServices."PDC Carriage Charge Type");
            ReturnOrderLineDb.SetRange("No.", ShippingAgentServices."PDC Carriage Charge No.");
            if ReturnOrderLineDb.FindSet() then
                if not CarriageRefunded then
                    ReturnOrderLineDb.DeleteAll(true)
                else
                    repeat
                        ReturnOrderLineDb.Validate(Quantity, 1);
                        ReturnOrderLineDb.Validate("Return Qty. to Receive", 1);
                        ReturnOrderLineDb.Modify();
                    until ReturnOrderLineDb.next() = 0;
        end;

        SendReturnConfirmEmail(ReturnOrderHeaderDb);
    end;

    /// <summary>
    /// SetOnConvertFromInvoice.
    /// </summary>
    procedure SetOnConvertFromInvoice()
    begin
        OnConvertFromInvoice := true;
    end;

    /// <summary>
    /// SendReturnConfirmEmail.
    /// </summary>
    /// <param name="SalesHeader1">Record "Sales Header".</param>
    procedure SendReturnConfirmEmail(SalesHeader1: Record "Sales Header")
    var
        ReturnConfSendEmail: Report "PDC Portal - Return Confirm";
    begin
        SalesHeader1.SetRecfilter();
        ReturnConfSendEmail.SetTableview(SalesHeader1);
        ReturnConfSendEmail.UseRequestPage(false);
        ReturnConfSendEmail.Run();
    end;
}

