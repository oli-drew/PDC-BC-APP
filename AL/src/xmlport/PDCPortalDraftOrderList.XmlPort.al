/// <summary>
/// XmlPort PDC Portal Draft Order List (ID 50016).
/// </summary>
xmlport 50016 "PDC Portal Draft Order List"
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
                }
                textelement(branchFilter)
                {
                }
                textelement(Approvals)
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
            tableelement(orderheader; "PDC Draft Order Header")
            {
                MinOccurs = Zero;
                XmlName = 'order';
                UseTemporary = true;

                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; OrderHeader."Document No.")
                {
                }
                fieldelement(poNo; OrderHeader."PO No.")
                {
                }
                fieldelement(status; OrderHeader.Status)
                {
                }
                fieldelement(requestedShipmentDate; OrderHeader."Requested Shipment Date")
                {
                }
                textelement(ordertotal)
                {
                    XmlName = 'orderTotal';
                }
                textelement(orderDate)
                {
                }
                textelement(createdBy)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Clear(createdBy);
                        if Contact.Get(OrderHeader."Created By ID") then
                            createdBy := Contact.Name;
                    end;
                }
                fieldelement(postcode; OrderHeader."Ship-to Post Code")
                {
                }
                fieldelement(awaitingApproval; OrderHeader."Awaiting Approval")
                {
                    MinOccurs = Zero;
                }
                textelement(processing)
                {
                    MinOccurs = Zero;
                }

                tableelement(branches; "PDC Branch")
                {
                    UseTemporary = true;

                    textattribute(jsonarray2)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(branchId; branches."Branch No.")
                    {
                    }
                    fieldelement(branchName; branches.Name)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PDCBranch: Record "PDC Branch";
                    StaffLines: Record "PDC Draft Order Staff Line";
                    PortalsMgt: Codeunit "PDC Portal Mgt";
                    NAVPortalsMgt: Codeunit "PDC Portals Management";
                    tot: Decimal;
                begin
                    tot := PortalsMgt.GetDraftOrderTotal(OrderHeader);
                    orderTotal := Format(tot, 0, 9);

                    orderDate := NAVPortalsMgt.FormatDate(Dt2Date(OrderHeader."Created Date"));
                    orderheader.CalcFields("Proceed Order");
                    processing := Format(orderheader."Proceed Order", 0, 9);

                    branches.DeleteAll();
                    StaffLines.SetAutoCalcFields("Customer No.", "Branch ID");
                    StaffLines.setrange("Document No.", OrderHeader."Document No.");
                    if StaffLines.FindSet() then
                        repeat
                            if PDCBranch.get(StaffLines."Customer No.", StaffLines."Branch ID") then
                                if not branches.Get(PDCBranch."Customer No.", PDCBranch."Branch No.") then begin
                                    branches.Init();
                                    branches := PDCBranch;
                                    branches.Insert();
                                end;
                        until StaffLines.Next() = 0;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        Contact: Record Contact;

    /// <summary>
    /// procedure FilterData set filters before export.
    /// </summary>
    /// <param name="DraftOrderHeaderDb">VAR Record "PDC Draft Order Header".</param>
    procedure FilterData(var DraftOrderHeaderDb: Record "PDC Draft Order Header")
    var
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        OrderHeader.Reset();
        OrderHeader.DeleteAll();

        if Approvals <> '' then DraftOrderHeaderDb.SetFilter("Awaiting Approval", Approvals);

        if searchTerm <> '' then begin
            DraftOrderHeaderDb.FilterGroup(-1);
            DraftOrderHeaderDb.SetFilter("Document No.", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Your Reference", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to Customer Name", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to Customer Name 2", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to Address", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to Address 2", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to City", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to Contact", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Sell-to County", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Name", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Name 2", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Address", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Address 2", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to City", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Contact", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to County", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to E-Mail", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Mobile Phone No.", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("Ship-to Post Code", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.SetFilter("PO No.", '@*' + searchTerm + '*');
            DraftOrderHeaderDb.FilterGroup(0);
        end;

        DraftOrderHeaderDb.Ascending(false);

        if not Paging.FindSet() then begin
            if (DraftOrderHeaderDb.FindSet()) then
                repeat
                    OrderHeader.TransferFields(DraftOrderHeaderDb);
                    OrderHeader.Insert();
                until DraftOrderHeaderDb.Next() = 0;
        end else begin
            Paging.SetRecords(DraftOrderHeaderDb.Count);

            if (DraftOrderHeaderDb.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := DraftOrderHeaderDb.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        OrderHeader.TransferFields(DraftOrderHeaderDb);
                        OrderHeader.Insert();
                        RecordsToRead -= 1;
                    until ((DraftOrderHeaderDb.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;

        OrderHeader.Ascending(false);
    end;

    /// <summary>
    /// procedure GetBranchFilter returns branch filter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetBranchFilter(): Text
    begin
        exit(branchFilter);
    end;
}

