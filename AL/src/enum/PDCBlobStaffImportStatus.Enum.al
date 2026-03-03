/// <summary>
/// Enum PDC Blob Staff Import Status (ID 50010).
/// Status values for staff import log entries.
/// </summary>
enum 50010 "PDC Blob Staff Import Status"
{
    Extensible = false;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Created)
    {
        Caption = 'Created';
    }
    value(2; Updated)
    {
        Caption = 'Updated';
    }
    value(3; Skipped)
    {
        Caption = 'Skipped';
    }
    value(4; Error)
    {
        Caption = 'Error';
    }
}
