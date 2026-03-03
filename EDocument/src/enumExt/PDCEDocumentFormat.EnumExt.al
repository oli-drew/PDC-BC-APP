/// <summary>
/// EnumExtension PDC E-Document Format (ID 50301) extends E-Document Format.
/// Adds R777 CSV as a document format option for E-Document services.
/// </summary>
enumextension 50301 "PDC E-Document Format" extends "E-Document Format"
{
    value(50300; "PDC R777 CSV")
    {
        Caption = 'R777 CSV';
        Implementation = "E-Document" = "PDC R777 CSV Format";
    }
    value(50301; "PDC CSV")
    {
        Caption = 'PDC CSV';
        Implementation = "E-Document" = "PDC CSV Format";
    }
}
