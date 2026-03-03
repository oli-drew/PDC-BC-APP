/// <summary>
/// Table PDC EDI Import Line (ID 50300).
/// Temporary table for holding parsed EDI line data during import.
/// </summary>
table 50300 "PDC EDI Import Line"
{
    Caption = 'EDI Import Line';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(20; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(40; "Import Error"; Boolean)
        {
            Caption = 'Import Error';
        }
        field(41; "Import Error Text"; Text[250])
        {
            Caption = 'Import Error Text';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
