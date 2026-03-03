/// <summary>
/// Codeunit PDC Carbonfact Tests (ID 50500).
/// Automated tests for Carbonfact integration reports.
/// </summary>
codeunit 50500 "PDC Carbonfact Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "PDC Test Library";
        ProductDataExport: Report "PDC CF Product Data Export";
        PurchaseExport: Report "PDC CF Purchase Export";
        ImportCO2e: Report "PDC CF Import CO2e";
        IsInitialized: Boolean;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
    end;

    // =================================================================
    // ParseAttributeName Tests
    // =================================================================

    [Test]
    procedure ParseAttributeName_FullFormat()
    var
        Material: Text;
        Construction: Text;
        RecycledStatus: Text;
    begin
        // [GIVEN] Attribute name in full 4-part format: "Material, Construction, Recycled, (ID)"
        // [WHEN] ParseAttributeName is called
        ProductDataExport.ParseAttributeName('Polyester, Woven, Non-Recycled, (12)', Material, Construction, RecycledStatus);

        // [THEN] All three parts are extracted correctly
        Assert.AreEqual('Polyester', Material, 'Material should be Polyester');
        Assert.AreEqual('Woven', Construction, 'Construction should be Woven');
        Assert.AreEqual('Non-Recycled', RecycledStatus, 'RecycledStatus should be Non-Recycled');
    end;

    [Test]
    procedure ParseAttributeName_MaterialOnly()
    var
        Material: Text;
        Construction: Text;
        RecycledStatus: Text;
    begin
        // [GIVEN] Attribute name with only material (no commas)
        // [WHEN] ParseAttributeName is called
        ProductDataExport.ParseAttributeName('Leather', Material, Construction, RecycledStatus);

        // [THEN] Only Material is populated
        Assert.AreEqual('Leather', Material, 'Material should be Leather');
        Assert.AreEqual('', Construction, 'Construction should be empty');
        Assert.AreEqual('', RecycledStatus, 'RecycledStatus should be empty');
    end;

    [Test]
    procedure ParseAttributeName_TwoParts()
    var
        Material: Text;
        Construction: Text;
        RecycledStatus: Text;
    begin
        // [GIVEN] Attribute name with two parts: "Material, Construction"
        // [WHEN] ParseAttributeName is called
        ProductDataExport.ParseAttributeName('Cotton, Knitted', Material, Construction, RecycledStatus);

        // [THEN] Material and Construction are populated, RecycledStatus is empty
        Assert.AreEqual('Cotton', Material, 'Material should be Cotton');
        Assert.AreEqual('Knitted', Construction, 'Construction should be Knitted');
        Assert.AreEqual('', RecycledStatus, 'RecycledStatus should be empty');
    end;

    [Test]
    procedure ParseAttributeName_RecycledVariant()
    var
        Material: Text;
        Construction: Text;
        RecycledStatus: Text;
    begin
        // [GIVEN] Attribute name with Recycled status
        // [WHEN] ParseAttributeName is called
        ProductDataExport.ParseAttributeName('Nylon, Knitted, Recycled, (27)', Material, Construction, RecycledStatus);

        // [THEN] Recycled status is correctly parsed
        Assert.AreEqual('Nylon', Material, 'Material should be Nylon');
        Assert.AreEqual('Knitted', Construction, 'Construction should be Knitted');
        Assert.AreEqual('Recycled', RecycledStatus, 'RecycledStatus should be Recycled');
    end;

    // =================================================================
    // GetItemCOO Tests
    // =================================================================

    [Test]
    procedure GetItemCOO_FromItem()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Code[10];
    begin
        // [GIVEN] Item with Country/Region of Origin Code set
        Initialize();
        CreateTestItem(Item, 'T-COO-01');
        Item."Country/Region of Origin Code" := 'GB';
        Item.Modify(false);

        CreateTestItemCategory(ItemCategory, 'T-COO-CAT');
        ItemCategory."PDC CF Default COO" := 'CN';
        ItemCategory.Modify(false);

        // [WHEN] GetItemCOO is called
        Result := ProductDataExport.GetItemCOO(Item, ItemCategory);

        // [THEN] Item's own COO is returned (not category fallback)
        Assert.AreEqual('GB', Result, 'Should return item COO');
    end;

    [Test]
    procedure GetItemCOO_FallbackToCategory()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Code[10];
    begin
        // [GIVEN] Item with no Country/Region of Origin Code
        Initialize();
        CreateTestItem(Item, 'T-COO-02');

        CreateTestItemCategory(ItemCategory, 'T-COO-CT2');
        ItemCategory."PDC CF Default COO" := 'CN';
        ItemCategory.Modify(false);

        // [WHEN] GetItemCOO is called
        Result := ProductDataExport.GetItemCOO(Item, ItemCategory);

        // [THEN] Category default is returned
        Assert.AreEqual('CN', Result, 'Should return category default COO');
    end;

    // =================================================================
    // GetItemMass Tests
    // =================================================================

    [Test]
    procedure GetItemMass_FromItem()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Decimal;
    begin
        // [GIVEN] Item with Net Weight set
        Initialize();
        CreateTestItem(Item, 'T-MASS-01');
        Item."Net Weight" := 0.75;
        Item.Modify(false);

        CreateTestItemCategory(ItemCategory, 'T-MASS-CT');
        ItemCategory."PDC CF Default Mass" := 1.5;
        ItemCategory.Modify(false);

        // [WHEN] GetItemMass is called
        Result := ProductDataExport.GetItemMass(Item, ItemCategory);

        // [THEN] Item's own mass is returned
        Assert.AreNearlyEqual(0.75, Result, 0.001, 'Should return item mass');
    end;

    [Test]
    procedure GetItemMass_FallbackToCategory()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Decimal;
    begin
        // [GIVEN] Item with Net Weight = 0
        Initialize();
        CreateTestItem(Item, 'T-MASS-02');

        CreateTestItemCategory(ItemCategory, 'T-MASS-C2');
        ItemCategory."PDC CF Default Mass" := 1.5;
        ItemCategory.Modify(false);

        // [WHEN] GetItemMass is called
        Result := ProductDataExport.GetItemMass(Item, ItemCategory);

        // [THEN] Category default mass is returned
        Assert.AreNearlyEqual(1.5, Result, 0.001, 'Should return category default mass');
    end;

    // =================================================================
    // BuildCareLabel Tests
    // =================================================================

    [Test]
    procedure BuildCareLabel_MultiFabric_SortedDescending()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Text;
    begin
        // [GIVEN] Item with 3 fabric attributes at different percentages
        Initialize();
        CreateTestItem(Item, 'T-CARE-01');
        CreateTestItemCategory(ItemCategory, 'T-CARE-CT');

        // Attr 12: Polyester, Woven, Non-Recycled = 25%
        CreateTestItemAttribute(12, 'Polyester, Woven, Non-Recycled, (12)');
        CreateTestAttrValueAndMapping(12, Item."No.", 25);

        // Attr 16: Cotton, Woven, Non-Recycled = 45%
        CreateTestItemAttribute(16, 'Cotton, Woven, Non-Recycled, (16)');
        CreateTestAttrValueAndMapping(16, Item."No.", 45);

        // Attr 24: Nylon, Woven, Recycled = 30%
        CreateTestItemAttribute(24, 'Nylon, Woven, Recycled, (24)');
        CreateTestAttrValueAndMapping(24, Item."No.", 30);

        // [WHEN] BuildCareLabel is called
        Result := ProductDataExport.BuildCareLabel(Item."No.", ItemCategory);

        // [THEN] Components sorted descending by percentage: 45% Cotton, 30% Nylon, 25% Polyester
        Assert.AreEqual(
            '45% Non-Recycled Cotton 30% Recycled Nylon 25% Non-Recycled Polyester',
            Result,
            'Care label should be sorted descending by percentage');
    end;

    [Test]
    procedure BuildCareLabel_SingleFabric()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Text;
    begin
        // [GIVEN] Item with single fabric attribute
        Initialize();
        CreateTestItem(Item, 'T-CARE-02');
        CreateTestItemCategory(ItemCategory, 'T-CARE-C2');

        CreateTestItemAttribute(14, 'Polyester, Knitted, Non-Recycled, (14)');
        CreateTestAttrValueAndMapping(14, Item."No.", 100);

        // [WHEN] BuildCareLabel is called
        Result := ProductDataExport.BuildCareLabel(Item."No.", ItemCategory);

        // [THEN] Single entry care label
        Assert.AreEqual('100% Non-Recycled Polyester', Result, 'Should show 100% single fabric');
    end;

    [Test]
    procedure BuildCareLabel_NoAttributes_FallbackToCategory()
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        Result: Text;
    begin
        // [GIVEN] Item with no fabric attributes
        Initialize();
        CreateTestItem(Item, 'T-CARE-03');
        CreateTestItemCategory(ItemCategory, 'T-CARE-C3');
        ItemCategory."PDC CF Default Care Label" := '100% Polyester';
        ItemCategory.Modify(false);

        // [WHEN] BuildCareLabel is called
        Result := ProductDataExport.BuildCareLabel(Item."No.", ItemCategory);

        // [THEN] Category default care label is returned
        Assert.AreEqual('100% Polyester', Result, 'Should fallback to category default care label');
    end;

    // =================================================================
    // PropagateCO2e Tests
    // =================================================================

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure PropagateCO2e_CopiesFromConsumingItem()
    var
        ProdItem: Record Item;
        ConsumingItem: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
    begin
        // [GIVEN] Production item with BOM pointing to consuming item that has CO2e
        Initialize();

        // Create consuming item with CO2e value
        CreateTestItem(ConsumingItem, 'T-CO2-SRC');
        ConsumingItem."PDC Carbon Emissions CO2e" := 12.345;
        ConsumingItem.Modify(false);

        // Create production BOM
        ProdBOMHeader.Init();
        ProdBOMHeader."No." := 'T-BOM-CO2';
        ProdBOMHeader.Status := ProdBOMHeader.Status::Certified;
        if not ProdBOMHeader.Insert(false) then
            ProdBOMHeader.Modify(false);

        ProdBOMLine.Init();
        ProdBOMLine."Production BOM No." := 'T-BOM-CO2';
        ProdBOMLine."Line No." := 10000;
        ProdBOMLine.Type := ProdBOMLine.Type::Item;
        ProdBOMLine."No." := ConsumingItem."No.";
        ProdBOMLine."Quantity per" := 1;
        if not ProdBOMLine.Insert(false) then
            ProdBOMLine.Modify(false);

        // Create production item linked to BOM, Carbonfact enabled
        CreateTestItem(ProdItem, 'T-CO2-TGT');
        ProdItem."PDC Carbonfact Enabled" := true;
        ProdItem."Production BOM No." := 'T-BOM-CO2';
        ProdItem.Modify(false);

        // [WHEN] PropagateCO2e is called
        ImportCO2e.PropagateCO2eToProductionItems();

        // [THEN] Production item has CO2e from consuming item
        ProdItem.Get(ProdItem."No.");
        Assert.AreNearlyEqual(12.345, ProdItem."PDC Carbon Emissions CO2e", 0.001, 'CO2e should be copied from consuming item');
    end;

    [Test]
    [HandlerFunctions('MessageHandler')]
    procedure PropagateCO2e_NoBOMLine10000_SkipsItem()
    var
        ProdItem: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
    begin
        // [GIVEN] Production item with BOM that has NO line 10000
        Initialize();

        ProdBOMHeader.Init();
        ProdBOMHeader."No." := 'T-BOM-SKIP';
        ProdBOMHeader.Status := ProdBOMHeader.Status::Certified;
        if not ProdBOMHeader.Insert(false) then
            ProdBOMHeader.Modify(false);

        CreateTestItem(ProdItem, 'T-CO2-SKP');
        ProdItem."PDC Carbonfact Enabled" := true;
        ProdItem."Production BOM No." := 'T-BOM-SKIP';
        ProdItem."PDC Carbon Emissions CO2e" := 0;
        ProdItem.Modify(false);

        // [WHEN] PropagateCO2e is called
        ImportCO2e.PropagateCO2eToProductionItems();

        // [THEN] Production item CO2e remains 0 (unchanged)
        ProdItem.Get(ProdItem."No.");
        Assert.AreNearlyEqual(0, ProdItem."PDC Carbon Emissions CO2e", 0.001, 'CO2e should remain 0 when no BOM line 10000');
    end;

    // =================================================================
    // GetOrderDate Tests
    // =================================================================

    [Test]
    procedure GetOrderDate_FromPostedPurchaseInvoice()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        Result: Date;
        EntryNo: Integer;
    begin
        // [GIVEN] ILE with a Value Entry pointing to a Posted Purchase Invoice
        Initialize();
        EntryNo := GetNextILEEntryNo();

        ItemLedgerEntry.Init();
        ItemLedgerEntry."Entry No." := EntryNo;
        ItemLedgerEntry."Posting Date" := 20260215D;
        ItemLedgerEntry."Document No." := 'T-RCPT-01';
        ItemLedgerEntry.Insert(false);

        PurchInvHeader.Init();
        PurchInvHeader."No." := 'T-PINV-01';
        PurchInvHeader."Order Date" := 20260110D;
        if not PurchInvHeader.Insert(false) then
            PurchInvHeader.Modify(false);

        ValueEntry.Init();
        ValueEntry."Entry No." := GetNextValueEntryNo();
        ValueEntry."Item Ledger Entry No." := EntryNo;
        ValueEntry."Document Type" := ValueEntry."Document Type"::"Purchase Invoice";
        ValueEntry."Document No." := 'T-PINV-01';
        ValueEntry.Insert(false);

        // [WHEN] GetOrderDate is called
        Result := PurchaseExport.GetOrderDate(ItemLedgerEntry);

        // [THEN] Order Date from Posted Purchase Invoice is returned
        Assert.AreEqual(20260110D, Result, 'Should return Order Date from Purch. Inv. Header');
    end;

    [Test]
    procedure GetOrderDate_FallbackToPurchReceipt()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Result: Date;
    begin
        // [GIVEN] ILE with no Value Entry but a matching Purchase Receipt
        Initialize();

        PurchRcptHeader.Init();
        PurchRcptHeader."No." := 'T-RCPT-02';
        PurchRcptHeader."Order Date" := 20260105D;
        if not PurchRcptHeader.Insert(false) then
            PurchRcptHeader.Modify(false);

        ItemLedgerEntry.Init();
        ItemLedgerEntry."Entry No." := GetNextILEEntryNo();
        ItemLedgerEntry."Posting Date" := 20260215D;
        ItemLedgerEntry."Document No." := 'T-RCPT-02';
        ItemLedgerEntry.Insert(false);

        // [WHEN] GetOrderDate is called
        Result := PurchaseExport.GetOrderDate(ItemLedgerEntry);

        // [THEN] Order Date from Purchase Receipt Header is returned
        Assert.AreEqual(20260105D, Result, 'Should return Order Date from Purch. Rcpt. Header');
    end;

    [Test]
    procedure GetOrderDate_FallbackToPostingDate()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Result: Date;
    begin
        // [GIVEN] ILE with no Value Entry and no matching Purchase Receipt
        Initialize();

        ItemLedgerEntry.Init();
        ItemLedgerEntry."Entry No." := GetNextILEEntryNo();
        ItemLedgerEntry."Posting Date" := 20260215D;
        ItemLedgerEntry."Document No." := 'T-RCPT-NONE';
        ItemLedgerEntry.Insert(false);

        // [WHEN] GetOrderDate is called
        Result := PurchaseExport.GetOrderDate(ItemLedgerEntry);

        // [THEN] Posting Date is returned as last resort
        Assert.AreEqual(20260215D, Result, 'Should return ILE Posting Date as fallback');
    end;

    [Test]
    procedure GetOrderDate_BlankInvoiceOrderDate_FallsThrough()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Result: Date;
        EntryNo: Integer;
    begin
        // [GIVEN] ILE with Posted Purchase Invoice that has blank Order Date,
        //         but a Purchase Receipt with a valid Order Date
        Initialize();
        EntryNo := GetNextILEEntryNo();

        PurchInvHeader.Init();
        PurchInvHeader."No." := 'T-PINV-BL';
        PurchInvHeader."Order Date" := 0D;
        if not PurchInvHeader.Insert(false) then
            PurchInvHeader.Modify(false);

        ValueEntry.Init();
        ValueEntry."Entry No." := GetNextValueEntryNo();
        ValueEntry."Item Ledger Entry No." := EntryNo;
        ValueEntry."Document Type" := ValueEntry."Document Type"::"Purchase Invoice";
        ValueEntry."Document No." := 'T-PINV-BL';
        ValueEntry.Insert(false);

        PurchRcptHeader.Init();
        PurchRcptHeader."No." := 'T-RCPT-BL';
        PurchRcptHeader."Order Date" := 20260120D;
        if not PurchRcptHeader.Insert(false) then
            PurchRcptHeader.Modify(false);

        ItemLedgerEntry.Init();
        ItemLedgerEntry."Entry No." := EntryNo;
        ItemLedgerEntry."Posting Date" := 20260215D;
        ItemLedgerEntry."Document No." := 'T-RCPT-BL';
        ItemLedgerEntry.Insert(false);

        // [WHEN] GetOrderDate is called
        Result := PurchaseExport.GetOrderDate(ItemLedgerEntry);

        // [THEN] Falls through to Purchase Receipt Order Date
        Assert.AreEqual(20260120D, Result, 'Should skip blank invoice Order Date and use Purch. Rcpt. Header');
    end;

    // =================================================================
    // Helper Procedures
    // =================================================================

    local procedure GetNextILEEntryNo(): Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if ItemLedgerEntry.FindLast() then
            exit(ItemLedgerEntry."Entry No." + 1);
        exit(1);
    end;

    local procedure GetNextValueEntryNo(): Integer
    var
        ValueEntry: Record "Value Entry";
    begin
        if ValueEntry.FindLast() then
            exit(ValueEntry."Entry No." + 1);
        exit(1);
    end;

    local procedure CreateTestItem(var Item: Record Item; ItemNo: Code[20])
    begin
        Item.Init();
        Item."No." := ItemNo;
        Item.Description := 'Test Item ' + ItemNo;
        if not Item.Insert(false) then
            Item.Modify(false);
    end;

    local procedure CreateTestItemCategory(var ItemCategory: Record "Item Category"; CategoryCode: Code[20])
    begin
        ItemCategory.Init();
        ItemCategory.Code := CategoryCode;
        ItemCategory.Description := 'Test Category ' + CategoryCode;
        if not ItemCategory.Insert(false) then
            ItemCategory.Modify(false);
    end;

    local procedure CreateTestItemAttribute(AttrID: Integer; AttrName: Text[250])
    var
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttribute.Init();
        ItemAttribute.ID := AttrID;
        ItemAttribute.Name := AttrName;
        ItemAttribute.Type := ItemAttribute.Type::Decimal;
        if not ItemAttribute.Insert(false) then
            ItemAttribute.Modify(false);
    end;

    local procedure CreateTestAttrValueAndMapping(AttrID: Integer; ItemNo: Code[20]; Percentage: Decimal)
    var
        ItemAttrValue: Record "Item Attribute Value";
        ItemAttrValueMapping: Record "Item Attribute Value Mapping";
        ValueID: Integer;
    begin
        // Find next available value ID for this attribute
        ItemAttrValue.SetRange("Attribute ID", AttrID);
        if ItemAttrValue.FindLast() then
            ValueID := ItemAttrValue.ID + 1
        else
            ValueID := 1;

        ItemAttrValue.Init();
        ItemAttrValue."Attribute ID" := AttrID;
        ItemAttrValue.ID := ValueID;
        ItemAttrValue.Value := Format(Percentage);
        ItemAttrValue."Numeric Value" := Percentage;
        if not ItemAttrValue.Insert(false) then
            ItemAttrValue.Modify(false);

        ItemAttrValueMapping.Init();
        ItemAttrValueMapping."Table ID" := Database::Item;
        ItemAttrValueMapping."No." := ItemNo;
        ItemAttrValueMapping."Item Attribute ID" := AttrID;
        ItemAttrValueMapping."Item Attribute Value ID" := ValueID;
        if not ItemAttrValueMapping.Insert(false) then
            ItemAttrValueMapping.Modify(false);
    end;

    [MessageHandler]
    procedure MessageHandler(Message: Text[1024])
    begin
        // Suppress message dialogs during test execution
    end;
}
