/// <summary>
/// TableExtension PDCCustomer (ID 50002) extends Record Customer.
/// </summary>
tableextension 50002 PDCCustomer extends Customer
{
    fields
    {
        field(50000; "PDC Do not send E-Mails"; Boolean)
        {
            Caption = 'Do not send E-Mails';
        }
        field(50001; "PDC Do not print/send reports"; Boolean)
        {
            Caption = 'Do not print/send reports';
        }
        field(50003; "PDC Carriage Charge Limit"; Decimal)
        {
            Caption = 'Carriage Charge Limit';
            MinValue = 0;
        }
        field(50004; "PDC Allow Auto-Pick"; Boolean)
        {
            Caption = 'Allow Auto-Pick';
            InitValue = true;
        }
        field(50005; "PDC Default Branch No."; Code[20])
        {
            Caption = 'Default Branch No.';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("No."));
        }
        field(50006; "PDC Branch Mandatory"; Boolean)
        {
        }
        field(50007; "PDC Statement E-Mail"; Text[50])
        {
            Caption = 'Statement E-Mail';
        }
        field(50008; "PDC Invoice E-Mail"; Text[50])
        {
            Caption = 'Invoice E-Mail';
        }
        field(50009; "PDC Block Release"; Boolean)
        {
            Caption = 'Block Release';
        }
        field(50011; "PDC Send Statement"; Boolean)
        {
            Caption = 'Send Statement';
        }
        field(50012; "PDC Send Invoice"; Boolean)
        {
            Caption = 'Send Invoice';
        }
        field(50013; "PDC Statement Mailing Group"; code[10])
        {
            Caption = 'Statement Mailing Group';
            TableRelation = "Mailing Group".Code;
        }
        field(50014; "PDC Invoice Mailing Group"; code[10])
        {
            Caption = 'Invoice Mailing Group';
            TableRelation = "Mailing Group".Code;
        }
        field(50015; "PDC Print Statement"; Boolean)
        {
            Caption = 'Print Statement';
        }
        field(50016; "PDC Print Invoice"; Boolean)
        {
            Caption = 'Print Invoice';
        }
        field(50019; "PDC Company Number"; Text[30])
        {
            Caption = 'Company Number';
        }
        field(50020; "PDC Use Custom Reason Codes"; Boolean)
        {
            Caption = 'Use Custom Reason Codes';
        }
        field(50021; "PDC Portal Theme"; Option)
        {
            Caption = 'Portal Theme';
            OptionMembers = Default,"Autumnal Orange","Forest Green","Ruby Red";
        }
        field(50022; "PDC Portal Logo"; Text[250])
        {
        }
        field(50023; "PDC PO Number Format"; Text[30])
        {
            Caption = 'PO Number Format';
        }
        field(50024; "PDC Contract No. Format"; Text[30])
        {
            Caption = 'Contract No. Format';
        }
        field(50025; "PDC Portal Default Split Order"; Boolean)
        {
            Caption = 'Portal Default Split Order';
            InitValue = true;
        }
        field(50026; "PDC Entitlement Enabled"; Boolean)
        {
            Caption = 'Entitlement Enabled';

            trigger OnValidate()
            var
                StaffEntitlement: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlement.UpdateStaffEntitlementFromCustomer(Rec, xRec);
            end;
        }
        field(50027; "PDC Over Entitlement Action"; enum "PDC Over Entitlement Action")
        {
            Caption = 'Over Entitlement Action';
        }
    }

    /// <summary>
    /// SendStatement.
    /// </summary>
    /// <param name="pStartDate">Date.</param>
    /// <param name="pEndDate">Date.</param>
    /// <param name="pShowConfirm">Boolean.</param>
    /// <param name="pShowOutstandingOnly">Boolean.</param>
    procedure SendStatement(pStartDate: Date; pEndDate: Date; pShowConfirm: Boolean; pShowOutstandingOnly: Boolean)
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PDCEmailManagementSetup: Record "PDC Email Management Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustStatement: Report Statement;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        EmailStr: Text;
        FileName: Text[250];
    begin

        if pShowConfirm then
            if not Confirm('Do you want to send the Customer Statement ?') then
                Error('');

        SalesReceivablesSetup.Get();
        PDCEmailManagementSetup.Get(SalesReceivablesSetup."PDC Statement E-mail Setup", PDCEmailManagementSetup.Type::Setup, 0);
        Clear(CustStatement);
        if (pStartDate <> 0D) and (pEndDate <> 0D) then
            CustStatement.InitializeRequest(
                false, //PrintEntriesDue
                false, //PrintAllHavingEntry
                true, //PrintAllHavingBal
                false, //PrintReversedEntries
                false, //PrintUnappliedEntries
                false, //IncludeAgingBand
                '1M+CM', //PeriodLength
                0, //DateChoice
                false, //LogInteraction
                pStartDate, //StartDate
                pEndDate //EndDate
                )
        else
            CustStatement.InitializeRequest(
                false, //PrintEntriesDue
                false, //PrintAllHavingEntry
                true, //PrintAllHavingBal
                false, //PrintReversedEntries
                false, //PrintUnappliedEntries
                false, //IncludeAgingBand
                '1M+CM', //PeriodLength
                0, //DateChoice
                false, //LogInteraction
                SalesReceivablesSetup."PDC Def.Cust.Statm. Start Date", //StartDate
                SalesReceivablesSetup."PDC Def. Cust. Statm. End Date" //EndDate
            );

        if "PDC Send Statement" then
            if ("E-Mail" <> '') or ("PDC Statement E-Mail" <> '') or ("PDC Statement Mailing Group" <> '') then begin

                CustLedgerEntry.Reset();
                CustLedgerEntry.SetRange("Customer No.", "No.");
                CustLedgerEntry.SetRange(Open, true);
                if not CustLedgerEntry.IsEmpty then begin
                    FileName := 'Statement_' + "No." + '_' + Format(WorkDate(), 10, '<Year4><Month,2><Day,2>') + '.pdf';

                    TempBlob.CreateOutStream(OutStr);


                    Customer.SetRange("No.", "No.");
                    CustStatement.SetTableview(Customer);
                    CustStatement.SaveAs('', ReportFormat::Pdf, OutStr);

                    if "PDC Statement E-Mail" <> '' then
                        EmailStr := "PDC Statement E-Mail"
                    else
                        EmailStr := "E-Mail";

                    if (EmailStr <> '') then
                        PDCEmailManagementSetup.ProcessEmail(PDCEmailManagementSetup.Code, CopyStr(EmailStr, 1, 80), Name, 'Peter Drew Contracts Ltd', '', FileName, TempBlob, "No.", "PDC Statement Mailing Group");
                end;
            end;

        if "PDC Print Statement" then begin
            Clear(CustStatement);
            SetRecfilter();
            CustStatement.SetTableview(Rec);
            CustStatement.UseRequestPage(pShowConfirm);
            CustStatement.Run();
        end;
    end;

    /// <summary>
    /// SendStatementToAll.
    /// </summary>
    procedure SendStatementToAll()
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PDCEmailManagementSetup: Record "PDC Email Management Setup";
    begin
        if not Confirm('Do you want to send the Customer Statement to all Customers ?') then
            Error('');

        SalesReceivablesSetup.Get();
        PDCEmailManagementSetup.Get(SalesReceivablesSetup."PDC Statement E-mail Setup", PDCEmailManagementSetup.Type::Setup, 0);

        Customer.Reset();
        if Customer.FindSet() then
            repeat
                if Customer."PDC Send Statement" then
                    Customer.SendStatement(
                        SalesReceivablesSetup."PDC Def.Cust.Statm. Start Date",
                        SalesReceivablesSetup."PDC Def. Cust. Statm. End Date",
                        false,
                        false);
            until Customer.Next() = 0;
    end;

}

