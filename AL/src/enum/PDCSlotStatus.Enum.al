/// <summary>
/// Enum PDC Slot Status (ID 50012).
/// </summary>
enum 50012 "PDC Slot Status"
{
    Extensible = false;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Complete)
    {
        Caption = 'Complete';
    }
}
