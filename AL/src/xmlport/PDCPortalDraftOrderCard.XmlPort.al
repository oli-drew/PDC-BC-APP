/// <summary>
/// xmlport PDC Portal Draft Order Card (ID 50017).
/// </summary>
xmlport 50017 "PDC Portal Draft Order Card"
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
                textelement(stafflineno)
                {
                    MinOccurs = Zero;
                    XmlName = 'staffLineNo';
                }
                textelement(Approvals)
                {
                    MinOccurs = Zero;
                }
            }
            tableelement(draftorderheader; "PDC Draft Order Header")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'order';
                UseTemporary = true;
                fieldelement(no; DraftOrderHeader."Document No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(poNo; DraftOrderHeader."PO No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(status; DraftOrderHeader.Status)
                {
                    MinOccurs = Zero;
                }
                textelement(branchname)
                {
                    MinOccurs = Zero;
                    XmlName = 'branch';
                }
                fieldelement(requestedShippingDate; DraftOrderHeader."Requested Shipment Date")
                {
                    MinOccurs = Zero;
                }
                fieldelement(code; DraftOrderHeader."Ship-to Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(contact; DraftOrderHeader."Ship-to Contact")
                {
                    MinOccurs = Zero;
                }
                textelement(deliveryname)
                {
                    MinOccurs = Zero;
                    XmlName = 'name';
                }
                fieldelement(address; DraftOrderHeader."Ship-to Address")
                {
                    MinOccurs = Zero;
                }
                fieldelement(address2; DraftOrderHeader."Ship-to Address 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(city; DraftOrderHeader."Ship-to City")
                {
                    MinOccurs = Zero;
                }
                fieldelement(county; DraftOrderHeader."Ship-to County")
                {
                    MinOccurs = Zero;
                }
                fieldelement(postCode; DraftOrderHeader."Ship-to Post Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(country; DraftOrderHeader."Ship-to Country/Region Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(homeaddress; DraftOrderHeader."Is Home Ship-To Address")
                {
                    MinOccurs = Zero;
                }
                fieldelement(email; DraftOrderHeader."Ship-to E-Mail")
                {
                    MinOccurs = Zero;
                }
                fieldelement(mobileNo; DraftOrderHeader."Ship-to Mobile Phone No.")
                {
                    MinOccurs = Zero;
                }
                textelement(ordertotal)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'orderTotal';
                }
                fieldelement(awaitingApproval; DraftOrderHeader."Awaiting Approval")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    PortalsMgt: Codeunit "PDC Portal Mgt";
                    tot: Decimal;
                begin

                    tot := PortalsMgt.GetDraftOrderTotal(DraftOrderHeader);
                    orderTotal := Format(tot, 0, 9);
                end;
            }
            tableelement(draftorderstaffline; "PDC Draft Order Staff Line")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(no; DraftOrderStaffLine."Staff ID")
                {
                }
                fieldelement(staffLineNo; DraftOrderStaffLine."Line No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(name; DraftOrderStaffLine."Staff Name")
                {
                    MinOccurs = Zero;
                }
                fieldelement(gender; DraftOrderStaffLine."Body Type/Gender")
                {
                    MinOccurs = Zero;
                }
                fieldelement(yourId; DraftOrderStaffLine."Wearer ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(branch; DraftOrderStaffLine."Branch Name")
                {
                    MinOccurs = Zero;
                }
                fieldelement(branchid; DraftOrderStaffLine."Branch ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(uniformId; DraftOrderStaffLine."Wardrobe ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(uniform; DraftOrderStaffLine."Wardrobe Name")
                {
                    MinOccurs = Zero;
                }
                textelement(contract)
                {
                    MinOccurs = Zero;
                }
                textelement(contractname)
                {
                    MinOccurs = Zero;
                    XmlName = 'contractName';
                }
                textelement(numberoflines)
                {
                    MinOccurs = Zero;
                    XmlName = 'numberOfLines';

                    trigger OnBeforePassVariable()
                    var
                        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
                        itemQty: Decimal;
                    begin
                        numberOfLines := '0';

                        DraftOrderItemLineDb.Reset();
                        DraftOrderItemLineDb.SetRange("Document No.", noFilter);
                        DraftOrderItemLineDb.SetRange("Staff Line No.", DraftOrderStaffLine."Line No.");
                        DraftOrderItemLineDb.SetFilter(Quantity, '>%1', 0);
                        if DraftOrderItemLineDb.Findset() then begin
                            Clear(itemQty);
                            repeat
                                itemQty += DraftOrderItemLineDb.Quantity;
                            until DraftOrderItemLineDb.next() = 0;
                            numberOfLines := Format(itemQty, 0, 9);
                        end;
                    end;
                }
                textelement(exceeded)
                {
                    MinOccurs = Zero;
                    XmlName = 'exceeded';

                    trigger OnBeforePassVariable()
                    var
                        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
                    begin
                        exceeded := Format(false);

                        DraftOrderItemLineDb.Reset();
                        DraftOrderItemLineDb.SetRange("Document No.", noFilter);
                        DraftOrderItemLineDb.SetRange("Staff Line No.", DraftOrderStaffLine."Line No.");
                        DraftOrderItemLineDb.SetFilter(Quantity, '>%1', 0);

                        if DraftOrderItemLineDb.FindSet() then
                            repeat
                                DraftOrderItemLineDb.CalcFields(Entitlement, "Quantity Issued");

                                if (DraftOrderItemLineDb.Quantity + DraftOrderItemLineDb."Quantity Issued") > DraftOrderItemLineDb.Entitlement then
                                    exceeded := Format(true);
                            until DraftOrderItemLineDb.Next() = 0;
                    end;

                }
                textelement(reasonCode)
                {
                    MinOccurs = Zero;
                }
                textelement(reasonDescription)
                {
                    MinOccurs = Zero;
                }
                fieldelement(staffpoNo; DraftOrderStaffLine."PO No.")
                {
                    MinOccurs = Zero;
                }
                textelement(blocked)
                {
                    MinOccurs = Zero;
                }
                textelement(contractBlocked)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    ContractDB: Record "PDC Contract";
                    Reason: Record "Reason Code";
                    BranchStaff: Record "PDC Branch Staff";
                begin
                    DraftOrderStaffLine.CalcFields("Contract ID");
                    DraftOrderStaffLine.CalcFields("Customer No.");
                    ContractDB.Get(
                                 DraftOrderStaffLine."Customer No.",
                                 DraftOrderStaffLine."Contract ID");
                    contract := ContractDB."Contract Code";
                    contractName := ContractDB.Description;
                    contractBlocked := Format(ContractDB.Blocked);

                    if not Reason.Get(DraftOrderStaffLine."Reason Code") then Clear(Reason);
                    reasonCode := Reason.Code;
                    reasonDescription := Reason.Description;

                    Clear(blocked);
                    if BranchStaff.Get(DraftOrderStaffLine."Staff ID") then blocked := Format(BranchStaff.Blocked)
                end;
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
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User")
    var
        DraftOrderHeaderDb: Record "PDC Draft Order Header";
        DraftOrderStaffLinedb: Record "PDC Draft Order Staff Line";
        CustPortalMgt: Codeunit "PDC Portal Mgt";
    begin
        DraftOrderHeaderDb.Reset();
        CustPortalMgt.FilterDraftOrders(PortalUser, DraftOrderHeaderDb);
        DraftOrderHeaderDb.SetRange("Document No.", noFilter);
        if Approvals <> '' then DraftOrderHeaderDb.SetFilter("Awaiting Approval", Approvals);

        if not DraftOrderHeaderDb.FindFirst() then exit;


        deliveryName := DraftOrderHeaderDb."Ship-to Name" + ' ' + DraftOrderHeaderDb."Ship-to Name 2";

        DraftOrderHeader.TransferFields(DraftOrderHeaderDb);
        DraftOrderHeader.Insert();

        DraftOrderStaffLinedb.Reset();
        DraftOrderStaffLinedb.SetRange("Document No.", noFilter);

        if not DraftOrderStaffLinedb.FindSet() then exit;

        DraftOrderStaffLine.DeleteAll();

        repeat
            DraftOrderStaffLine.TransferFields(DraftOrderStaffLinedb);
            DraftOrderStaffLine.Insert();
        until DraftOrderStaffLinedb.Next() = 0;
    end;

    /// <summary>
    /// SaveData.
    /// </summary>
    /// <param name="CustomerNo">Code[20].</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure SaveData(CustomerNo: Code[20]; var PortalUser: Record "PDC Portal User")
    var
        DraftOrderHeaderDb: Record "PDC Draft Order Header";
        DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
        DraftOrderStaffLineDb2: Record "PDC Draft Order Staff Line";
        StaffDb: Record "PDC Branch Staff";
        BranchDb: Record "PDC Branch";
        DocumentNo: Code[20];
    begin
        DocumentNo := noFilter;
        DraftOrderHeader.FindFirst();

        if noFilter = '' then begin
            DraftOrderHeaderDb.Init();
            DraftOrderHeaderDb.Validate("Document No.", '');
            DraftOrderHeaderDb.Validate("Sell-to Customer No.", CustomerNo);
            DraftOrderHeaderDb.Validate("PO No.", DraftOrderHeader."PO No.");
            DraftOrderHeaderDb.Validate("Ship-to Code", DraftOrderHeader."Ship-to Code");

            if DraftOrderHeader."Ship-to Code" = '' then
                if PortalUser."Default Ship-to Code" <> '' then
                    DraftOrderHeaderDb.Validate("Ship-to Code", PortalUser."Default Ship-to Code")
                else
                    if DraftOrderStaffLine.FindSet() then begin
                        StaffDb.Get(DraftOrderStaffLine."Staff ID");
                        if BranchDb.Get(StaffDb."Sell-to Customer No.", StaffDb."Branch ID") then
                            if BranchDb."Ship-to Address" <> '' then
                                DraftOrderHeaderDb.Validate("Ship-to Code", BranchDb."Ship-to Address");
                    end;

            DraftOrderHeaderDb."Created By ID" := PortalUser."Contact No.";

            if DraftOrderHeader."Is Home Ship-To Address" then begin
                DraftOrderHeaderDb."Ship-to E-Mail" := DraftOrderHeader."Ship-to E-Mail";
                DraftOrderHeaderDb."Ship-to Mobile Phone No." := DraftOrderHeader."Ship-to Mobile Phone No.";
            end
            else begin
                DraftOrderHeaderDb."Ship-to E-Mail" := PortalUser."E-Mail";
                DraftOrderHeaderDb."Ship-to Mobile Phone No." := PortalUser."Phone No."
            end;

            DraftOrderHeaderDb.Insert(true);

            DraftOrderHeader.DeleteAll();
            DraftOrderHeader.TransferFields(DraftOrderHeaderDb);
            DraftOrderHeader.Insert(true);

            DocumentNo := DraftOrderHeader."Document No.";
        end else begin
            DraftOrderHeaderDb.Get(noFilter);
            DraftOrderHeaderDb.Validate("PO No.", DraftOrderHeader."PO No.");
            DraftOrderHeaderDb.Validate("Ship-to Code", DraftOrderHeader."Ship-to Code");
            DraftOrderHeaderDb."Modified By ID" := PortalUser."Contact No.";

            if DraftOrderHeader."Is Home Ship-To Address" then begin
                DraftOrderHeaderDb."Ship-to E-Mail" := DraftOrderHeader."Ship-to E-Mail";
                DraftOrderHeaderDb."Ship-to Mobile Phone No." := DraftOrderHeader."Ship-to Mobile Phone No.";
            end;
            DraftOrderHeaderDb.Modify(true);
        end;

        if DraftOrderStaffLine.FindSet() then
            repeat

                DraftOrderStaffLineDb2.Reset();
                DraftOrderStaffLineDb2.SetRange("Document No.", DocumentNo);
                DraftOrderStaffLineDb2.SetRange("Staff ID", DraftOrderStaffLine."Staff ID");

                // If the staff line hasn't been found then add one -- and
                // also add an item line for each item in the wardrobe.
                if DraftOrderStaffLineDb2.IsEmpty then begin
                    DraftOrderStaffLineDb.Init();
                    DraftOrderStaffLineDb.TransferFields(DraftOrderStaffLine);
                    DraftOrderStaffLineDb."Line No." := GetNextStaffLineNo(DocumentNo);
                    DraftOrderStaffLineDb."Document No." := DocumentNo;
                    DraftOrderStaffLineDb.Insert(true);

                    AddWardrobeLinesToStaffMember(CustomerNo, DraftOrderStaffLineDb);
                end;

            until DraftOrderStaffLine.Next() = 0;

        DraftOrderStaffLine.DeleteAll();

        DraftOrderStaffLineDb.SetFilter("Document No.", DocumentNo);
        if DraftOrderStaffLineDb.FindSet() then
            repeat
                DraftOrderStaffLine.TransferFields(DraftOrderStaffLineDb);
                DraftOrderStaffLine.Insert();
            until DraftOrderStaffLineDb.Next() = 0;
    end;

    local procedure GetNextStaffLineNo(DocumentNo: Code[20]): Integer
    var
        DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
        CurrentMax: Integer;
    begin
        DraftOrderStaffLineDb.Reset();
        DraftOrderStaffLineDb.SetRange("Document No.", DocumentNo);

        if not DraftOrderStaffLineDb.FindSet() then exit(10000);

        CurrentMax := 0;

        repeat

            if DraftOrderStaffLineDb."Line No." > CurrentMax then CurrentMax := DraftOrderStaffLineDb."Line No.";

        until DraftOrderStaffLineDb.Next() = 0;
        exit(CurrentMax + 10000);
    end;

    local procedure AddWardrobeLinesToStaffMember(CustomerNo: Code[20]; var DraftOrderStaffLine: Record "PDC Draft Order Staff Line")
    var
        WardrobeLine: Record "PDC Wardrobe Line";
        TempDraftOrderItemLine: Record "PDC Draft Order Item Line" temporary;
        PortalsMgt: Codeunit "PDC Portal Mgt";
        LineNoCounter: Integer;
    begin
        TempDraftOrderItemLine.Reset();
        TempDraftOrderItemLine.SetRange("Document No.", DraftOrderStaffLine."Document No.");
        TempDraftOrderItemLine.SetRange("Staff Line No.", DraftOrderStaffLine."Line No.");

        if TempDraftOrderItemLine.FindSet() then exit;

        DraftOrderStaffLine.CalcFields("Wardrobe ID");
        WardrobeLine.Reset();
        WardrobeLine.SetRange("Wardrobe ID", DraftOrderStaffLine."Wardrobe ID");

        if WardrobeLine.FindSet() then
            repeat
                LineNoCounter := LineNoCounter - 10000;
                TempDraftOrderItemLine.Init();
                TempDraftOrderItemLine."Line No." := LineNoCounter;
                TempDraftOrderItemLine."Staff Line No." := DraftOrderStaffLine."Line No.";
                TempDraftOrderItemLine."Product Code" := WardrobeLine."Product Code";
                TempDraftOrderItemLine.Quantity := 0;
                TempDraftOrderItemLine.Insert(true);
            until WardrobeLine.Next() = 0;

        TempDraftOrderItemLine.Reset();
        if TempDraftOrderItemLine.FindSet() then
            PortalsMgt.AddOrUpdateDraftOrderItemLines(CustomerNo, DraftOrderStaffLine."Document No.", TempDraftOrderItemLine, DraftOrderStaffLine."Line No.", false);
    end;

    /// <summary>
    /// DeleteStaffMember.
    /// </summary>
    procedure DeleteStaffMember()
    var
        DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
    begin
        DraftOrderStaffLineDb.Get(noFilter, staffLineNo);

        DraftOrderItemLineDb.Reset();
        DraftOrderItemLineDb.SetRange("Document No.", noFilter);
        DraftOrderItemLineDb.SetRange("Staff Line No.", DraftOrderStaffLineDb."Line No.");

        if DraftOrderItemLineDb.FindSet() then
            DraftOrderItemLineDb.DeleteAll(true);

        DraftOrderStaffLineDb.Delete(true);

        DraftOrderStaffLine.Reset();
        DraftOrderStaffLineDb.Reset();

        DraftOrderStaffLineDb.SetRange("Document No.", noFilter);
        if DraftOrderStaffLineDb.FindSet() then
            repeat
                DraftOrderStaffLine.TransferFields(DraftOrderStaffLineDb);
                DraftOrderStaffLine.Insert();
            until DraftOrderStaffLineDb.Next() = 0;
    end;

    /// <summary>
    /// DeleteData.
    /// </summary>
    procedure DeleteData()
    var
        DraftOrderHeaderDb: Record "PDC Draft Order Header";
    begin
        DraftOrderHeaderDb.Get(noFilter);
        DraftOrderHeaderDb.Delete(true);
    end;

    procedure DraftOrdersMerge(var FromDraftOrderHeader: Record "PDC Draft Order Header"; CustomerNo: Code[20]; var PortalUser: Record "PDC Portal User"): Boolean
    var
        Customer: Record Customer;
        ToDraftOrderHeader: Record "PDC Draft Order Header";
        FromDraftOrderStaffLine: Record "PDC Draft Order Staff Line";
        FromDraftOrderItemLine: Record "PDC Draft Order Item Line";
        ToDraftOrderStaffLine: Record "PDC Draft Order Staff Line";
        ToDraftOrderItemLine: Record "PDC Draft Order Item Line";
        TempDraftOrderHeader: Record "PDC Draft Order Header" temporary;
        TempOrderStaffLine: Record "PDC Draft Order Staff Line" temporary;
        TempOrderItemLine: Record "PDC Draft Order Item Line" temporary;
        LastStaffLineNo: Integer;
        LastItemLineNo: Integer;
        SameCustomerErr: label 'Orders must have same Customer No.';
        DuplicateStaffErr: label 'Duplicate staff members found in one or more draft orders.';
    begin
        if FromDraftOrderHeader.findset() then
            //check
            repeat
                if Customer."No." = '' then
                    Customer.get(FromDraftOrderHeader."Sell-to Customer No.")
                else
                    if not (Customer."No." = FromDraftOrderHeader."Sell-to Customer No.") then
                        //exit; //must be same customer
                        Error(SameCustomerErr);

                TempDraftOrderHeader.Init();
                TempDraftOrderHeader := FromDraftOrderHeader;
                TempDraftOrderHeader.Insert();

                FromDraftOrderStaffLine.setrange("Document No.", FromDraftOrderHeader."Document No.");
                if FromDraftOrderStaffLine.findset() then
                    repeat
                        TempOrderStaffLine.setrange("Staff ID", FromDraftOrderStaffLine."Staff ID");
                        if TempOrderStaffLine.FindFirst() then
                            //exit(false); //cannot have same staff in several orders
                            error(DuplicateStaffErr);

                        TempOrderStaffLine.reset();
                        TempOrderStaffLine.Init();
                        TempOrderStaffLine := FromDraftOrderStaffLine;
                        TempOrderStaffLine.Insert();

                        FromDraftOrderItemLine.setrange("Document No.", FromDraftOrderHeader."Document No.");
                        FromDraftOrderItemLine.setrange("Staff Line No.", FromDraftOrderStaffLine."Line No.");
                        if FromDraftOrderItemLine.findset() then
                            repeat
                                TempOrderItemLine.Init();
                                TempOrderItemLine := FromDraftOrderItemLine;
                                TempOrderItemLine.Insert();
                            until FromDraftOrderItemLine.next() = 0;
                    until FromDraftOrderStaffLine.Next() = 0;
            until FromDraftOrderHeader.next() = 0;


        if TempOrderStaffLine.FindSet() then begin
            DraftOrderHeader.FindFirst();

            ToDraftOrderHeader.Init();
            ToDraftOrderHeader.Validate("Document No.", '');
            ToDraftOrderHeader.Validate("Sell-to Customer No.", CustomerNo);
            ToDraftOrderHeader.Validate("PO No.", DraftOrderHeader."PO No.");
            ToDraftOrderHeader.Validate("Ship-to Code", DraftOrderHeader."Ship-to Code");
            if DraftOrderHeader."Ship-to Code" = '' then
                if PortalUser."Default Ship-to Code" <> '' then
                    ToDraftOrderHeader.Validate("Ship-to Code", PortalUser."Default Ship-to Code");
            ToDraftOrderHeader."Created By ID" := PortalUser."Contact No.";
            if DraftOrderHeader."Is Home Ship-To Address" then begin
                ToDraftOrderHeader."Ship-to E-Mail" := DraftOrderHeader."Ship-to E-Mail";
                ToDraftOrderHeader."Ship-to Mobile Phone No." := DraftOrderHeader."Ship-to Mobile Phone No.";
            end
            else begin
                ToDraftOrderHeader."Ship-to E-Mail" := PortalUser."E-Mail";
                ToDraftOrderHeader."Ship-to Mobile Phone No." := PortalUser."Phone No."
            end;
            ToDraftOrderHeader.Insert(true);

            DraftOrderHeader.DeleteAll();
            DraftOrderHeader.TransferFields(ToDraftOrderHeader);
            DraftOrderHeader.Insert(true);

            DraftOrderStaffLine.DeleteAll();

            LastStaffLineNo := 0;
            repeat
                LastStaffLineNo += 10000;
                ToDraftOrderStaffLine.init();
                ToDraftOrderStaffLine := TempOrderStaffLine;
                ToDraftOrderStaffLine."Document No." := ToDraftOrderHeader."Document No.";
                ToDraftOrderStaffLine."Line No." := LastStaffLineNo;
                ToDraftOrderStaffLine.Insert(true);

                DraftOrderStaffLine.Init();
                DraftOrderStaffLine.TransferFields(ToDraftOrderStaffLine);
                DraftOrderStaffLine.Insert();

                LastItemLineNo := 0;
                TempOrderItemLine.setrange("Staff ID", TempOrderStaffLine."Staff ID");
                if TempOrderItemLine.FindSet() then
                    repeat
                        LastItemLineNo += 10000;
                        ToDraftOrderItemLine.init();
                        ToDraftOrderItemLine := TempOrderItemLine;
                        ToDraftOrderItemLine."Document No." := ToDraftOrderHeader."Document No.";
                        ToDraftOrderItemLine."Staff Line No." := LastStaffLineNo;
                        ToDraftOrderItemLine."Line No." := LastItemLineNo;
                        ToDraftOrderItemLine.Insert(true);

                        FromDraftOrderItemLine.get(TempOrderItemLine."Document No.", TempOrderItemLine."Staff Line No.", TempOrderItemLine."Line No.");
                        FromDraftOrderItemLine.Delete(true);
                    until TempOrderItemLine.Next() = 0;

                FromDraftOrderStaffLine.get(TempOrderStaffLine."Document No.", TempOrderStaffLine."Line No.");
                FromDraftOrderStaffLine.Delete(true);

            until TempOrderStaffLine.Next() = 0;

            TempDraftOrderHeader.FindSet();
            repeat
                FromDraftOrderHeader.get(TempDraftOrderHeader."Document No.");
                FromDraftOrderHeader.Delete(true);
            until TempDraftOrderHeader.Next() = 0;

            exit(true);
        end;
        exit(false);
    end;

    procedure SendApproval()
    var
        DraftOrderHeaderDb: Record "PDC Draft Order Header";
    begin
        if DraftOrderHeaderDb.Get(noFilter) then begin
            DraftOrderHeader.FindFirst();
            if DraftOrderHeader."PO No." <> '' then
                DraftOrderHeaderDb.Validate("PO No.", DraftOrderHeader."PO No.");

            DraftOrderHeaderDb."Awaiting Approval" := true;
            DraftOrderHeaderDb."Awaiting Approval DT" := CurrentDateTime();
            DraftOrderHeaderDb.modify();

            DraftOrderHeaderDb.SetRecfilter();
            Report.Run(Report::"PDC Portal - Order Approve", false, false, DraftOrderHeaderDb);
        end;
    end;
}

