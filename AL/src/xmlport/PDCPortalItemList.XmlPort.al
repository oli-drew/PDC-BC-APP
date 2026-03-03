/// <summary>
/// XmlPort PDC Portal Item List (ID 50064).
/// </summary>
XmlPort 50064 "PDC Portal Item List"
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
                textelement(f_nofilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'noFilter';
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
            tableelement(doc; Item)
            {
                MinOccurs = Zero;
                XmlName = 'document';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(no; Doc."No.")
                {
                }
                fieldelement(name; Doc.Description)
                {
                }
                fieldelement(type; Doc.Type)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
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
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="ItemDb">VAR Record Item.</param>
    procedure FilterData(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"; var ItemDb: Record Item)
    var
        TempItem: Record Item temporary;
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;
    begin
        if f_noFilter <> '' then begin
            ItemDb.SetFilter("No.", '%1', '@*' + UpperCase(f_noFilter) + '*');
            if ItemDb.Findset() then
                repeat
                    TempItem := ItemDb;
                    if TempItem.Insert() then;
                until ItemDb.next() = 0;
            ItemDb.SetRange("No.");
            ItemDb.SetFilter(Description, '%1', '@*' + UpperCase(f_noFilter) + '*');
            if ItemDb.Findset() then
                repeat
                    TempItem := ItemDb;
                    if TempItem.Insert() then;
                until ItemDb.next() = 0;

        end;

        //init paging
        Paging.SetRecords(TempItem.Count);

        //load records
        Doc.Reset();
        Doc.DeleteAll();
        if (TempItem.FindSet()) then begin
            ProcessData := true;
            if (Paging."Records to Skip" > 0) then begin
                SkippedRecords := TempItem.Next(Paging."Records to Skip");
                ProcessData := (SkippedRecords = Paging."Records to Skip");
            end;
            if (ProcessData) then begin
                RecordsToRead := Paging."Page Size";
                repeat
                    Doc.TransferFields(TempItem);
                    Doc.Insert();
                    RecordsToRead -= 1;
                until ((TempItem.Next() = 0) or (RecordsToRead <= 0));
            end;
        end;
    end;
}

