/// <summary>
/// XmlPort PDC Portal Wardrobe List (ID 50014).
/// </summary>
xmlport 50014 "PDC Portal Wardrobe List"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
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
            tableelement(WardrobeHeader; "PDC Wardrobe Header")
            {
                MinOccurs = Zero;
                UseTemporary = true;
                XmlName = 'wardrobe';
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(id; WardrobeHeader."Wardrobe ID")
                {
                }
                fieldelement(description; WardrobeHeader.Description)
                {
                }
                textelement(coreItems)
                {
                    MinOccurs = Zero;
                }
                textelement(accesoryItems)
                {
                    MinOccurs = Zero;
                }
                textelement(staffAssigned)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    Lines: Record "PDC Wardrobe Line";
                    Staff: Record "PDC Branch Staff";
                begin
                    Lines.setrange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
                    Lines.setrange(Discontinued, false);
                    Lines.setrange("Item Type", Lines."Item Type"::Core);
                    coreItems := format(Lines.Count, 0, 9);
                    Lines.setrange("Item Type", Lines."Item Type"::Accessory);
                    accesoryItems := format(Lines.Count, 0, 9);

                    Staff.setrange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
                    Staff.setrange(Blocked, false);
                    staffAssigned := format(Staff.Count, 0, 9);
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
    /// <param name="NavPortalUser">Record "PDC Portal User".</param>
    procedure FilterData(NavPortalUser: Record "PDC Portal User")
    var
        WardrobeHeaderDB: Record "PDC Wardrobe Header";
        PDCPortalMgt: Codeunit "PDC Portal Mgt";
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;

    begin
        WardrobeHeader.Reset();
        WardrobeHeader.DeleteAll();

        WardrobeHeaderDB.Reset();
        PDCPortalMgt.FilterWardrobes(NavPortalUser, WardrobeHeaderDB);

        if searchTerm <> '' then begin
            wardrobeheaderDB.FilterGroup(-1);
            wardrobeheaderDB.SetFilter("Customer Name", '@*' + searchTerm + '*');
            wardrobeheaderDB.SetFilter(Description, '@*' + searchTerm + '*');
            wardrobeheaderDB.SetFilter("Wardrobe ID", '@*' + searchTerm + '*');
            wardrobeheaderDB.FilterGroup(0);
        end;

        if not Paging.FindSet() then begin
            if WardrobeHeaderDB.FindSet() then
                repeat
                    WardrobeHeader.TransferFields(WardrobeHeaderDB);
                    WardrobeHeader.Insert();
                until WardrobeHeaderDB.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(WardrobeHeaderDB.Count);

            if WardrobeHeaderDB.FindSet() then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := WardrobeHeaderDB.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        WardrobeHeader.TransferFields(wardrobeheaderDB);
                        WardrobeHeader.Insert();
                        RecordsToRead -= 1;
                    until ((wardrobeheaderDB.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;
    end;
}

