/// <summary>
/// TableExtension PDCSalesReceivablesSetup (ID 50030) extends Record Sales &amp; Receivables Setup.
/// </summary>
tableextension 50030 PDCSalesReceivablesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "PDC Default Item Template"; Code[10])
        {
            Caption = 'Default Item Template';
            TableRelation = "Config. Template Header".Code where("Table ID" = filter(27));
        }
        field(50001; "PDC Default Customer Template"; Code[10])
        {
            Caption = 'Default Customer Template';
            TableRelation = "Config. Template Header".Code where("Table ID" = filter(18));
        }
        field(50002; "PDC Default Vendor Template"; Code[10])
        {
            Caption = 'Default Vendor Template';
            TableRelation = "Config. Template Header".Code where("Table ID" = filter(23));
        }
        field(50003; "PDC Start Invoice No."; Integer)
        {
            Caption = 'Start Invoice No.';
        }
        field(50004; "PDC Start Cr.Memo No."; Integer)
        {
            Caption = 'Start Cr.Memo No.';
        }
        field(50005; "PDC Sender Email"; Text[30])
        {
            Caption = 'Sender Email';
        }
        field(50006; "PDC Sender Name"; Text[30])
        {
            Caption = 'Sender Name';
        }
        field(50007; PDCCC; Text[200])
        {
            Caption = 'CC';
        }
        field(50008; "PDC Email Subject"; Text[50])
        {
            Caption = 'Email Subject';
        }
        field(50009; "PDC Email Body"; Text[250])
        {
            Caption = 'Email Body';
        }
        field(50010; "PDC Use Test E-Mail Address"; Boolean)
        {
            Caption = 'Use Test E-Mail Address';
        }
        field(50011; "PDC Test E-Mail Address"; Text[100])
        {
            Caption = 'Test E-Mail Address';
        }
        field(50012; "PDC Barcode Nos."; Code[10])
        {
            Caption = 'Barcode Nos.';
            TableRelation = "No. Series";
        }
        field(50013; "PDC Invoice E-mail Setup"; Code[10])
        {
            Caption = 'Invoice E-mail Setup';
            TableRelation = "PDC Email Management Setup".Code where(Type = const(Setup));
        }
        field(50014; "PDC Statement E-mail Setup"; Code[10])
        {
            Caption = 'Statement E-mail Setup';
            TableRelation = "PDC Email Management Setup".Code where(Type = const(Setup));
        }
        field(50015; "PDC Credit Memo E-mail Setup"; Code[10])
        {
            Caption = 'Credit Memo E-mail Setup';
            TableRelation = "PDC Email Management Setup".Code where(Type = const(Setup));
        }
        field(50016; "PDC Despatch Date Buffer"; DateFormula)
        {
            Caption = 'Despatch Date Buffer';
        }
        field(50017; "PDC Carriage Charge Limit"; Decimal)
        {
            Caption = 'Carriage Charge Limit';
            MinValue = 0;
            ObsoleteState = Pending;
            ObsoleteReason = 'Not used';
        }
        field(50018; "PDC Carriage Charge G/L Acc."; Code[10])
        {
            Caption = 'Carriage Charge G/L Acc.';
            TableRelation = "G/L Account"."No.";
        }
        field(50019; "PDC Consignment Nos."; Code[10])
        {
            Caption = 'Consignment Nos.';
            TableRelation = "No. Series";
        }
        field(50020; "PDC Def.Cust.Statm. Start Date"; Date)
        {
            Caption = 'Def. Cust. Statm. Start Date';
        }
        field(50021; "PDC Def. Cust. Statm. End Date"; Date)
        {
            Caption = 'Def. Cust. Statm. End Date';
        }
        field(50022; "PDC Label Printer"; Text[250])
        {
            Caption = 'Label Printer';
            TableRelation = Printer;
        }
        field(50023; "PDC Order Cut Off Time"; Time)
        {
            Caption = 'Order Cut Off Time';
        }
        field(50024; "PDC Order Conf. E-mail Body"; Integer)
        {
            Caption = 'Order Conf. E-mail Body';
        }
        field(50025; "PDC Return Conf. E-mail Body"; Integer)
        {
            Caption = 'Return Conf. E-mail Body';
        }
        field(50026; "PDC Branding Nos."; Code[10])
        {
            Caption = 'Branding Nos.';
            TableRelation = "No. Series";
        }
        field(50027; "PDC Proposal Nos."; Code[10])
        {
            Caption = 'Proposal Nos.';
            TableRelation = "No. Series";
        }
        field(50028; "PDC Ship-to Addrs. Nos."; Code[10])
        {
            Caption = 'Ship-to Addrs. Nos.';
            TableRelation = "No. Series";
        }
        field(50029; "PDC Entitlement E-mail Body"; Integer)
        {
            Caption = 'Entitlement E-mail Body';
        }
        field(50030; "PDC Order Approval E-mail Body"; Integer)
        {
            Caption = 'Order Conf. E-mail Body';
        }
        field(50031; "PDC Inv.Pick Print Labels"; Boolean)
        {
            Caption = 'Inv.Pick Print Labels';
        }
        field(50032; "PDC Despatch Cut Off Time"; Time)
        {
            Caption = 'Despatch Cut Off Time';
        }
        field(50033; "PDC Order Notif. E-mail Body"; Integer)
        {
            Caption = 'Order Notif. E-mail Body';
        }
        field(50034; "PDC User Welcome E-mail Body"; Integer)
        {
            Caption = 'User Welcome E-mail Body';
        }
        field(50035; "PDC Order Conf2. E-mail Body"; Integer)
        {
            Caption = 'Order Conf2. E-mail Body';
        }
        field(50036; "PDC Order Appr.Rem.E-mail Body"; Integer)
        {
            Caption = 'Order Approve Reminder E-mail Body';
        }
    }

    /// <summary>
    /// PortalConf_ImportAttachment.
    /// </summary>
    /// <param name="ReqFieldNo">Integer.</param>
    procedure PortalConf_ImportAttachment(ReqFieldNo: Integer)
    var
        Attachment: Record Attachment;
        FileManagement: Codeunit "File Management";
        FileName: Text;
        FileExt: Text[250];
        LocText001Lbl: label 'Import Attachment', Comment = 'Import Attachment';
        LocText002Lbl: label 'All Files (*.*)|*.*', Comment = 'All Files (*.*)|*.*';
        LocText003Lbl: label 'Error during copying file: %1.', Comment = 'Error during copying file: %1.';
        OldAttachmentNo: Integer;
        InStream: InStream;
        OutStream: OutStream;
    begin
        case ReqFieldNo of
            FieldNo("PDC Order Conf. E-mail Body"):
                OldAttachmentNo := "PDC Order Conf. E-mail Body";
            FieldNo("PDC Order Conf2. E-mail Body"):
                OldAttachmentNo := "PDC Order Conf2. E-mail Body";
            FieldNo("PDC Return Conf. E-mail Body"):
                OldAttachmentNo := "PDC Return Conf. E-mail Body";
            FieldNo("PDC Entitlement E-mail Body"):
                OldAttachmentNo := "PDC Entitlement E-mail Body";
            FieldNo("PDC Order Approval E-mail Body"):
                OldAttachmentNo := "PDC Order Approval E-mail Body";
            FieldNo("PDC Order Notif. E-mail Body"):
                OldAttachmentNo := "PDC Order Notif. E-mail Body";
            FieldNo("PDC User Welcome E-mail Body"):
                OldAttachmentNo := "PDC User Welcome E-mail Body";
            FieldNo("PDC Order Appr.Rem.E-mail Body"):
                OldAttachmentNo := "PDC Order Appr.Rem.E-mail Body";
        end;

        if OldAttachmentNo = 0 then
            Attachment.Insert(true)
        else
            if not Attachment.Get(OldAttachmentNo) then
                Attachment.Insert(true);

        if not UploadIntoStream(LocText001Lbl, '', LocText002Lbl, FileName, InStream) then
            Error(LocText003Lbl, GetLastErrorText);
        Attachment."Storage Type" := Attachment."Storage Type"::Embedded;
        Attachment."Storage Pointer" := '';
        FileExt := CopyStr(FileManagement.GetExtension(FileName), 1, 250);
        if FileExt <> '' then
            Attachment."File Extension" := FileExt;
        Attachment."Attachment File".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        Attachment.Modify();

        case ReqFieldNo of
            FieldNo("PDC Order Conf. E-mail Body"):
                "PDC Order Conf. E-mail Body" := Attachment."No.";
            FieldNo("PDC Order Conf2. E-mail Body"):
                "PDC Order Conf2. E-mail Body" := Attachment."No.";
            FieldNo("PDC Return Conf. E-mail Body"):
                "PDC Return Conf. E-mail Body" := Attachment."No.";
            FieldNo("PDC Entitlement E-mail Body"):
                "PDC Entitlement E-mail Body" := Attachment."No.";
            FieldNo("PDC Order Approval E-mail Body"):
                "PDC Order Approval E-mail Body" := Attachment."No.";
            FieldNo("PDC Order Notif. E-mail Body"):
                "PDC Order Notif. E-mail Body" := Attachment."No.";
            FieldNo("PDC User Welcome E-mail Body"):
                "PDC User Welcome E-mail Body" := Attachment."No.";
            FieldNo("PDC Order Appr.Rem.E-mail Body"):
                "PDC Order Appr.Rem.E-mail Body" := Attachment."No.";
        end;
        Modify();
    end;

    /// <summary>
    /// PortalConf_ExportAttachment.
    /// </summary>
    /// <param name="ReqFieldNo">Integer.</param>
    procedure PortalConf_ExportAttachment(ReqFieldNo: Integer)
    var
        Attachment: Record Attachment;
        FileName: Text;
        OldAttachmentNo: Integer;
        InStr: InStream;
    begin
        case ReqFieldNo of
            FieldNo("PDC Order Conf. E-mail Body"):
                OldAttachmentNo := "PDC Order Conf. E-mail Body";
            FieldNo("PDC Order Conf2. E-mail Body"):
                OldAttachmentNo := "PDC Order Conf2. E-mail Body";
            FieldNo("PDC Return Conf. E-mail Body"):
                OldAttachmentNo := "PDC Return Conf. E-mail Body";
            FieldNo("PDC Entitlement E-mail Body"):
                OldAttachmentNo := "PDC Entitlement E-mail Body";
            FieldNo("PDC Order Approval E-mail Body"):
                OldAttachmentNo := "PDC Order Approval E-mail Body";
            FieldNo("PDC Order Notif. E-mail Body"):
                OldAttachmentNo := "PDC Order Notif. E-mail Body";
            FieldNo("PDC Order Appr.Rem.E-mail Body"):
                OldAttachmentNo := "PDC Order Appr.Rem.E-mail Body";
            FieldNo("PDC User Welcome E-mail Body"):
                OldAttachmentNo := "PDC User Welcome E-mail Body";
        end;

        if Attachment.Get(OldAttachmentNo) then begin
            Attachment.CalcFields("Attachment File");
            if Attachment."Attachment File".Hasvalue then begin
                case ReqFieldNo of
                    Rec.FieldNo("PDC Order Conf. E-mail Body"):
                        FileName := 'Order Confirmation' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC Order Conf2. E-mail Body"):
                        FileName := 'Order Confirmation 2' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC Return Conf. E-mail Body"):
                        FileName := 'Return Confirmation' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC Entitlement E-mail Body"):
                        FileName := 'Entitlement' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC Order Approval E-mail Body"):
                        FileName := 'ApprovalRequest' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC Order Notif. E-mail Body"):
                        FileName := 'NotificationRequest' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC Order Appr.Rem.E-mail Body"):
                        FileName := 'ApproveReminder' + '.' + Attachment."File Extension";
                    Rec.FieldNo("PDC User Welcome E-mail Body"):
                        FileName := 'WelcomeEmail' + '.' + Attachment."File Extension";
                end;

                Attachment."Attachment File".CreateInStream(InStr);
                DownloadFromStream(InStr, '', '', '', FileName);
            end;
        end;
    end;

    /// <summary>
    /// PortalConf_RemoveAttachment.
    /// </summary>
    /// <param name="ReqFieldNo">Integer.</param>
    /// <param name="Prompt">Boolean.</param>
    procedure PortalConf_RemoveAttachment(ReqFieldNo: Integer; Prompt: Boolean)
    var
        Attachment: Record Attachment;
        OldAttachmentNo: Integer;
        RemoveQst: Label 'Do you want to remove %1?', Comment = '%1 = table name';
    begin
        case ReqFieldNo of
            FieldNo("PDC Order Conf. E-mail Body"):
                OldAttachmentNo := "PDC Order Conf. E-mail Body";
            FieldNo("PDC Order Conf2. E-mail Body"):
                OldAttachmentNo := "PDC Order Conf2. E-mail Body";
            FieldNo("PDC Return Conf. E-mail Body"):
                OldAttachmentNo := "PDC Return Conf. E-mail Body";
            FieldNo("PDC Entitlement E-mail Body"):
                OldAttachmentNo := "PDC Entitlement E-mail Body";
            FieldNo("PDC Order Approval E-mail Body"):
                OldAttachmentNo := "PDC Order Approval E-mail Body";
            FieldNo("PDC Order Notif. E-mail Body"):
                OldAttachmentNo := "PDC Order Notif. E-mail Body";
            FieldNo("PDC Order Appr.Rem.E-mail Body"):
                OldAttachmentNo := "PDC Order Appr.Rem.E-mail Body";
            FieldNo("PDC User Welcome E-mail Body"):
                OldAttachmentNo := "PDC User Welcome E-mail Body";
        end;

        if Attachment.Get(OldAttachmentNo) then begin
            if Prompt then
                if not Confirm(RemoveQst, false, Attachment.TableCaption()) then
                    exit;
            Attachment.Delete(true);

            case ReqFieldNo of
                FieldNo("PDC Order Conf. E-mail Body"):
                    "PDC Order Conf. E-mail Body" := 0;
                FieldNo("PDC Order Conf2. E-mail Body"):
                    "PDC Order Conf2. E-mail Body" := 0;
                FieldNo("PDC Return Conf. E-mail Body"):
                    "PDC Return Conf. E-mail Body" := 0;
                FieldNo("PDC Entitlement E-mail Body"):
                    "PDC Entitlement E-mail Body" := 0;
                FieldNo("PDC Order Approval E-mail Body"):
                    "PDC Order Approval E-mail Body" := 0;
                FieldNo("PDC Order Notif. E-mail Body"):
                    "PDC Order Notif. E-mail Body" := 0;
                FieldNo("PDC Order Appr.Rem.E-mail Body"):
                    "PDC Order Appr.Rem.E-mail Body" := 0;
                FieldNo("PDC User Welcome E-mail Body"):
                    "PDC User Welcome E-mail Body" := 0;
            end;
            Modify();
        end;
    end;
}

