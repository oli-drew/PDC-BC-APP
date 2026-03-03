/// <summary>
/// XmlPort PDC Portal Posted Inv. List (ID 50053).
/// </summary>
XmlPort 50053 "PDC Portal Posted Inv. List"
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
            tableelement(ledgerentry; "Cust. Ledger Entry")
            {
                MinOccurs = Zero;
                XmlName = 'invoice';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; LedgerEntry."Document No.")
                {
                }
                textelement(invoiceheader_postingdate)
                {
                    XmlName = 'postingDate';

                    trigger OnBeforePassVariable()
                    begin
                        InvoiceHeader_PostingDate := PortalsMgt.FormatDate(LedgerEntry."Posting Date");
                    end;
                }
                textelement(invoiceheader_duedate)
                {
                    XmlName = 'dueDate';

                    trigger OnBeforePassVariable()
                    begin
                        InvoiceHeader_DueDate := PortalsMgt.FormatDate(LedgerEntry."Due Date");
                    end;
                }
                fieldelement(amount; LedgerEntry.Amount)
                {
                }
                fieldelement(currencyCode; LedgerEntry."Currency Code")
                {
                }
                textelement(invoiceheader_documentdate)
                {
                    XmlName = 'documentDate';

                    trigger OnBeforePassVariable()
                    begin
                        InvoiceHeader_DocumentDate := PortalsMgt.FormatDate(LedgerEntry."Document Date");
                    end;
                }
                textelement(invoiceheader_duedateoverdue)
                {
                    XmlName = 'dueDateOverdue';

                    trigger OnBeforePassVariable()
                    begin
                        InvoiceHeader_DueDateOverdue := Format(
                          (LedgerEntry."Due Date" <> 0D) and (LedgerEntry."Due Date" < Today), 0, 9);
                    end;
                }
                fieldelement(origamount; LedgerEntry."Amount (LCY)")
                {
                }
                fieldelement(remainingAmount; LedgerEntry."Remaining Amt. (LCY)")
                {
                }
                textelement(postingdatexml)
                {
                    MinOccurs = Zero;
                    XmlName = 'postingDateXML';

                    trigger OnBeforePassVariable()
                    begin
                        postingDateXML := Format(LedgerEntry."Posting Date", 0, 9);
                    end;
                }
                textelement(orderno)
                {
                    MinOccurs = Zero;
                    XmlName = 'orderNo';
                }
                textelement(externaldocumentno)
                {
                    MinOccurs = Zero;
                    XmlName = 'externalDocumentNo';
                }
                textelement(yourreference)
                {
                    MinOccurs = Zero;
                    XmlName = 'yourReference';
                }
                trigger OnAfterGetRecord()
                begin
                    if SalesInvoiceHeader.Get(ledgerentry."Document No.") then begin
                        orderno := SalesInvoiceHeader."Order No.";
                        externaldocumentno := SalesInvoiceHeader."External Document No.";
                        yourreference := SalesInvoiceHeader."Your Reference";
                    end;

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
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
    /// <param name="LedgerEntryDb">VAR Record "Cust. Ledger Entry".</param>
    /// <param name="PortalUser">Record "PDC Portal User".</param>
    procedure FilterData(var LedgerEntryDb: Record "Cust. Ledger Entry"; PortalUser: Record "PDC Portal User")
    var
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        //apply filters
        if PortalUser."Customer No." = '' then exit;

        if searchTerm <> '' then begin
            LedgerEntryDb.FilterGroup(-1);
            LedgerEntryDb.SetFilter(Description, '@*' + searchTerm + '*');
            LedgerEntryDb.SetFilter("Customer Name", '@*' + searchTerm + '*');
            LedgerEntryDb.SetFilter("Your Reference", '@*' + searchTerm + '*');
            LedgerEntryDb.SetFilter("Message to Recipient", '@*' + searchTerm + '*');
            LedgerEntryDb.SetFilter("Document No.", '@*' + searchTerm + '*');
            LedgerEntryDb.FilterGroup(0);
        end;

        //load records
        LedgerEntry.Reset();
        LedgerEntry.DeleteAll();

        if not Paging.FindSet() then begin
            if (LedgerEntryDb.FindSet()) then
                repeat
                    LedgerEntry.TransferFields(LedgerEntryDb);
                    LedgerEntry.Insert();
                until LedgerEntryDb.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(LedgerEntryDb.Count);

            if (LedgerEntryDb.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := LedgerEntryDb.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        LedgerEntry.TransferFields(LedgerEntryDb);
                        LedgerEntry.Insert();
                        RecordsToRead -= 1;
                    until ((LedgerEntryDb.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;
    end;
}

