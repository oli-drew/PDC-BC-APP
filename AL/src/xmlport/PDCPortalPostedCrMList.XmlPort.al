/// <summary>
/// XmlPort PDC Portal Posted Cr.M. List (ID 50056).
/// </summary>
XmlPort 50056 "PDC Portal Posted Cr.M. List"
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
            tableelement(crmemoheader; "Sales Cr.Memo Header")
            {
                MinOccurs = Zero;
                XmlName = 'crmemo';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(no; CrMemoHeader."No.")
                {
                }
                textelement(crmemoheader_postingdate)
                {
                    XmlName = 'postingDate';

                    trigger OnBeforePassVariable()
                    begin
                        CrMemoHeader_PostingDate := PortalsMgt.FormatDate(CrMemoHeader."Posting Date");
                    end;
                }
                textelement(crmemoheader_shipmentdate)
                {
                    XmlName = 'shipmentDate';

                    trigger OnBeforePassVariable()
                    begin
                        CrMemoHeader_ShipmentDate := PortalsMgt.FormatDate(CrMemoHeader."Shipment Date");
                    end;
                }
                fieldelement(amount; CrMemoHeader.Amount)
                {
                }
                fieldelement(amountInclVat; CrMemoHeader."Amount Including VAT")
                {
                }
                fieldelement(currencyCode; CrMemoHeader."Currency Code")
                {
                }
                fieldelement(yourReference; CrMemoHeader."Your Reference")
                {
                }
                textelement(postingdatexml)
                {
                    MinOccurs = Zero;
                    XmlName = 'postingDateXML';

                    trigger OnBeforePassVariable()
                    begin
                        postingDateXML := Format(CrMemoHeader."Posting Date", 0, 9);
                    end;
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
    /// <param name="CrMemoHeaderDb">VAR Record "Sales Cr.Memo Header".</param>
    procedure FilterData(var CrMemoHeaderDb: Record "Sales Cr.Memo Header")
    var
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        //load records
        CrMemoHeader.Reset();
        CrMemoHeader.DeleteAll();

        if searchTerm <> '' then begin
            CrMemoHeaderDb.FilterGroup(-1);
            CrMemoHeaderDb.SetFilter("Bill-to Name", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Bill-to Name 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Bill-to Address", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Bill-to Address 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Bill-to City", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Bill-to Contact", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Your Reference", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to Name", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to Name 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to Address", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to Address 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to City", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to Contact", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Posting Description", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("VAT Registration No.", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Registration Number", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to Customer Name", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to Customer Name 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to Address", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to Address 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to City", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to Contact", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Bill-to County", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to County", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Ship-to County", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to Phone No.", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Sell-to E-Mail", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Document Exchange Identifier", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("Doc. Exch. Original Identifier", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC Employee Name", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC Customer Reference", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC External Name", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter(PDCPLSNO, '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC Notes", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC CCM Notes", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC E-Mail 1", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC E-Mail 2", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC E-Mail 3", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC E-Mail 4", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("PDC Collection Reference", '@*' + searchTerm + '*');
            CrMemoHeaderDb.SetFilter("No.", '@*' + searchTerm + '*');
            CrMemoHeaderDb.FilterGroup(0);
        end;

        if not Paging.FindSet() then begin
            if (CrMemoHeaderDb.FindSet()) then
                repeat
                    CrMemoHeader.TransferFields(CrMemoHeaderDb);
                    CrMemoHeader.Insert();
                until CrMemoHeaderDb.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(CrMemoHeaderDb.Count);

            if (CrMemoHeaderDb.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := CrMemoHeaderDb.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        CrMemoHeader.TransferFields(CrMemoHeaderDb);
                        CrMemoHeader.Insert();
                        RecordsToRead -= 1;
                    until ((CrMemoHeaderDb.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;
    end;
}

