/// <summary>
/// XmlPort PDC Portal Wardrobe Item List (ID 50038).
/// </summary>
xmlport 50038 "PDC Portal Wardrobe Item List"
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
                textelement(f_wardrobeIDfilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'wardrobeIDFilter';
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
            tableelement(wardrobeheader; "PDC Wardrobe Header")
            {
                MinOccurs = Zero;
                XmlName = 'header';
                UseTemporary = true;
                fieldelement(id; WardrobeHeader."Wardrobe ID")
                {
                }
                fieldelement(description; WardrobeHeader.Description)
                {
                }

            }
            tableelement(item; Item)
            {
                MinOccurs = Zero;
                XmlName = 'item';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(no; Item."No.")
                {
                }
                fieldelement(name; Item.Description)
                {
                }
                fieldelement(productCode; Item."PDC Product Code")
                {
                }
                fieldelement(colour; Item."PDC Colour")
                {
                }
                fieldelement(gender; Item."PDC Gender")
                {
                }
                textelement(imageUrl)
                {
                }
                textelement(wardrobeUrl)
                {
                }
                tableelement(itemWardrobes; "PDC Wardrobe Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'itemWardrobes';
                    LinkTable = Item;
                    LinkFields = "Product Code" = field("PDC Product Code");
                    SourceTableView = where(Discontinued = const(false));

                    textattribute(jsonarray2)
                    {
                        Occurrence = Optional;
                        XmlName = 'json_Array';
                    }
                    fieldelement(wardrobeID; itemWardrobes."Wardrobe ID")
                    {
                    }
                    textelement(wardrobeName)
                    {
                        trigger OnBeforePassVariable()
                        var
                            Wardrobe: Record "PDC Wardrobe Header";
                        begin
                            clear(wardrobeName);
                            if Wardrobe.get(itemWardrobes."Wardrobe ID") then
                                wardrobeName := Wardrobe.Description;
                        end;
                    }
                    fieldelement(entitlementQty; itemWardrobes."Quantity Entitled in Period")
                    {
                    }
                    fieldelement(entitlementPeriod; itemWardrobes."Entitlement Period")
                    {
                    }
                    fieldelement(itemType; itemWardrobes."Item Type")
                    {
                    }
                    tableelement(itemColours; "PDC Wardrobe Item Option")
                    {
                        MinOccurs = Zero;
                        XmlName = 'itemColours';
                        LinkTable = itemWardrobes;
                        LinkFields = "Wardrobe ID" = field("Wardrobe ID"), "Product Code" = field("Product Code");
                        textattribute(jsonarray3)
                        {
                            Occurrence = Optional;
                            XmlName = 'json_Array';
                        }
                        fieldelement(colour; itemColours."Colour Code")
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    var
                        WardrobeHeader1: Record "PDC Wardrobe Header";
                        PortalUserWardrobe: Record "PDC Portal User Wardrobe";
                    begin
                        if WardrobeHeader1.get(itemWardrobes."Wardrobe ID") and WardrobeHeader1.Disable then
                            currXMLport.Skip();

                        PortalUserWardrobe.Reset();
                        PortalUserWardrobe.SetRange("Portal User ID", PortalUserLocal.Id);
                        PortalUserWardrobe.SetRange("Sell-To Customer No.", PortalUserLocal."Customer No.");
                        if not PortalUserWardrobe.IsEmpty() then
                            if not PortalUserWardrobe.get(PortalUserLocal.Id, PortalUserLocal."Customer No.", WardrobeHeader1."Wardrobe ID") then
                                currXMLport.Skip()
                    end;
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
        jsonarray2 := 'true';
        jsonarray3 := 'true';
    end;

    var
        PortalUserLocal: Record "PDC Portal User";
        CustPortalMgt: Codeunit "PDC Portal Mgt";
        CustomerNo: Code[20];

    /// <summary>
    /// InitData.
    /// </summary>
    procedure InitData()
    begin
        Paging.Reset();
        Paging.DeleteAll();
    end;

    /// <summary>
    /// GetFilters.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="ItemDb">VAR Record Item.</param>
    Procedure GetFilters(var parWardrobeID: Code[20])
    begin
        parWardrobeID := f_wardrobeIDfilter;
    end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="ItemDb">VAR Record Item.</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User"; var ItemDb: Record Item)
    var
        WardrobeHeaderDb: Record "PDC Wardrobe Header";
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        PortalUserLocal := PortalUser;

        if searchTerm <> '' then begin
            ItemDb.FilterGroup(-1);
            ItemDb.SetFilter(Description, '@*' + searchTerm + '*');
            ItemDb.SetFilter("Description 2", '@*' + searchTerm + '*');
            ItemDb.SetFilter("Vendor Item No.", '@*' + searchTerm + '*');
            ItemDb.SetFilter("Block Reason", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Product Description", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Style Description", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Colour Description", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Size Description", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Fit Description", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Branding Description", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Web Picture Path", '@*' + searchTerm + '*');
            ItemDb.SetFilter("PDC Product Code", '@*' + searchTerm + '*');
            ItemDb.FilterGroup(0);
        end;

        //load records
        Item.Reset();
        Item.DeleteAll();
        if not Paging.FindSet() then begin
            if (ItemDb.FindSet()) then
                repeat
                    Item.TransferFields(ItemDb);
                    Item.Insert();
                until ItemDb.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(ItemDb.Count);

            if (ItemDb.FindSet()) then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := ItemDB.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        Item.TransferFields(ItemDb);
                        Item.Insert();
                        RecordsToRead -= 1;
                    until ((ItemDb.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;

        CustPortalMgt.GetCustomerNumber(PortalUser, CustomerNo);
        itemWardrobes.SetRange("Customer No.", CustomerNo);
        if f_wardrobeIDfilter <> '' then begin
            itemWardrobes.setfilter("Wardrobe ID", f_wardrobeIDfilter);
            if WardrobeHeaderDb.get(f_wardrobeIDfilter) then begin
                wardrobeheader := WardrobeHeaderDb;
                if wardrobeheader.insert() then;
            end;
        end;
    end;
}

