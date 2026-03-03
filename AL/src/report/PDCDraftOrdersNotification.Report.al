/// <summary>
/// Report PDCDraftOrdersNotification (ID 50042).
/// </summary>
report 50042 PDCDraftOrdersNotification
{
    Caption = 'Draft Orders Notification';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("PDC Portal User"; "PDC Portal User")
        {
            trigger OnAfterGetRecord()
            var
                PDCDraftOrderHeader: Record "PDC Draft Order Header";
                PDCPortalMgt: Codeunit "PDC Portal Mgt";
                EmailMessage: Codeunit "Email Message";
                Email: Codeunit Email;
                BodyText: Text;
                tableLine: Text;
                ListTo: list of [Text];
                ListCC: list of [Text];
            begin
                PDCPortalMgt.FilterDraftOrdersForCreatedByMe("PDC Portal User", PDCDraftOrderHeader);
                if PDCDraftOrderHeader.FindSet() then begin
                    BodyText := RawBodyText;
                    MapHTMLFields(BodyText, '{{CustomerName}}', PDCDraftOrderHeader."Sell-to Customer Name");
                    tableLine := '';
                    repeat
                        tableLine += '<tr>';
                        tableLine += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + PDCDraftOrderHeader."Document No." + '</td>';
                        tableLine += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + PDCDraftOrderHeader."PO No." + '</td>';
                        tableLine += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + CurrencySymbol + Format(PDCPortalMgt.GetDraftOrderTotal(PDCDraftOrderHeader)) + '</td>';
                        tableLine += '</tr>';
                    until PDCDraftOrderHeader.Next() = 0;
                    MapHTMLFields(BodyText, '{{tableLine}}', tableLine);
                    Clear(ListTo);
                    ListTo.Add("PDC Portal User"."E-Mail");
                    EmailMessage.Create(ListTo, 'Draft Order Notification', BodyText, true, ListCC, ListBCC);
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
        CurrencySymbol := GeneralLedgerSetup."Local Currency Symbol";
        SalesReceivablesSetup.Get();
        if Attachment.Get(SalesReceivablesSetup."PDC Order Notif. E-mail Body") then
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
        CurrencySymbol: Text[10];

}
