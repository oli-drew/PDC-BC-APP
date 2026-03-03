/// <summary>
/// XmlPort PDC Portal Entitlement Staff (ID 50033).
/// </summary>
xmlport 50033 "PDC Portal Entitlement Staff"
{

    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
                textelement(branchId)
                {
                    MinOccurs = Zero;
                }
                textelement(searchTerm)
                {
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
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                textelement(staffid)
                {

                    trigger OnBeforePassVariable()
                    begin
                        staffid := BranchStaff."Staff ID";
                    end;
                }
                fieldelement(branchid; BranchStaff."Branch ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(name; BranchStaff.Name)
                {
                    MinOccurs = Zero;
                }
                fieldelement(gender; BranchStaff."Body Type/Gender")
                {
                    MinOccurs = Zero;
                }
                fieldelement(uniform; BranchStaff."Wardrobe ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(yourid; BranchStaff."Wearer ID")
                {
                    MinOccurs = Zero;
                }
                textelement(branchname)
                {
                    MinOccurs = Zero;
                    XmlName = 'branchname';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();
                        Branch.SetRange("Branch No.", BranchStaff."Branch ID");
                        Branch.SetRange("Customer No.", BranchStaff."Sell-to Customer No.");

                        if not Branch.FindFirst() then exit;

                        branchName := Branch.Name;
                    end;
                }
                textelement(wardrobename)
                {
                    MinOccurs = Zero;
                    XmlName = 'wardrobename';

                    trigger OnBeforePassVariable()
                    var
                        WardrobeHeader: Record "PDC Wardrobe Header";
                    begin
                        WardrobeHeader.Reset();
                        WardrobeHeader.SetRange("Wardrobe ID", BranchStaff."Wardrobe ID");

                        if not WardrobeHeader.FindFirst() then exit;

                        wardrobeName := WardrobeHeader.Description;
                    end;
                }
                textelement(productsCount)
                {
                    MinOccurs = Zero;
                }
                textelement(itemsCount)
                {
                    MinOccurs = Zero;
                }
                textelement(disablePostpone)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Entitlement: Record "PDC Staff Entitlement";
                    begin
                        disablePostpone := 'false';
                        if not (GlobalEntitlementType = 'predicted') then begin
                            Entitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                            Entitlement.SetRange("Wardrobe ID", BranchStaff."Wardrobe ID");
                            Entitlement.SetRange(Inactive, false);
                            Entitlement.SetRange("Item Type", Entitlement."item type"::Core);
                            Entitlement.SetRange("Wardrobe Discontinued", false);
                            Entitlement.SetFilter("Posponed Period (Days)", '>%1', 0);
                            if not Entitlement.IsEmpty then
                                disablePostpone := 'true'
                        end;
                    end;
                }
                textelement(postponeDaysCnt)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcCount(BranchStaff."Staff ID", GlobalEntitlementType, productsCount, itemsCount);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        GlobalEntitlementType: Text;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="Branch">VAR Record "PDC Branch".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="Command">Text.</param>
    procedure FilterData(var Branch: Record "PDC Branch"; var PortalUser: Record "PDC Portal User"; Command: Text)
    var
        TempBranchStaffFiltered: Record "PDC Branch Staff" temporary;
        PortalMgt: Codeunit "PDC Portal Mgt";
        recRef: RecordRef;
        toInsert: Boolean;
    begin
        GlobalEntitlementType := Command;

        BranchStaff.Reset();
        BranchStaff.DeleteAll();
        Branch.SetRange("Customer No.", PortalUser."Customer No.");

        Case branchId of
            'All',
            '':
                Branch.SetRange("Branch No.");
            'Mine':
                Branch.SetFilter("Branch No.", PortalMgt.GetMyBranchesFilter(PortalUser));
            else
                Branch.SetFilter("Branch No.", PortalMgt.GetBranchFilterWithChilds(PortalUser."Customer No.", branchId));
        End;

        if Branch.FindSet() then
            repeat
                TempBranchStaffFiltered.Reset();
                BranchStaffFilter(Branch."Branch No.", TempBranchStaffFiltered, PortalUser, Command);

                TempBranchStaffFiltered.SetAutoCalcFields("Branch Name", "Wardrobe Description");
                if TempBranchStaffFiltered.FindSet() then begin
                    toInsert := false;
                    if searchTerm = '' then
                        toInsert := true
                    else begin
                        recRef.GetTable(TempBranchStaffFiltered);
                        if Format(recRef).ToLower().Contains(searchTerm.ToLower()) then
                            toInsert := true;
                    end;
                    if toInsert then
                        repeat
                            if not (BranchStaff.Get(TempBranchStaffFiltered."Staff ID")) then begin
                                BranchStaff.TransferFields(TempBranchStaffFiltered);
                                BranchStaff.Insert();
                            end
                        until TempBranchStaffFiltered.Next() = 0;
                end;

                BranchStaff.SetCurrentkey(Name);
            until Branch.Next() = 0;
    end;

    local procedure BranchStaffFilter(BranchNo: Code[20]; var
                                                              TempBranchStaffFiltered: Record "PDC Branch Staff";

var
PortalUser: Record "PDC Portal User";
EntitlementType: Text)
    var
        BranchStaffDB: Record "PDC Branch Staff";
        Entitlement: Record "PDC Staff Entitlement";
        EntitlementPredicted: Record "PDC Staff Entitlement Predict.";
    begin
        TempBranchStaffFiltered.Reset();
        TempBranchStaffFiltered.DeleteAll();

        BranchStaffDB.Reset();
        BranchStaffDB.SetRange("Branch ID", BranchNo);
        BranchStaffDB.SetRange("Sell-to Customer No.", PortalUser."Customer No.");
        BranchStaffDB.SetRange(Blocked, false);
        if BranchStaffDB.FindSet() then
            repeat
                if EntitlementType in ['remaining', 'complete', 'exceeded'] then begin
                    Entitlement.Reset();
                    Entitlement.SetRange("Staff ID", BranchStaffDB."Staff ID");
                    Entitlement.SetRange("Wardrobe ID", BranchStaffDB."Wardrobe ID");
                    Entitlement.SetRange("Item Type", Entitlement."item type"::Core);
                    Entitlement.SetRange(Inactive, false);
                    Entitlement.SetRange("Wardrobe Discontinued", false);
                    if EntitlementType = 'complete' then begin
                        Entitlement.SetFilter("Calc. Qty. Remaining in Period", '<>0');
                        if Entitlement.IsEmpty then
                            if not (TempBranchStaffFiltered.Get(BranchStaffDB."Staff ID")) then begin
                                TempBranchStaffFiltered.TransferFields(BranchStaffDB);
                                TempBranchStaffFiltered.Insert();
                            end;
                    end
                    else
                        if EntitlementType in ['remaining', 'exceeded'] then begin
                            if EntitlementType = 'remaining' then Entitlement.SetFilter("Calc. Qty. Remaining in Period", '>0');
                            if EntitlementType = 'exceeded' then Entitlement.SetFilter("Calc. Qty. Remaining in Period", '<0');
                            if not Entitlement.IsEmpty then
                                if not (TempBranchStaffFiltered.Get(BranchStaffDB."Staff ID")) then begin
                                    TempBranchStaffFiltered.TransferFields(BranchStaffDB);
                                    TempBranchStaffFiltered.Insert();
                                end
                        end
                end
                else
                    if EntitlementType in ['predicted'] then begin
                        EntitlementPredicted.Reset();
                        EntitlementPredicted.SetRange("Staff ID", BranchStaffDB."Staff ID");
                        EntitlementPredicted.SetRange("Wardrobe ID", BranchStaffDB."Wardrobe ID");
                        EntitlementPredicted.SetRange("Item Type", EntitlementPredicted."item type"::Core);
                        EntitlementPredicted.SetFilter("Calc. Qty. Remaining in Period", '>0');
                        if not EntitlementPredicted.IsEmpty then
                            if not (TempBranchStaffFiltered.Get(BranchStaffDB."Staff ID")) then begin
                                TempBranchStaffFiltered.TransferFields(BranchStaffDB);
                                TempBranchStaffFiltered.Insert();
                            end;
                    end;
            until BranchStaffDB.Next() = 0;
    end;

    local procedure CalcCount(StaffID: Code[20]; EntitlementType: Text; var productsCount1: Text; var itemsCount1: Text)
    var
        BranchStaff1: Record "PDC Branch Staff";
        Entitlement: Record "PDC Staff Entitlement";
        EntitlementPredicted: Record "PDC Staff Entitlement Predict.";
        ProdCnt: Integer;
        ItemCnt: Decimal;
    begin
        BranchStaff1.Get(StaffID);

        if EntitlementType in ['remaining', 'complete', 'exceeded'] then begin
            Entitlement.Reset();
            Entitlement.SetRange("Staff ID", BranchStaff1."Staff ID");
            Entitlement.SetRange("Wardrobe ID", BranchStaff1."Wardrobe ID");
            Entitlement.SetRange("Item Type", Entitlement."item type"::Core);
            Entitlement.SetRange(Inactive, false);
            Entitlement.SetRange("Wardrobe Discontinued", false);
            if EntitlementType = 'remaining' then Entitlement.SetFilter("Calc. Qty. Remaining in Period", '>0');
            if EntitlementType = 'complete' then Entitlement.SetFilter("Calc. Qty. Remaining in Period", '0');
            if EntitlementType = 'exceeded' then Entitlement.SetFilter("Calc. Qty. Remaining in Period", '<0');
            if Entitlement.Findset() then
                repeat
                    ProdCnt += 1;
                    ItemCnt += Entitlement."Calc. Qty. Remaining in Period";
                until Entitlement.next() = 0;
        end
        else
            if EntitlementType in ['predicted'] then begin
                EntitlementPredicted.Reset();
                EntitlementPredicted.SetRange("Staff ID", BranchStaff1."Staff ID");
                EntitlementPredicted.SetRange("Wardrobe ID", BranchStaff1."Wardrobe ID");
                EntitlementPredicted.SetRange("Item Type", EntitlementPredicted."item type"::Core);
                EntitlementPredicted.SetFilter("Calc. Qty. Remaining in Period", '>0');
                if EntitlementPredicted.Findset() then
                    repeat
                        ProdCnt += 1;
                        ItemCnt += EntitlementPredicted."Calc. Qty. Remaining in Period";
                    until EntitlementPredicted.next() = 0;
            end;

        productsCount1 := Format(ProdCnt, 9);
        itemsCount1 := Format(ItemCnt, 0, 9);
    end;

    /// <summary>
    /// SaveData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure SaveData(var PortalUser: Record "PDC Portal User")
    var
        BranchStaffDB: Record "PDC Branch Staff";
        Entitlement: Record "PDC Staff Entitlement";
        tmpDays: Integer;
    begin
        if not Evaluate(tmpDays, postponeDaysCnt) then
            exit;

        if BranchStaffDB.Get(staffid) and (tmpDays > 0) then begin
            Entitlement.SetRange("Staff ID", BranchStaffDB."Staff ID");
            Entitlement.SetRange("Wardrobe ID", BranchStaffDB."Wardrobe ID");
            Entitlement.SetRange(Inactive, false);
            Entitlement.SetRange("Item Type", Entitlement."item type"::Core);
            Entitlement.SetRange("Wardrobe Discontinued", false);
            if Entitlement.FindSet(true) then begin
                Entitlement.ModifyAll("Posponed Period (Days)", tmpDays);
                Entitlement.ModifyAll("Posponed By User", PortalUser."Contact No.");
                Entitlement.ModifyAll("Posponed At", CurrentDatetime);
            end;
        end;
    end;

    /// <summary>
    /// PredictedCalc.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure PredictedCalc(var PortalUser: Record "PDC Portal User")
    var
        Branch: Record "PDC Branch";
        BranchStaffDB: Record "PDC Branch Staff";
        EntitlementPredicted: Record "PDC Staff Entitlement Predict.";
    begin
        Branch.SetRange("Customer No.", PortalUser."Customer No.");
        if Branch.FindSet() then
            repeat
                BranchStaffDB.Reset();
                BranchStaffDB.SetRange("Branch ID", Branch."Branch No.");
                BranchStaffDB.SetRange("Sell-to Customer No.", Branch."Customer No.");
                BranchStaffDB.SetRange(Blocked, false);
                if BranchStaffDB.FindSet() then
                    repeat
                        EntitlementPredicted.CreateRecords(BranchStaffDB."Staff ID");
                    until BranchStaffDB.next() = 0;
            until Branch.next() = 0;
    end;
}

