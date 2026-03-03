/// <summary>
/// Codeunit PDC Email ManagementJQ (ID 50009) proceed Email sending.
/// </summary>
codeunit 50009 "PDC Email Management JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        EmailLog: Record "PDC Email Management Setup";
        RecRef: RecordRef;
    begin
        Rec.testfield("Record ID to Process");
        if RecRef.GET(Rec."Record ID to Process") then begin
            RecRef.SETTABLE(EmailLog);
            if EmailLog.get(EmailLog.Code, EmailLog.Type, EmailLog."Line No.") then
                if not CODEUNIT.RUN(CODEUNIT::"PDC Email Management", EmailLog) then
                    //to-do requeue
                    ERROR(GETLASTERRORTEXT);
        end;
    end;

    /// <summary>
    /// EnqueueEmail.
    /// </summary>
    /// <param name="EmailLog">VAR Record "PDC Email Management Setup".</param>
    procedure EnqueueEmail(var EmailLog: Record "PDC Email Management Setup")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        CLEAR(JobQueueEntry.ID);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"PDC Email Management JQ";
        JobQueueEntry."Record ID to Process" := EmailLog.RECORDID;
        JobQueueEntry."Job Queue Category Code" := 'INTERFACE'; //to-do
        JobQueueEntry."No. of Attempts to Run" := 3; //to-do        
        JobQueueEntry.Description := EmailLog."Customer No.";
        JobQueueEntry."User Session ID" := SESSIONID();
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime + 5 * 1000; //+5 sek
        JobQueueEntry."PDC Force Running In Error" := true;
        JobQueueEntry.Modify()
    end;

}