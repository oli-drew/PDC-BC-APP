/// <summary>
/// Report PDC Import Stock P003 (ID 50040).
/// </summary>
Report 50040 "PDC Import Stock P003"
{
    Caption = 'Import Stock P003';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                //1 - download new CSV file from http
                if GuiAllowed then begin
                    window.Open('#1#############################################');
                    window.Update(1, StrSubstNo(DownloadingTxt, URL));
                end;
                if not HTTPRequest.Get(URL, response) then
                    exit;
                response.Content().ReadAs(FileContent);
                if GuiAllowed then
                    window.Close();

                //2 - parse InStr, read data into Item Vendor table
                if GuiAllowed then begin
                    window.Open('#1#############################################\' +
                                '#2#############################################');
                    window.Update(1, StrSubstNo(ParseFileTxt, TempNameValueBuffer.Name));
                end;

                TempBlob.CreateOutStream(OutStr);
                OutStr.WriteText(FileContent);
                TempBlob.CreateInStream(InStr);

                ItemVendor.Reset();
                ItemVendor.SetRange("Vendor No.", VendorNo);
                ItemVendor.ModifyAll("PDC Vendor Inventory", 0);
                ItemVendor.ModifyAll("PDC Vendor Inventory DT", 0DT);

                while not InStr.eos do begin
                    Clear(fileRowTxt);
                    InStr.ReadText(fileRowTxt);
                    row += 1;

                    if GuiAllowed then
                        window.Update(2, StrSubstNo(RowTxt, row));

                    if row > 1 then begin //1srt row is header
                        VendorItemNo := copystr(GetValueFromString(fileRowTxt, 1), 1, MaxStrLen(VendorItemNo));
                        VendorItemQtyTxt := GetValueFromString(fileRowTxt, 2);
                        if Evaluate(VendorItemQty, VendorItemQtyTxt) and (VendorItemQty > 0) then begin
                            ItemVendor.Reset();
                            ItemVendor.SetRange("Vendor No.", VendorNo);
                            ItemVendor.SetRange("Vendor Item No.", VendorItemNo);
                            if not ItemVendor.FindFirst() then begin
                                Item.SetRange("Vendor No.", VendorNo);
                                Item.SetRange("Vendor Item No.", VendorItemNo);
                                if Item.FindFirst() then begin
                                    ItemVendor.Init();
                                    ItemVendor."Vendor No." := Item."Vendor No.";
                                    ItemVendor."Item No." := Item."No.";
                                    ItemVendor."Vendor Item No." := Item."Vendor Item No.";
                                    ItemVendor.Insert();
                                end;
                            end;
                            if ItemVendor."Item No." <> '' then begin
                                ItemVendor."PDC Vendor Inventory" := VendorItemQty;
                                ItemVendor."PDC Vendor Inventory DT" := CurrentDatetime;
                                ItemVendor.Modify();
                            end;
                        end;
                    end;
                end;

                if GuiAllowed then
                    window.Close();
            end;

            trigger OnPreDataItem()
            begin
                URL := 'http://www.portwest.biz/downloads/simplesoh.csv';
                VendorNo := 'P003';
            end;
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

    labels
    {
    }

    var
        Item: Record Item;
        ItemVendor: Record "Item Vendor";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        HTTPRequest: HttpClient;
        response: HttpResponseMessage;
        FileContent: Text;
        OutStr: OutStream;
        InStr: InStream;
        URL: Text;
        fileRowTxt: Text;
        row: Integer;
        VendorItemNo: Code[20];
        VendorItemQtyTxt: Text;
        VendorItemQty: Decimal;
        VendorNo: Code[20];
        window: Dialog;
        DownloadingTxt: label 'Downloading %1', Comment = '%1=file name';
        ParseFileTxt: label 'Parse file %1', Comment = '%1=file name';
        RowTxt: label 'row %1', comment = '%1=row id';


    local procedure GetValueFromString(FromValue: Text; ValueNo: Integer) RetValue: Text
    var
        x: Integer;
    begin
        if FromValue = '' then
            exit('');
        if ValueNo = 0 then
            exit;

        for x := 1 to ValueNo do
            if StrPos(FromValue, ',') <> 0 then begin
                RetValue := CopyStr(FromValue, 1, StrPos(FromValue, ',') - 1);
                FromValue := CopyStr(FromValue, StrPos(FromValue, ',') + 1);
            end
            else begin
                RetValue := FromValue;
                FromValue := '';
            end;
    end;
}

