/// <summary>
/// Table PDC Wardrobe Entitlement Group (ID 50001).
/// </summary>
table 50001 "PDC Wardrobe Entitlement Group"
{
    Caption = 'Wardrobe Entitlement Group';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";
        }
        field(2; "Type"; Enum PDCEntitlementGroupType)
        {
            Caption = 'Type';
        }
        field(3; "Group Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "PDC Staff Entitlement Group".Code where(Type = field(Type));

            trigger OnValidate()
            begin
                EntitlementGroup.get(Type, "Group Code");
                validate(Value, EntitlementGroup."Default Value");
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Value"; Decimal)
        {
            Caption = 'Value';
        }
        field(6; "Entitlement Period"; Integer)
        {
            Caption = 'Entitlement Period (Days)';
            InitValue = 365;
            MinValue = 1;
        }
    }
    keys
    {
        key(PK; "Wardrobe ID", Type, "Group Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if Type = Type::" " then
            FieldError(Type);
        StaffEntitlementFunctions.UpdateStaffEntitlementGroupsFromWardrobeLine(xRec, Rec);
    end;

    trigger OnModify()
    begin
        if Type = Type::" " then
            FieldError(Type);
        StaffEntitlementFunctions.UpdateStaffEntitlementGroupsFromWardrobeLine(xRec, Rec);
    end;

    var
        EntitlementGroup: Record "PDC Staff Entitlement Group";
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";

}
