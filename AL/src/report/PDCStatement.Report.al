/// <summary>
/// Report PDC Statement (ID 50000).
/// </summary>
Report 50000 "PDC Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PDCStatement.rdlc';

    Caption = 'Customer Statement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Print Statements", "Currency Filter";

            column(No_Cust; "No.")
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(OrglAmtCaption; OrglAmtCaptionLbl)
            {
            }
            column(RemainingAmtCaption; RemainingAmtCaptionLbl)
            {
            }
            column(CurrencyCodeCaption; CurrencyCodeCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                PrintOnlyIfDetail = true;

                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo_CompanyInfo; CompanyInfo."Giro No.")
                {
                }
                column(BankName_CompanyInfo; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfo1Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyInfo3Picture; CompanyInfo3.Picture)
                {
                }
                column(BankAccNo_CompanyInfo; CompanyInfo."Bank Account No.")
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(StartDate; StartDate)
                {
                }
                column(EndDate; EndDate)
                {
                }
                column(LastStatementNo_Customer; Format(Customer."Last Statement No."))
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(StatementCaption; StatementCaptionLbl)
                {
                }
                column(PhoneNoCaption; PhoneNoCaptionLbl)
                {
                }
                column(VATRegNoCaption; VATRegNoCaptionLbl)
                {
                }
                column(GiroNoCaption; GiroNoCaptionLbl)
                {
                }
                column(BankNameCaption; BankNameCaptionLbl)
                {
                }
                column(BankAccountNoCaption; BankAccountNoCaptionLbl)
                {
                }
                column(CustomerNoCaption; CustomerNoCaptionLbl)
                {
                }
                column(StartDateCaption; StartDateCaptionLbl)
                {
                }
                column(EndDateCaption; EndDateCaptionLbl)
                {
                }
                column(StatementNoCaption; StatementNoCaptionLbl)
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(DueDateCaption; DueDateCaptionLbl)
                {
                }
                column(BalanceCaption; BalanceCaptionLbl)
                {
                }
                column(Total_Caption2; Total_CaptionLbl)
                {
                }
                dataitem(CurrencyLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    PrintOnlyIfDetail = true;

                    dataitem(CustLedgEntryHdr; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(Currency2Code_CustLedgEntryHdr; StrSubstNo(EntriesTxt, TempCurrency2.Code))
                        {
                        }
                        column(StartBalance; StartBalance)
                        {
                            AutoFormatExpression = TempCurrency2.Code;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCode3; CurrencyCode3)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdr; CustBalance)
                        {
                        }
                        column(PrintLine; PrintLine)
                        {
                        }
                        column(DtldCustLedgEntryType; Format(DtldCustLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        dataitem(DtldCustLedgEntries; "Detailed Cust. Ledg. Entry")
                        {
                            DataItemTableView = sorting("Customer No.", "Posting Date", "Entry Type", "Currency Code");

                            column(CustBalanceAmount; CustBalance - Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(PostDate_DtldCustLedgEntries; "Posting Date")
                            {
                            }
                            column(DocNo_DtldCustLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDate_DtldCustLedgEntries; "Due Date")
                            {
                            }
                            column(CurrCode_DtldCustLedgEntries; "Currency Code")
                            {
                            }
                            column(Amt_DtldCustLedgEntries; Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(RemainAmt_DtldCustLedgEntries; "Remaining Amount")
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(CustBalance; CustBalance)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Currency2Code_CustLedgEntry2; TempCurrency2.Code)
                            {
                            }
                            column(EntryNo_DtldCustLedgEntries; "Entry No.")
                            {
                            }
                            column(CustomerRefCaption; CustRefCaptionLbl)
                            {
                            }
                            column(CustomerRef; CustRef)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                l_CustLedgEntry: Record "Cust. Ledger Entry";
                            begin
                                if SkipReversedUnapplied(DtldCustLedgEntries) or (Amount = 0) then
                                    CurrReport.Skip();

                                if ShowOutstandingOnly then begin
                                    l_CustLedgEntry.Get("Cust. Ledger Entry No.");
                                    if not l_CustLedgEntry.Open then
                                        CurrReport.Skip();
                                end;

                                "Remaining Amount" := 0;
                                PrintLine := true;
                                case "Entry Type" of
                                    "entry type"::"Initial Entry":
                                        begin
                                            "Cust. Ledger Entry".Get("Cust. Ledger Entry No.");
                                            Description := "Cust. Ledger Entry".Description;
                                            "Due Date" := "Cust. Ledger Entry"."Due Date";
                                            "Cust. Ledger Entry".SetRange("Date Filter", 0D, EndDate);
                                            "Cust. Ledger Entry".CalcFields("Remaining Amount");
                                            "Remaining Amount" := "Cust. Ledger Entry"."Remaining Amount";
                                            "Cust. Ledger Entry".SetRange("Date Filter");
                                        end;
                                    "entry type"::Application:
                                        begin
                                            DtldCustLedgEntries2.SetCurrentkey("Customer No.", "Posting Date", "Entry Type");
                                            DtldCustLedgEntries2.SetRange("Customer No.", "Customer No.");
                                            DtldCustLedgEntries2.SetRange("Posting Date", "Posting Date");
                                            DtldCustLedgEntries2.SetRange("Entry Type", "entry type"::Application);
                                            DtldCustLedgEntries2.SetRange("Transaction No.", "Transaction No.");
                                            DtldCustLedgEntries2.SetFilter("Currency Code", '<>%1', "Currency Code");
                                            if not DtldCustLedgEntries2.IsEmpty then begin
                                                Description := MultiCurrTxt;
                                                "Due Date" := 0D;
                                            end else
                                                PrintLine := false;
                                        end;
                                    "entry type"::"Payment Discount",
                                    "entry type"::"Payment Discount (VAT Excl.)",
                                    "entry type"::"Payment Discount (VAT Adjustment)",
                                    "entry type"::"Payment Discount Tolerance",
                                    "entry type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "entry type"::"Payment Discount Tolerance (VAT Adjustment)":
                                        begin
                                            Description := PaymentDiscTxt;
                                            "Due Date" := 0D;
                                        end;
                                    "entry type"::"Payment Tolerance",
                                    "entry type"::"Payment Tolerance (VAT Excl.)",
                                    "entry type"::"Payment Tolerance (VAT Adjustment)":
                                        begin
                                            Description := ApplWriteoffsTxt;
                                            "Due Date" := 0D;
                                        end;
                                    "entry type"::"Appln. Rounding",
                                    "entry type"::"Correction of Remaining Amount":
                                        begin
                                            Description := RoundTxt;
                                            "Due Date" := 0D;
                                        end;
                                end;

                                if PrintLine then
                                    CustBalance := CustBalance + "Remaining Amount";

                                if SalesInvHeader.Get("Document No.") then
                                    CustRef := SalesInvHeader."PDC Customer Reference"
                                else
                                    CustRef := '';

                                if ShowOutstandingOnly then
                                    if "Remaining Amount" = 0 then
                                        CurrReport.Skip();

                                LinesInDataset += 1;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange("Customer No.", Customer."No.");
                                SetRange("Posting Date", StartDate, EndDate);
                                SetRange("Currency Code", TempCurrency2.Code);
                                if TempCurrency2.Code = '' then begin
                                    GLSetup.TestField("LCY Code");
                                    CurrencyCode3 := GLSetup."LCY Code"
                                end else
                                    CurrencyCode3 := TempCurrency2.Code;
                            end;
                        }
                    }
                    dataitem(CustLedgEntryFooter; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(CustBalance_CustLedgEntryFooter; CustBalance)
                        {
                            AutoFormatExpression = TempCurrency2.Code;
                            AutoFormatType = 1;
                        }
                        column(Total_Caption; Total_CaptionLbl)
                        {
                        }
                        column(Number_CustLedgEntryFooter; Number)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                    }
                    dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No." = field("No.");
                        DataItemLinkReference = Customer;
                        DataItemTableView = sorting("Customer No.", Open, Positive, "Due Date");

                        column(OverDueEntries; StrSubstNo(OverdueTxt, TempCurrency2.Code))
                        {
                        }
                        column(Total_Caption_CustLedgEntry2; Total_CaptionLbl)
                        {
                        }
                        column(RemainAmt_CustLedgEntry2; "Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            IncludeCaption = false;
                        }
                        column(PostDate_CustLedgEntry2; "Posting Date")
                        {
                        }
                        column(DocNo_CustLedgEntry2; "Document No.")
                        {
                        }
                        column(Description_CustLedgEntry2; Description)
                        {
                            IncludeCaption = false;
                        }
                        column(DueDate_CustLedgEntry2; "Due Date")
                        {
                        }
                        column(OriginalAmt_CustLedgEntry2; "Original Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            IncludeCaption = false;
                        }
                        column(CurrencyCode_CustLedgEntry2; "Currency Code")
                        {
                        }
                        column(PrintEntriesDue; PrintEntriesDue)
                        {
                        }
                        column(Currency2Code2nd_CustLedgEntry2; TempCurrency2.Code)
                        {
                        }
                        column(CurrencyCode4_CustLedgEntry2; CurrencyCode3)
                        {
                        }
                        column(CustNo_CustLedgEntry2; "Customer No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            CustLedgEntry: Record "Cust. Ledger Entry";
                        begin
                            if IncludeAgingBand then
                                if ("Posting Date" > EndDate) and ("Due Date" >= EndDate) then
                                    CurrReport.Skip();
                            CustLedgEntry := CustLedgEntry2;
                            CustLedgEntry.SetRange("Date Filter", 0D, EndDate);

                            if ShowOutstandingOnly then
                                CustLedgEntry.SetRange(Open, true);

                            CustLedgEntry.CalcFields("Remaining Amount");
                            "Remaining Amount" := CustLedgEntry."Remaining Amount";
                            if CustLedgEntry."Remaining Amount" = 0 then
                                CurrReport.Skip();

                            if IncludeAgingBand and ("Posting Date" <= EndDate) then
                                UpdateBuffer(TempCurrency2.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            if "Due Date" >= EndDate then
                                CurrReport.Skip();

                            if ShowOutstandingOnly then
                                if "Remaining Amount" = 0 then
                                    CurrReport.Skip();

                            LinesInDataset += 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not IncludeAgingBand then
                                SetRange("Due Date", 0D, EndDate - 1);
                            SetRange("Currency Code", TempCurrency2.Code);
                            if (not PrintEntriesDue) and (not IncludeAgingBand) then
                                CurrReport.Break();
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        l_DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        l_CustLedgEntry: Record "Cust. Ledger Entry";
                        l_CustAmount: Decimal;
                    begin
                        if Number = 1 then
                            TempCurrency2.FindFirst();

                        repeat
                            if not IsFirstLoop then
                                IsFirstLoop := true
                            else
                                if TempCurrency2.next() = 0 then
                                    CurrReport.Break();
                            "Cust. Ledger Entry".SetCurrentkey("Customer No.", "Posting Date", "Currency Code");
                            "Cust. Ledger Entry".SetRange("Customer No.", Customer."No.");
                            "Cust. Ledger Entry".SetRange("Posting Date", 0D, EndDate);
                            "Cust. Ledger Entry".SetRange("Currency Code", TempCurrency2.Code);

                            if ShowOutstandingOnly then
                                "Cust. Ledger Entry".SetRange(Open, true);

                            EntriesExists := not "Cust. Ledger Entry".IsEmpty;
                        until EntriesExists;
                        Cust2 := Customer;
                        Cust2.SetRange("Date Filter", 0D, StartDate - 1);
                        Cust2.SetRange("Currency Filter", TempCurrency2.Code);
                        Cust2.CalcFields("Net Change");

                        StartBalance := Cust2."Net Change";
                        CustBalance := Cust2."Net Change";

                        if ShowOutstandingOnly then begin
                            l_CustAmount := 0;
                            l_DetCustLedgEntry.SetCurrentkey("Customer No.", "Posting Date", "Currency Code");
                            l_DetCustLedgEntry.SetRange("Customer No.", Customer."No.");
                            l_DetCustLedgEntry.SetRange("Posting Date", 0D, StartDate - 1);
                            l_DetCustLedgEntry.SetRange("Currency Code", TempCurrency2.Code);
                            if l_DetCustLedgEntry.Findset() then
                                repeat
                                    l_CustLedgEntry.Get(l_DetCustLedgEntry."Cust. Ledger Entry No.");
                                    if l_CustLedgEntry.Open then
                                        l_CustAmount += l_DetCustLedgEntry.Amount;
                                until l_DetCustLedgEntry.next() = 0;
                            StartBalance := l_CustAmount;
                            CustBalance := l_CustAmount;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Customer.Copyfilter("Currency Filter", TempCurrency2.Code);
                    end;
                }
                dataitem(AgingBandLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                    column(AgingDate1; Format(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2; Format(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; Format(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3; Format(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; Format(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4; Format(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; StrSubstNo(AgedSumTxt, AgingBandEndingDate, PeriodLength, SelectStr(DateChoice + 1, DuePostDateTxt)))
                    {
                    }
                    column(AgingDate41; Format(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; Format(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt; TempAgingBandBuf."Column 1 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt; TempAgingBandBuf."Column 2 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt; TempAgingBandBuf."Column 3 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt; TempAgingBandBuf."Column 4 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt; TempAgingBandBuf."Column 5 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                    {
                    }
                    column(beforeCaption; beforeCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            if not TempAgingBandBuf.Find('-') then
                                CurrReport.Break();
                        end else
                            if TempAgingBandBuf.next() = 0 then
                                CurrReport.Break();
                        AgingBandCurrencyCode := TempAgingBandBuf."Currency Code";
                        if AgingBandCurrencyCode = '' then
                            AgingBandCurrencyCode := GLSetup."LCY Code";

                        LinesInDataset += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not IncludeAgingBand then
                            CurrReport.Break();
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                TempAgingBandBuf.DeleteAll();
                CurrReport.Language := LanguageCU.GetLanguageIdOrDefault("Language Code");
                PrintLine := false;
                Cust2 := Customer;
                Copyfilter("Currency Filter", TempCurrency2.Code);
                if PrintAllHavingBal then
                    if TempCurrency2.Findset() then
                        repeat
                            Cust2.SetRange("Date Filter", 0D, EndDate);
                            Cust2.SetRange("Currency Filter", TempCurrency2.Code);
                            Cust2.CalcFields("Net Change");
                            PrintLine := Cust2."Net Change" <> 0;
                        until (TempCurrency2.next() = 0) or PrintLine;
                if (not PrintLine) and PrintAllHavingEntry then begin
                    "Cust. Ledger Entry".Reset();
                    "Cust. Ledger Entry".SetCurrentkey("Customer No.", "Posting Date");
                    "Cust. Ledger Entry".SetRange("Customer No.", "No.");
                    "Cust. Ledger Entry".SetRange("Posting Date", StartDate, EndDate);
                    if ShowOutstandingOnly then
                        "Cust. Ledger Entry".SetRange(Open, true);
                    Copyfilter("Currency Filter", "Cust. Ledger Entry"."Currency Code");
                    PrintLine := not "Cust. Ledger Entry".IsEmpty;
                end;
                if not PrintLine then
                    CurrReport.Skip();

                FormatAddr.Customer(CustAddr, Customer);

                if not CurrReport.Preview then begin
                    LockTable();
                    Find();
                    "Last Statement No." := "Last Statement No." + 1;
                    modify();
                    Commit();
                end else
                    "Last Statement No." := "Last Statement No." + 1;

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          7, Format("Last Statement No."), 0, 0, Database::Customer, "No.", "Salesperson Code", '',
                          StatementTxt + Format("Last Statement No."), '');
                IsFirstLoop := false;
            end;

            trigger OnPreDataItem()
            begin
                VerifyDates();
                AgingBandEndingDate := EndDate;
                CalcAgingBandDates();

                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                TempCurrency2.Code := '';
                TempCurrency2.Insert();
                Copyfilter("Currency Filter", Currency.Code);
                if Currency.Findset() then
                    repeat
                        TempCurrency2 := Currency;
                        TempCurrency2.Insert();
                    until Currency.next() = 0;
            end;
        }
        dataitem(BlankReportLine; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(BlankLine; 'BlankLine')
            {
            }

            trigger OnPreDataItem()
            begin
                if LinesInDataset > 0 then
                    CurrReport.Break();
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
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Start Date';
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'End Date';
                    }
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Show Overdue Entries';
                    }
                    group(Include)
                    {
                        Caption = 'Include';
                        field(IncludeAllCustomerswithLE; PrintAllHavingEntry)
                        {
                            ApplicationArea = All;
                            Caption = 'Include All Customers with Ledger Entries';
                            ToolTip = 'Include All Customers with Ledger Entries';
                            MultiLine = true;

                            trigger OnValidate()
                            begin
                                if not PrintAllHavingEntry then
                                    PrintAllHavingBal := true;
                            end;
                        }
                        field(IncludeAllCustomerswithBalance; PrintAllHavingBal)
                        {
                            ApplicationArea = All;
                            Caption = 'Include All Customers with a Balance';
                            ToolTip = 'Include All Customers with a Balance';
                            MultiLine = true;

                            trigger OnValidate()
                            begin
                                if not PrintAllHavingBal then
                                    PrintAllHavingEntry := true;
                            end;
                        }
                        field(IncludeReversedEntries; PrintReversedEntries)
                        {
                            ApplicationArea = All;
                            Caption = 'Include Reversed Entries';
                            ToolTip = 'Include Reversed Entries';
                        }
                        field(IncludeUnappliedEntries; PrintUnappliedEntries)
                        {
                            ApplicationArea = All;
                            Caption = 'Include Unapplied Entries';
                            ToolTip = 'Include Unapplied Entries';
                        }
                        field(ShowOutstandingOnlyFld; ShowOutstandingOnly)
                        {
                            ApplicationArea = All;
                            Caption = 'Show Outstanding Balances Only';
                            ToolTip = 'Show Outstanding Balances Only';
                        }
                    }
                    group(AgingBand)
                    {
                        Caption = 'Aging Band';
                        field(IncludeAgingBandFld; IncludeAgingBand)
                        {
                            ApplicationArea = All;
                            Caption = 'Include Aging Band';
                            ToolTip = 'Include Aging Band';
                        }
                        field(AgingBandPeriodLengt; PeriodLength)
                        {
                            ApplicationArea = All;
                            Caption = 'Aging Band Period Length';
                            ToolTip = 'Aging Band Period Length';
                        }
                        field(AgingBandby; DateChoice)
                        {
                            ApplicationArea = All;
                            Caption = 'Aging Band by';
                            ToolTip = 'Aging Band by';
                            OptionCaption = 'Due Date,Posting Date';
                        }
                    }
                    field(LogInteractionFld; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        ToolTip = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitRequestPageDataInternal();
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GLSetup.Get();
        LogInteractionEnable := true;
        CompanyInfo.Get();
        SalesSetup.Get();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."logo position on documents"::"No Logo":
                ;
            SalesSetup."logo position on documents"::Left:
                begin
                    CompanyInfo3.Get();
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;

        InitRequestPageDataInternal();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        Cust2: Record Customer;
        Currency: Record Currency;
        TempCurrency2: Record Currency temporary;
        "Cust. Ledger Entry": Record "Cust. Ledger Entry";
        DtldCustLedgEntries2: Record "Detailed Cust. Ledg. Entry";
        TempAgingBandBuf: Record "Aging Band Buffer" temporary;
        SalesInvHeader: Record "Sales Invoice Header";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        LanguageCU: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        "Due Date": Date;
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        Description: Text;
        StartBalance: Decimal;
        CustBalance: Decimal;
        "Remaining Amount": Decimal;
        CurrencyCode3: Code[20];
        MultiCurrTxt: label 'Multicurrency Application';
        PaymentDiscTxt: label 'Payment Discount';
        RoundTxt: label 'Rounding';
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array[5] of Date;
        EntriesTxt: label 'Entries %1', Comment = '%1=country code';
        OverdueTxt: label 'Overdue Entries %1', Comment = '%1=country code';
        StatementTxt: label 'Statement ';
        SpecifyAgingBandTxt: label 'You must specify the Aging Band Period Length.';
        AgingBandEndingDate: Date;
        SpecAgingBandDateTxt: label 'You must specify Aging Band Ending Date.';
        AgedSumTxt: label 'Aged Summary by %1 (%2 by %3)', Comment = '%1, %2, %3';
        IncludeAgingBand: Boolean;
        PeriodLgthTxt: label 'Period Length is out of range.';
        AgingBandCurrencyCode: Code[20];
        DuePostDateTxt: label 'Due Date,Posting Date';
        ApplWriteoffsTxt: label 'Application Writeoffs';
        LogInteractionEnable: Boolean;
        NegatingPeriodTxt: label '-%1', Comment = 'Negating the period length: %1 is the period length';
        StatementCaptionLbl: label 'Statement';
        PhoneNoCaptionLbl: label 'Phone No.';
        VATRegNoCaptionLbl: label 'VAT Registration No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        BankAccountNoCaptionLbl: label 'Account No.';
        CustomerNoCaptionLbl: label 'Customer No.';
        StartDateCaptionLbl: label 'Starting Date';
        EndDateCaptionLbl: label 'Ending Date';
        StatementNoCaptionLbl: label 'Statement No.';
        PostingDateCaptionLbl: label 'Posting Date';
        DueDateCaptionLbl: label 'Due Date';
        BalanceCaptionLbl: label 'Balance';
        TotalCaptionLbl: label 'Total';
        beforeCaptionLbl: label '..before';
        BlankStartDateErr: label 'Start Date must have a value.';
        BlankEndDateErr: label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: label 'Start date must be earlier than End date.';
        IsFirstLoop: Boolean;
        isInitialized: Boolean;
        Total_CaptionLbl: label 'Total';
        HomePageCaptionLbl: label 'Home Page';
        EmailCaptionLbl: label 'E-Mail';
        DocumentDateCaptionLbl: label 'Document Date';
        DescriptionCaptionLbl: label 'Description';
        OrglAmtCaptionLbl: label 'Original Amount';
        RemainingAmtCaptionLbl: label 'Remaining Amount';
        CurrencyCodeCaptionLbl: label 'Currency Code';
        DocumentNoCaptionLbl: label 'Document No';
        CustRef: Code[30];
        CustRefCaptionLbl: label 'Reference';
        ShowOutstandingOnly: Boolean;
        LinesInDataset: Integer;

    local procedure GetDate(PostingDate: Date; DueDate_DtldCustLedgEntries: Date): Date
    begin
        if DateChoice = Datechoice::"Posting Date" then
            exit(PostingDate);

        exit(DueDate_DtldCustLedgEntries);
    end;

    local procedure CalcAgingBandDates()
    begin
        if not IncludeAgingBand then
            exit;
        if AgingBandEndingDate = 0D then
            Error(SpecAgingBandDateTxt);
        if Format(PeriodLength) = '' then
            Error(SpecifyAgingBandTxt);
        Evaluate(PeriodLength2, StrSubstNo(NegatingPeriodTxt, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CalcDate(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CalcDate(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CalcDate(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CalcDate(PeriodLength2, AgingDate[2]);
        if AgingDate[2] <= AgingDate[1] then
            Error(PeriodLgthTxt);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal)
    var
        I: Integer;
        GoOn: Boolean;
    begin
        TempAgingBandBuf.Init();
        TempAgingBandBuf."Currency Code" := CurrencyCode;
        if not TempAgingBandBuf.Find() then
            TempAgingBandBuf.Insert();
        I := 1;
        GoOn := true;
        while (I <= 5) and GoOn do begin
            if Date <= AgingDate[I] then
                if I = 1 then begin
                    TempAgingBandBuf."Column 1 Amt." := TempAgingBandBuf."Column 1 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 2 then begin
                    TempAgingBandBuf."Column 2 Amt." := TempAgingBandBuf."Column 2 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 3 then begin
                    TempAgingBandBuf."Column 3 Amt." := TempAgingBandBuf."Column 3 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 4 then begin
                    TempAgingBandBuf."Column 4 Amt." := TempAgingBandBuf."Column 4 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 5 then begin
                    TempAgingBandBuf."Column 5 Amt." := TempAgingBandBuf."Column 5 Amt." + Amount;
                    GoOn := false;
                end;
            I := I + 1;
        end;
        TempAgingBandBuf.modify();
    end;

    local procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record "Detailed Cust. Ledg. Entry"): Boolean
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if PrintReversedEntries and PrintUnappliedEntries then
            exit(false);
        if not PrintUnappliedEntries then
            if DtldCustLedgEntries.Unapplied then
                exit(true);
        if not PrintReversedEntries then begin
            CustLedgEntry.Get(DtldCustLedgEntries."Cust. Ledger Entry No.");
            if CustLedgEntry.Reversed then
                exit(true);
        end;
        exit(false);
    end;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewPrintEntriesDue">Boolean.</param>
    /// <param name="NewPrintAllHavingEntry">Boolean.</param>
    /// <param name="NewPrintAllHavingBal">Boolean.</param>
    /// <param name="NewPrintReversedEntries">Boolean.</param>
    /// <param name="NewPrintUnappliedEntries">Boolean.</param>
    /// <param name="NewIncludeAgingBand">Boolean.</param>
    /// <param name="NewPeriodLength">Text[30].</param>
    /// <param name="NewDateChoice">Option.</param>
    /// <param name="NewLogInteraction">Boolean.</param>
    /// <param name="NewStartDate">Date.</param>
    /// <param name="NewEndDate">Date.</param>
    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean; NewStartDate: Date; NewEndDate: Date)
    begin
        InitRequestPageDataInternal();

        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        IncludeAgingBand := NewIncludeAgingBand;
        Evaluate(PeriodLength, NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteraction := NewLogInteraction;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    local procedure InitRequestPageDataInternal()
    begin
        if isInitialized then
            exit;

        isInitialized := true;

        if (not PrintAllHavingEntry) and (not PrintAllHavingBal) then
            PrintAllHavingBal := true;

        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Stmnt.") <> '';
        LogInteractionEnable := LogInteraction;

        if Format(PeriodLength) = '' then
            Evaluate(PeriodLength, '<1M+CM>');
    end;

    local procedure VerifyDates()
    begin
        if StartDate = 0D then
            Error(BlankStartDateErr);
        if EndDate = 0D then
            Error(BlankEndDateErr);
        if StartDate > EndDate then
            Error(StartDateLaterTheEndDateErr);
    end;

    /// <summary>
    /// SetCustomerAndDates.
    /// </summary>
    /// <param name="NewStartDate">Date.</param>
    /// <param name="NewEndDate">Date.</param>
    procedure SetCustomerAndDates(NewStartDate: Date; NewEndDate: Date)
    begin
        if 0D in [NewStartDate, NewEndDate] then
            Error('Start or Ending dates cannot be empty.');

        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    /// <summary>
    /// SetShowOutStandingOnly.
    /// </summary>
    /// <param name="pShowOutstandingOnly">Boolean.</param>
    procedure SetShowOutStandingOnly(pShowOutstandingOnly: Boolean)
    begin
        ShowOutstandingOnly := pShowOutstandingOnly;
    end;
}

