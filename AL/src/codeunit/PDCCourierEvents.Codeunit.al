codeunit 50012 "PDC Courier Events"
{
    SingleInstance = true;
    EventSubscriberInstance = Manual;

    var
        PDFBlob: Codeunit "Temp Blob";
        RepId: Integer;

    procedure SetReportBlob(var InStream: InStream)
    var
        OutStream: OutStream;
    begin
        PDFBlob.CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
    end;

    procedure SetRepId(NewRepId: Integer)
    begin
        RepId := NewRepId;
    end;

    procedure Clean()
    begin
        clear(PDFBlob);
        Clear(RepId);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, OnAfterDocumentReady, '', true, true)]
    local procedure ReportManagementOnAfterDocumentReady(ObjectId: Integer; var TargetStream: OutStream; var Success: Boolean)
    var
        InStream: InStream;
    begin
        if RepId <> 0 then
            if ObjectId = RepId then begin
                PDFBlob.CreateInStream(InStream);
                CopyStream(TargetStream, InStream);
                Success := true;
            end;
    end;

}