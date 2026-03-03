/// <summary>
/// Codeunit PDC Blob Staff Import (ID 50021).
/// Core import logic for staff from Azure Blob Storage Excel files.
/// </summary>
codeunit 50021 "PDC Blob Staff Import"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Setup: Record "PDC Blob Staff Import Setup";
    begin
        // Job Queue entry point
        // Parameter = Customer No (optional)
        // If blank, process all enabled setups
        if Rec."Parameter String" <> '' then begin
            Setup.Get(Rec."Parameter String");
            Setup.TestField(Enabled, true);
            RunImport(Setup."Customer No.");
        end else
            RunAllEnabled();
    end;

    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        ErrorCount: Integer;
        CreatedCount: Integer;
        UpdatedCount: Integer;
        SkippedCount: Integer;
        CurrentSetup: Record "PDC Blob Staff Import Setup";
        CurrentFileName: Text[250];
        CurrentImportDateTime: DateTime;
        FileAlreadyImportedMsg: Label 'File "%1" was already imported on %2. Do you want to import again?';
        FileAlreadyImportedErr: Label 'File "%1" was already imported on %2. Skipping.';

    /// <summary>
    /// Runs the import for all enabled configurations.
    /// </summary>
    procedure RunAllEnabled()
    var
        Setup: Record "PDC Blob Staff Import Setup";
    begin
        Setup.SetRange(Enabled, true);
        if Setup.FindSet() then
            repeat
                RunImport(Setup."Customer No.");
            until Setup.Next() = 0;
    end;

    /// <summary>
    /// Runs the import for a specific customer.
    /// </summary>
    /// <param name="CustomerNo">The customer number to import for.</param>
    /// <returns>True if import was successful.</returns>
    procedure RunImport(CustomerNo: Code[20]): Boolean
    begin
        exit(RunImportWithOptions(CustomerNo, true));
    end;

    /// <summary>
    /// Runs the import with option to skip duplicate check.
    /// </summary>
    procedure RunImportWithOptions(CustomerNo: Code[20]; CheckDuplicate: Boolean): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        LatestFileName: Text;
        PreviousImportDT: DateTime;
    begin
        // Reset counters
        ErrorCount := 0;
        CreatedCount := 0;
        UpdatedCount := 0;
        SkippedCount := 0;
        CurrentImportDateTime := CurrentDateTime;

        // 1. Get and validate setup
        CurrentSetup.Get(CustomerNo);
        CurrentSetup.TestField("Storage Account Name");
        CurrentSetup.TestField("Container Name");
        CurrentSetup.TestField("SAS Token");

        // 2. Find latest file
        LatestFileName := FindLatestBlobFile();
        if LatestFileName = '' then
            exit(false);

        CurrentFileName := CopyStr(LatestFileName, 1, MaxStrLen(CurrentFileName));

        // 3. Check if file was already imported
        if CheckDuplicate then begin
            PreviousImportDT := GetPreviousImportDateTime(CurrentFileName);
            if PreviousImportDT <> 0DT then begin
                if GuiAllowed then begin
                    if not Confirm(FileAlreadyImportedMsg, false, CurrentFileName, PreviousImportDT) then
                        exit(false);
                end else begin
                    // In Job Queue mode, skip already imported files
                    exit(false);
                end;
            end;
        end;

        // 4. Download file
        if not DownloadBlobFile(LatestFileName, TempBlob) then
            exit(false);

        // 5. Process Excel
        ProcessExcelFile(TempBlob);

        // 6. Update last import info
        UpdateLastImportInfo(LatestFileName);
        exit(true);
    end;

    local procedure GetPreviousImportDateTime(FileName: Text): DateTime
    var
        ImportLog: Record "PDC Blob Staff Import Log";
    begin
        ImportLog.SetRange("Customer No.", CurrentSetup."Customer No.");
        ImportLog.SetRange("File Name", FileName);
        ImportLog.SetFilter(Status, '<>%1', ImportLog.Status::Error);
        if ImportLog.FindLast() then
            exit(ImportLog."Import DateTime");
        exit(0DT);
    end;

    local procedure FindLatestBlobFile(): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: Text;
        XmlDoc: XmlDocument;
        BlobNodes: XmlNodeList;
        BlobNode: XmlNode;
        NameNode: XmlNode;
        PropertiesNode: XmlNode;
        LastModifiedNode: XmlNode;
        BlobName: Text;
        LastModified: Text;
        LatestFileName: Text;
        LatestDateTime: DateTime;
        BlobDateTime: DateTime;
        Pattern: Text;
    begin
        if not Client.Get(CurrentSetup.GetBlobListUrl(), Response) then
            exit('');

        if not Response.IsSuccessStatusCode then
            exit('');

        Response.Content.ReadAs(Content);
        if not XmlDocument.ReadFrom(Content, XmlDoc) then
            exit('');

        Pattern := CurrentSetup."File Name Pattern";
        if Pattern = '' then
            Pattern := '*.xlsx';

        XmlDoc.SelectNodes('//Blob', BlobNodes);
        foreach BlobNode in BlobNodes do begin
            if BlobNode.SelectSingleNode('Name', NameNode) then begin
                BlobName := NameNode.AsXmlElement().InnerText;

                // Check if file matches pattern
                if MatchesPattern(BlobName, Pattern) then begin
                    // Get Last-Modified
                    if BlobNode.SelectSingleNode('Properties', PropertiesNode) then
                        if PropertiesNode.SelectSingleNode('Last-Modified', LastModifiedNode) then begin
                            LastModified := LastModifiedNode.AsXmlElement().InnerText;
                            BlobDateTime := ParseHttpDateTime(LastModified);

                            if BlobDateTime > LatestDateTime then begin
                                LatestDateTime := BlobDateTime;
                                LatestFileName := BlobName;
                            end;
                        end;
                end;
            end;
        end;

        exit(LatestFileName);
    end;

    local procedure MatchesPattern(FileName: Text; Pattern: Text): Boolean
    var
        FileExt: Text;
        PatternExt: Text;
    begin
        // Simple pattern matching - supports *.ext
        if Pattern = '*' then
            exit(true);

        if Pattern.StartsWith('*.') then begin
            PatternExt := CopyStr(Pattern, 3);
            if FileName.Contains('.') then begin
                FileExt := CopyStr(FileName, FileName.LastIndexOf('.') + 1);
                exit(FileExt.ToLower() = PatternExt.ToLower());
            end;
        end;

        // Exact match
        exit(FileName.ToLower() = Pattern.ToLower());
    end;

    local procedure ParseHttpDateTime(HttpDate: Text): DateTime
    var
        Year, Month, Day : Integer;
        MonthNames: List of [Text];
        Parts: List of [Text];
        MonthName: Text;
        TimeText: Text;
        ParsedTime: Time;
        i: Integer;
    begin
        // Parse format: "Mon, 03 Feb 2026 10:00:00 GMT"
        MonthNames.Add('Jan');
        MonthNames.Add('Feb');
        MonthNames.Add('Mar');
        MonthNames.Add('Apr');
        MonthNames.Add('May');
        MonthNames.Add('Jun');
        MonthNames.Add('Jul');
        MonthNames.Add('Aug');
        MonthNames.Add('Sep');
        MonthNames.Add('Oct');
        MonthNames.Add('Nov');
        MonthNames.Add('Dec');

        Parts := HttpDate.Split(' ');
        if Parts.Count < 5 then
            exit(0DT);

        Evaluate(Day, Parts.Get(2));
        MonthName := Parts.Get(3);
        for i := 1 to 12 do
            if MonthNames.Get(i) = MonthName then begin
                Month := i;
                break;
            end;
        Evaluate(Year, Parts.Get(4));

        TimeText := Parts.Get(5); // "10:00:00"
        if not Evaluate(ParsedTime, TimeText) then
            ParsedTime := 0T;

        exit(CreateDateTime(DMY2Date(Day, Month, Year), ParsedTime));
    end;

    local procedure DownloadBlobFile(BlobName: Text; var TempBlob: Codeunit "Temp Blob"): Boolean
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
        OutStr: OutStream;
    begin
        if not Client.Get(CurrentSetup.GetBlobDownloadUrl(BlobName), Response) then
            exit(false);

        if not Response.IsSuccessStatusCode then
            exit(false);

        TempBlob.CreateOutStream(OutStr);
        Response.Content.ReadAs(InStr);
        CopyStream(OutStr, InStr);
        exit(true);
    end;

    local procedure ProcessExcelFile(var TempBlob: Codeunit "Temp Blob")
    var
        InStr: InStream;
        SheetName: Text;
        RowNo: Integer;
        LastRowNo: Integer;
    begin
        TempExcelBuf.Reset();
        TempExcelBuf.DeleteAll();

        TempBlob.CreateInStream(InStr);
        SheetName := GetFirstSheetName(TempBlob);
        if SheetName = '' then
            SheetName := 'Sheet1';

        TempExcelBuf.OpenBookStream(InStr, SheetName);
        TempExcelBuf.ReadSheet();

        // Find last row
        LastRowNo := 0;
        if TempExcelBuf.FindSet() then
            repeat
                if TempExcelBuf."Row No." > LastRowNo then
                    LastRowNo := TempExcelBuf."Row No.";
            until TempExcelBuf.Next() = 0;

        // Process rows (skip header row 1)
        for RowNo := 2 to LastRowNo do
            ProcessExcelRow(RowNo);
    end;

    local procedure GetFirstSheetName(var TempBlob: Codeunit "Temp Blob"): Text
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        InStr: InStream;
    begin
        TempBlob.CreateInStream(InStr);
        if TempExcelBuf.GetSheetsNameListFromStream(InStr, TempNameValueBuffer) then
            if TempNameValueBuffer.FindFirst() then
                exit(TempNameValueBuffer.Value);
        exit('');
    end;

    local procedure ProcessExcelRow(RowNo: Integer)
    var
        WearerID: Code[20];
        FirstName: Text[30];
        LastName: Text[30];
        BodyType: Code[10];
        BranchID: Code[20];
        WardrobeID: Code[20];
        ContractID: Code[20];
    begin
        // Read cell values based on OBJECT-DESIGN mapping
        WearerID := CopyStr(GetCellValue(RowNo, 1), 1, 20);   // Column A
        FirstName := CopyStr(GetCellValue(RowNo, 2), 1, 30);  // Column B
        LastName := CopyStr(GetCellValue(RowNo, 3), 1, 30);   // Column C
        BodyType := CopyStr(GetCellValue(RowNo, 4), 1, 10);   // Column D
        BranchID := CopyStr(GetCellValue(RowNo, 5), 1, 20);   // Column E
        WardrobeID := CopyStr(GetCellValue(RowNo, 6), 1, 20); // Column F
        ContractID := CopyStr(GetCellValue(RowNo, 7), 1, 20); // Column G

        // Validate required fields
        if WearerID = '' then begin
            LogImport(RowNo, WearerID, '', FirstName, LastName, BranchID, WardrobeID, ContractID, BodyType,
                      "PDC Blob Staff Import Status"::Error, 'Wearer ID is empty');
            ErrorCount += 1;
            exit;
        end;

        // Create or update staff
        CreateOrUpdateStaff(RowNo, WearerID, FirstName, LastName, BodyType, BranchID, WardrobeID, ContractID);
    end;

    local procedure GetCellValue(RowNo: Integer; ColNo: Integer): Text
    begin
        if TempExcelBuf.Get(RowNo, ColNo) then
            exit(TempExcelBuf."Cell Value as Text");
        exit('');
    end;

    local procedure CreateOrUpdateStaff(RowNo: Integer; WearerID: Code[20]; FirstName: Text[30]; LastName: Text[30]; BodyType: Code[10]; BranchID: Code[20]; WardrobeID: Code[20]; ContractID: Code[20])
    var
        Staff: Record "PDC Branch Staff";
        PDCPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";
        IsNew: Boolean;
        StatusEnum: Enum "PDC Blob Staff Import Status";
        LogMessage: Text;
        ValidationErrors: Text;
    begin
        // Find existing by Wearer ID + Customer
        Staff.SetRange("Sell-to Customer No.", CurrentSetup."Customer No.");
        Staff.SetRange("Wearer ID", WearerID);
        IsNew := Staff.IsEmpty();

        if IsNew then begin
            if not CurrentSetup."Create New Staff" then begin
                LogImport(RowNo, WearerID, '', FirstName, LastName, BranchID, WardrobeID, ContractID, BodyType,
                          "PDC Blob Staff Import Status"::Skipped, 'Create New Staff is disabled');
                SkippedCount += 1;
                exit;
            end;

            // Create new staff
            Staff.Init();
            PDCPortal.Get('CUSTP');
            PDCPortal.TestField("Branch Staff Series Nos.");
            Staff."No. Series" := PDCPortal."Branch Staff Series Nos.";
            Staff."Staff ID" := NoSeries.GetNextNo(Staff."No. Series", WorkDate());
            Staff.Validate("Sell-to Customer No.", CurrentSetup."Customer No.");
            Staff."Wearer ID" := WearerID;
            Staff.Insert(false);
            CreatedCount += 1;
            StatusEnum := "PDC Blob Staff Import Status"::Created;
            LogMessage := 'Staff created';
        end else begin
            if not CurrentSetup."Update Existing Staff" then begin
                Staff.FindFirst();
                LogImport(RowNo, WearerID, Staff."Staff ID", FirstName, LastName, BranchID, WardrobeID, ContractID, BodyType,
                          "PDC Blob Staff Import Status"::Skipped, 'Update Existing Staff is disabled');
                SkippedCount += 1;
                exit;
            end;
            Staff.FindFirst();
            UpdatedCount += 1;
            StatusEnum := "PDC Blob Staff Import Status"::Updated;
            LogMessage := 'Staff updated';
        end;

        // Update fields
        Staff."First Name" := FirstName;
        Staff."Last Name" := LastName;
        Staff.Name := FirstName + ' ' + LastName;

        // Validate optional lookups
        if BodyType <> '' then
            if ValidateBodyType(BodyType) then
                Staff."Body Type/Gender" := BodyType
            else
                ValidationErrors += 'Body Type not found; ';

        if BranchID <> '' then
            if ValidateBranch(BranchID) then
                Staff.Validate("Branch ID", BranchID)
            else
                ValidationErrors += 'Branch not found; ';

        if WardrobeID <> '' then
            if ValidateWardrobe(WardrobeID) then
                Staff.Validate("Wardrobe ID", WardrobeID)
            else
                ValidationErrors += 'Wardrobe not found; ';

        if ContractID <> '' then
            if ValidateContract(ContractID) then
                Staff.Validate("Contract ID", ContractID)
            else
                ValidationErrors += 'Contract not found; ';

        Staff.Modify(false);

        // Log with validation warnings
        if ValidationErrors <> '' then begin
            LogMessage += ' (Warnings: ' + ValidationErrors.TrimEnd('; ') + ')';
            ErrorCount += 1;
        end;

        LogImport(RowNo, WearerID, Staff."Staff ID", FirstName, LastName, BranchID, WardrobeID, ContractID, BodyType,
                  StatusEnum, LogMessage);
    end;

    local procedure LogImport(RowNo: Integer; WearerID: Code[20]; StaffID: Code[20]; FirstName: Text[30]; LastName: Text[30]; BranchID: Code[20]; WardrobeID: Code[20]; ContractID: Code[20]; BodyType: Code[10]; Status: Enum "PDC Blob Staff Import Status"; Message: Text)
    var
        ImportLog: Record "PDC Blob Staff Import Log";
    begin
        ImportLog.Init();
        ImportLog."Entry No." := 0; // Auto-increment
        ImportLog."Customer No." := CurrentSetup."Customer No.";
        ImportLog."Import DateTime" := CurrentImportDateTime;
        ImportLog."File Name" := CurrentFileName;
        ImportLog."Row No." := RowNo;
        ImportLog."Wearer ID" := WearerID;
        ImportLog."Staff ID" := StaffID;
        ImportLog."First Name" := FirstName;
        ImportLog."Last Name" := LastName;
        ImportLog."Branch ID" := BranchID;
        ImportLog."Wardrobe ID" := WardrobeID;
        ImportLog."Contract ID" := ContractID;
        ImportLog."Body Type" := BodyType;
        ImportLog.Status := Status;
        ImportLog.Message := CopyStr(Message, 1, MaxStrLen(ImportLog.Message));
        ImportLog.Insert(true);
    end;

    local procedure ValidateBodyType(BodyType: Code[10]): Boolean
    var
        GeneralLookup: Record "PDC General Lookup";
    begin
        if BodyType = '' then
            exit(false);

        GeneralLookup.SetRange(Type, 'BODYTYPE');
        GeneralLookup.SetRange(Code, BodyType);
        exit(not GeneralLookup.IsEmpty());
    end;

    local procedure ValidateBranch(BranchID: Code[20]): Boolean
    var
        Branch: Record "PDC Branch";
    begin
        if BranchID = '' then
            exit(false);

        exit(Branch.Get(CurrentSetup."Customer No.", BranchID));
    end;

    local procedure ValidateWardrobe(WardrobeID: Code[20]): Boolean
    var
        Wardrobe: Record "PDC Wardrobe Header";
    begin
        if WardrobeID = '' then
            exit(false);

        if not Wardrobe.Get(WardrobeID) then
            exit(false);

        exit(Wardrobe."Customer No." = CurrentSetup."Customer No.");
    end;

    local procedure ValidateContract(ContractID: Code[20]): Boolean
    var
        Contract: Record "PDC Contract";
    begin
        if ContractID = '' then
            exit(false);

        exit(Contract.Get(CurrentSetup."Customer No.", ContractID));
    end;

    local procedure UpdateLastImportInfo(FileName: Text)
    begin
        CurrentSetup."Last Import DateTime" := CurrentImportDateTime;
        CurrentSetup."Last Import File Name" := CopyStr(FileName, 1, MaxStrLen(CurrentSetup."Last Import File Name"));
        CurrentSetup."Last Import Staff Created" := CreatedCount;
        CurrentSetup."Last Import Staff Updated" := UpdatedCount;
        CurrentSetup."Last Import Errors" := ErrorCount;
        CurrentSetup.Modify();
    end;
}
