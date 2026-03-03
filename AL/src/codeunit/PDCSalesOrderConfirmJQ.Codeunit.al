/// <summary>
/// Codeunit PDCSalesOrderConfirmJQ (ID 50020).
/// </summary>
codeunit 50020 "PDC Sales Order Confirm JQ"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        PortalOrderConfirmation: Report "PDC Portal - Order Confirm";
        PortalOrderConfirmation2: Report "PDC Portal - Order Confirm2";
        RecordRefVar: RecordRef;
    begin
        Rec.TESTFIELD("Record ID to Process");
        if RecordRefVar.GET(Rec."Record ID to Process") then begin
            RecordRefVar.SETTABLE(SalesHeader);
            if SalesHeader.FIND() then begin
                SalesHeader.SetRecfilter();
                PortalOrderConfirmation.SetTableview(SalesHeader);
                PortalOrderConfirmation.UseRequestPage(false);
                PortalOrderConfirmation.Run();

                PortalOrderConfirmation2.SetTableview(SalesHeader);
                PortalOrderConfirmation2.UseRequestPage(false);
                PortalOrderConfirmation2.Run();
            end;
        end;
    end;

    /// <summary>
    /// EnqueueSendOrderConfirmEmail.
    /// </summary>
    /// <param name="SalesHeader">Record "Sales Header".</param>
    procedure EnqueueSendOrderConfirmEmail(SalesHeader: Record "Sales Header")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.setrange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.setrange("Object ID to Run", CODEUNIT::"PDC Sales Order Confirm JQ");
        JobQueueEntry.setrange(Description, Format(SalesHeader."Document Type") + ';' + SalesHeader."No.");
        if not JobQueueEntry.IsEmpty then
            exit;

        CLEAR(JobQueueEntry.ID);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"PDC Sales Order Confirm JQ";
        JobQueueEntry."Record ID to Process" := SalesHeader.RECORDID;
        JobQueueEntry."Job Queue Category Code" := 'INTERFACE'; //to-do
        JobQueueEntry."No. of Attempts to Run" := 3; //to-do        
        JobQueueEntry.Description := Format(SalesHeader."Document Type") + ';' + SalesHeader."No.";
        JobQueueEntry."User Session ID" := SESSIONID();
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime + 5 * 1000; //+5 sek
        JobQueueEntry."PDC Force Running In Error" := true;
        JobQueueEntry.Modify()
    end;

}
