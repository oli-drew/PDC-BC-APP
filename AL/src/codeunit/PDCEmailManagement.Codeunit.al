/// <summary>
/// Codeunit PDC Email Management (ID 50006).
/// </summary>
Codeunit 50006 "PDC Email Management"
{

    TableNo = "PDC Email Management Setup";

    trigger OnRun()
    begin
        Rec.TestField(Type, Rec.Type::Log);

        SendEmail(Rec);
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        EmailErr: label 'The email address "%1" is invalid.', Comment = '%1=email address';


    local procedure SendEmail(var EmailMgmtLog: Record "PDC Email Management Setup")
    var
        EmailMgmtLog2: Record "PDC Email Management Setup";
        MailingGroupContacts: Record "Contact Mailing Group";
        Contact: Record Contact;
        ReportSelections: Record "Report Selections";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCMHeader: Record "Sales Cr.Memo Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        TestEmailAddress: Text[100];
        InStr: InStream;
        OutStr: OutStream;
        CurrLineText: Text;
        BodyText: Text;
        ListTo: list of [Text];
        ListCC: list of [Text];
        ListBCC: list of [Text];
        SendOK: Boolean;
        ReportNo: Integer;
    begin
        SalesSetup.Get();
        TestEmailAddress := SalesSetup."PDC Test E-Mail Address";

        EmailMgmtLog.CalcFields("Body BLOB");
        if EmailMgmtLog."Body BLOB".Hasvalue then begin
            EmailMgmtLog."Body BLOB".CreateInstream(InStr);
            repeat
                InStr.ReadText(CurrLineText);
                BodyText := BodyText + CurrLineText;
            until InStr.eos;
        end else
            BodyText := EmailMgmtLog.Body;

        if TestEmailAddress > '' then //In Test Mode
            ListTo.Add(TestEmailAddress)
        else
            ListTo.Add(EmailMgmtLog."Email Address");
        if EmailMgmtLog."Mailing Group" <> '' then begin
            MailingGroupContacts.setrange("Mailing Group Code", EmailMgmtLog."Mailing Group");
            if MailingGroupContacts.FindSet() then
                repeat
                    Contact.Get(MailingGroupContacts."Contact No.");
                    if Contact."E-Mail" <> '' then
                        ListTo.Add(Contact."E-Mail");
                    if Contact."E-Mail 2" <> '' then
                        ListTo.Add(Contact."E-Mail 2");
                until MailingGroupContacts.Next() = 0;
        end;
        if EmailMgmtLog."CC Addresses" <> '' then
            ListCC.Add(EmailMgmtLog."CC Addresses");
        EmailMessage.Create(ListTo, EmailMgmtLog.Subject, BodyText, true, ListCC, ListBCC);

        // if EmailMgmtLog."File Attachment Location Log" <> '' then begin
        //     InputFile.Open(EmailMgmtLog."File Attachment Location Log");
        //     InputFile.CreateInStream(instr);
        //     EmailMessage.AddAttachment(copystr(FileMgt.GetFileName(EmailMgmtLog."File Attachment Location Log"), 1, 250), 'PDF', instr);
        //     InputFile.Close();
        //     clear(instr);
        // end;

        if EmailMgmtLog."Source RecordId".TableNo <> 0 then
            case EmailMgmtLog.Code of
                SalesSetup."PDC Invoice E-mail Setup":
                    if RecRef.GET(EmailMgmtLog."Source RecordId") then begin
                        RecRef.SetRecFilter();
                        RecRef.SETTABLE(SalesInvHeader);

                        if ReportSelections.Get(ReportSelections.Usage::"S.Invoice", 1) then
                            ReportNo := ReportSelections."Report ID"
                        else
                            ReportNo := 206;

                        TempBlob.CreateOutStream(OutStr);
                        Report.SaveAs(ReportNo, '', ReportFormat::Pdf, OutStr, RecRef);
                        TempBlob.CreateInStream(InStr);
                        EmailMessage.AddAttachment('Invoice_' + SalesInvHeader."No." + '.pdf', 'PDF', InStr);
                    end;
                SalesSetup."PDC Credit Memo E-mail Setup":
                    if RecRef.GET(EmailMgmtLog."Source RecordId") then begin
                        RecRef.SetRecFilter();
                        RecRef.SETTABLE(SalesCMHeader);

                        if ReportSelections.Get(ReportSelections.Usage::"S.Cr.Memo", 1) then
                            ReportNo := ReportSelections."Report ID"
                        else
                            ReportNo := 207;

                        TempBlob.CreateOutStream(OutStr);
                        Report.SaveAs(ReportNo, '', ReportFormat::Pdf, OutStr, RecRef);
                        TempBlob.CreateInStream(InStr);
                        EmailMessage.AddAttachment('CrMemo_' + SalesCMHeader."No." + '.pdf', 'PDF', InStr);
                    end;
            end;

        EmailMgmtLog.CalcFields(Attachment);
        if EmailMgmtLog.Attachment.HasValue then begin
            if EmailMgmtLog."File Attachment Location Log" = '' then
                EmailMgmtLog."File Attachment Location Log" := 'Attachment_' + EmailMgmtLog.Code + '.pdf';
            EmailMgmtLog.Attachment.CreateInStream(InStr);
            EmailMessage.AddAttachment(EmailMgmtLog."File Attachment Location Log", 'PDF', InStr);
        end;

        SendOK := Email.Send(EmailMessage, enum::"Email Scenario"::Default);

        EmailMgmtLog2.Get(EmailMgmtLog.Code, EmailMgmtLog.Type, EmailMgmtLog."Line No.");

        if SendOK then begin
            if TestEmailAddress > '' then
                EmailMgmtLog2."Email Address" := TestEmailAddress;
            EmailMgmtLog2.Sent := true;
            EmailMgmtLog2."Date Sent" := CurrentDatetime;
            EmailMgmtLog."Error Text" := '';
            EmailMgmtLog2.modify();
            Commit();
        end else begin
            if TestEmailAddress > '' then
                EmailMgmtLog2."Email Address" := TestEmailAddress;
            EmailMgmtLog2.Sent := false;
            EmailMgmtLog2."Date Sent" := CurrentDatetime;
            EmailMgmtLog2."Error Text" := CopyStr('Sending Failure. ' + GetLastErrorText, 1, MaxStrLen(EmailMgmtLog."Error Text"));
            EmailMgmtLog2.modify();
            Commit();
        end;
    end;

    /// <summary>
    /// SendEmails.
    /// </summary>
    procedure SendEmails()
    var
        EmailMgmtLog: Record "PDC Email Management Setup";
    begin
        EmailMgmtLog.Reset();
        EmailMgmtLog.SetCurrentkey(Sent);
        EmailMgmtLog.SetRange(Type, EmailMgmtLog.Type::Log);
        EmailMgmtLog.SetRange(Sent, false);
        EmailMgmtLog.SetRange(Skip, false);
        if EmailMgmtLog.Findset() then
            repeat
                SendEmail(EmailMgmtLog);
            until EmailMgmtLog.next() = 0;
    end;

    /// <summary>
    /// CheckValidEmailAddresses.
    /// </summary>
    /// <param name="Recipients">Text[1024].</param>
    /// <param name="ErrorText">Text[250].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckValidEmailAddresses(Recipients: Text; ErrorText: Text): Boolean
    var
        s: Text;
    begin
        if Recipients = '' then begin
            ErrorText := StrSubstNo(EmailErr, Recipients);
            exit(false);
        end;

        s := Recipients;
        while StrPos(s, ';') > 1 do begin
            if not CheckValidEmailAddress(CopyStr(s, 1, StrPos(s, ';') - 1), ErrorText) then
                exit(false);
            s := CopyStr(s, StrPos(s, ';') + 1);
        end;

        if not CheckValidEmailAddress(s, ErrorText) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// CheckValidEmailAddress.
    /// </summary>
    /// <param name="EmailAddress">Text[250].</param>
    /// <param name="ErrorText">VAR Text[250].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckValidEmailAddress(EmailAddress: Text; var ErrorText: Text): Boolean
    var
        i: Integer;
        NoOfAtSigns: Integer;
    begin
        if EmailAddress = '' then begin
            ErrorText := StrSubstNo(EmailErr, EmailAddress);
            exit(false);
        end;

        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then begin
            ErrorText := StrSubstNo(EmailErr, EmailAddress);
            exit(false);
        end;

        for i := 1 to StrLen(EmailAddress) do begin
            if EmailAddress[i] = '@' then
                NoOfAtSigns := NoOfAtSigns + 1;
            if not (
              ((EmailAddress[i] >= 'a') and (EmailAddress[i] <= 'z')) or
              ((EmailAddress[i] >= 'A') and (EmailAddress[i] <= 'Z')) or
              ((EmailAddress[i] >= '0') and (EmailAddress[i] <= '9')) or
              (EmailAddress[i] in ['@', '.', '-', '_']))
            then begin
                ErrorText := StrSubstNo(EmailErr, EmailAddress);
                exit(false);
            end;
        end;

        if NoOfAtSigns <> 1 then begin
            ErrorText := StrSubstNo(EmailErr, EmailAddress);
            exit(false);
        end;

        exit(true);
    end;
}

