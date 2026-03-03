/// <summary>
/// TableExtension PDCJobQueueEntry (ID 50033) extends Record Job Queue Entry.
/// </summary>
tableextension 50033 PDCJobQueueEntry extends "Job Queue Entry"
{
    fields
    {
        field(50000; "PDC Force Running In Error"; Boolean)
        {
            Caption = 'Force Running In Error';
        }
    }
}

