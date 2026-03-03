/// <summary>
/// xmlport PDC Portal Compl. Order List (ID 50030).
/// </summary>
xmlport 50030 "PDC Portal Compl. Order List"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

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
            tableelement(line; "Sales Invoice Line")
            {
                MinOccurs = Zero;
                XmlName = 'invoice';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; Line."Document No.")
                {
                }
                textelement(invoiceheader_postingdate)
                {
                    XmlName = 'postingDate';
                }
                textelement(invoiceheader_duedate)
                {
                    XmlName = 'dueDate';
                }
                textelement(invoiceheader_amount)
                {
                    XmlName = 'amount';
                }
                textelement(invoiceheader_currcode)
                {
                    XmlName = 'currencyCode';
                }
                textelement(invoiceheader_documentdate)
                {
                    XmlName = 'documentDate';
                }
                textelement(invoiceheader_duedateoverdue)
                {
                    XmlName = 'dueDateOverdue';
                }
                fieldelement(reference; Line."PDC Customer Reference")
                {
                }
                fieldelement(wearerId; Line."PDC Wearer ID")
                {
                }
                fieldelement(wearerName; Line."PDC Wearer Name")
                {
                }
                fieldelement(orderedId; Line."PDC Ordered By ID")
                {
                }
                fieldelement(orderedName; Line."PDC Ordered By Name")
                {
                }
                textelement(invoiceheader_shippostcode)
                {
                    XmlName = 'postCode';
                }
                textelement(shipmentNo)
                {
                }
                textelement(shipmentDate)
                {
                }
                textelement(allowReturn)
                {
                }
                textelement(consignmentNo)
                {
                    MinOccurs = Zero;
                }
                textelement(deliveryStatus)
                {
                    MinOccurs = Zero;
                }
                textelement(deliveryStatusText)
                {
                    MinOccurs = Zero;
                }
                fieldelement(createdId; Line."PDC Created By ID")
                {
                }
                fieldelement(createdName; Line."PDC Created By Name")
                {
                }
                textelement(shippingAgent)
                {
                }
                textelement(salesOrderNo)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    SalesInvHdr: Record "Sales Invoice Header";
                    TempSalesShptLine: Record "Sales Shipment Line" temporary;
                    CourierShipmentHeader: Record PDCCourierShipmentHeader;
                    ParcelsInfo: Record "PDC Parcels Info";
                begin
                    SalesInvHdr.Get(Line."Document No.");

                    SalesInvHdr.CalcFields(Amount);

                    InvoiceHeader_Amount := Format(SalesInvHdr.Amount, 0, 9);
                    InvoiceHeader_CurrCode := SalesInvHdr."Currency Code";
                    InvoiceHeader_PostingDate := PortalsMgt.FormatDate(SalesInvHdr."Posting Date");
                    InvoiceHeader_DueDate := PortalsMgt.FormatDate(SalesInvHdr."Due Date");
                    InvoiceHeader_DocumentDate := PortalsMgt.FormatDate(SalesInvHdr."Document Date");
                    InvoiceHeader_DueDateOverdue := Format(
                      (SalesInvHdr."Due Date" <> 0D) and (SalesInvHdr."Due Date" < Today), 0, 9);
                    InvoiceHeader_ShipPostCode := SalesInvHdr."Ship-to Post Code";
                    salesOrderNo := SalesInvHdr."Order No.";

                    Clear(shipmentNo);
                    Clear(shipmentDate);

                    Clear(TempSalesShptLine);
                    Line.GetSalesShptLines(TempSalesShptLine);
                    if TempSalesShptLine.FindFirst() then begin
                        shipmentNo := TempSalesShptLine."Document No.";
                        shipmentDate := PortalsMgt.FormatDate(TempSalesShptLine."Shipment Date");
                        CourierShipmentHeader.SetRange(SalesShipmentHeaderNo, TempSalesShptLine."Document No.");
                        if CourierShipmentHeader.FindFirst() then
                            consignmentNo := CourierShipmentHeader.consignmentNumber
                        else
                            consignmentNo := '0';

                        Clear(ParcelsInfo);
                        if consignmentNo <> '0' then begin
                            ParcelsInfo.SetRange(ConsignmentNumber, consignmentNo);
                            if ParcelsInfo.FindFirst() then;
                        end;
                        deliveryStatus := Format(ParcelsInfo.Status);
                        if (ParcelsInfo.Status = ParcelsInfo.Status::Returned) and (ParcelsInfo."Return Status" <> ParcelsInfo."Return Status"::" ") then
                            deliveryStatusText := format(ParcelsInfo."Return Status")
                        else
                            if ParcelsInfo.Status = ParcelsInfo.Status::Exception then
                                deliveryStatusText := ParcelsInfo.ErrorText
                            else
                                deliveryStatusText := ParcelsInfo.StatusDescription;
                    end;
                    shippingAgent := SalesInvHdr."Shipping Agent Code";
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        PortalsMgt: Codeunit "PDC Portals Management";


    /// <summary>
    /// procedure InitData init variables.
    /// </summary>
    procedure InitData()
    begin
        Paging.Reset();
        Paging.DeleteAll();
    end;

    /// <summary>
    /// procedure FilterData used for setting record filters.
    /// </summary>
    /// <param name="LedgerEntryDb">VAR Record "Cust. Ledger Entry".</param>
    /// <param name="PortalUser">Record "PDC Portal User".</param>
    procedure FilterData(var LedgerEntryDb: Record "Cust. Ledger Entry"; PortalUser: Record "PDC Portal User")
    var
        PortalRole: Record "PDC Portal Role";
        Line1: Record "Sales Invoice Line";
        TempLineBuffer: Record "Sales Invoice Line" temporary;
        NavPortalMgt: Codeunit "PDC Portals Management";
        recRef: RecordRef;
        toInsert: Boolean;
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        //apply filters

        if PortalUser."Customer No." = '' then exit;

        NavPortalMgt.GetUserMergedRole(PortalUser, PortalRole);
        if PortalRole.Returns then
            allowReturn := 'True'
        else
            allowReturn := 'False';

        TempLineBuffer.Reset();
        TempLineBuffer.DeleteAll();
        if (LedgerEntryDb.FindSet()) then
            repeat
                Line1.Reset();
                Line1.SetRange("Document No.", LedgerEntryDb."Document No.");
                Line1.SetRange(Type, Line1.Type::Item);
                Line1.SetFilter(Quantity, '<>%1', 0);
                if not Line1.FindFirst() then
                    Line1.SetRange(Type);
                Line1.SetAutoCalcFields("PDC Ship-to Post Code");
                if Line1.FindSet() then
                    repeat
                        toInsert := false;
                        if searchTerm = '' then
                            toInsert := true
                        else begin
                            recRef.GetTable(Line1);
                            if Format(recRef).ToLower().Contains(searchTerm.ToLower()) then
                                toInsert := true;
                        end;
                        if toInsert then begin
                            TempLineBuffer.SetRange("Document No.", Line1."Document No.");
                            TempLineBuffer.SetRange("PDC Wearer ID", Line1."PDC Wearer ID");
                            if not TempLineBuffer.FindFirst() then begin
                                TempLineBuffer.Init();
                                TempLineBuffer := Line1;
                                TempLineBuffer.Insert();
                            end;
                        end;
                    until Line1.next() = 0;
            until LedgerEntryDb.next() = 0;
        TempLineBuffer.Reset();

        TempLineBuffer.Ascending(false);

        //load records
        Line.Reset();
        Line.DeleteAll();

        if not Paging.FindSet() then begin
            if (TempLineBuffer.FindSet()) then
                repeat
                    Line.TransferFields(TempLineBuffer);
                    Line.Insert();
                until TempLineBuffer.Next() = 0;
        end else begin
            Paging.SetRecords(TempLineBuffer.Count);

            if (TempLineBuffer.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := TempLineBuffer.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        Line.TransferFields(TempLineBuffer);
                        Line.Insert();
                        RecordsToRead -= 1;
                    until ((TempLineBuffer.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;

        Line.Ascending(false);
    end;

    /// <summary>
    /// procedure GetBranchFilter return branchFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetBranchFilter(): Text
    begin
        exit(branchFilter);
    end;
}

