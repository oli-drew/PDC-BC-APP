/// <summary>
/// OnAfterGetRecord.
/// </summary>
Report 50037 "PDC Entitlement E-mail"
{

    ProcessingOnly = true;

    dataset
    {
        dataitem(User; "PDC Portal User")
        {
            DataItemTableView = where("E-Mail" = filter(<> ''), "Entitlement Email Report" = const(true));
            RequestFilterFields = Id, "Customer No.";

            trigger OnAfterGetRecord()
            begin
                EmailEntitlement(User);
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

    local procedure EmailEntitlement(PortalUser: Record "PDC Portal User")
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        Branch: Record "PDC Branch";
        PortalUserBranch: Record "PDC Portal User Branch";
        Staff: Record "PDC Branch Staff";
        WardrobeHeader: Record "PDC Wardrobe Header";
        AttRec: Record Attachment;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        ListTo: list of [Text];
        ListCC: list of [Text];
        ListBCC: list of [Text];
        BodyText: Text;
        BlobInStream: InStream;
        LinesBodyText: Text;
        ProdCnt: Integer;
        ItemCnt: Decimal;
    begin
        CompanyInfo.Get();
        if (CompanyInfo.Name = '') or (CompanyInfo."E-Mail" = '') then
            exit;

        if PortalUser."E-Mail" = '' then
            exit;

        if not (Customer.get(PortalUser."Customer No.") and Customer."PDC Entitlement Enabled") then
            exit;

        Branch.SetRange("Customer No.", PortalUser."Customer No.");
        if Branch.Findset() then
            repeat
                if PortalUserBranch.Get(PortalUser.Id, Branch."Customer No.", Branch."Branch No.") then begin
                    Staff.SetRange("Sell-to Customer No.", Branch."Customer No.");
                    Staff.SetRange("Branch ID", Branch."Branch No.");
                    Staff.SetRange(Blocked, false);
                    if Staff.Findset() then
                        repeat
                            CalcCount(Staff."Staff ID", ProdCnt, ItemCnt);
                            if ProdCnt > 0 then begin
                                if BodyText = '' then begin
                                    SalesSetup.Get();
                                    if AttRec.Get(SalesSetup."PDC Entitlement E-mail Body") then
                                        AttRec.CalcFields("Attachment File");
                                    if AttRec."Attachment File".Hasvalue then begin
                                        AttRec."Attachment File".CreateInstream(BlobInStream, Textencoding::UTF8);
                                        BlobInStream.Read(BodyText);
                                    end;
                                    if BodyText = '' then
                                        exit;
                                end;
                                Clear(WardrobeHeader);
                                WardrobeHeader.SetRange("Wardrobe ID", Staff."Wardrobe ID");
                                if WardrobeHeader.FindFirst() then;

                                LinesBodyText += '<tr>';
                                LinesBodyText += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + Staff.Name + '</td>';
                                LinesBodyText += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + Staff."Wearer ID" + '</td>';
                                LinesBodyText += '<td bgcolor=white valign=top>' + Branch.Name + '</td>';
                                LinesBodyText += '<td bgcolor=white valign=top>' + WardrobeHeader.Description + '</td>';
                                LinesBodyText += '<td bgcolor=white valign=top>' + Format(ProdCnt) + '</td>';
                                LinesBodyText += '<td bgcolor=white valign=top>' + Format(ItemCnt) + '</td>';
                                LinesBodyText += '</tr>';
                            end;
                        until Staff.next() = 0;
                end;
            until Branch.next() = 0;

        if LinesBodyText = '' then
            exit;

        MapHTMLFields(BodyText, '{{CustomerName}}', PortalUser.Name);
        MapHTMLFields(BodyText, '{{tableLine}}', LinesBodyText);

        ListTo.Add(PortalUser."E-Mail");
        ListBCC.Add('uniforms@peterdrew.com');
        EmailMessage.Create(ListTo, 'Entitlement report', BodyText, true, ListCC, ListBCC);
        Email.Send(EmailMessage, enum::"Email Scenario"::Default);
    end;

    local procedure MapHTMLFields(var SourceText: Text; FieldName: Text; FieldValue: Text)
    begin
        while StrPos(SourceText, FieldName) <> 0 do
            SourceText := CopyStr(SourceText, 1, StrPos(SourceText, FieldName) - 1) +
                          FieldValue +
                          CopyStr(SourceText, StrPos(SourceText, FieldName) + StrLen(FieldName));
    end;

    local procedure CalcCount(StaffID: Code[20]; var ProdCnt: Integer; var ItemCnt: Decimal)
    var
        BranchStaff1: Record "PDC Branch Staff";
        Entitlement: Record "PDC Staff Entitlement";
    begin
        Clear(ProdCnt);
        Clear(ItemCnt);

        BranchStaff1.Get(StaffID);

        Entitlement.Reset();
        Entitlement.SetRange("Staff ID", BranchStaff1."Staff ID");
        Entitlement.SetRange("Wardrobe ID", BranchStaff1."Wardrobe ID");
        Entitlement.SetRange("Item Type", Entitlement."item type"::Core);
        Entitlement.SetRange(Inactive, false);
        Entitlement.SetRange("Wardrobe Discontinued", false);
        Entitlement.SetFilter("Calc. Qty. Remaining in Period", '>0');
        if Entitlement.Findset() then
            repeat
                ProdCnt += 1;
                ItemCnt += Entitlement."Calc. Qty. Remaining in Period";
            until Entitlement.next() = 0;
    end;
}

