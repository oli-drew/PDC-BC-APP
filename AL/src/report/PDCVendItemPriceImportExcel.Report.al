/// <summary>
/// Report PDC VendItemPriceImportExcel (ID 50057) imports new Puchase Prices from Excel.
/// </summary>
Report 50057 "PDC VendItemPriceImportExcel"
{
    Caption = 'Vendor Item Price Import From Excel';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(ImportLoop; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin

                AnalyzeData();
            end;

            trigger OnPostDataItem()
            begin
                if ImportLineCount > 0 then
                    Message(ImportResultMsg, PurchPrice.TableCaption, ImportLineCount);
            end;

            trigger OnPreDataItem()
            begin
                clear(ImportLineCount);
            end;
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        TempExcelBuf.DeleteAll();
    end;

    trigger OnPreReport()
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
    begin
        if not File.UploadIntoStream(ImportExcelTxt, '', ImportExcelFromFileTxt, FileName, FileInStream) then
            exit;

        if TempExcelBuf.GetSheetsNameListFromStream(FileInStream, TempNameValueBuffer) then
            if TempNameValueBuffer.Count = 1 then
                SheetName := TempNameValueBuffer.Value
            else
                if PAGE.RunModal(PAGE::"Name/Value Lookup", TempNameValueBuffer) = ACTION::LookupOK then
                    SheetName := TempNameValueBuffer.Value;
        TempExcelBuf.OpenBookStream(FileInStream, SheetName);
        TempExcelBuf.ReadSheet();
    end;

    var
        Item: Record Item;
        Vendor: Record Vendor;
        ItemVendor: Record "Item Vendor";
        PurchPrice: Record "Purchase Price";
        PurchPrice2: Record "Purchase Price";

        TempExcelBuf: Record "Excel Buffer" temporary;
        Window: Dialog;
        TotalRecNo: Integer;
        RecNo: Integer;
        FileName: Text;
        SheetName: Text;
        ImportLineCount: Integer;
        FileInStream: InStream;
        ImportResultMsg: label '%1 table has been successfully updated with %2 entries.', Comment = '%1=table name, %2=new records count';
        ImportExcelTxt: label 'Import Excel File';
        ImportExcelFromFileTxt: label 'Excel Files (*.xlsx)|*.xlsx';
        WindowsTxt: label 'Analyzing Data...\\';

    local procedure AnalyzeData()
    var
        i: Integer;
        LastRowNo: Integer;
    begin
        Window.Open(
          WindowsTxt +
          '#1# %');
        RecNo := 0;
        TotalRecNo := TempExcelBuf.Count;
        Window.Update(1, 0);

        clear(LastRowNo);
        if TempExcelBuf.Findset() then
            repeat
                if LastRowNo < TempExcelBuf."Row No." then
                    LastRowNo := TempExcelBuf."Row No.";
            until TempExcelBuf.Next() = 0;

        i := 1;

        if LastRowNo > 1 then
            repeat
                RecNo += 1;
                Window.Update(1, ROUND(RecNo / TotalRecNo * 10000, 1, '<'));

                i += 1;

                if TempExcelBuf.Get(i, 1) and (TempExcelBuf."Cell Value as Text" <> '') then begin
                    clear(Item);
                    Item.reset();
                    clear(Vendor);
                    if Item.get(COPYSTR(TempExcelBuf."Cell Value as Text", 1, 20)) then
                        Vendor.get(item."Vendor No.")
                    else begin
                        Item.setrange("Vendor Item No.", COPYSTR(TempExcelBuf."Cell Value as Text", 1, 20));
                        if Item.FindFirst() then
                            Vendor.get(item."Vendor No.")
                        else begin
                            ItemVendor.reset();
                            ItemVendor.setrange("Vendor Item No.", COPYSTR(TempExcelBuf."Cell Value as Text", 1, 20));
                            if ItemVendor.FindFirst() then begin
                                Item.get(ItemVendor."Item No.");
                                Vendor.get(ItemVendor."Vendor No.")
                            end;
                        end;
                    end;
                    if Item."No." <> '' then begin
                        PurchPrice.init();
                        PurchPrice.validate("Item No.", Item."No.");
                        PurchPrice.Validate("Vendor No.", Vendor."No.");
                        if TempExcelBuf.Get(i, 2) and (TempExcelBuf."Cell Value as Text" <> '') then begin
                            evaluate(PurchPrice."Starting Date", TempExcelBuf."Cell Value as Text");
                            PurchPrice.validate("Starting Date");
                        end;
                        if TempExcelBuf.Get(i, 3) and (TempExcelBuf."Cell Value as Text" <> '') then begin
                            evaluate(PurchPrice."Ending Date", TempExcelBuf."Cell Value as Text");
                            PurchPrice.validate("Ending Date");
                        end;
                        if TempExcelBuf.Get(i, 4) and (TempExcelBuf."Cell Value as Text" <> '') then begin
                            evaluate(PurchPrice."Minimum Quantity", TempExcelBuf."Cell Value as Text");
                            PurchPrice.validate("Minimum Quantity");
                        end;
                        if TempExcelBuf.Get(i, 6) and (TempExcelBuf."Cell Value as Text" <> '') then
                            PurchPrice.validate("Unit of Measure Code", copystr(TempExcelBuf."Cell Value as Text", 1, MaxStrLen(PurchPrice."Unit of Measure Code")));
                        TempExcelBuf.Get(i, 5);
                        evaluate(PurchPrice."Direct Unit Cost", TempExcelBuf."Cell Value as Text");
                        PurchPrice.validate("Direct Unit Cost");
                        PurchPrice.insert(true);
                        ImportLineCount += 1;

                        if PurchPrice."Starting Date" <> 0D then begin
                            PurchPrice2.SETRANGE("Item No.", PurchPrice."Item No.");
                            PurchPrice2.SETRANGE("Vendor No.", PurchPrice."Vendor No.");
                            PurchPrice2.SETRANGE("Currency Code", PurchPrice."Currency Code");
                            PurchPrice2.SETRANGE("Variant Code", PurchPrice."Variant Code");
                            PurchPrice2.SETRANGE("Unit of Measure Code", PurchPrice."Unit of Measure Code");
                            PurchPrice2.SETRANGE("Minimum Quantity", PurchPrice."Minimum Quantity");
                            PurchPrice2.SETFILTER("Starting Date", '<%1', PurchPrice."Starting Date");
                            if PurchPrice2.FindSet(true) then
                                repeat
                                    if (PurchPrice2."Ending Date" = 0D) OR (PurchPrice2."Ending Date" > PurchPrice."Starting Date" - 1) then begin
                                        PurchPrice2."Ending Date" := PurchPrice."Starting Date" - 1;
                                        PurchPrice2.MODifY();
                                    end;
                                until PurchPrice2.next() = 0;
                        end;
                    end;
                end;
            until i = LastRowNo;

        Window.Close();
    end;
}

