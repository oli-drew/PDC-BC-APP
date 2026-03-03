/// <summary>
/// XmlPort PDC Portal Open Ledgers (ID 50059).
/// </summary>
XmlPort 50059 "PDC Portal Open Ledgers"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
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
                    MinOccurs = Zero;
                }
                fieldelement(noOfPages; Paging."No of Pages")
                {
                    MinOccurs = Zero;
                }
                fieldelement(noOfRecords; Paging."No of Records")
                {
                    MinOccurs = Zero;
                }
            }
            tableelement(custledgerentry; "Cust. Ledger Entry")
            {
                MinOccurs = Zero;
                XmlName = 'ledger';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                textelement(postingdate)
                {
                    XmlName = 'postingDate';
                }
                fieldelement(documentType; CustLedgerEntry."Document Type")
                {
                }
                fieldelement(documentNo; CustLedgerEntry."Document No.")
                {
                }
                fieldelement(description; CustLedgerEntry.Description)
                {
                }
                fieldelement(originalAmount; CustLedgerEntry."Original Amt. (LCY)")
                {
                }
                fieldelement(amount; CustLedgerEntry."Amount (LCY)")
                {
                }
                fieldelement(remainingAmount; CustLedgerEntry."Remaining Amt. (LCY)")
                {
                }
                textelement(duedate)
                {
                    XmlName = 'dueDate';
                }
                textelement(overdue)
                {
                    XmlName = 'overdue';

                    trigger OnBeforePassVariable()
                    begin
                        if (CustLedgerEntry."Due Date" < Today) then
                            overdue := 'True'
                        else
                            overdue := 'False';
                    end;
                }
                textelement(doctype)
                {
                    XmlName = 'doctype';
                }
                textelement(postingdatexml)
                {
                    MinOccurs = Zero;
                    XmlName = 'postingDateXML';
                }

                trigger OnAfterGetRecord()
                begin
                    postingDate := Format(CustLedgerEntry."Posting Date", 0, '<Day,2>/<Month,2>/<Year>');
                    dueDate := Format(CustLedgerEntry."Due Date", 0, '<Day,2>/<Month,2>/<Year>');
                    doctype := Format(CustLedgerEntry."Document Type".AsInteger());
                    postingDateXML := Format(CustLedgerEntry."Posting Date", 0, 9);
                end;
            }
            textelement(balancedue)
            {
                MinOccurs = Zero;
                XmlName = 'balanceDue';
            }
            textelement(balance)
            {
                MinOccurs = Zero;
                XmlName = 'balance';
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">Record "PDC Portal User".</param>
    procedure FilterData(PortalUser: Record "PDC Portal User")
    var
        custLedgerEntryDb: Record "Cust. Ledger Entry";
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
        theBalance: Decimal;
        theDueBalance: Decimal;
    begin
        custLedgerEntryDb.Reset();
        custLedgerEntryDb.SetRange(Open, true);
        custLedgerEntryDb.SetRange("Customer No.", PortalUser."Customer No.");

        if searchTerm <> '' then begin
            custLedgerEntryDb.FilterGroup(-1);
            custLedgerEntryDb.SetFilter(Description, '@*' + searchTerm + '*');
            custLedgerEntryDb.SetFilter("Customer Name", '@*' + searchTerm + '*');
            custLedgerEntryDb.SetFilter("Your Reference", '@*' + searchTerm + '*');
            custLedgerEntryDb.SetFilter("Message to Recipient", '@*' + searchTerm + '*');
            custLedgerEntryDb.FilterGroup(0);
        end;

        if Paging.FindSet() then Paging.SetRecords(custLedgerEntryDb.Count);

        if (custLedgerEntryDb.FindSet()) then begin
            if not Paging.FindSet() then
                repeat
                    CustLedgerEntry.TransferFields(custLedgerEntryDb);
                    CustLedgerEntry.Insert();
                until custLedgerEntryDb.Next() = 0
            else begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := custLedgerEntryDb.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        CustLedgerEntry.TransferFields(custLedgerEntryDb);
                        CustLedgerEntry.Insert();
                        RecordsToRead -= 1;
                    until ((custLedgerEntryDb.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;

            custLedgerEntryDb.FindFirst();

            theBalance := 0;
            theDueBalance := 0;

            repeat
                custLedgerEntryDb.CalcFields("Remaining Amt. (LCY)");
                theBalance := theBalance + custLedgerEntryDb."Remaining Amt. (LCY)";

                if custLedgerEntryDb."Due Date" < Today then
                    theDueBalance := theDueBalance + custLedgerEntryDb."Remaining Amt. (LCY)";
            until custLedgerEntryDb.Next() = 0;

            balance := Format(theBalance * -1, 0, '<Precision,2:2><Standard Format,2>');
            balanceDue := Format(theDueBalance, 0, '<Precision,2:2><Standard Format,2>');
        end;

    end;

    /// <summary>
    /// InitData.
    /// </summary>
    procedure InitData()
    begin
        Paging.Reset();
        Paging.DeleteAll();
    end;
}

