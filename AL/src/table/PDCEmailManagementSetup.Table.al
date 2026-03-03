/// <summary>
/// Table PDC Email Management Setup (ID 50009).
/// </summary>
table 50009 "PDC Email Management Setup"
{
    LookupPageId = "PDC Email Managem. Setup List";
    DrillDownPageId = "PDC Email Managem. Setup List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Setup,Address,Log;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Sender Email Address"; Text[80])
        {
            Caption = 'Sender Email Address';
        }
        field(5; "Sender Email Name"; Text[80])
        {
            Caption = 'Sender Email Name';
        }
        field(6; Subject; Text[80])
        {
            Caption = 'Subject';
        }
        field(7; "File Attachment Location"; Text[250])
        {
            Caption = 'File Attachment Location';
            ObsoleteState = Removed;
            ObsoleteReason = 'Removed fro cloud version';
        }
        field(8; "Email HTML Template"; Blob)
        {
            Caption = 'Email HTML Template';
        }
        field(9; "Parameter 1"; Text[10])
        {
            Caption = 'Parameter 1';
        }
        field(10; "Parameter 2"; Text[10])
        {
            Caption = 'Parameter 2';
        }
        field(11; "Parameter 3"; Text[10])
        {
            Caption = 'Parameter 3';
        }
        field(12; "Email Address"; Text[100])
        {
            Caption = 'Email Address';
        }
        field(13; "Address Type"; Option)
        {
            Caption = 'Address Type';
            OptionCaption = 'To,CC';
            OptionMembers = "To",CC;
        }
        field(14; "CC Addresses"; Text[250])
        {
            Caption = 'CC';
        }
        field(15; "File Attachment Location Log"; Text[250])
        {
            Caption = 'File Attachment Location';
        }
        field(16; "Body BLOB"; Blob)
        {
            Caption = 'Body BLOB';
        }
        field(17; Body; Text[250])
        {
            Caption = 'Body';
        }
        field(18; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(19; Sent; Boolean)
        {
            Caption = 'Sent';
        }
        field(20; "Date Sent"; DateTime)
        {
            Caption = 'Date Sent';
        }
        field(21; "Error Text"; Text[50])
        {
            Caption = 'Error Text';
        }
        field(22; "Mailing Group"; code[10])
        {
            Caption = 'Mailing Group';
            TableRelation = "Mailing Group".Code;
        }
        field(23; "Source RecordId"; RecordId)
        {
            Caption = 'Source RecordId';
        }
        field(24; "Skip"; Boolean)
        {
            Caption = 'Skip';
        }
        field(35; Attachment; Blob)
        {
            Caption = 'Attachment';
        }
    }

    keys
    {
        key(Key1; "Code", Type, "Line No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Lookup; "Code")
        {
        }
    }

    var
        EmailManagement: Codeunit "PDC Email Management";

    var
        Text001Lbl: label 'Are you sure you wish to overwrite the existing Email HTML?', Comment = 'Are you sure you wish to overwrite the existing Email HTML?';
        Text002Lbl: label 'Are you sure you wish to remove the existing Email HTML?', Comment = 'Are you sure you wish to remove the existing Email HTML?';
        EmailHTMLLbl: Label 'Email HTML';
        EmailAttachmentLbl: Label 'Email Attachment';

    /// <summary>
    /// ProcessEmail.
    /// </summary>
    /// <param name="EmailCode">Code[10].</param>
    /// <param name="EmailToAddress">Text[80].</param>
    /// <param name="TagParam1Value">Text[250].</param>
    /// <param name="TagParam2Value">Text[250].</param>
    /// <param name="TagParam3Value">Text[250].</param>
    /// <param name="FileAttachment">Text[250].</param>
    /// <param name="CustomerNo">Code[20].</param>
    /// <param name="ToMailingGroup">Code[10].</param>
    procedure ProcessEmail(EmailCode: Code[10]; EmailToAddress: Text[80]; TagParam1Value: Text[250]; TagParam2Value: Text[250]; TagParam3Value: Text[250]; FileAttachment: text[250]; var TempBlob: Codeunit "Temp Blob"; CustomerNo: Code[20]; ToMailingGroup: Code[10])
    var
        PDCEmailManagementSetup: Record "PDC Email Management Setup";
        BigBodyText: BigText;
        SubjectText: Text[80];
    begin
        PDCEmailManagementSetup.Get(EmailCode, PDCEmailManagementSetup.Type::Setup, 0);
        CreateSubject(PDCEmailManagementSetup, SubjectText, TagParam1Value, TagParam2Value, TagParam3Value);
        CreateHTMLEmail(PDCEmailManagementSetup, BigBodyText, TagParam1Value, TagParam2Value, TagParam3Value);
        InsertLogEntry(PDCEmailManagementSetup, EmailToAddress, SubjectText, BigBodyText, FileAttachment, TempBlob, CustomerNo, ToMailingGroup);
        Commit();
        EmailManagement.SendEmails();
    end;

    /// <summary>
    /// ProcessEmail.
    /// </summary>
    /// <param name="EmailCode">Code[10].</param>
    /// <param name="EmailToAddress">Text[80].</param>
    /// <param name="TagParam1Value">Text[250].</param>
    /// <param name="TagParam2Value">Text[250].</param>
    /// <param name="TagParam3Value">Text[250].</param>
    /// <param name="RecId">RecordId.</param>
    /// <param name="CustomerNo">Code[20].</param>
    /// <param name="ToMailingGroup">Code[10].</param>
    procedure ProcessEmail(EmailCode: Code[10]; EmailToAddress: Text[80]; TagParam1Value: Text[250]; TagParam2Value: Text[250]; TagParam3Value: Text[250]; RecId: RecordId; CustomerNo: Code[20]; ToMailingGroup: Code[10])
    var
        PDCEmailManagementSetup: Record "PDC Email Management Setup";
        PDCEmailManagementSetupLog: Record "PDC Email Management Setup";
        PDCEmailManagementJQ: Codeunit "PDC Email Management JQ";
        BigBodyText: BigText;
        SubjectText: Text[80];
    begin
        PDCEmailManagementSetup.Get(EmailCode, PDCEmailManagementSetup.Type::Setup, 0);
        CreateSubject(PDCEmailManagementSetup, SubjectText, TagParam1Value, TagParam2Value, TagParam3Value);
        CreateHTMLEmail(PDCEmailManagementSetup, BigBodyText, TagParam1Value, TagParam2Value, TagParam3Value);
        InsertLogEntry(PDCEmailManagementSetup, EmailToAddress, SubjectText, BigBodyText, RecId, CustomerNo, ToMailingGroup, PDCEmailManagementSetupLog);
        PDCEmailManagementJQ.EnqueueEmail(PDCEmailManagementSetupLog);
    end;

    /// <summary>
    /// CreateSubject.
    /// </summary>
    /// <param name="PDCEmailManagementSetup">Record "PDC Email Management Setup".</param>
    /// <param name="SubjectText">VAR Text[80].</param>
    /// <param name="Param1Value">Text[250].</param>
    /// <param name="Param2Value">Text[250].</param>
    /// <param name="Param3Value">Text[250].</param>
    procedure CreateSubject(PDCEmailManagementSetup: Record "PDC Email Management Setup"; var SubjectText: Text[80]; Param1Value: Text[250]; Param2Value: Text[250]; Param3Value: Text[250])
    var
        TempSubjectText: Text;
    begin
        if PDCEmailManagementSetup.Subject = '' then
            exit;

        TempSubjectText := PDCEmailManagementSetup.Subject;
        StringReplace(TempSubjectText, PDCEmailManagementSetup."Parameter 1", Param1Value);
        StringReplace(TempSubjectText, PDCEmailManagementSetup."Parameter 2", Param2Value);
        StringReplace(TempSubjectText, PDCEmailManagementSetup."Parameter 3", Param3Value);

        SubjectText := copystr(TempSubjectText, 1, MaxStrLen(SubjectText));
    end;

    /// <summary>
    /// CreateHTMLEmail.
    /// </summary>
    /// <param name="PDCEmailManagementSetup">Record "PDC Email Management Setup".</param>
    /// <param name="BigBody">VAR BigText.</param>
    /// <param name="Param1Value">Text[250].</param>
    /// <param name="Param2Value">Text[250].</param>
    /// <param name="Param3Value">Text[250].</param>
    procedure CreateHTMLEmail(PDCEmailManagementSetup: Record "PDC Email Management Setup"; var BigBody: BigText; Param1Value: Text[250]; Param2Value: Text[250]; Param3Value: Text[250])
    var
        InStream: InStream;
        CurrLine: Text;
    begin
        PDCEmailManagementSetup.CalcFields("Email HTML Template");
        if not PDCEmailManagementSetup."Email HTML Template".Hasvalue then exit;

        PDCEmailManagementSetup."Email HTML Template".CreateInStream(InStream);
        repeat
            InStream.ReadText(CurrLine);

            StringReplace(CurrLine, PDCEmailManagementSetup."Parameter 1", Param1Value);
            StringReplace(CurrLine, PDCEmailManagementSetup."Parameter 2", Param2Value);
            StringReplace(CurrLine, PDCEmailManagementSetup."Parameter 3", Param3Value);
            BigBody.AddText(CurrLine);
        until InStream.EOS();
    end;

    /// <summary>
    /// StringReplace.
    /// </summary>
    /// <param name="PassedText">VAR Text[1024].</param>
    /// <param name="ToReplace">Text[10].</param>
    /// <param name="ReplaceWith">Text[250].</param>
    procedure StringReplace(var PassedText: Text; ToReplace: Text; ReplaceWith: Text)
    begin
        if PassedText = '' then
            exit;
        if StrPos(PassedText, ToReplace) = 0 then
            exit;

        repeat
            PassedText := CopyStr(PassedText, 1, StrPos(PassedText, ToReplace) - 1) +    //Bit of Passedtext up to ToReplace
            ReplaceWith +
            CopyStr(PassedText, StrPos(PassedText, ToReplace) + StrLen(ToReplace)); //Bit of Passedtext after ToReplace
        until StrPos(PassedText, ToReplace) = 0;
    end;

    /// <summary>
    /// InsertLogEntry.
    /// </summary>
    /// <param name="PDCEmailManagementSetup">Record "PDC Email Management Setup".</param>
    /// <param name="ToEmailAddress">Text[80].</param>
    /// <param name="SubjectText">Text[80].</param>
    /// <param name="BodyText">BigText.</param>
    /// <param name="FileAttachment">Text[250].</param>
    /// <param name="CustomerNo">Code[20].</param>
    /// <param name="ToMailingGroup">Code[10].</param>
    procedure InsertLogEntry(PDCEmailManagementSetup: Record "PDC Email Management Setup"; ToEmailAddress: Text[80]; SubjectText: Text[80]; BodyText: BigText; FileAttachment: text[250]; var TempBlob: Codeunit "Temp Blob"; CustomerNo: Code[20]; ToMailingGroup: Code[10])
    var
        PDCEmailManagementSetupAddress: Record "PDC Email Management Setup";
        PDCEmailManagementSetupLog: Record "PDC Email Management Setup";
        LineNo: Integer;
        ToAddress: Text;
        CCAddress: Text;
        Outstream: OutStream;
        InStream: InStream;
    begin
        PDCEmailManagementSetupLog.SetRange(PDCEmailManagementSetupLog.Type, PDCEmailManagementSetupLog.Type::Log);
        PDCEmailManagementSetupLog.SetRange(Code, PDCEmailManagementSetup.Code);
        if PDCEmailManagementSetupLog.FindLast() then
            LineNo := PDCEmailManagementSetupLog."Line No." + 1
        else
            LineNo := 1;

        ToAddress := ToEmailAddress;

        PDCEmailManagementSetupAddress.Reset();
        PDCEmailManagementSetupAddress.SetRange(Type, PDCEmailManagementSetupAddress.Type::Address);
        PDCEmailManagementSetupAddress.SetRange(Code, PDCEmailManagementSetup.Code);
        if PDCEmailManagementSetupAddress.FindSet() then
            repeat
                case PDCEmailManagementSetupAddress."Address Type" of
                    PDCEmailManagementSetupAddress."address type"::"To":
                        if ToAddress = '' then
                            ToAddress := PDCEmailManagementSetupAddress."Email Address"
                        else
                            ToAddress := ToAddress + ';' + PDCEmailManagementSetupAddress."Email Address";
                    PDCEmailManagementSetupAddress."address type"::CC:
                        if CCAddress = '' then
                            CCAddress := PDCEmailManagementSetupAddress."Email Address"
                        else
                            CCAddress := CCAddress + ';' + PDCEmailManagementSetupAddress."Email Address";
                end;
            until PDCEmailManagementSetupAddress.Next() = 0;

        PDCEmailManagementSetupLog.Init();
        PDCEmailManagementSetupLog.Code := PDCEmailManagementSetup.Code;
        PDCEmailManagementSetupLog.Type := PDCEmailManagementSetupLog.Type::Log;
        PDCEmailManagementSetupLog."Line No." := LineNo;
        PDCEmailManagementSetupLog."Sender Email Address" := PDCEmailManagementSetup."Sender Email Address";
        PDCEmailManagementSetupLog."Sender Email Name" := PDCEmailManagementSetup."Sender Email Name";
        PDCEmailManagementSetupLog."Email Address" := CopyStr(ToAddress, 1, 80);
        PDCEmailManagementSetupLog."CC Addresses" := CopyStr(CCAddress, 1, 250);
        PDCEmailManagementSetupLog."Customer No." := CustomerNo;
        PDCEmailManagementSetupLog.Subject := SubjectText;
        BodyText.GetSubText(PDCEmailManagementSetupLog.Body, 1, 250);
        PDCEmailManagementSetupLog."Body BLOB".CreateOutstream(Outstream);
        BodyText.Write(Outstream);
        PDCEmailManagementSetupLog."File Attachment Location Log" := FileAttachment;
        PDCEmailManagementSetupLog."Mailing Group" := ToMailingGroup;
        PDCEmailManagementSetupLog.Insert();

        TempBlob.CreateInStream(InStream);
        PDCEmailManagementSetupLog.Attachment.CreateOutStream(Outstream);
        CopyStream(Outstream, InStream);
        PDCEmailManagementSetupLog.Modify();
    end;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="PDCEmailManagementSetup"></param>
    /// <param name="ToEmailAddress"></param>
    /// <param name="SubjectText"></param>
    /// <param name="BodyText"></param>
    /// <param name="RecId"></param>
    /// <param name="CustomerNo"></param>
    /// <param name="ToMailingGroup"></param>
    /// <param name="PDCEmailManagementSetupLog"></param>
    procedure InsertLogEntry(PDCEmailManagementSetup: Record "PDC Email Management Setup"; ToEmailAddress: Text[80]; SubjectText: Text[80]; BodyText: BigText; RecId: RecordId; CustomerNo: Code[20]; ToMailingGroup: Code[10]; var PDCEmailManagementSetupLog: Record "PDC Email Management Setup")
    var
        PDCEmailManagementSetupAddress: Record "PDC Email Management Setup";
        LineNo: Integer;
        ToAddress: Text;
        CCAddress: Text;
        Outstream: OutStream;
    begin
        PDCEmailManagementSetupLog.SetRange(PDCEmailManagementSetupLog.Type, PDCEmailManagementSetupLog.Type::Log);
        PDCEmailManagementSetupLog.SetRange(Code, PDCEmailManagementSetup.Code);
        if PDCEmailManagementSetupLog.FindLast() then
            LineNo := PDCEmailManagementSetupLog."Line No." + 1
        else
            LineNo := 1;

        ToAddress := ToEmailAddress;

        PDCEmailManagementSetupAddress.Reset();
        PDCEmailManagementSetupAddress.SetRange(Type, PDCEmailManagementSetupAddress.Type::Address);
        PDCEmailManagementSetupAddress.SetRange(Code, PDCEmailManagementSetup.Code);
        if PDCEmailManagementSetupAddress.FindSet() then
            repeat
                case PDCEmailManagementSetupAddress."Address Type" of
                    PDCEmailManagementSetupAddress."address type"::"To":
                        if ToAddress = '' then
                            ToAddress := PDCEmailManagementSetupAddress."Email Address"
                        else
                            ToAddress := ToAddress + ';' + PDCEmailManagementSetupAddress."Email Address";
                    PDCEmailManagementSetupAddress."address type"::CC:
                        if CCAddress = '' then
                            CCAddress := PDCEmailManagementSetupAddress."Email Address"
                        else
                            CCAddress := CCAddress + ';' + PDCEmailManagementSetupAddress."Email Address";
                end;
            until PDCEmailManagementSetupAddress.Next() = 0;

        PDCEmailManagementSetupLog.Init();
        PDCEmailManagementSetupLog.Code := PDCEmailManagementSetup.Code;
        PDCEmailManagementSetupLog.Type := PDCEmailManagementSetupLog.Type::Log;
        PDCEmailManagementSetupLog."Line No." := LineNo;
        PDCEmailManagementSetupLog."Sender Email Address" := PDCEmailManagementSetup."Sender Email Address";
        PDCEmailManagementSetupLog."Sender Email Name" := PDCEmailManagementSetup."Sender Email Name";
        PDCEmailManagementSetupLog."Email Address" := CopyStr(ToAddress, 1, 80);
        PDCEmailManagementSetupLog."CC Addresses" := CopyStr(CCAddress, 1, 250);
        PDCEmailManagementSetupLog."Customer No." := CustomerNo;
        PDCEmailManagementSetupLog.Subject := SubjectText;
        BodyText.GetSubText(PDCEmailManagementSetupLog.Body, 1, 250);
        PDCEmailManagementSetupLog."Body BLOB".CreateOutstream(Outstream);
        BodyText.Write(Outstream);
        PDCEmailManagementSetupLog."Mailing Group" := ToMailingGroup;
        PDCEmailManagementSetupLog."Source RecordId" := RecId;
        PDCEmailManagementSetupLog.Insert();
    end;


    procedure ImportTemplate()
    var
        FromFile: Text;
        InStr: InStream;
        OutStr: OutStream;
    begin
        if Rec."Email HTML Template".Hasvalue then
            if not Confirm(Text001Lbl, false) then
                exit;
        if File.UploadIntoStream(EmailHTMLLbl, '', 'HTML (*.html)|*.html', FromFile, InStr) then begin
            Rec."Email HTML Template".CreateOutStream(OutStr);
            CopyStream(OutStr, InStr);
            Rec.Modify();
        end;
    end;

    procedure ClearTemplate()
    begin
        if Confirm(Text002Lbl, false) then begin
            Rec.CalcFields("Email HTML Template");
            Clear(Rec."Email HTML Template");
            Rec.Modify();
        end;
    end;

    procedure ExportTemplate()
    var
        ToFile: Text;
        InStr: InStream;
    begin
        if Rec."Email HTML Template".Hasvalue then begin
            Rec.CalcFields("Email HTML Template");
            Rec."Email HTML Template".CreateInStream(InStr);
            ToFile := EmailHTMLLbl + '.html';
            file.DownloadFromStream(InStr, EmailHTMLLbl, '', 'HTML (*.html)|*.html', ToFile);
        end;
    end;

    procedure ExportAttachment()
    var
        ToFile: Text;
        InStr: InStream;
    begin
        if Rec.Attachment.Hasvalue then begin
            Rec.CalcFields(Attachment);
            Rec.Attachment.CreateInStream(InStr);
            if Rec."File Attachment Location Log" <> '' then
                ToFile := Rec."File Attachment Location Log"
            else
                ToFile := EmailAttachmentLbl + '.pdf';
            file.DownloadFromStream(InStr, EmailAttachmentLbl, '', 'PDF (*.pdf)|*.pdf', ToFile);
        end;
    end;
}

