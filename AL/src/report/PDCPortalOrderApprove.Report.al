/// <summary>
/// Report PDC Portal - Order Approve (ID 50039).
/// </summary>
Report 50039 "PDC Portal - Order Approve"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("PDC Draft Order Header"; "PDC Draft Order Header")
        {
            RequestFilterFields = "Document No.";

            trigger OnAfterGetRecord()
            begin
                EmailHTML("PDC Draft Order Header");
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

    local procedure EmailHTML(Header: Record "PDC Draft Order Header")
    var
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        AttRec: Record Attachment;
        PortalUser: Record "PDC Portal User";
        TempApproversPortalUser: Record "PDC Portal User" temporary;
        BranchStaff: Record "PDC Branch Staff";
        PortalsManagement: Codeunit "PDC Portals Management";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        BodyText: Text;
        BlobInStream: InStream;
        ListTo: list of [Text];
        ListCC: list of [Text];
        ListBCC: list of [Text];
    begin
        CompanyInfo.Get();
        if (CompanyInfo.Name = '') or (CompanyInfo."E-Mail" = '') then
            exit;

        PortalUser.SetRange("Contact No.", Header."Created By ID");
        if not PortalUser.FindFirst() then
            exit;

        if BranchStaff.get(PortalUser."Staff ID") then
            PortalsManagement.GetStaffApproversList(TempApproversPortalUser, BranchStaff)
        else
            PortalsManagement.GetUserApproversList(TempApproversPortalUser, PortalUser);

        TempApproversPortalUser.setfilter("E-Mail", '<>%1', '');
        TempApproversPortalUser.setrange("Allow Approval Email", true);
        if not TempApproversPortalUser.FindSet() then
            exit;

        SalesSetup.Get();
        if AttRec.Get(SalesSetup."PDC Order Approval E-mail Body") then
            AttRec.CalcFields("Attachment File");
        if AttRec."Attachment File".Hasvalue then begin
            AttRec."Attachment File".CreateInstream(BlobInStream, Textencoding::UTF8);
            BlobInStream.Read(BodyText);
        end;

        if BodyText <> '' then begin
            MapHTMLFields(BodyText, '{{approvalName}}', TempApproversPortalUser.Name);
            MapHTMLFields(BodyText, '{{draftOrderNumber}}', Header."Document No.");
            MapHTMLFields(BodyText, '{{createdByName}}', PortalUser.Name);

            repeat
                ListTo.Add(TempApproversPortalUser."E-Mail");
            until TempApproversPortalUser.Next() = 0;

            EmailMessage.Create(ListTo, 'Order Approval Request ' + Header."Document No.", BodyText, true, ListCC, ListBCC);
            Email.Send(EmailMessage, enum::"Email Scenario"::Default);
        end;
    end;

    local procedure MapHTMLFields(var SourceText: Text; FieldName: Text; FieldValue: Text)
    begin
        while StrPos(SourceText, FieldName) <> 0 do
            SourceText := CopyStr(SourceText, 1, StrPos(SourceText, FieldName) - 1) +
                          FieldValue +
                          CopyStr(SourceText, StrPos(SourceText, FieldName) + StrLen(FieldName));
    end;
}

