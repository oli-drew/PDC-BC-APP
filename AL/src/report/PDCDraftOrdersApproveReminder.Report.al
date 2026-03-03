/// <summary>
/// Report PDCDraftOrdersApproveReminder (ID 50061).
/// </summary>
report 50061 PDCDraftOrdersApproveReminder
{
    Caption = 'Draft Orders Approve Reminder';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("PDC Portal User"; "PDC Portal User")
        {
            DataItemTableView = where("User Type" = filter(Approver), "Approval Email Report" = const(true));
            trigger OnAfterGetRecord()
            var
                Contact: Record Contact;
                DraftOrderHeader: Record "PDC Draft Order Header";
                PortalUser: Record "PDC Portal User";
                PDCPortalMgt: Codeunit "PDC Portal Mgt";
                EmailMessage: Codeunit "Email Message";
                Email: Codeunit Email;
                BodyText: Text;
                tableLine: Text;
                ListTo: list of [Text];
                ListCC: list of [Text];
                SubjectTxt: label 'Approval Reminder';
            begin
                PDCPortalMgt.FilterDraftOrdersForMyApprovals("PDC Portal User", DraftOrderHeader);
                if DraftOrderHeader.FindSet() then begin
                    BodyText := RawBodyText;
                    Contact.get("Contact No.");
                    MapHTMLFields(BodyText, '{{CustomerName}}', Contact.Name);

                    tableLine := '';
                    repeat
                        PortalUser.SetRange("Contact No.", DraftOrderHeader."Created By ID");
                        if PortalUser.FindFirst() then
                            Contact.get(PortalUser."Contact No.")
                        else
                            clear(Contact);

                        tableLine += '<tr>';
                        tableLine += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + DraftOrderHeader."Document No." + '</td>';
                        tableLine += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + Contact.Name + '</td>';
                        tableLine += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + format(DraftOrderHeader."Awaiting Approval DT") + '</td>';
                        tableLine += '</tr>';
                    until DraftOrderHeader.Next() = 0;
                    MapHTMLFields(BodyText, '{{tableLine}}', tableLine);
                    Clear(ListTo);
                    ListTo.Add("PDC Portal User"."E-Mail");
                    EmailMessage.Create(ListTo, SubjectTxt, BodyText, true, ListCC, ListBCC);
                    Email.Send(EmailMessage, enum::"Email Scenario"::Default);
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Attachment: Record Attachment;
        InStream: InStream;
        EmailTmplErrorLbl: Label 'The email template does not exist';
    begin
        GeneralLedgerSetup.Get();
        SalesReceivablesSetup.Get();
        if Attachment.Get(SalesReceivablesSetup."PDC Order Appr.Rem.E-mail Body") then
            Attachment.CalcFields("Attachment File");
        if Attachment."Attachment File".HasValue then begin
            Attachment."Attachment File".CreateInStream(InStream, TextEncoding::UTF8);
            InStream.Read(RawBodyText);
        end;
        if RawBodyText = '' then
            Error(EmailTmplErrorLbl);
        ListBCC.Add('uniforms@peterdrew.com');
    end;

    local procedure MapHTMLFields(var SourceText: Text; FieldName: Text; FieldValue: Text)
    begin
        while StrPos(SourceText, FieldName) <> 0 do
            SourceText := CopyStr(SourceText, 1, StrPos(SourceText, FieldName) - 1) +
                          FieldValue +
                          CopyStr(SourceText, StrPos(SourceText, FieldName) + StrLen(FieldName));
    end;

    var
        RawBodyText: Text;
        ListBCC: list of [Text];

}