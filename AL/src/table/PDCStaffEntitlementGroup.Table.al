/// <summary>
/// Table PDC Staff Entitlement Group (ID 50000).
/// </summary>
table 50000 "PDC Staff Entitlement Group"
{
    Caption = 'Staff Entitlement Group';
    DataClassification = CustomerContent;
    LookupPageId = "PDC Staff Entitlement Groups";
    DrillDownPageId = "PDC Staff Entitlement Groups";

    fields
    {
        field(1; "Type"; Enum PDCEntitlementGroupType)
        {
            Caption = 'Type';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Default Value"; Decimal)
        {
            Caption = 'Default Value';
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(PK; Type, Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Type = Type::" " then
            FieldError(Type);
    end;

    trigger OnModify()
    begin
        if Type = Type::" " then
            FieldError(Type);
    end;

}
