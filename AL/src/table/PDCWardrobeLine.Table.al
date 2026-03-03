/// <summary>
/// Table PDC Wardrobe Line (ID 50019).
/// </summary>
table 50019 "PDC Wardrobe Line"
{

    Caption = 'Wardrobe Line';
    DrillDownPageID = "PDC Wardrobe Line List";
    LookupPageID = "PDC Wardrobe Line List";

    fields
    {
        field(1; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";

            trigger OnValidate()
            var
                Wardrobe: Record "PDC Wardrobe Header";
            begin
                if "Wardrobe ID" = '' then
                    Clear("Wardrobe SystemId")
                else
                    if Wardrobe.Get("Wardrobe ID") then
                        "Wardrobe SystemId" := Wardrobe.SystemId;
            end;
        }
        field(2; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Item1: Record Item;
            begin
                if "Product Code" <> '' then begin
                    Item1.SetCurrentkey("PDC Product Code");
                    Item1.SetRange("PDC Product Code", "Product Code");
                    Item1.SetRange(Blocked, false);
                    if Item1.FindFirst() then
                        "Item Gender" := Item1."PDC Gender";
                end;
            end;
        }
        field(3; "Wardrobe SystemId"; Guid)
        {
            Caption = 'Wardrobe SystemId';
            TableRelation = "PDC Wardrobe Header".SystemId;

            trigger OnValidate()
            var
                Wardrobe: Record "PDC Wardrobe Header";
            begin
                if IsNullGuid("Wardrobe SystemId") then
                    "Wardrobe ID" := ''
                else
                    if Wardrobe.GetBySystemId("Wardrobe SystemId") then
                        "Wardrobe ID" := Wardrobe."Wardrobe ID";
            end;
        }
        field(20; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = 'Core,Accessory';
            OptionMembers = Core,Accessory;
        }
        field(100; "Customer No."; Code[20])
        {
            CalcFormula = lookup("PDC Wardrobe Header"."Customer No." where("Wardrobe ID" = field("Wardrobe ID")));
            Caption = 'Customer No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
        }
        field(103; "Item Gender"; Code[2])
        {
            Caption = 'Item Gender';
            TableRelation = "PDC Gender".Code;
        }
        field(104; "Quantity Entitled in Period"; Integer)
        {
            Caption = 'Quantity Entitled in Period';
        }
        field(105; Discontinued; Boolean)
        {
            Caption = 'Discontinued';
        }
        field(106; "Entitlement Period"; Integer)
        {
            Caption = 'Entitlement Period (Days)';
            InitValue = 365;
            MinValue = 1;
        }
        field(107; "Entitlement Qty. Group"; Code[20])
        {
            Caption = 'Entitlement Qty. Group';
            TableRelation = "PDC Staff Entitlement Group".Code where(Type = const("Quantity Group"));
        }
        field(108; "Entitlement Value Group"; Code[20])
        {
            Caption = 'Entitlement Value Group';
            TableRelation = "PDC Staff Entitlement Group".Code where(Type = const("Value Group"));
        }
        field(109; "Entitlement Points Group"; Code[20])
        {
            Caption = 'Entitlement Points Group';
            TableRelation = "PDC Staff Entitlement Group".Code where(Type = const("Points Group"));
        }
    }

    keys
    {
        key(Key1; "Wardrobe ID", "Product Code")
        {
        }
        key(Key2; "Product Code", "Item Gender", Discontinued)
        {
        }
        key(Key3; "Item Type", "Product Code", "Item Gender", Discontinued)
        {
        }
        key(Key4; "Wardrobe ID", "Sort Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PDCWardrobeItemOption: Record "PDC Wardrobe Item Option";
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if StaffEntitlementFunctions.WardrobeEntitlementExistsForWardrobeLine(Rec) then
            Error(StaffEntitlementExistsLbl, "Wardrobe ID", "Product Code");

        PDCWardrobeItemOption.Reset();
        PDCWardrobeItemOption.SetRange("Wardrobe ID", "Wardrobe ID");
        PDCWardrobeItemOption.SetRange("Product Code", "Product Code");
        PDCWardrobeItemOption.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if ("Item Gender" <> '') then
            StaffEntitlementFunctions.UpdateStaffEntitlementFromWardrobeLine(xRec, Rec);
        StaffEntitlementFunctions.UpdateGroupsFromWardrobeLine(xRec, Rec);
    end;

    trigger OnModify()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if ("Item Gender" <> '') then
            StaffEntitlementFunctions.UpdateStaffEntitlementFromWardrobeLine(xRec, Rec);
        StaffEntitlementFunctions.UpdateGroupsFromWardrobeLine(xRec, Rec);
    end;

    var
        StaffEntitlementExistsLbl: label 'Staff Entitlement Exists for Wardrobe ID %1, Item No. %2. Please discontinue line.', Comment = 'Staff Entitlement Exists for Wardrobe ID %1, Item No. %2. Please discontinue line.';
}

