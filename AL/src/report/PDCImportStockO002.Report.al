// /// <summary>
// /// Report PDC Import Stock O002 (ID 50042).
// /// </summary>
// Report 50042 "PDC Import Stock O002"
// {
//     Caption = 'Import Stock O002';
//     ProcessingOnly = true;
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;

//     dataset
//     {
//         dataitem("Integer"; "Integer")
//         {
//             DataItemTableView = sorting(Number) where(Number = const(1));

//             trigger OnAfterGetRecord()
//             begin
//                 //1 - download new file from ftp
//                 if GuiAllowed then begin
//                     window.Open('#1#############################################');
//                     window.Update(1, StrSubstNo(DownloadingTxt, URL));
//                 end;

//                 SourceFileName := 'stockfile.csv';
//                 FTP_DownloadFile(URL, User, Pass,
//                                  SourceFileName,
//                                  false,
//                                  false,
//                                  TempBlob);
//                 if GuiAllowed then
//                     window.Close();

//                 //3 -open file,  parse InStr, read data into Item Vendor table               
//                 if GuiAllowed then begin
//                     window.Open('#1#############################################\' +
//                                 '#2#############################################');
//                     window.Update(1, StrSubstNo(ParseFileTxt, CleanFileName));
//                 end;

//                 TempBlob.CreateInStream(InStr);

//                 ItemVendor.Reset();
//                 ItemVendor.SetRange("Vendor No.", VendorNo);
//                 ItemVendor.ModifyAll("PDC Vendor Inventory", 0);
//                 ItemVendor.ModifyAll("PDC Vendor Inventory DT", 0DT);

//                 while not InStr.eos do begin
//                     Clear(fileRowTxt);
//                     InStr.ReadText(fileRowTxt);
//                     row += 1;

//                     if GuiAllowed then
//                         window.Update(2, StrSubstNo(RowTxt, row));

//                     if row > 1 then begin //1srt row is header
//                         VendorItemNo := copystr(GetValueFromString(fileRowTxt, 1), 1, MaxStrLen(VendorItemNo));
//                         VendorItemQtyTxt := GetValueFromString(fileRowTxt, 3);
//                         if Evaluate(VendorItemQty, VendorItemQtyTxt) and (VendorItemQty > 0) then begin
//                             ItemVendor.Reset();
//                             ItemVendor.SetRange("Vendor No.", VendorNo);
//                             ItemVendor.SetRange("Vendor Item No.", VendorItemNo);
//                             if not ItemVendor.FindFirst() then begin
//                                 Item.SetRange("Vendor No.", VendorNo);
//                                 Item.SetRange("Vendor Item No.", VendorItemNo);
//                                 if Item.FindFirst() then begin
//                                     ItemVendor.Init();
//                                     ItemVendor."Vendor No." := Item."Vendor No.";
//                                     ItemVendor."Item No." := Item."No.";
//                                     ItemVendor."Vendor Item No." := Item."Vendor Item No.";
//                                     ItemVendor.Insert();
//                                 end;
//                             end;
//                             if ItemVendor."Item No." <> '' then begin
//                                 ItemVendor."PDC Vendor Inventory" := VendorItemQty;
//                                 ItemVendor."PDC Vendor Inventory DT" := CurrentDatetime;
//                                 ItemVendor.Modify();
//                             end;
//                         end;
//                     end;
//                 end;

//                 if GuiAllowed then
//                     window.Close();
//             end;

//             trigger OnPreDataItem()
//             begin
//                 URL := 'ftp://upload.webofficesystems.com';
//                 User := 'ornclothing_ftp';
//                 Pass := '4FG5fjdkDF_fjdkAAh4';
//                 VendorNo := 'O002';
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         Item: Record Item;
//         ItemVendor: Record "Item Vendor";
//         TempBlob: Codeunit "Temp Blob";
//         InStr: InStream;
//         URL: Text;
//         User: Text;
//         Pass: Text;
//         SourceFileName: Text;
//         CleanFileName: Text;
//         fileRowTxt: Text;
//         row: Integer;
//         VendorNo: Code[20];
//         VendorItemNo: Code[20];
//         VendorItemQtyTxt: Text;
//         VendorItemQty: Decimal;
//         window: Dialog;
//         DownloadingTxt: label 'Downloading %1', Comment = '%1=file name';
//         ParseFileTxt: label 'Parse file %1', Comment = '%1=file name';
//         RowTxt: label 'row %1', comment = '%1=row id';

//     local procedure FTP_DownloadFile(FTP_url: Text; pUser: Text; pPass: Text; FTP_FilePath: Text; DeleteSource: Boolean; ShowMessage: Boolean; var DestTempBlob: Codeunit "Temp Blob")
//     var
//         FTPWebRequest: dotnet FtpWebRequest;
//         FTPWebResponce: dotnet FtpWebResponse;
//         NetCredentials: dotnet NetworkCredential;
//         locInStr: InStream;
//         locOutStr: OutStream;
//         FTPConnErr: label 'FTP Connection error (%1)', comment = '%1=error code';
//         DownloadCompletedMsg: label 'Download completed';
//     begin
//         FTPWebRequest := FTPWebRequest.Create(FTP_url + '/' + FTP_FilePath);
//         NetCredentials := NetCredentials.NetworkCredential(pUser, pPass);
//         FTPWebRequest.Credentials := NetCredentials;
//         FTPWebRequest.KeepAlive(true);
//         FTPWebRequest.UsePassive(true);
//         FTPWebRequest.UseBinary(true);
//         FTPWebRequest.Timeout := 600000;
//         if not IsNull(FTPWebRequest) then begin
//             FTPWebRequest.Method('RETR');
//             FTPWebResponce := FTPWebRequest.GetResponse();

//             if not IsNull(FTPWebResponce) then begin
//                 locInStr := FTPWebResponce.GetResponseStream();
//                 DestTempBlob.CreateOutStream(locOutStr);
//                 CopyStream(locOutStr, InStr);

//                 if DeleteSource then begin
//                     FTPWebRequest := FTPWebRequest.Create(FTP_url + '/' + FTP_FilePath);
//                     FTPWebRequest.Credentials := NetCredentials;
//                     FTPWebRequest.KeepAlive(true);
//                     FTPWebRequest.UsePassive(true);
//                     FTPWebRequest.UseBinary(true);
//                     if not IsNull(FTPWebRequest) then begin
//                         FTPWebRequest.Method('DELE');
//                         FTPWebResponce := FTPWebRequest.GetResponse();
//                     end;
//                 end;
//             end;
//             if ShowMessage then
//                 Message(DownloadCompletedMsg);
//         end
//         else
//             Error(FTPConnErr, FTP_url);

//         Clear(FTPWebResponce);
//         Clear(FTPWebRequest)
//     end;


//     local procedure GetValueFromString(FromValue: Text; ValueNo: Integer) RetValue: Text
//     var
//         x: Integer;
//     begin
//         if FromValue = '' then
//             exit('');
//         if ValueNo = 0 then
//             exit;

//         for x := 1 to ValueNo do
//             if StrPos(FromValue, ',') <> 0 then begin
//                 RetValue := CopyStr(FromValue, 1, StrPos(FromValue, ',') - 1);
//                 FromValue := CopyStr(FromValue, StrPos(FromValue, ',') + 1);
//             end
//             else begin
//                 RetValue := FromValue;
//                 FromValue := '';
//             end;
//     end;
// }

