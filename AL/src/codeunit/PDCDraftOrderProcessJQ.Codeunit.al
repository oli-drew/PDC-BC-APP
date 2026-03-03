/// <summary>
/// Codeunit PDCDraftOrderProcessJQ (ID 50002) proceed Draft Order to Sales Order.
/// </summary>
codeunit 50005 "PDC Draft Order Process JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        RecRef: RecordRef;
    begin
        Rec.TESTFIELD("Record ID to Process");
        if RecRef.GET(Rec."Record ID to Process") then begin
            RecRef.SETTABLE(DraftOrderHeader);
            if DraftOrderHeader.get(DraftOrderHeader."Document No.") then
                if not CODEUNIT.RUN(CODEUNIT::"PDC Draft Order Process", DraftOrderHeader) then
                    //to-do requeue
                    ERROR(GETLASTERRORTEXT);
        end;
    end;

    /// <summary>
    /// procedure EnqueueDraftOrder insert new entry in Job Queue.
    /// </summary>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    procedure EnqueueDraftOrder(var DraftOrderHeader: Record "PDC Draft Order Header")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.setrange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.setrange("Object ID to Run", CODEUNIT::"PDC Draft Order Process JQ");
        JobQueueEntry.setrange(Description, DraftOrderHeader."Document No.");
        if not JobQueueEntry.IsEmpty then
            exit;

        CLEAR(JobQueueEntry.ID);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"PDC Draft Order Process JQ";
        JobQueueEntry."Record ID to Process" := DraftOrderHeader.RECORDID;
        JobQueueEntry."Job Queue Category Code" := 'INTERFACE'; //to-do
        JobQueueEntry."No. of Attempts to Run" := 3; //to-do        
        JobQueueEntry.Description := DraftOrderHeader."Document No.";
        JobQueueEntry."User Session ID" := SESSIONID();
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime + 5 * 1000; //+5 sek
        JobQueueEntry."PDC Force Running In Error" := true;
        JobQueueEntry.Modify()
    end;

}