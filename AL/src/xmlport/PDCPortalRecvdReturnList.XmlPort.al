/// <summary>
/// XmlPort PDC Portal Recvd Return List (ID 50015).
/// </summary>
XmlPort 50015 "PDC Portal Recvd Return List"
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
            tableelement(orderheader; "Sales Header")
            {
                MinOccurs = Zero;
                XmlName = 'orderHeader';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; OrderHeader."No.")
                {
                }
                fieldelement(status; OrderHeader.Status)
                {
                }
                fieldelement(branchNo; OrderHeader."PDC Branch No.")
                {
                }
                textelement(orderheader_branchname)
                {
                    XmlName = 'branchName';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();
                        Branch.SetRange("Customer No.", OrderHeader."Sell-to Customer No.");
                        Branch.SetRange("Branch No.", OrderHeader."PDC Branch No.");

                        if not Branch.FindFirst() then exit;

                        OrderHeader_BranchName := Branch.Name;
                    end;
                }
                fieldelement(returnFromInvoice; OrderHeader."PDC Return From Invoice No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(returnRef; OrderHeader."PDC Collection Reference")
                {
                    MinOccurs = Zero;
                }
                fieldelement(collectionContact; OrderHeader."Ship-to Contact")
                {
                    MinOccurs = Zero;
                }
                fieldelement(postCode; OrderHeader."Sell-to Post Code")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                begin
                    OrderHeader."PDC Branch No." := '';
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", OrderHeader."Document Type");
                    SalesLine.SetRange("Document No.", OrderHeader."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("No.", '<>%1', '');
                    if SalesLine.Findset() then
                        repeat
                            OrderHeader."PDC Branch No." := SalesLine."PDC Branch No.";
                        until (SalesLine.next() = 0) or (OrderHeader."PDC Branch No." <> '');
                end;
            }
        }
    }

    var
        SalesLine: Record "Sales Line";

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="OrderHeaderDb">VAR Record "Sales Header".</param>
    procedure FilterData(var OrderHeaderDb: Record "Sales Header")
    var
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        //load records
        OrderHeader.Reset();
        OrderHeader.DeleteAll();

        OrderHeader.Ascending(false);

        if searchTerm <> '' then begin
            OrderHeaderDb.FilterGroup(-1);
            OrderHeaderDb.SetFilter("Bill-to Name", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Bill-to Name 2", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Bill-to Address", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Bill-to Address 2", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Bill-to City", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Bill-to Contact", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Your Reference", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to Name", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to Name 2", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to Address", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to Address 2", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to City", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to Contact", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Posting Description", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Format Region", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("VAT Registration No.", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Registration Number", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Customer Name", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Customer Name 2", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Address", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Address 2", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to City", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Contact", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Bill-to County", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to County", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Ship-to County", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Prepmt. Posting Description", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Phone No.", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to E-Mail", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Employee Name", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Customer Reference", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Notes", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Ship-to E-Mail", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Ship-to Mobile Phone No.", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Delivery Instruction", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Collection Reference", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Drop-Off Email", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Drop-Off Location", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("PDC Return From Invoice No.", '@*' + searchTerm + '*');
            OrderHeaderDb.SetFilter("Sell-to Post Code", '@*' + searchTerm + '*');
            OrderHeaderDb.FilterGroup(0);
        end;

        if not Paging.FindSet() then begin
            if (OrderHeaderDb.FindSet()) then
                repeat
                    OrderHeader.TransferFields(OrderHeaderDb);
                    OrderHeader.Insert();
                until OrderHeaderDb.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(OrderHeaderDb.Count);

            if (OrderHeaderDb.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := OrderHeaderDb.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        OrderHeader.TransferFields(OrderHeaderDb);
                        OrderHeader.Insert();
                        RecordsToRead -= 1;
                    until ((OrderHeaderDb.Next() = 0) or (RecordsToRead <= 0));
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

