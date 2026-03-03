/// <summary>
/// Report PDC Job Queue Restart (ID 50043).
/// </summary>
report 50043 "PDC Job Queue Restart"
{
    Caption = 'Job Queue Restart';
    ProcessingOnly = true;

    dataset
    {
        dataitem(ReportLoop; Integer)
        {
            DataItemTableView = where(Number = filter(1));

            trigger OnAfterGetRecord()
            begin
                if JobQueueEntry.findset() then
                    repeat
                        if (JobQueueEntry.Status = JobQueueEntry.Status::Error) and (JobQueueEntry."PDC Force Running In Error") then begin
                            JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
                            JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                        end;
                    until JobQueueEntry.Next() = 0;
            end;
        }
    }


    var
        JobQueueEntry: Record "Job Queue Entry";
}