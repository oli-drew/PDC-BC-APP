/// <summary>
/// XmlPort PDC Portal Staff List (ID 50011).
/// </summary>
xmlport 50011 "PDC Portal Staff List"
{

    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                textelement(branchId)
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

            tableelement(branchstaff; "PDC Branch Staff")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(staffid; BranchStaff."Staff ID")
                {
                }
                fieldelement(branchid; BranchStaff."Branch ID")
                {
                }
                fieldelement(name; BranchStaff.Name)
                {
                }
                fieldelement(gender; BranchStaff."Body Type/Gender")
                {
                }
                fieldelement(uniform; BranchStaff."Wardrobe ID")
                {
                }
                fieldelement(contract; BranchStaff."Contract ID")
                {
                }
                fieldelement(yourid; BranchStaff."Wearer ID")
                {
                }
                fieldelement(blocked; BranchStaff.Blocked)
                {
                }
                fieldelement(branchname; BranchStaff."Branch Name")
                {
                    XmlName = 'branchname';
                }
                fieldelement(wardrobename; BranchStaff."Wardrobe Description")
                {
                    XmlName = 'wardrobename';
                }
                textelement(contractcode)
                {
                    MinOccurs = Zero;
                }
                fieldelement(contractname; BranchStaff."Contract Name")
                {
                    MinOccurs = Zero;
                }
                textelement(entRemaining)
                {
                    MinOccurs = Zero;
                }
                textelement(entComplete)
                {
                    MinOccurs = Zero;
                }
                textelement(entExceeded)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    Contract: Record "PDC Contract";
                begin
                    FindEntitlementStatus(BranchStaff);

                    Contract.Reset();
                    Contract.SetRange("No.", BranchStaff."Contract ID");
                    if not Contract.FindFirst() then clear(Contract);
                    contractcode := Contract."Contract Code";
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

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
    /// <param name="PDCBranch">VAR Record "PDC Branch".</param>
    /// <param name="PDCPortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="Command">Text.</param>
    procedure FilterData(var PDCBranch: Record "PDC Branch"; var PDCPortalUser: Record "PDC Portal User"; Command: Text)
    var
        PDCBranchStaffDb: Record "PDC Branch Staff";
        TempBuffer: Record "PDC Branch Staff" temporary;
        PortalMgt: Codeunit "PDC Portal Mgt";
        recRef: RecordRef;
        toInsert: Boolean;
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        PDCBranch.SetRange("Customer No.", PDCPortalUser."Customer No.");

        Case branchId of
            'All',
            '':
                PDCBranch.SetRange("Branch No.");
            'Mine':
                PDCBranch.SetFilter("Branch No.", PortalMgt.GetMyBranchesFilter(PDCPortalUser));
            else
                PDCBranch.SetFilter("Branch No.", PortalMgt.GetBranchFilterWithChilds(PDCPortalUser."Customer No.", branchId));
        End;

        if PDCBranch.FindSet() then
            repeat
                BranchStaffFilter(PDCBranch."Branch No.", PDCBranchStaffDb, PDCPortalUser, Command);

                PDCBranchStaffDb.SetAutoCalcFields("Branch Name", "Wardrobe Description", "Contract Name");
                if PDCBranchStaffDb.FindSet() then
                    repeat
                        toInsert := false;
                        if searchTerm = '' then
                            toInsert := true
                        else begin
                            recRef.GetTable(PDCBranchStaffDb);
                            if Format(RecRef).ToLower().Contains(searchTerm.ToLower()) then
                                toInsert := true;
                        end;

                        if toInsert and not (TempBuffer.Get(PDCBranchStaffDb."Staff ID")) then begin
                            TempBuffer.TransferFields(PDCBranchStaffDb);
                            TempBuffer.Insert();
                        end
                    until PDCBranchStaffDb.Next() = 0;
            until PDCBranch.Next() = 0;

        TempBuffer.reset();

        //load records
        BranchStaff.Reset();
        BranchStaff.DeleteAll();

        if not Paging.FindSet() then begin
            if (TempBuffer.FindSet()) then
                repeat
                    BranchStaff.TransferFields(TempBuffer);
                    BranchStaff.Insert();
                until TempBuffer.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(TempBuffer.Count);

            if (TempBuffer.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := TempBuffer.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        BranchStaff.TransferFields(TempBuffer);
                        BranchStaff.Insert();
                        RecordsToRead -= 1;
                    until ((TempBuffer.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;

        BranchStaff.SetCurrentkey(Name);
    end;

    local procedure BranchStaffFilter(BranchNo: Code[20]; var
                                                              PDCBranchStaff: Record "PDC Branch Staff";

var
PDCPortalUser: Record "PDC Portal User";
ActiveInactive: Text)
    begin
        PDCBranchStaff.Reset();

        PDCBranchStaff.SetRange("Branch ID", BranchNo);
        PDCBranchStaff.SetRange("Sell-to Customer No.", PDCPortalUser."Customer No.");


        if ActiveInactive = 'active' then PDCBranchStaff.SetRange(Blocked, false);
        if ActiveInactive = 'inactive' then PDCBranchStaff.SetRange(Blocked, true);
    end;

    local procedure FindEntitlementStatus(PDCBranchStaff1: Record "PDC Branch Staff")
    var
        PDCStaffEntitlement: Record "PDC Staff Entitlement";
    begin
        entRemaining := 'false';
        entComplete := 'false';
        entExceeded := 'false';

        PDCStaffEntitlement.Reset();
        PDCStaffEntitlement.SetRange("Staff ID", PDCBranchStaff1."Staff ID");
        PDCStaffEntitlement.SetRange("Wardrobe ID", PDCBranchStaff1."Wardrobe ID");
        PDCStaffEntitlement.SetRange("Item Type", PDCStaffEntitlement."item type"::Core);
        PDCStaffEntitlement.SetRange(Inactive, false);
        PDCStaffEntitlement.SetRange("Wardrobe Discontinued", false);
        PDCStaffEntitlement.SetFilter("Calc. Qty. Remaining in Period", '<>0'); //check complete
        if PDCStaffEntitlement.IsEmpty() then
            entComplete := 'true'
        else begin
            PDCStaffEntitlement.SetFilter("Calc. Qty. Remaining in Period", '>0'); //check remaining
            if not PDCStaffEntitlement.IsEmpty() then
                entRemaining := 'true';
            PDCStaffEntitlement.SetFilter("Calc. Qty. Remaining in Period", '<0'); //check exceeded
            if not PDCStaffEntitlement.IsEmpty() then
                entExceeded := 'true';
        end;
    end;
}

