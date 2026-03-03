/// <summary>
/// XmlPort Cust. Portal Comp Return List (ID 50022).
/// </summary>
XmlPort 50022 "PDC Portal Comp Return List"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(noFilter)
                {
                    MinOccurs = Zero;
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
            tableelement(returnreceiptheader; "Return Receipt Header")
            {
                MinOccurs = Zero;
                XmlName = 'completedOrder';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; ReturnReceiptHeader."No.")
                {
                }
                fieldelement(status; ReturnReceiptHeader."Reason Code")
                {
                }
                fieldelement(branchNo; ReturnReceiptHeader."PDC Customer Reference")
                {
                }
                textelement(returnreceiptheader_branchname)
                {
                    XmlName = 'branchName';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();
                        Branch.SetRange("Customer No.", ReturnReceiptHeader."Sell-to Customer No.");
                        Branch.SetRange("Branch No.", ReturnReceiptHeader."PDC Branch No.");

                        if not Branch.FindFirst() then exit;

                        ReturnReceiptHeader_BranchName := Branch.Name;
                    end;
                }
                fieldelement(returnFromInvoice; ReturnReceiptHeader."PDC Return From Invoice No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(returnRef; ReturnReceiptHeader."PDC Collection Reference")
                {
                    MinOccurs = Zero;
                }
                fieldelement(collectionContact; ReturnReceiptHeader."Ship-to Contact")
                {
                    MinOccurs = Zero;
                }
                fieldelement(postCode; ReturnReceiptHeader."Sell-to Post Code")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    Line: Record "Return Receipt Line";
                begin
                    ReturnReceiptHeader."PDC Branch No." := '';
                    Line.Reset();
                    Line.SetRange("Document No.", ReturnReceiptHeader."No.");
                    Line.SetRange(Type, Line.Type::Item);
                    Line.SetFilter("No.", '<>%1', '');
                    if Line.Findset() then
                        repeat
                            ReturnReceiptHeader."PDC Branch No." := Line."PDC Branch No.";
                        until (Line.next() = 0) or (ReturnReceiptHeader."PDC Branch No." <> '');
                end;
            }
        }
    }

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="ReturnReceiptHeaderDb">VAR Record "Return Receipt Header".</param>
    procedure FilterData(var ReturnReceiptHeaderDb: Record "Return Receipt Header")
    var
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        //load records
        ReturnReceiptHeader.Reset();
        ReturnReceiptHeader.DeleteAll();

        ReturnReceiptHeader.Ascending(false);

        if searchTerm <> '' then begin
            ReturnReceiptHeaderDb.FilterGroup(-1);
            ReturnReceiptHeaderDb.SetFilter("Bill-to Name", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Bill-to Name 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Bill-to Address", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Bill-to Address 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Bill-to City", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Bill-to Contact", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Your Reference", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to Name", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to Name 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to Address", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to Address 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to City", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to Contact", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Posting Description", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("VAT Registration No.", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to Customer Name", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to Customer Name 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to Address", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to Address 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to City", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to Contact", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Bill-to County", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to County", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Ship-to County", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Employee Name", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Customer Reference", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC External Name", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter(PDCPLSNO, '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Notes", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC CCM Notes", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC E-Mail 1", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC E-Mail 2", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC E-Mail 3", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC E-Mail 4", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Collection Reference", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Drop-Off Email", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Drop-Off Location", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC WebOrder No.", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("PDC Return From Invoice No.", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("Sell-to Post Code", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.SetFilter("No.", '@*' + searchTerm + '*');
            ReturnReceiptHeaderDb.FilterGroup(0);
        end;

        if not Paging.FindSet() then begin
            if (ReturnReceiptHeaderDb.FindSet()) then
                repeat
                    ReturnReceiptHeader.TransferFields(ReturnReceiptHeaderDb);
                    ReturnReceiptHeader.Insert();
                until ReturnReceiptHeaderDb.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(ReturnReceiptHeaderDb.Count);

            if (ReturnReceiptHeaderDb.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := ReturnReceiptHeaderDb.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        ReturnReceiptHeader.TransferFields(ReturnReceiptHeaderDb);
                        ReturnReceiptHeader.Insert();
                        RecordsToRead -= 1;
                    until ((ReturnReceiptHeaderDb.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;
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

