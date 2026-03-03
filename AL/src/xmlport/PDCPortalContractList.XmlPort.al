/// <summary>
/// XmlPort Cust. Portal Contract List (ID 50013).
/// </summary>
xmlport 50013 "PDC Portal Contract List"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
                textelement(f_Id)
                {
                }
                textelement(f_selectedType)
                {
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
            tableelement(Contract; "PDC Contract")
            {
                MinOccurs = Zero;
                XmlName = 'contract';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(no; Contract."No.")
                {
                }
                fieldelement(description; Contract.Description)
                {
                }
                fieldelement(contractCode; Contract."Contract Code")
                {
                }
                fieldelement(blocked; Contract.Blocked)
                {
                }
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
        ContractDB: Record "PDC Contract";
        ProcessData: Boolean;
        SkippedRecords: Integer;
        RecordsToRead: Integer;

    begin
        Contract.Reset();
        Contract.DeleteAll();

        ContractDB.Reset();
        ContractDB.SetRange("Customer No.", NavPortalUser."Customer No.");

        if f_Id <> '' then
            ContractDB.SetFilter("No.", f_Id);
        case f_selectedType of
            'Active':
                ContractDB.SetRange(Blocked, false);
            'Inactive':
                ContractDB.SetRange(Blocked, true);
        end;

        if searchTerm <> '' then begin
            ContractDB.FilterGroup(-1);
            ContractDB.SetFilter(Description, '@*' + searchTerm + '*');
            ContractDB.SetFilter("No.", '@*' + searchTerm + '*');
            ContractDB.FilterGroup(0);
        end;

        if not Paging.FindSet() then begin
            if ContractDB.FindSet() then
                repeat
                    Contract.TransferFields(ContractDB);
                    Contract.Insert();
                until ContractDB.Next() = 0;
        end else begin
            //init paging
            Paging.SetRecords(ContractDB.Count);

            if ContractDB.FindSet() then begin
                ProcessData := true;
                if (Paging."Records to Skip" > 0) then begin
                    SkippedRecords := ContractDB.Next(Paging."Records to Skip");
                    ProcessData := (SkippedRecords = Paging."Records to Skip");
                end;
                if (ProcessData) then begin
                    RecordsToRead := Paging."Page Size";
                    repeat
                        Contract.TransferFields(ContractDB);
                        Contract.Insert();
                        RecordsToRead -= 1;
                    until ((ContractDB.Next() = 0) or (RecordsToRead <= 0));
                end;
            end;
        end;
    end;

    /// <summary>
    /// UpdateContract.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure UpdateContract(var NavPortalUser: Record "PDC Portal User")
    var
        ContractDB: Record "PDC Contract";
        ContractNotFoundErr: label 'Contract with id %1 not found', Comment = '%1=contract id';
    begin
        ContractDB.Reset();
        ContractDB.SetRange("Customer No.", NavPortalUser."Customer No.");
        ContractDB.SetRange("No.", f_Id);

        if not Contract.FindFirst() then
            Error(ContractNotFoundErr, f_Id);

        if not ContractDB.FindFirst() then
            Error(ContractNotFoundErr, f_Id);

        ContractDB.Validate(Description, CopyStr(Contract.Description, 1, 30));
        ContractDB.Validate("Contract Code", CopyStr(Contract."Contract Code", 1, 30));
        ContractDB.Blocked := Contract.Blocked;
        ContractDB.Modify(true);
    end;

    /// <summary>
    /// AddContract.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure AddContract(var NavPortalUser: Record "PDC Portal User")
    var
        ContractDB: Record "PDC Contract";
        NavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";
        ContractNotFoundErr: label 'Contract with id %1 not found', Comment = '%1=contract id';
    begin
        if not Contract.FindFirst() then
            Error(ContractNotFoundErr, f_Id);

        ContractDB.Init();
        ContractDB."Customer No." := NavPortalUser."Customer No.";

        NavPortal.Get('CUSTP');
        if NavPortal."Contract Series Nos." = '' then
            ContractDB."No." := DELCHR(Contract."No.", '=', ';/?:@&=+$,')
        else begin
            ContractDB."No. Series" := NavPortal."Contract Series Nos.";
            ContractDB."No." := NoSeries.GetNextNo(ContractDB."No. Series", WorkDate());
        end;

        ContractDB.Insert(true);

        ContractDB.Validate(Description, CopyStr(Contract.Description, 1, 30));
        ContractDB.Validate("Contract Code", CopyStr(Contract."Contract Code", 1, 30));
        ContractDB.Blocked := Contract.Blocked;
        ContractDB.Modify(true);
    end;
}

