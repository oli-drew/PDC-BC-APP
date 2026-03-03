/// <summary>
/// Report PDC Create Stockkeeping Unit (ID 50054).
/// </summary>
Report 50054 "PDC Create Stockkeeping Unit"
{
    AdditionalSearchTerms = 'create sku';
    ApplicationArea = Warehouse;
    Caption = 'PDC Create Stockkeeping Unit';
    ProcessingOnly = true;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Inventory Posting Group", "Location Filter", "Variant Filter";

            trigger OnAfterGetRecord()
            var
                ItemVariant: Record "Item Variant";
            begin
                if SaveFilters then begin
                    LocationFilter := GetFilter("Location Filter");
                    VariantFilter := GetFilter("Variant Filter");
                    SaveFilters := false;
                end;
                SetFilter("Location Filter", LocationFilter);
                SetFilter("Variant Filter", VariantFilter);

                Location.SetFilter(Code, GetFilter("Location Filter"));

                if ReplacePreviousSKUs then begin
                    StockkeepingUnit.Reset();
                    StockkeepingUnit.SetRange("Item No.", "No.");
                    if GetFilter("Variant Filter") <> '' then
                        StockkeepingUnit.SetFilter("Variant Code", GetFilter("Variant Filter"));
                    if GetFilter("Location Filter") <> '' then
                        StockkeepingUnit.SetFilter("Location Code", GetFilter("Location Filter"));
                    StockkeepingUnit.DeleteAll();
                end;

                DialogWindow.Update(1, "No.");
                ItemVariant.SetRange("Item No.", "No.");
                ItemVariant.SetFilter(Code, GetFilter("Variant Filter"));
                case true of
                    (SKUCreationMethod = Skucreationmethod::Location) or
                    ((SKUCreationMethod = Skucreationmethod::"Location & Variant") and
                     (not ItemVariant.Findfirst())):
                        if Location.Findset() then
                            repeat
                                DialogWindow.Update(2, Location.Code);
                                SetRange("Location Filter", Location.Code);
                                CreateSKUIfRequired(Item, Location.Code, '');
                            until Location.next() = 0;
                    (SKUCreationMethod = Skucreationmethod::Variant) or
                    ((SKUCreationMethod = Skucreationmethod::"Location & Variant") and
                     (not Location.Findfirst())):
                        if ItemVariant.FindSet() then
                            repeat
                                DialogWindow.Update(3, ItemVariant.Code);
                                SetRange("Variant Filter", ItemVariant.Code);
                                CreateSKUIfRequired(Item, '', ItemVariant.Code);
                            until ItemVariant.next() = 0;
                    (SKUCreationMethod = Skucreationmethod::"Location & Variant"):
                        if Location.Findset() then
                            repeat
                                DialogWindow.Update(2, Location.Code);
                                SetRange("Location Filter", Location.Code);
                                if ItemVariant.Findset() then
                                    repeat
                                        DialogWindow.Update(3, ItemVariant.Code);
                                        SetRange("Variant Filter", ItemVariant.Code);
                                        CreateSKUIfRequired(Item, Location.Code, ItemVariant.Code);
                                    until ItemVariant.next() = 0;
                            until Location.next() = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                DialogWindow.Close();
            end;

            trigger OnPreDataItem()
            begin
                Location.SetRange("Use As In-Transit", false);

                DialogWindow.Open(
                  Progress1Txt +
                  Progress2Txt +
                  Progress3Txt);

                SaveFilters := true;
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
                    field(SKUCreationMethodFld; SKUCreationMethod)
                    {
                        ApplicationArea = Location;
                        Caption = 'Create Per';
                        OptionCaption = 'Location,Variant,Location & Variant';
                        ToolTip = 'Specifies if you want to create stockkeeping units per location or per variant or per location combined with variant.';
                    }
                    field(ItemInInventoryOnlyFld; ItemInInventoryOnly)
                    {
                        ApplicationArea = Location;
                        Caption = 'Item In Inventory Only';
                        ToolTip = 'Specifies if you only want the batch job to create stockkeeping units for items that are in your inventory (that is, for items where the value in the Inventory field is above 0).';
                    }
                    field(ReplacePreviousSKUsFld; ReplacePreviousSKUs)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Replace Previous SKUs';
                        ToolTip = 'Specifies if you want the batch job to replace all previous created stockkeeping units on the items you have included in the batch job.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
        end;
    }

    labels
    {
    }

    var
        StockkeepingUnit: Record "Stockkeeping Unit";
        Location: Record Location;
        DialogWindow: Dialog;
        SKUCreationMethod: Option Location,Variant,"Location & Variant";
        ItemInInventoryOnly: Boolean;
        ReplacePreviousSKUs: Boolean;
        SaveFilters: Boolean;
        LocationFilter: Text;
        VariantFilter: Text;
        Progress1Txt: label 'Item No.       #1##################\', Comment = '%1=item no.';
        Progress2Txt: label 'Location Code  #2########\', Comment = '%1=locatin code';
        Progress3Txt: label 'Variant Code   #3########\', Comment = '%1=variant code';

    /// <summary>
    /// CreateSKUIfRequired.
    /// </summary>
    /// <param name="Item2">VAR Record Item.</param>
    /// <param name="LocationCode">Code[10].</param>
    /// <param name="VariantCode">Code[10].</param>
    procedure CreateSKUIfRequired(var Item2: Record Item; LocationCode: Code[10]; VariantCode: Code[10])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateSKU(Item2, LocationCode, VariantCode, ItemInInventoryOnly, IsHandled);
        if IsHandled then
            exit;

        Item2.CalcFields(Inventory);
        if (ItemInInventoryOnly and (Item2.Inventory > 0)) or
           (not ItemInInventoryOnly)
        then
            if not StockkeepingUnit.Get(LocationCode, Item2."No.", VariantCode) then
                CreateSKU(Item2, LocationCode, VariantCode);
    end;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="CreatePerOption">Option Location,Variant,Location and Variant".</param>
    /// <param name="NewItemInInventoryOnly">Boolean.</param>
    /// <param name="NewReplacePreviousSKUs">Boolean.</param>
    procedure InitializeRequest(CreatePerOption: Option Location,Variant,"Location & Variant"; NewItemInInventoryOnly: Boolean; NewReplacePreviousSKUs: Boolean)
    begin
        SKUCreationMethod := CreatePerOption;
        ItemInInventoryOnly := NewItemInInventoryOnly;
        ReplacePreviousSKUs := NewReplacePreviousSKUs;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSKU(var Item: Record Item; LocationCode: Code[10]; VariantCode: Code[10]; ItemInInventoryOnly: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStockkeepingUnitInsert(var StockkeepingUnit: Record "Stockkeeping Unit"; Item: Record Item)
    begin
    end;

    /// <summary>
    /// CreateSKU.
    /// </summary>
    /// <param name="Item2">VAR Record Item.</param>
    /// <param name="LocationCode">Code[10].</param>
    /// <param name="VariantCode">Code[10].</param>
    procedure CreateSKU(var Item2: Record Item; LocationCode: Code[10]; VariantCode: Code[10])
    begin
        StockkeepingUnit.Init();
        StockkeepingUnit."Item No." := Item2."No.";
        StockkeepingUnit."Location Code" := LocationCode;
        StockkeepingUnit."Variant Code" := VariantCode;
        StockkeepingUnit.CopyFromItem(Item2);
        StockkeepingUnit."Last Date Modified" := WorkDate();
        StockkeepingUnit."Special Equipment Code" := Item2."Special Equipment Code";
        StockkeepingUnit."Put-away Template Code" := Item2."Put-away Template Code";
        StockkeepingUnit.SetHideValidationDialog(true);
        StockkeepingUnit.Validate("Phys Invt Counting Period Code", Item2."Phys Invt Counting Period Code");
        StockkeepingUnit."Put-away Unit of Measure Code" := Item2."Put-away Unit of Measure Code";
        StockkeepingUnit."Use Cross-Docking" := Item2."Use Cross-Docking";
        OnBeforeStockkeepingUnitInsert(StockkeepingUnit, Item2);
        StockkeepingUnit.Insert(true);
    end;
}

