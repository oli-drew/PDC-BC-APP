/// <summary>
/// Report PDC Portal - Return Confirm (ID 50028).
/// </summary>
Report 50028 "PDC Portal - Return Confirm"
{
    ProcessingOnly = true;
    Caption = 'Portal - Return Confirmation';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const("Return Order"));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                EmailHTML("Sales Header");
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

    local procedure EmailHTML(SalesHeader1: Record "Sales Header")
    var
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine1: Record "Sales Line";
        Item: Record Item;
        AttRec: Record Attachment;
        PortalUser: Record "PDC Portal User";
        NAVPortalsMgt: Codeunit "PDC Portals Management";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        BodyText: Text;
        BlobInStream: InStream;
        LinesBodyText: Text;
        CarriageAmt: Decimal;
        ListTo: list of [Text];
        ListCC: list of [Text];
        ListBCC: list of [Text];
    begin
        CompanyInfo.Get();
        if (CompanyInfo.Name = '') or (CompanyInfo."E-Mail" = '') then
            exit;


        SalesLine1.Reset();
        SalesLine1.SetRange("Document Type", SalesHeader1."Document Type");
        SalesLine1.SetRange("Document No.", SalesHeader1."No.");
        SalesLine1.SetRange(Type, SalesLine1.Type::Item);
        if SalesLine1.FindFirst() then begin
            PortalUser.SetRange("Contact No.", SalesLine1."PDC Ordered By ID");
            if PortalUser.FindFirst() then;
        end;

        if PortalUser."E-Mail" = '' then
            exit;

        SalesHeader1.SetRecfilter();

        SalesSetup.Get();
        if AttRec.Get(SalesSetup."PDC Return Conf. E-mail Body") then
            AttRec.CalcFields("Attachment File");
        if AttRec."Attachment File".Hasvalue then begin
            AttRec."Attachment File".CreateInstream(BlobInStream, Textencoding::UTF8);
            BlobInStream.Read(BodyText);
        end;

        if BodyText <> '' then begin
            SalesHeader1.CalcFields(Amount);

            SalesLine1.Reset();
            SalesLine1.SetRange("Document Type", SalesHeader1."Document Type");
            SalesLine1.SetRange("Document No.", SalesHeader1."No.");
            Clear(CarriageAmt);
            SalesLine1.SetRange(Type, SalesLine1.Type::"G/L Account");
            SalesLine1.SetRange("No.", SalesSetup."PDC Carriage Charge G/L Acc.");
            if SalesLine1.Findset() then
                repeat
                    CarriageAmt += SalesLine1."Line Amount";
                until SalesLine1.next() = 0;
            SalesLine1.SetRange(Type, SalesLine1.Type::Item);
            SalesLine1.SetRange("No.");
            if SalesLine1.FindFirst() then
                if SalesLine1.Findset() then
                    repeat
                        if not Item.Get(SalesLine1."No.") then Clear(Item);

                        LinesBodyText += '<tr>';
                        LinesBodyText += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + SalesLine1."PDC Wearer Name" + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top style="text-align: left;" class="align-left">' + SalesLine1.Description + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top>' + Item."PDC Colour" + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top>' + Item."PDC Size" + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top>' + Item."PDC Fit" + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top><span>£</span>' + Format(SalesLine1."Unit Price", 0, 9) + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top>' + Format(SalesLine1.Quantity) + '</td>';
                        LinesBodyText += '<td bgcolor=white valign=top><span>£</span>' + Format(SalesLine1."Line Amount", 0, 9) + '</td>';
                        LinesBodyText += '</tr>';
                    until SalesLine1.next() = 0;

            MapHTMLFields(BodyText, '{{CustomerName}}', PortalUser.Name);
            MapHTMLFields(BodyText, '{{returnNumber}}', SalesHeader1."No.");
            MapHTMLFields(BodyText, '{{invoiceNumber}}', SalesHeader1."PDC Return From Invoice No.");
            MapHTMLFields(BodyText, '{{returnDate}}', NAVPortalsMgt.FormatDate(SalesHeader1."Posting Date"));
            MapHTMLFields(BodyText, '{{orderDate}}', NAVPortalsMgt.FormatDate(SalesHeader1."Order Date"));
            MapHTMLFields(BodyText, '{{requestedPick}}', NAVPortalsMgt.FormatDate(SalesHeader1."Posting Date"));

            if LinesBodyText <> '' then
                MapHTMLFields(BodyText, '{{tableLine}}', LinesBodyText);

            MapHTMLFields(BodyText, '{{subtotalPrice}}', Format(SalesHeader1.Amount - CarriageAmt, 0, 9));
            MapHTMLFields(BodyText, '{{carriagePrice}}', Format(CarriageAmt, 0, 9));
            MapHTMLFields(BodyText, '{{totalPrice}}', Format(SalesHeader1.Amount, 0, 9));
            MapHTMLFields(BodyText, '{{pickAddress}}',
                                     SalesHeader1."Ship-to Name" + ', ' + SalesHeader1."Ship-to Name 2" + '<br>' +
                                     SalesHeader1."Ship-to Address" + ', ' + SalesHeader1."Ship-to Address 2" + '<br>' +
                                     SalesHeader1."Ship-to City" + ', ' + SalesHeader1."Ship-to County" + '<br>' +
                                     SalesHeader1."Ship-to Post Code"
                                     );

            ListTo.Add(PortalUser."E-Mail");
            ListBCC.Add('uniforms@peterdrew.com');
            EmailMessage.Create(ListTo, 'Return Confirmation ' + SalesHeader1."No.", BodyText, true, ListCC, ListBCC);
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

