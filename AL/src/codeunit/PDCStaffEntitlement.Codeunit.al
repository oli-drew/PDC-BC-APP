Codeunit 50000 "PDC Staff Entitlement"
{

    trigger OnRun()
    begin
    end;

    var
        GlobalCustomer: Record Customer;
        TempWardrobeLineInsertedLines: Record "PDC Wardrobe Line" temporary;
        NothingToPostErr: label 'Nothing to post.';
        WardrobeLineAlreadyExistsErr: label 'Wardrobe ID %1, Product Code %2 already exists.', Comment = '%1=wardrobe, %2=product';
        WardrobeItemOptionAlreadyExistsErr: label 'Wardrobe ID %1, Product Code %2, Colour Code %3 already exists.', Comment = '%1=wardrobe, %2=product, %3=colour';
        WardrobeCopyTxt: label 'Copy from %1', Comment = '%1=wardrobe from';

    /// <summary>
    /// WaredrobLineProtexSKUCodeLookup.
    /// </summary>
    /// <param name="pRec">VAR Record "PDC Wardrobe Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure WaredrobLineProtexSKUCodeLookup(var pRec: Record "PDC Wardrobe Line"): Boolean
    var
        Item: Record Item;
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeLine2: Record "PDC Wardrobe Line";
        ItemList: Page "Item List";
        SortOrder: Integer;
    begin
        Item.Reset();
        if pRec."Product Code" <> '' then begin
            Item.SetRange("PDC Product Code", pRec."Product Code");
            if Item.FindFirst() then;
            Item.Reset();
        end;

        Clear(ItemList);
        ItemList.LookupMode(true);
        ItemList.SetTableview(Item);
        ItemList.SetRecord(Item);
        if ItemList.RunModal() <> Action::LookupOK then
            Error(''); // stops action without throwing error

        Item.Reset();
        Item.SetFilter("No.", ItemList.GetSelectionFilter());
        if Item.Count = 1 then begin
            Item.FindFirst();
            pRec.Validate("Product Code", Item."PDC Product Code")
        end
        else
            if Item.Findset() then
                repeat
                    WardrobeLine2.Reset();
                    WardrobeLine2.SetRange("Wardrobe ID", pRec."Wardrobe ID");
                    WardrobeLine2.SetRange("Product Code", Item."PDC Product Code");
                    if WardrobeLine2.IsEmpty then begin
                        WardrobeLine2.Reset();
                        WardrobeLine2.SetCurrentkey("Sort Order");
                        WardrobeLine2.SetRange("Wardrobe ID", pRec."Wardrobe ID");
                        if WardrobeLine2.FindLast() then;

                        WardrobeLine.Init();
                        WardrobeLine.Validate("Wardrobe ID", WardrobeLine2."Wardrobe ID");
                        WardrobeLine.Validate("Product Code", Item."PDC Product Code");
                        SortOrder += 1;
                        WardrobeLine.Validate("Sort Order", SortOrder);
                        WardrobeLine.Insert(true);
                    end;
                until Item.next() = 0;

        exit(true);
    end;

    /// <summary>
    /// WardrobeItemOptionColourLookup.
    /// </summary>
    /// <param name="pRec">VAR Record "PDC Wardrobe Item Option".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure WardrobeItemOptionColourLookup(var pRec: Record "PDC Wardrobe Item Option"): Boolean
    var
        Item: Record Item;
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
        WardrobeItemOption2: Record "PDC Wardrobe Item Option";
        ItemList: Page "Item List";
    begin
        Item.Reset();
        Item.SetRange("PDC Product Code", pRec."Product Code");

        Clear(ItemList);
        ItemList.LookupMode(true);
        ItemList.SetTableview(Item);
        ItemList.SetRecord(Item);
        if ItemList.RunModal() <> Action::LookupOK then
            Error(''); // stops action without throwing error

        Item.Reset();
        Item.SetFilter("No.", ItemList.GetSelectionFilter());
        if Item.Count = 1 then begin
            Item.FindFirst();
            pRec.Validate("Colour Code", Item."PDC Colour")
        end
        else
            if Item.Findset() then
                repeat
                    WardrobeItemOption2.Reset();
                    WardrobeItemOption2.SetRange("Wardrobe ID", pRec."Wardrobe ID");
                    WardrobeItemOption2.SetRange("Product Code", pRec."Product Code");
                    if WardrobeItemOption2.IsEmpty then begin
                        WardrobeItemOption.Init();
                        WardrobeItemOption.Validate("Wardrobe ID", pRec."Wardrobe ID");
                        WardrobeItemOption.Validate("Product Code", pRec."Product Code");
                        WardrobeItemOption.Validate("Colour Code", Item."PDC Colour");
                        WardrobeItemOption.Insert(true);
                    end;
                until Item.next() = 0;

        exit(true);
    end;

    /// <summary>
    /// UpdateWardrobeWorksheetMatchingRecs.
    /// </summary>
    /// <param name="pRec">VAR Record "PDC Wardrobe Worksheet".</param>
    /// <param name="pFieldNo">Integer.</param>
    procedure UpdateWardrobeWorksheetMatchingRecs(var pRec: Record "PDC Wardrobe Worksheet"; pFieldNo: Integer)
    var
        WardrobeWorksheet: Record "PDC Wardrobe Worksheet";
        SourceRecRef: RecordRef;
        DestinyRecRef: RecordRef;
        SourceFieldRef: FieldRef;
        DestinyFieldRef: FieldRef;
        ModifyRec: Boolean;
    begin
        WardrobeWorksheet.Reset();
        WardrobeWorksheet.SetRange("Wardrobe ID", pRec."Wardrobe ID");
        WardrobeWorksheet.SetFilter("Entry No.", '<>%1', pRec."Entry No.");

        if pFieldNo in
           [pRec.FieldNo("Item Type"), pRec.FieldNo("Sort Order"), pRec.FieldNo("Body Type/Gender"), pRec.FieldNo("Quantity Entitled in Period"), pRec.FieldNo("Entitlement Period")]
        then
            WardrobeWorksheet.SetRange("Product Code", pRec."Product Code");

        if WardrobeWorksheet.Findset() then begin
            SourceRecRef.GetTable(pRec);
            SourceFieldRef := SourceRecRef.Field(pFieldNo);
            repeat
                DestinyRecRef.GetTable(WardrobeWorksheet);
                DestinyFieldRef := DestinyRecRef.Field(pFieldNo);
                if DestinyFieldRef.Value <> SourceFieldRef.Value then begin
                    DestinyFieldRef.Value(SourceFieldRef.Value);
                    DestinyRecRef.Modify(true);
                    ModifyRec := true;
                end;
            until WardrobeWorksheet.next() = 0;
        end;

        if ModifyRec then
            pRec.Modify(true);
    end;

    local procedure CheckWardrobeWorksheetBeforePosting(var pRec: Record "PDC Wardrobe Worksheet")
    var
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
    begin
        pRec.FindSet();
        repeat
            if pRec."Wardrobe ID" <> '' then begin
                WardrobeLine.Reset();
                WardrobeLine.SetRange("Wardrobe ID", pRec."Wardrobe ID");
                WardrobeLine.SetRange("Product Code", pRec."Product Code");
                if not WardrobeLine.IsEmpty then
                    Error(WardrobeLineAlreadyExistsErr, pRec."Wardrobe ID", pRec."Product Code");

                WardrobeItemOption.Reset();
                WardrobeItemOption.SetRange("Wardrobe ID", pRec."Wardrobe ID");
                WardrobeItemOption.SetRange("Product Code", pRec."Product Code");
                WardrobeItemOption.SetRange("Colour Code", pRec."Colour Code");
                if not WardrobeItemOption.IsEmpty then
                    Error(WardrobeItemOptionAlreadyExistsErr, pRec."Wardrobe ID", pRec."Product Code", pRec."Colour Code");

            end;
        until pRec.Next() = 0;
    end;

    procedure PostWardrobeWorksheetToWardrobe(var pRec: Record "PDC Wardrobe Worksheet")
    var
        WardrobeHeader: Record "PDC Wardrobe Header";
        RecRef: RecordRef;
        NewWardrobeID: Code[20];
    begin
        if pRec.IsEmpty then
            Error(NothingToPostErr);

        CheckWardrobeWorksheetBeforePosting(pRec);

        RecRef.GetTable(TempWardrobeLineInsertedLines);
        if RecRef.IsTemporary then begin
            TempWardrobeLineInsertedLines.Reset();
            TempWardrobeLineInsertedLines.DeleteAll();
        end;

        Clear(NewWardrobeID);
        pRec.FindSet();
        repeat
            if pRec."Wardrobe ID" = '' then begin
                if NewWardrobeID = '' then begin
                    WardrobeHeader.Init();
                    WardrobeHeader.Insert(true);
                    NewWardrobeID := WardrobeHeader."Wardrobe ID";
                    WardrobeHeader.Validate("Customer No.", pRec."Customer No.");
                    WardrobeHeader.Validate(Description, pRec."Wardrobe Description");
                    WardrobeHeader.Modify(true);
                end;
            end
            else
                WardrobeHeader.Get(pRec."Wardrobe ID");

            if WardrobeHeader."Customer No." <> '' then begin
                WardrobeHeader.Validate("Customer No.", pRec."Customer No.");
                WardrobeHeader.Modify(true);
            end;

            if not TempWardrobeLineInsertedLines.Get(WardrobeHeader."Wardrobe ID", pRec."Product Code") then
                InsertWardrobeLine(pRec, NewWardrobeID);

            InsertWardrobeItemOption(pRec, NewWardrobeID);
        until pRec.Next() = 0;

        pRec.DeleteAll(true);
    end;

    local procedure InsertWardrobeLine(WardrobeWorksheet: Record "PDC Wardrobe Worksheet"; NewWardrobeID: Code[20])
    var
        WardrobeLine: Record "PDC Wardrobe Line";
    begin
        WardrobeLine.Init();
        if WardrobeWorksheet."Wardrobe ID" = '' then
            WardrobeLine.Validate("Wardrobe ID", NewWardrobeID)
        else
            WardrobeLine.Validate("Wardrobe ID", WardrobeWorksheet."Wardrobe ID");

        WardrobeLine.Validate("Product Code", WardrobeWorksheet."Product Code");
        WardrobeLine.Validate("Item Type", WardrobeWorksheet."Item Type");
        WardrobeLine.Validate("Sort Order", WardrobeWorksheet."Sort Order");
        WardrobeLine.Validate("Item Gender", WardrobeWorksheet."Body Type/Gender");
        WardrobeLine.Validate("Quantity Entitled in Period", WardrobeWorksheet."Quantity Entitled in Period");
        WardrobeLine.Validate("Entitlement Period", WardrobeWorksheet."Entitlement Period");
        WardrobeLine."Entitlement Qty. Group" := WardrobeWorksheet."Entitlement Qty. Group";
        WardrobeLine."Entitlement Value Group" := WardrobeWorksheet."Entitlement Value Group";
        WardrobeLine."Entitlement Points Group" := WardrobeWorksheet."Entitlement Points Group";
        WardrobeLine.Insert(true);

        TempWardrobeLineInsertedLines.Init();
        TempWardrobeLineInsertedLines.TransferFields(WardrobeLine);
        TempWardrobeLineInsertedLines.Insert();
    end;

    local procedure InsertWardrobeItemOption(WardrobeWorksheet: Record "PDC Wardrobe Worksheet"; NewWardrobeID: Code[20])
    var
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
    begin
        WardrobeItemOption.Init();
        if WardrobeWorksheet."Wardrobe ID" = '' then
            WardrobeItemOption.Validate("Wardrobe ID", NewWardrobeID)
        else
            WardrobeItemOption.Validate("Wardrobe ID", WardrobeWorksheet."Wardrobe ID");

        WardrobeItemOption.Validate("Product Code", WardrobeWorksheet."Product Code");
        WardrobeItemOption.Validate("Colour Code", WardrobeWorksheet."Colour Code");
        WardrobeItemOption.Insert(true);
    end;

    /// <summary>
    /// CopyWardrobe.
    /// </summary>
    /// <param name="SourceWardrobeHeader">VAR Record "PDC Wardrobe Header".</param>
    procedure CopyWardrobe(var SourceWardrobeHeader: Record "PDC Wardrobe Header")
    var
        WardrobeWorksheet: Record "PDC Wardrobe Worksheet";
        WardrobeHeader: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
        PagWardrobeWorksheet: Page "PDC Wardrobe Worksheet";
        LineNo: Integer;
    begin
        WardrobeHeader.Init();
        WardrobeHeader.Validate(Description, StrSubstNo(WardrobeCopyTxt, SourceWardrobeHeader."Wardrobe ID"));
        WardrobeHeader.Insert(true);

        WardrobeWorksheet.Reset();
        if WardrobeWorksheet.FindLast() then
            LineNo := WardrobeWorksheet."Entry No.";

        WardrobeLine.Reset();
        WardrobeLine.SetRange("Wardrobe ID", SourceWardrobeHeader."Wardrobe ID");
        if WardrobeLine.Findset() then
            repeat
                WardrobeItemOption.Reset();
                WardrobeItemOption.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
                WardrobeItemOption.SetRange("Product Code", WardrobeLine."Product Code");
                if WardrobeItemOption.Findset() then
                    repeat
                        WardrobeWorksheet.Init();
                        LineNo += 1;
                        WardrobeWorksheet.Validate("Entry No.", LineNo);
                        WardrobeWorksheet.Validate("Wardrobe ID", WardrobeHeader."Wardrobe ID");
                        WardrobeWorksheet.Validate("Customer No.", SourceWardrobeHeader."Customer No.");
                        WardrobeWorksheet.Validate("Product Code", WardrobeLine."Product Code");
                        WardrobeWorksheet.Validate("Item Type", WardrobeLine."Item Type");
                        WardrobeWorksheet.Validate("Sort Order", WardrobeLine."Sort Order");
                        WardrobeWorksheet.Validate("Body Type/Gender", WardrobeLine."Item Gender");
                        WardrobeWorksheet.Validate("Quantity Entitled in Period", WardrobeLine."Quantity Entitled in Period");
                        WardrobeWorksheet.Validate("Entitlement Period", WardrobeLine."Entitlement Period");
                        WardrobeWorksheet.Validate("Colour Code", WardrobeItemOption."Colour Code");
                        WardrobeWorksheet.Validate("Entitlement Qty. Group", WardrobeLine."Entitlement Qty. Group");
                        WardrobeWorksheet.Validate("Entitlement Value Group", WardrobeLine."Entitlement Value Group");
                        WardrobeWorksheet.Validate("Entitlement Points Group", WardrobeLine."Entitlement Points Group");
                        WardrobeWorksheet.Insert(true);
                    until WardrobeItemOption.next() = 0;

            until WardrobeLine.next() = 0;

        WardrobeWorksheet.Reset();
        WardrobeWorksheet.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
        if WardrobeWorksheet.IsEmpty then
            Error('');

        Commit();
        Clear(PagWardrobeWorksheet);
        PagWardrobeWorksheet.SetTableview(WardrobeWorksheet);
        PagWardrobeWorksheet.RunModal();

        WardrobeLine.Reset();
        WardrobeLine.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
        if WardrobeLine.IsEmpty then begin //Worksheet not posted
            WardrobeWorksheet.Reset();
            WardrobeWorksheet.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
            WardrobeWorksheet.DeleteAll(true);
            WardrobeHeader.Delete(true);
        end;
    end;

    /// <summary>
    /// UpdateStaffEntitlementFromCustomer.
    /// </summary>
    /// <param name="pRec">Record "PDC Branch Staff".</param>
    procedure UpdateStaffEntitlementFromCustomer(var pRec: Record Customer; pxRec: Record Customer)
    var
        BranchStaff: record "PDC Branch Staff";
        StaffEntitlement: Record "PDC Staff Entitlement";
    begin
        if pRec."No." = '' then exit;

        if pREc."PDC Entitlement Enabled" = pxRec."PDC Entitlement Enabled" then exit;

        GlobalCustomer := pRec;

        if not GlobalCustomer."PDC Entitlement Enabled" then begin
            StaffEntitlement.Reset();
            StaffEntitlement.setrange("Customer No.", GlobalCustomer."No.");
            StaffEntitlement.DeleteAll(false);
            exit;
        end
        else begin
            BranchStaff.setrange("Sell-to Customer No.", GlobalCustomer."No.");
            BranchStaff.setrange(Blocked, false);
            if BranchStaff.FindSet() then
                repeat
                    UpdateStaffEntitlementFromBranchStaff(BranchStaff);
                until BranchStaff.next() = 0;
        end;
    end;

    /// <summary>
    /// UpdateStaffEntitlementFromBranchStaff.
    /// </summary>
    /// <param name="pRec">Record "PDC Branch Staff".</param>
    procedure UpdateStaffEntitlementFromBranchStaff(pRec: Record "PDC Branch Staff")
    var
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
        WardrobeGroups: Record "PDC Wardrobe Entitlement Group";
        StaffEntitlement: Record "PDC Staff Entitlement";
        GroupType: Enum PDCEntitlementGroupType;
    begin
        if GlobalCustomer."No." <> pRec."Sell-to Customer No." then
            GlobalCustomer.get(pRec."Sell-to Customer No.");
        if not GlobalCustomer."PDC Entitlement Enabled" then begin
            StaffEntitlement.Reset();
            StaffEntitlement.setrange("Customer No.", GlobalCustomer."No.");
            StaffEntitlement.DeleteAll(true);
            exit;
        end;

        InactivateStaffEntitlementForBranchStaff(pRec);

        if pRec.Blocked then exit;
        Wardrobe.get(pRec."Wardrobe ID");
        WardrobeLine.Reset();
        WardrobeLine.SetRange("Wardrobe ID", pRec."Wardrobe ID");
        WardrobeLine.SetRange("Customer No.", pRec."Sell-to Customer No.");
        if pRec."Body Type/Gender" <> 'O' then
            WardrobeLine.SetFilter("Item Gender", pRec."Body Type/Gender" + '|U');
        if WardrobeLine.Findset() then
            repeat
                if not IsWardroveByGroups(Wardrobe) then begin
                    WardrobeItemOption.Reset();
                    WardrobeItemOption.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
                    WardrobeItemOption.SetRange("Product Code", WardrobeLine."Product Code");
                    if not WardrobeItemOption.IsEmpty then begin
                        StaffEntitlement.Reset();
                        StaffEntitlement.SetRange("Staff ID", pRec."Staff ID");
                        StaffEntitlement.SetRange("Product Code", WardrobeLine."Product Code");
                        if StaffEntitlement.IsEmpty then
                            InsertStaffEntitlementLine(pRec, WardrobeLine, GroupType::" ", '')
                        else begin
                            StaffEntitlement.SetRange(Inactive, true);
                            StaffEntitlement.ModifyAll("Wardrobe ID", WardrobeLine."Wardrobe ID", true);
                            StaffEntitlement.ModifyAll(Inactive, false, true);
                        end;
                    end;
                end;
            until WardrobeLine.next() = 0;

        if IsWardroveByGroups(Wardrobe) then begin
            WardrobeGroups.SetRange("Wardrobe ID", pRec."Wardrobe ID");
            if WardrobeGroups.FindSet() then
                repeat
                    if ((WardrobeGroups.Type = WardrobeGroups.Type::"Quantity Group") and (Wardrobe."Entitlement By Qty. Group")) or
                       ((WardrobeGroups.Type = WardrobeGroups.Type::"Value Group") and (Wardrobe."Entitlement By Value Group")) or
                       ((WardrobeGroups.Type = WardrobeGroups.Type::"Points Group") and (Wardrobe."Entitlement By Points Group")) then begin
                        StaffEntitlement.Reset();
                        StaffEntitlement.SetRange("Staff ID", pRec."Staff ID");
                        StaffEntitlement.setrange("Group Type", WardrobeGroups.Type);
                        StaffEntitlement.setrange("Group Code", WardrobeGroups."Group Code");
                        if StaffEntitlement.IsEmpty then
                            InsertStaffEntitlementLine(pRec, WardrobeLine, WardrobeGroups.Type, WardrobeGroups."Group Code")
                        else begin
                            StaffEntitlement.SetRange(Inactive, true);
                            StaffEntitlement.ModifyAll("Wardrobe ID", WardrobeLine."Wardrobe ID", true);
                            StaffEntitlement.ModifyAll(Inactive, false, true);
                        end;
                    end;
                until WardrobeGroups.Next() = 0;
        end;
    end;

    /// <summary>
    /// UpdateStaffEntitlementFromWardrobeLine.
    /// </summary>
    /// <param name="pxRec">Record "PDC Wardrobe Line".</param>
    /// <param name="pRec">Record "PDC Wardrobe Line".</param>
    procedure UpdateStaffEntitlementFromWardrobeLine(pxRec: Record "PDC Wardrobe Line"; pRec: Record "PDC Wardrobe Line")
    var
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
        BranchStaff: Record "PDC Branch Staff";
        StaffEntitlement: Record "PDC Staff Entitlement";
        GroupType: Enum PDCEntitlementGroupType;
    begin
        Wardrobe.get(pRec."Wardrobe ID");

        if GlobalCustomer."No." <> Wardrobe."Customer No." then
            GlobalCustomer.get(Wardrobe."Customer No.");
        if not GlobalCustomer."PDC Entitlement Enabled" then begin
            StaffEntitlement.Reset();
            StaffEntitlement.setrange("Customer No.", GlobalCustomer."No.");
            StaffEntitlement.DeleteAll(false);
            exit;
        end;


        WardrobeItemOption.Reset();
        WardrobeItemOption.SetRange("Wardrobe ID", pRec."Wardrobe ID");
        WardrobeItemOption.SetRange("Product Code", pRec."Product Code");
        if not WardrobeItemOption.IsEmpty then begin
            pRec.CalcFields("Customer No.");

            BranchStaff.Reset();
            BranchStaff.SetRange("Sell-to Customer No.", pRec."Customer No.");
            BranchStaff.SetRange("Wardrobe ID", pRec."Wardrobe ID");
            BranchStaff.SetRange(Blocked, false);
            if (pxRec."Item Gender" <> 'U') and (pxRec."Item Gender" <> '') then
                BranchStaff.SetFilter("Body Type/Gender", pxRec."Item Gender" + '|O');

            if BranchStaff.Findset() then
                repeat
                    StaffEntitlement.Reset();
                    StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                    StaffEntitlement.SetRange("Product Code", pxRec."Product Code");
                    StaffEntitlement.SetRange("Quantity Posted", 0);
                    StaffEntitlement.DeleteAll(true);
                until BranchStaff.next() = 0;
            if pRec.Discontinued then exit;

            BranchStaff.Reset();
            BranchStaff.SetRange("Sell-to Customer No.", pRec."Customer No.");
            BranchStaff.SetRange("Wardrobe ID", pRec."Wardrobe ID");
            BranchStaff.SetRange(Blocked, false);
            if pxRec."Item Gender" <> 'U' then
                BranchStaff.SetFilter("Body Type/Gender", pRec."Item Gender" + '|O');
            if BranchStaff.Findset() then
                repeat
                    if not IsWardroveByGroups(Wardrobe) then begin
                        StaffEntitlement.Reset();
                        StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                        StaffEntitlement.SetRange("Product Code", pRec."Product Code");
                        if StaffEntitlement.IsEmpty then
                            InsertStaffEntitlementLine(BranchStaff, pRec, GroupType::" ", '');
                    end;
                until BranchStaff.next() = 0;
        end;
    end;

    /// <summary>
    /// UpdateStaffEntitlementFromWardrobeItemOption.
    /// </summary>
    /// <param name="pRec">Record "PDC Wardrobe Item Option".</param>
    procedure UpdateStaffEntitlementFromWardrobeItemOption(pRec: Record "PDC Wardrobe Item Option")
    var
        WardrobeLine: Record "PDC Wardrobe Line";
        BranchStaff: Record "PDC Branch Staff";
        StaffEntitlement: Record "PDC Staff Entitlement";
        GroupType: Enum PDCEntitlementGroupType;
    begin
        WardrobeLine.Reset();
        WardrobeLine.SetRange("Wardrobe ID", pRec."Wardrobe ID");
        WardrobeLine.SetRange("Product Code", pRec."Product Code");
        WardrobeLine.FindFirst();
        WardrobeLine.CalcFields("Customer No.");

        BranchStaff.Reset();
        BranchStaff.SetRange("Sell-to Customer No.", WardrobeLine."Customer No.");
        BranchStaff.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
        if WardrobeLine."Item Gender" <> 'U' then
            BranchStaff.SetFilter("Body Type/Gender", WardrobeLine."Item Gender" + '|O');
        if BranchStaff.Findset() then
            repeat
                StaffEntitlement.Reset();
                StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                StaffEntitlement.SetRange("Product Code", WardrobeLine."Product Code");
                StaffEntitlement.ModifyAll(Inactive, false, true);
            until BranchStaff.next() = 0;

        if WardrobeLine.Discontinued then exit;

        BranchStaff.Reset();
        BranchStaff.SetRange("Sell-to Customer No.", WardrobeLine."Customer No.");
        BranchStaff.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
        if WardrobeLine."Item Gender" <> 'U' then
            BranchStaff.SetFilter("Body Type/Gender", WardrobeLine."Item Gender" + '|O');
        if BranchStaff.Findset() then
            repeat
                StaffEntitlement.Reset();
                StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                StaffEntitlement.SetRange("Product Code", WardrobeLine."Product Code");
                if StaffEntitlement.IsEmpty then
                    InsertStaffEntitlementLine(BranchStaff, WardrobeLine, GroupType::" ", '');
            until BranchStaff.next() = 0;
    end;

    /// <summary>
    /// UpdateStaffEntitlementFromWardrobe.
    /// </summary>
    /// <param name="pRec">Record "PDC Wardrobe Header".</param>
    procedure UpdateStaffEntitlementFromWardrobe(pRec: Record "PDC Wardrobe Header")
    var
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeGroup: Record "PDC Wardrobe Entitlement Group";
    begin
        WardrobeLine.setrange("Wardrobe ID", pRec."Wardrobe ID");
        WardrobeLine.setrange(Discontinued, false);
        if WardrobeLine.FindSet() then
            repeat
                WardrobeLine.Modify(true);
            until WardrobeLine.next() = 0;
        WardrobeGroup.setrange("Wardrobe ID", pRec."Wardrobe ID");
        if WardrobeGroup.FindSet() then
            repeat
                WardrobeGroup.Modify(true);
            until WardrobeGroup.Next() = 0;
    end;

    local procedure InsertStaffEntitlementLine(BranchStaff: Record "PDC Branch Staff"; WardrobeLine: Record "PDC Wardrobe Line"; GroupType: Enum PDCEntitlementGroupType; GroupCode: Code[20])
    var
        StaffEntitlement: Record "PDC Staff Entitlement";
    begin
        WardrobeLine.CalcFields("Customer No.");
        StaffEntitlement.Init();
        StaffEntitlement.Validate("Staff ID", BranchStaff."Staff ID");
        StaffEntitlement."Staff ID" := BranchStaff."Staff ID";
        StaffEntitlement.Validate("Wardrobe ID", WardrobeLine."Wardrobe ID");
        StaffEntitlement.Validate("Customer No.", WardrobeLine."Customer No.");
        StaffEntitlement.Validate("Branch No.", BranchStaff."Branch ID");
        if GroupCode = '' then
            StaffEntitlement.Validate("Product Code", WardrobeLine."Product Code")
        else begin
            StaffEntitlement.Validate("Group Type", GroupType);
            StaffEntitlement.validate("Group Code", GroupCode);
        end;
        StaffEntitlement.Insert(true);
    end;

    /// <summary>
    /// WardrobeEntitlementExistsForBranchStaff.
    /// </summary>
    /// <param name="StaffID">Code[20].</param>
    /// <returns>Return variable rtnExists of type Boolean.</returns>
    procedure WardrobeEntitlementExistsForBranchStaff(StaffID: Code[20]) rtnExists: Boolean
    var
        StaffEntitlement: Record "PDC Staff Entitlement";
    begin
        StaffEntitlement.Reset();
        StaffEntitlement.SetRange("Staff ID", StaffID);
        exit(not StaffEntitlement.IsEmpty);
    end;

    /// <summary>
    /// WardrobeEntitlementExistsForWardrobeLine.
    /// </summary>
    /// <param name="WardrobeLine">Record "PDC Wardrobe Line".</param>
    /// <returns>Return variable rtnExists of type Boolean.</returns>
    procedure WardrobeEntitlementExistsForWardrobeLine(WardrobeLine: Record "PDC Wardrobe Line") rtnExists: Boolean
    var
        StaffEntitlement: Record "PDC Staff Entitlement";
    begin
        StaffEntitlement.Reset();
        StaffEntitlement.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
        StaffEntitlement.SetRange("Product Code", WardrobeLine."Product Code");
        exit(not StaffEntitlement.IsEmpty);
    end;

    /// <summary>
    /// UpdateStaffentitlementQuantities.
    /// </summary>
    /// <param name="pRec">VAR Record "PDC Staff Entitlement".</param>
    procedure UpdateStaffentitlementQuantities(var pRec: Record "PDC Staff Entitlement")
    begin
        if pRec.Findset() then
            repeat
                pRec.CalculateQuantities(pRec, true);
            until pRec.Next() = 0;
    end;

    /// <summary>
    /// UpdateGroupsFromWardrobeLine.
    /// </summary>
    /// <param name="pxRec">Record "PDC Wardrobe Line".</param>
    /// <param name="pRec">Record "PDC Wardrobe Line".</param>
    procedure UpdateGroupsFromWardrobeLine(pxRec: Record "PDC Wardrobe Line"; pRec: Record "PDC Wardrobe Line")
    var
        WardrobeGroups: Record "PDC Wardrobe Entitlement Group";
        CurrType: Enum PDCEntitlementGroupType;
        CurrCode: Code[20];
        i: Integer;
    begin
        for i := 1 to 3 do begin
            case i of
                1:
                    begin
                        CurrType := CurrType::"Quantity Group";
                        CurrCode := pRec."Entitlement Qty. Group";
                    end;
                2:
                    begin
                        CurrType := CurrType::"Value Group";
                        CurrCode := pRec."Entitlement Value Group";
                    end;
                3:
                    begin
                        CurrType := CurrType::"Points Group";
                        CurrCode := pRec."Entitlement Points Group";
                    end;
            end;

            if CurrCode <> '' then begin
                WardrobeGroups.setrange("Wardrobe ID", pRec."Wardrobe ID");
                WardrobeGroups.setrange(Type, CurrType);
                WardrobeGroups.setrange("Group Code", CurrCode);
                if WardrobeGroups.IsEmpty then begin
                    WardrobeGroups.Init();
                    WardrobeGroups."Wardrobe ID" := pRec."Wardrobe ID";
                    WardrobeGroups.Type := CurrType;
                    WardrobeGroups.Validate("Group Code", CurrCode);
                    WardrobeGroups.Insert(true);
                end;
            end;
        end;
    end;

    /// <summary>
    /// UpdateStaffEntitlementGroupsFromWardrobeLine.
    /// </summary>
    /// <param name="pxRec">Record "PDC Wardrobe Entitlement Group".</param>
    /// <param name="pRec">Record "PDC Wardrobe Entitlement Group".</param>
    procedure UpdateStaffEntitlementGroupsFromWardrobeLine(pxRec: Record "PDC Wardrobe Entitlement Group"; pRec: Record "PDC Wardrobe Entitlement Group")
    var
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        BranchStaff: Record "PDC Branch Staff";
        StaffEntitlement: Record "PDC Staff Entitlement";
    begin
        Wardrobe.get(pRec."Wardrobe ID");
        BranchStaff.Reset();
        BranchStaff.SetRange("Sell-to Customer No.", Wardrobe."Customer No.");
        BranchStaff.SetRange("Wardrobe ID", Wardrobe."Wardrobe ID");
        BranchStaff.SetRange(Blocked, false);
        if BranchStaff.Findset() then
            repeat
                StaffEntitlement.Reset();
                StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                StaffEntitlement.SetRange("Group Type", pxRec.Type);
                StaffEntitlement.SetRange("Group Code", pxRec."Group Code");
                StaffEntitlement.DeleteAll(true);
            until BranchStaff.next() = 0;

        if ((pRec.Type = pRec.Type::"Quantity Group") and (Wardrobe."Entitlement By Qty. Group")) or
            ((pRec.Type = pRec.Type::"Value Group") and (Wardrobe."Entitlement By Value Group")) or
            ((pRec.Type = pRec.Type::"Points Group") and (Wardrobe."Entitlement By Points Group")) then
            if BranchStaff.Findset() then
                repeat
                    if IsWardroveByGroups(Wardrobe) then begin
                        StaffEntitlement.Reset();
                        StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                        StaffEntitlement.SetRange("Group Type", pRec.Type);
                        StaffEntitlement.SetRange("Group Code", pRec."Group Code");
                        if StaffEntitlement.IsEmpty then begin
                            WardrobeLine.setrange("Wardrobe ID", Wardrobe."Wardrobe ID");
                            WardrobeLine.FindFirst();
                            InsertStaffEntitlementLine(BranchStaff, WardrobeLine, pRec.Type, pRec."Group Code");
                        end;
                    end;
                until BranchStaff.next() = 0;
    end;

    /// <summary>
    /// IsWardroveByGroups.
    /// </summary>
    /// <param name="Wardrobe">Record "PDC Wardrobe Header".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsWardroveByGroups(Wardrobe: Record "PDC Wardrobe Header"): Boolean
    begin
        exit(Wardrobe."Entitlement By Qty. Group" or Wardrobe."Entitlement By Value Group" or Wardrobe."Entitlement By Points Group");
    end;

    /// <summary>
    /// UpdateDraftOrderItemLines.
    /// </summary>
    /// <param name="pRec">Record "PDC Draft Order Staff Line".</param>
    procedure UpdateDraftOrderItemLines(pRec: Record "PDC Draft Order Staff Line")
    var
        Item: Record Item;
        StaffEntitlement: Record "PDC Staff Entitlement";
        DraftOrderItemLine: Record "PDC Draft Order Item Line";
        LineNo: Integer;
    begin
        exit; // we won't be loading all items to the draft order for now. If it is needed in the future just remove this line.

        Clear(LineNo);
        DraftOrderItemLine.Reset();
        DraftOrderItemLine.SetRange("Document No.", pRec."Document No.");
        DraftOrderItemLine.SetRange("Staff Line No.", pRec."Line No.");
        if DraftOrderItemLine.FindLast() then
            LineNo := DraftOrderItemLine."Line No.";

        pRec.CalcFields("Wardrobe ID");
        StaffEntitlement.Reset();
        StaffEntitlement.SetRange("Staff ID", pRec."Staff ID");
        StaffEntitlement.SetRange("Wardrobe ID", pRec."Wardrobe ID");
        if StaffEntitlement.Findset() then
            repeat
                Item.Reset();
                Item.SetRange("PDC Product Code", StaffEntitlement."Product Code");
                if Item.Findset() then
                    repeat
                        DraftOrderItemLine.Reset();
                        DraftOrderItemLine.SetRange("Document No.", pRec."Document No.");
                        DraftOrderItemLine.SetRange("Staff Line No.", pRec."Line No.");
                        DraftOrderItemLine.SetRange("Item No.", Item."No.");
                        if DraftOrderItemLine.IsEmpty then begin
                            DraftOrderItemLine.Init();
                            DraftOrderItemLine.Validate("Document No.", pRec."Document No.");
                            DraftOrderItemLine."Staff Line No." := pRec."Line No.";
                            LineNo += 10000;
                            DraftOrderItemLine.Validate("Line No.", LineNo);
                            DraftOrderItemLine.Validate("Product Code", StaffEntitlement."Product Code");
                            DraftOrderItemLine.Validate("Item No.", Item."No.");
                            DraftOrderItemLine.Insert(true);
                        end;
                    until Item.next() = 0;

            until StaffEntitlement.next() = 0;
    end;

    local procedure InactivateStaffEntitlementForBranchStaff(BranchStaff: Record "PDC Branch Staff")
    var
        StaffEntitlement: Record "PDC Staff Entitlement";
    begin
        StaffEntitlement.Reset();
        StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
        if not BranchStaff.Blocked then
            StaffEntitlement.SetFilter("Wardrobe ID", '<>%1', BranchStaff."Wardrobe ID");
        StaffEntitlement.SetRange(Inactive, false);
        if StaffEntitlement.IsEmpty then
            exit;

        StaffEntitlement.FindSet();
        repeat
            StaffEntitlement.Validate(Inactive, true);
            StaffEntitlement.Validate("Inactivated Datetime", CurrentDatetime);
            StaffEntitlement.Modify(true);
        until StaffEntitlement.next() = 0;
    end;

    /// <summary>
    /// WardrobeEntitlementExistsForWardrobeHeader.
    /// </summary>
    /// <param name="WardrobeHeader">VAR Record "PDC Wardrobe Header".</param>
    /// <returns>Return variable FoundRecords of type Boolean.</returns>
    procedure WardrobeEntitlementExistsForWardrobeHeader(var WardrobeHeader: Record "PDC Wardrobe Header") FoundRecords: Boolean
    var
        StaffEnt: Record "PDC Staff Entitlement";
        BranchStaff: Record "PDC Branch Staff";
    begin
        StaffEnt.Reset();
        StaffEnt.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
        if (not (StaffEnt.IsEmpty)) then exit(true);

        BranchStaff.Reset();
        BranchStaff.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
        if (not (BranchStaff.IsEmpty)) then exit(true);

        exit(false);
    end;

    /// <summary>
    /// GetQtyIssued.
    /// </summary>
    /// <param name="StaffId">Code[20].</param>
    /// <param name="ProductCode">code[30].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetQtyEntitled(StaffId: Code[20]; ProductCode: code[30]): Decimal
    var
        StaffEntitlement: Record "PDC Staff Entitlement";
        Staff: Record "PDC Branch Staff";
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeGroup: Record "PDC Wardrobe Entitlement Group";
        GroupType: Enum PDCEntitlementGroupType;
    begin
        if Staff.get(StaffId) then
            if Wardrobe.get(Staff."Wardrobe ID") then
                if WardrobeLine.get(Wardrobe."Wardrobe ID", ProductCode) then
                    if Wardrobe."Entitlement By Qty. Group" then
                        if WardrobeGroup.get(WardrobeLine."Wardrobe ID", GroupType::"Quantity Group", WardrobeLine."Entitlement Qty. Group") then
                            exit(WardrobeGroup.Value);

        if StaffEntitlement.Get(staffId, ProductCode, 0, '') then begin
            StaffEntitlement.calcfields("Quantity Entitled in Period");
            exit(StaffEntitlement."Quantity Entitled in Period");
        end;
    end;

    /// <summary>
    /// GetQtyIssued.
    /// </summary>
    /// <param name="StaffId">Code[20].</param>
    /// <param name="ProductCode">code[30].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetQtyIssued(StaffId: Code[20]; ProductCode: code[30]; ModifyRec: Boolean): Decimal
    var
        StaffEntitlement: Record "PDC Staff Entitlement";
        Staff: Record "PDC Branch Staff";
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        GroupType: Enum PDCEntitlementGroupType;
    begin
        if Staff.get(StaffId) then
            if Wardrobe.get(Staff."Wardrobe ID") then
                if WardrobeLine.get(Wardrobe."Wardrobe ID", ProductCode) then
                    if Wardrobe."Entitlement By Qty. Group" then
                        if StaffEntitlement.Get(staffId, '', GroupType::"Quantity Group", WardrobeLine."Entitlement Qty. Group") then begin
                            StaffEntitlement.CalculateQuantities(StaffEntitlement, ModifyRec);
                            exit(StaffEntitlement."Calculated Quantity Issued");
                        end;

        if StaffEntitlement.Get(staffId, ProductCode, 0, '') then begin
            StaffEntitlement.CalculateQuantities(StaffEntitlement, ModifyRec);
            Exit(StaffEntitlement."Calculated Quantity Issued");
        end;
    end;

    /// <summary>
    /// GetsStaffDefaultSize.
    /// </summary>
    /// <param name="StaffId">Code[20].</param>
    /// <param name="ProductCode">code[30].</param>
    /// <param name="Size">VAR Record "PDC Size Scale Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetsStaffDefaultSize(StaffId: Code[20]; ProductCode: code[30]; var Size: Record "PDC Size Scale Line"): Boolean
    var
        SizeScaleHeader: Record "PDC Size Scale Header";
        SizeGroup: Record "PDC Size Group";
        Item: Record Item;
        StaffSizes: Record "PDC Staff Size";
        FromSize: Record "PDC Size Scale Line";
        ToSize: Record "PDC Size Scale Line";
        FromSizeDate: Date;
        found: Boolean;
    begin
        if StaffId = '' then
            exit(false);
        Item.Reset();
        Item.SetRange("PDC Product Code", ProductCode);
        Item.SetRange(Blocked, false);
        if not Item.FindFirst() then
            exit(false)
        else
            if Item."PDC Size Scale Code" = '' then
                exit(false);

        if StaffSizes.get(staffId, Item."PDC Size Scale Code") then begin
            if Size.get(StaffSizes."Size Scale Code", StaffSizes.Size, StaffSizes.Fit) then
                exit(true);
        end
        else
            if SizeScaleHeader.get(Item."PDC Size Scale Code") then
                if SizeGroup.get(SizeScaleHeader."Size Group") then begin
                    SizeScaleHeader.SetRange("Size Group", SizeGroup.Code);
                    SizeScaleHeader.setfilter(Code, '<>%1', Item."PDC Size Scale Code");
                    found := false;
                    clear(FromSizeDate);
                    if SizeScaleHeader.FindSet() then begin
                        repeat
                            if StaffSizes.get(staffId, SizeScaleHeader.Code) then
                                if FromSize.get(StaffSizes."Size Scale Code", StaffSizes.Size, StaffSizes.Fit) then begin
                                    ToSize.Reset();
                                    ToSize.SetCurrentKey("Garment Size", "Garment Fit");
                                    ToSize.setrange("Size Scale Code", Item."PDC Size Scale Code");
                                    ToSize.setfilter("Garment Size", '>=%1', FromSize."Garment Size");
                                    if FromSize.Fit <> '' then
                                        ToSize.setfilter("Garment Fit", '>=%1', FromSize."Garment Fit");
                                    if ToSize.FindFirst() then begin
                                        found := true;
                                        if FromSizeDate <= StaffSizes."Created At" then begin
                                            FromSizeDate := StaffSizes."Created At";
                                            Size := ToSize;
                                        end;
                                    end;
                                end;
                        until (SizeScaleHeader.next() = 0);
                        if found then
                            exit(true);
                    end;
                end;

        exit(false);
    end;
}

