/// <summary>
/// Report PDC Implement Items (ID 50013).
/// </summary>
Report 50013 "PDC Implement Items"
{
    Caption = 'Implement Items';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Creation Engine"; "PDC Item Creation Engine")
        {
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Item No.");

                if Include then begin
                    TestField("Unit Price");

                    Item.Init();
                    Item."No." := "Item No.";
                    Item.Insert(true);

                    ItemUoM.Init();
                    ItemUoM."Item No." := Item."No.";
                    ItemUoM.Code := "Unit of Measure Code";
                    ItemUoM."Qty. per Unit of Measure" := 1;
                    ItemUoM.Insert(true);

                    Item."Base Unit of Measure" := ItemUoM.Code;
                    Item.Description := "Item Description";
                    Item.Modify(true);

                    if ConfigTemplateHeader.Get("Config. Template Code") then begin
                        RecRef.GetTable(Item);
                        Clear(ConfigTemplateMgt);
                        ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader, RecRef);
                        Item.Get(Item."No."); //refresh
                    end;

                    Item.Validate("Item Category Code", "Item Category Code");
                    Item."PDC Product Code" := "Product Code";
                    Item."PDC Size Scale Code" := "Size Scale Code";
                    //Item."PDC SLA" := SLA;
                    Item."PDC Customer No." := "Customer No.";
                    Item."Vendor No." := "Item Creation Engine"."Vendor No.";
                    Item.Validate("PDC Gender", Gender);
                    Item."PDC Colour" := "Colour Code";
                    Item."PDC Colour Description" := "Colour Description";
                    Item."PDC Size" := Size;
                    Item."PDC Size Sequence" := "Size Sequence";
                    Item."PDC Size Description" := "Size Description";
                    Item."PDC Fit" := Fit;
                    Item."PDC Fit Sequence" := "Fit Sequence";
                    Item."PDC Fit Description" := "Fit Description";
                    Item."PDC Source" := Source;
                    Item.Validate("Unit Cost", "Unit Cost");
                    Item.Validate("Vendor Item No.", "Vendor Item No.");
                    Item."PDC Return Period" := "Return Period";
                    item."Lead Time Calculation" := "Lead Time Calculation";
                    item."PDC Contract Item" := "Contract Item";
                    Item.Modify(true);

                    if "Routing No." <> '' then begin
                        Item."Routing No." := "Routing No.";
                        Item."Production BOM No." := Item."No.";
                        Item."Replenishment System" := Item."replenishment system"::"Prod. Order";
                        Item.Modify(true);
                    end;

                    if "Unit Price" <> 0 then begin
                        SalesPrice.Init();
                        SalesPrice."Item No." := Item."No.";
                        if "Customer No." <> '' then begin
                            SalesPrice."Sales Type" := SalesPrice."sales type"::Customer;
                            SalesPrice."Sales Code" := "Customer No.";
                        end
                        else
                            SalesPrice."Sales Type" := SalesPrice."sales type"::"All Customers";
                        SalesPrice."Starting Date" := WorkDate();
                        SalesPrice."Unit of Measure Code" := Item."Base Unit of Measure";
                        SalesPrice."Unit Price" := "Unit Price";
                        SalesPrice.Insert(true);
                    end;

                    if NeedCreateSKU then begin
                        if SKULocationCode <> '' then
                            CreateSKU(Item, SKULocationCode, '');
                        if (SKULocationCode <> '') and (SKUBinCode <> '') then
                            CreateBinContent(Item."No.", SKULocationCode, SKUBinCode);
                    end;

                    if (Item."Vendor No." <> '') and (Item."Vendor Item No." <> '') then begin
                        ItemVendor.Init();
                        ItemVendor."Vendor No." := Item."Vendor No.";
                        ItemVendor."Item No." := Item."No.";
                        ItemVendor."Vendor Item No." := Item."Vendor Item No.";
                        if ItemVendor.Insert() then;
                    end;

                    if (Item."Vendor No." <> '') and (Item."Unit Cost" <> 0) then begin
                        PurchPrice.Init();
                        PurchPrice."Item No." := Item."No.";
                        PurchPrice."Vendor No." := Item."Vendor No.";
                        PurchPrice."Starting Date" := WorkDate();
                        PurchPrice."Unit of Measure Code" := Item."Base Unit of Measure";
                        PurchPrice."Direct Unit Cost" := Item."Unit Cost";
                        if PurchPrice.Insert() then;
                    end;

                    if Item."Production BOM No." <> '' then begin
                        BOMHeader.Init();
                        BOMHeader."No." := Item."Production BOM No.";
                        BOMHeader.Description := Item.Description;
                        BOMHeader."Unit of Measure Code" := Item."Base Unit of Measure";
                        BOMHeader.Insert(true);

                        Clear(BOMLineNo);
                        for i := 1 to 7 do begin
                            Clear(ConsItemNo);

                            case i of
                                1:
                                    ConsItemNo := "Consuming Garmet Item No.";
                                2:
                                    ConsItemNo := "Consuming Brand 1 Item No.";
                                3:
                                    ConsItemNo := "Consuming Brand 2 Item No.";
                                4:
                                    ConsItemNo := "Consuming Brand 3 Item No.";
                                5:
                                    ConsItemNo := "Consuming Brand 4 Item No.";
                                6:
                                    ConsItemNo := "Consuming Brand 5 Item No.";
                                7:
                                    ConsItemNo := "Consuming Brand 6 Item No.";
                            end;
                            //case

                            if ConsItemNo <> '' then begin
                                BOMLineNo += 10000;
                                BOMLine.Init();
                                BOMLine."Production BOM No." := BOMHeader."No.";
                                BOMLine."Line No." := BOMLineNo;
                                BOMLine.Insert(true);
                                BOMLine.Type := BOMLine.Type::Item;
                                BOMLine.Validate("No.", ConsItemNo);
                                BOMLine.Validate(Quantity, 1);
                                BOMLine.Validate("Quantity per", 1);
                                BOMLine.Modify();
                            end;
                        end; //for

                        BOMHeader.Validate(Status, BOMHeader.Status::Certified);
                        BOMHeader.Modify(true);
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Commit();
                DeleteAll();
                Commit();

                if NeedCreateSKU then
                    Page.RunModal(7371);
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Progress1Lbl +
                  Progress2Lbl);

                setrange("Journal Batch Name", ToBatchName);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SourceFld; Source)
                    {
                        ApplicationArea = All;
                        Caption = 'Source';
                        ToolTip = 'Source';
                    }
                    field(NeedCreateSKUFld; NeedCreateSKU)
                    {
                        ApplicationArea = All;
                        Caption = 'Create SKU';
                        ToolTip = 'Create SKU';
                    }
                    field(SKULocationCodeFld; SKULocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        ToolTip = 'Location Code';
                        TableRelation = Location.Code;

                        trigger OnValidate()
                        begin
                            SKUBinCode := '';
                        end;
                    }
                    field(SKUBinCodeFld; SKUBinCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Bin Code';
                        ToolTip = 'Bin Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Bin: Record Bin;
                        begin
                            if SKULocationCode <> '' then begin
                                Bin.SetRange("Location Code", SKULocationCode);
                                if Page.RunModal(0, Bin) = Action::LookupOK then
                                    SKUBinCode := Bin.Code;
                            end
                            else
                                SKUBinCode := '';
                        end;
                    }
                    field(SKUFixedFld; SKUFixed)
                    {
                        ApplicationArea = All;
                        Caption = 'Fixed';
                        ToolTip = 'Fixed';
                    }
                    field(SKUDefaultFld; SKUDefault)
                    {
                        ApplicationArea = All;
                        Caption = 'Default';
                        ToolTip = 'Default';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Item: Record Item;
        ItemUoM: Record "Item Unit of Measure";
        ItemVendor: Record "Item Vendor";
        SalesPrice: Record "Sales Price";
        PurchPrice: Record "Purchase Price";
        BOMHeader: Record "Production BOM Header";
        BOMLine: Record "Production BOM Line";
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
        ToBatchName: code[10];
        Window: Dialog;
        Source: Enum PDCItemSource;
        NeedCreateSKU: Boolean;
        SKULocationCode: Code[10];
        SKUBinCode: Code[20];
        SKUFixed: Boolean;
        SKUDefault: Boolean;
        i: Integer;
        BOMLineNo: Integer;
        ConsItemNo: Code[20];
        Progress1Lbl: label 'Creating Items...\\';
        Progress2Lbl: label 'Item No.               #1##########\', Comment = '%1=item no.';


    procedure Initialize(ToBatchName2: Code[10])
    begin
        ToBatchName := ToBatchName2;
    end;

    local procedure CreateSKU(var Item2: Record Item; LocationCode: Code[10]; VariantCode: Code[10])
    var
        StockkeepingUnit: Record "Stockkeeping Unit";
    begin
        if LocationCode = '' then
            exit;

        if not StockkeepingUnit.Get(LocationCode, Item2."No.", VariantCode) then begin
            StockkeepingUnit.Init();
            StockkeepingUnit."Item No." := Item2."No.";
            StockkeepingUnit."Location Code" := LocationCode;
            StockkeepingUnit."Variant Code" := VariantCode;
            StockkeepingUnit."Shelf No." := Item2."Shelf No.";
            StockkeepingUnit."Standard Cost" := Item2."Standard Cost";
            StockkeepingUnit."Last Direct Cost" := Item2."Last Direct Cost";
            StockkeepingUnit."Unit Cost" := Item2."Unit Cost";
            StockkeepingUnit."Vendor No." := Item2."Vendor No.";
            StockkeepingUnit."Vendor Item No." := Item2."Vendor Item No.";
            StockkeepingUnit."Lead Time Calculation" := Item2."Lead Time Calculation";
            StockkeepingUnit."Reorder Point" := Item2."Reorder Point";
            StockkeepingUnit."Maximum Inventory" := Item2."Maximum Inventory";
            StockkeepingUnit."Reorder Quantity" := Item2."Reorder Quantity";
            StockkeepingUnit."Lot Size" := Item2."Lot Size";
            StockkeepingUnit."Reordering Policy" := Item2."Reordering Policy";
            StockkeepingUnit."Include Inventory" := Item2."Include Inventory";
            StockkeepingUnit."Assembly Policy" := Item2."Assembly Policy";
            StockkeepingUnit."Manufacturing Policy" := Item2."Manufacturing Policy";
            StockkeepingUnit."Discrete Order Quantity" := Item2."Discrete Order Quantity";
            StockkeepingUnit."Minimum Order Quantity" := Item2."Minimum Order Quantity";
            StockkeepingUnit."Maximum Order Quantity" := Item2."Maximum Order Quantity";
            StockkeepingUnit."Safety Stock Quantity" := Item2."Safety Stock Quantity";
            StockkeepingUnit."Order Multiple" := Item2."Order Multiple";
            StockkeepingUnit."Safety Lead Time" := Item2."Safety Lead Time";
            StockkeepingUnit."Flushing Method" := Item2."Flushing Method";
            StockkeepingUnit."Replenishment System" := Item2."Replenishment System";
            StockkeepingUnit."Time Bucket" := Item2."Time Bucket";
            StockkeepingUnit."Rescheduling Period" := Item2."Rescheduling Period";
            StockkeepingUnit."Lot Accumulation Period" := Item2."Lot Accumulation Period";
            StockkeepingUnit."Dampener Period" := Item2."Dampener Period";
            StockkeepingUnit."Dampener Quantity" := Item2."Dampener Quantity";
            StockkeepingUnit."Overflow Level" := Item2."Overflow Level";
            StockkeepingUnit."Last Date Modified" := WorkDate();
            StockkeepingUnit."Special Equipment Code" := Item2."Special Equipment Code";
            StockkeepingUnit."Put-away Template Code" := Item2."Put-away Template Code";
            StockkeepingUnit."Phys Invt Counting Period Code" :=
              Item2."Phys Invt Counting Period Code";
            StockkeepingUnit."Put-away Unit of Measure Code" :=
              Item2."Put-away Unit of Measure Code";
            StockkeepingUnit."Use Cross-Docking" := Item2."Use Cross-Docking";
            StockkeepingUnit.Insert(true);
        end;
    end;

    local procedure CreateBinContent(pItemNo: Code[20]; pLocationCode: Code[10]; pBinCode: Code[20])
    var
        rBinCreationWorksheetLine: Record "Bin Creation Worksheet Line";
        LineNo: Integer;
    begin
        rBinCreationWorksheetLine.Reset();
        if rBinCreationWorksheetLine.FindLast() then
            LineNo := rBinCreationWorksheetLine."Line No." + 10000
        else
            LineNo := 10000;
        rBinCreationWorksheetLine.Init();
        rBinCreationWorksheetLine."Line No." := LineNo;
        rBinCreationWorksheetLine.Validate("Item No.", pItemNo);
        rBinCreationWorksheetLine.Fixed := true;
        rBinCreationWorksheetLine.Default := false;
        rBinCreationWorksheetLine.Type := rBinCreationWorksheetLine.Type::"Bin Content";
        rBinCreationWorksheetLine.Name := 'DEFAULT';
        rBinCreationWorksheetLine."Worksheet Template Name" := 'BINCONTENT';
        rBinCreationWorksheetLine."Location Code" := pLocationCode;
        rBinCreationWorksheetLine."Bin Code" := pBinCode;
        rBinCreationWorksheetLine.Fixed := SKUFixed;
        rBinCreationWorksheetLine.Default := SKUDefault;
        rBinCreationWorksheetLine."User ID" := copystr(UserId, 1, MaxStrLen(rBinCreationWorksheetLine."User ID"));
        rBinCreationWorksheetLine.Insert();
    end;
}

