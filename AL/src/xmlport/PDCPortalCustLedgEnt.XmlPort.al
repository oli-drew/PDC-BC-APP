/// <summary>
/// XmlPort PDC Portal Cust. Ledg. Ent. (ID 50054).
/// </summary>
XmlPort 50054 "PDC Portal Cust. Ledg. Ent."
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
                textelement(f_docnofilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'documentNoFilter';
                }
                textelement(f_doctypefilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'documentTypeFilter';
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
            tableelement(entry; "Cust. Ledger Entry")
            {
                MinOccurs = Zero;
                XmlName = 'entry';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(entryNo; Entry."Entry No.")
                {
                }
                fieldelement(documentType; Entry."Document Type")
                {
                }
                textelement(entry_documenttypetext)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'documentTypeText';

                    trigger OnBeforePassVariable()
                    begin
                        Entry_DocumentTypeText := Format(Entry."Document Type");
                    end;
                }
                fieldelement(documentNo; Entry."Document No.")
                {
                }
                textelement(entry_postingdate)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'postingDate';

                    trigger OnBeforePassVariable()
                    begin
                        Entry_PostingDate := PortalsMgt.FormatDate(Entry."Posting Date");
                    end;
                }
                textelement(entry_duedate)
                {
                    XmlName = 'dueDate';

                    trigger OnBeforePassVariable()
                    begin
                        Entry_DueDate := PortalsMgt.FormatDate(Entry."Due Date");
                    end;
                }
                textelement(entry_duedateoverdue)
                {
                    XmlName = 'dueDateOverdue';

                    trigger OnBeforePassVariable()
                    begin
                        Entry_DueDateOverdue := Format(Entry."Due Date");

                        if (Entry_DueDateOverdue < Format(Today)) then
                            Entry_DueDateOverdue := '0'
                        else
                            Entry_DueDateOverdue := '1';
                    end;
                }
                fieldelement(amount; Entry.Amount)
                {
                }
                fieldelement(currencyCode; Entry."Currency Code")
                {
                }
                fieldelement(amountLCY; Entry."Amount (LCY)")
                {
                }
                fieldelement(amountRemaining; Entry."Remaining Amount")
                {
                }
                fieldelement(description; Entry.Description)
                {
                }
                textelement(entry_recordcount)
                {
                    XmlName = 'recordCount';

                    trigger OnBeforePassVariable()
                    begin
                        Entry_recordCount := '0';
                    end;
                }
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
    /// <param name="CustLedgEntryDb">VAR Record "Cust. Ledger Entry".</param>
    procedure FilterData(var CustLedgEntryDb: Record "Cust. Ledger Entry")
    var
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        CustLedgEntryDb.SetFilter("Document Type", '%1|%2', CustLedgEntryDb."document type"::Invoice, CustLedgEntryDb."document type"::"Credit Memo");

        //init paging
        Paging.SetRecords(CustLedgEntryDb.Count);

        //load records
        Entry.Reset();
        if (CustLedgEntryDb.FindSet()) then begin
            ProcessData := true;
            if (Paging."Records to Skip" > 0) then begin
                SkippedRecords := CustLedgEntryDb.Next(Paging."Records to Skip");
                ProcessData := (SkippedRecords = Paging."Records to Skip");
            end;
            if (ProcessData) then begin
                RecordsToRead := Paging."Page Size";
                repeat
                    Entry.TransferFields(CustLedgEntryDb);
                    Entry.Insert();
                    RecordsToRead -= 1;
                until ((CustLedgEntryDb.Next() = 0) or (RecordsToRead <= 0));
            end;
        end;
    end;
}

