/// <summary>
/// Enum PDC Pick Status (ID 50011).
/// </summary>
enum 50011 "PDC Pick Status"
{
    Extensible = false;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Complete)
    {
        Caption = 'Complete';
    }
}
