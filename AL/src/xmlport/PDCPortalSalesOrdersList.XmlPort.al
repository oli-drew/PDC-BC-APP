/// <summary>
/// XmlPort PDC Portal Sales Orders List (ID 50060).
/// </summary>
XmlPort 50060 "PDC Portal Sales Orders List"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
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
                textelement(branchFilter)
                {
                }
                textelement(searchTerm)
                {
                    MinOccurs = Zero;
                }
            }
            tableelement(paging; "PDC Portal List Paging")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'paging';
                UseTemporary = true;
                fieldelement(pageIndex; Paging."Page Index")
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                fieldelement(noOfPages; Paging."No of Pages")
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                fieldelement(noOfRecords; Paging."No of Records")
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
            }
            tableelement(orderline; "Sales Line")
            {
                MinOccurs = Zero;
                XmlName = 'invoice';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; OrderLine."Document No.")
                {
                }
                textelement(orderheader_postingdate)
                {
                    XmlName = 'postingDate';

                    trigger OnBeforePassVariable()
                    begin
                        OrderHeader_PostingDate := PortalsMgt.FormatDate(OrderHeader."Posting Date");
                    end;
                }
                textelement(orderheader_duedate)
                {
                    XmlName = 'dueDate';

                    trigger OnBeforePassVariable()
                    begin
                        OrderHeader_DueDate := PortalsMgt.FormatDate(OrderHeader."Due Date");
                    end;
                }
                textelement(orderheader_shipmentdate)
                {
                    XmlName = 'shipmentDate';

                    trigger OnBeforePassVariable()
                    begin
                        OrderHeader_ShipmentDate := PortalsMgt.FormatDate(OrderHeader."Shipment Date");
                    end;
                }
                textelement(orderheader_amount)
                {
                    XmlName = 'amount';
                }
                textelement(orderheader_amountvat)
                {
                    XmlName = 'amountInclVat';
                }
                textelement(orderheader_currcode)
                {
                    XmlName = 'currencyCode';
                }
                textelement(orderheader_documentdate)
                {
                    XmlName = 'documentDate';

                    trigger OnBeforePassVariable()
                    begin
                        OrderHeader_DocumentDate := PortalsMgt.FormatDate(OrderHeader."Document Date");
                    end;
                }
                textelement(orderheader_duedateoverdue)
                {
                    XmlName = 'dueDateOverdue';

                    trigger OnBeforePassVariable()
                    begin
                        OrderHeader_DueDateOverdue := Format(
                          (OrderHeader."Due Date" <> 0D) and (OrderHeader."Due Date" < Today), 0, 9);
                    end;
                }
                textelement(orderheader_status)
                {
                    XmlName = 'status';
                }
                textelement(orderheader_reference)
                {
                    XmlName = 'yourReference';
                }
                textelement(orderDate)
                {
                }
                textelement(reference)
                {
                }
                textelement(wearerId)
                {
                }
                textelement(wearerName)
                {
                }
                textelement(orderedId)
                {
                }
                textelement(orderedName)
                {
                }
                textelement(orderheader_shiptopostcode)
                {
                    XmlName = 'postCode';
                }
                textelement(createdId)
                {
                }
                textelement(createdName)
                {
                }
                textelement(requestedDeliveryDate)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        requestedDeliveryDate := PortalsMgt.FormatDate(OrderHeader."Requested Delivery Date");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    OrderHeader.Get(OrderLine."Document Type", OrderLine."Document No.");

                    orderDate := PortalsMgt.FormatDate(OrderHeader."Order Date");

                    OrderHeader.CalcFields(Amount, "Amount Including VAT");
                    OrderHeader_Amount := Format(OrderHeader.Amount, 0, 9);
                    OrderHeader_AmountVAT := Format(OrderHeader."Amount Including VAT", 0, 9);
                    OrderHeader_CurrCode := OrderHeader."Currency Code";
                    OrderHeader_Status := Format(OrderHeader.Status);
                    OrderHeader_Reference := OrderHeader."Your Reference";
                    OrderHeader_ShipToPostCode := OrderHeader."Ship-to Post Code";

                    reference := OrderLine."PDC Customer Reference";
                    wearerId := OrderLine."PDC Wearer ID";
                    wearerName := OrderLine."PDC Wearer Name";
                    orderedId := OrderLine."PDC Ordered By ID";
                    orderedName := OrderLine."PDC Ordered By Name";

                    createdId := OrderLine."PDC Created By ID";
                    createdName := OrderLine."PDC Created By Name";
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        OrderHeader: Record "Sales Header";
        PortalsMgt: Codeunit "PDC Portals Management";

    /// <summary>
    /// InitData.
    /// </summary>
    procedure InitData()
    begin
        Paging.Reset();
        Paging.DeleteAll();
    end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="OrderHeaderDb">VAR Record "Sales Header".</param>
    procedure FilterData(var OrderHeaderDb: Record "Sales Header")
    var
        SalesLine1: Record "Sales Line";
        TempSalesLineBuffer: Record "Sales Line" temporary;
        recRef: RecordRef;
        toInsert: Boolean;
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        TempSalesLineBuffer.Reset();
        TempSalesLineBuffer.DeleteAll();
        if (OrderHeaderDb.FindSet()) then
            repeat
                SalesLine1.Reset();
                SalesLine1.SetRange("Document Type", OrderHeaderDb."Document Type");
                SalesLine1.SetRange("Document No.", OrderHeaderDb."No.");
                SalesLine1.SetRange(Type, SalesLine1.Type::Item);
                SalesLine1.SetFilter(Quantity, '<>%1', 0);
                if not SalesLine1.FindFirst() then
                    SalesLine1.SetRange(Type);
                SalesLine1.SetAutoCalcFields("PDC Ship-to Post Code");
                if SalesLine1.FindSet() then
                    repeat
                        toInsert := false;
                        if searchTerm = '' then
                            toInsert := true
                        else begin
                            recRef.GetTable(SalesLine1);
                            if Format(recRef).ToLower().Contains(searchTerm.ToLower()) then
                                toInsert := true;
                        end;
                        if toInsert then begin
                            TempSalesLineBuffer.SetRange("Document Type", SalesLine1."Document Type");
                            TempSalesLineBuffer.SetRange("Document No.", SalesLine1."Document No.");
                            TempSalesLineBuffer.SetRange("PDC Wearer ID", SalesLine1."PDC Wearer ID");
                            if not TempSalesLineBuffer.FindFirst() then begin
                                TempSalesLineBuffer.Init();
                                TempSalesLineBuffer := SalesLine1;
                                TempSalesLineBuffer.Insert();
                            end;
                        end;
                    until SalesLine1.next() = 0;
            until OrderHeaderDb.next() = 0;
        TempSalesLineBuffer.Reset();

        TempSalesLineBuffer.Ascending(false);

        //load records
        OrderLine.Reset();
        OrderLine.DeleteAll();

        if not Paging.FindSet() then begin
            if (TempSalesLineBuffer.FindSet()) then
                repeat
                    OrderLine.TransferFields(TempSalesLineBuffer);
                    OrderLine.Insert();
                until TempSalesLineBuffer.Next() = 0;
        end else begin
            Paging.SetRecords(TempSalesLineBuffer.Count);

            if (TempSalesLineBuffer.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := TempSalesLineBuffer.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        OrderLine.TransferFields(TempSalesLineBuffer);
                        OrderLine.Insert();
                        RecordsToRead -= 1;
                    until ((TempSalesLineBuffer.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;

        OrderLine.Ascending(false);
    end;

    /// <summary>
    /// GetBranchFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetBranchFilter(): Text
    begin
        exit(branchFilter);
    end;
}

