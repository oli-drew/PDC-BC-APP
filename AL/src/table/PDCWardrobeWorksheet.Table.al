/// <summary>
/// Table PDC Wardrobe Worksheet (ID 50027).
/// </summary>
table 50027 "PDC Wardrobe Worksheet"
{
    // //DOC PDCP9 JF 01/08/2017 - object creation. Table to allow PD to insert wardrobe data in one place. It will transfer the information to wardrobe line and wardrobe item option later.

    Caption = 'Wardrobe Worksheet';

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(10; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";

            trigger OnValidate()
            var
                WardrobeHeader: Record "PDC Wardrobe Header";
            begin
                if "Wardrobe ID" <> '' then begin
                    WardrobeHeader.Get("Wardrobe ID");
                    Validate("Wardrobe Description", WardrobeHeader.Description);
                end;
            end;
        }
        field(11; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Customer No."));
                CalcFields("Customer Name");
            end;
        }
        field(12; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Wardrobe Description"; Text[50])
        {
            Caption = 'Wardrobe Description';

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Wardrobe Description"));
            end;
        }
        field(100; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
        }
        field(101; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = 'Core,Accessory';
            OptionMembers = Core,Accessory;

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Item Type"));
            end;
        }
        field(102; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Sort Order"));
            end;
        }
        field(103; "Body Type/Gender"; Code[20])
        {
            Caption = 'Body Type/Gender';
            //TableRelation = "PDC General Lookup".Code where(Type = filter('BODYTYPE'));
            TableRelation = "PDC Gender".Code;

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Body Type/Gender"));
            end;
        }
        field(104; "Quantity Entitled in Period"; Integer)
        {
            Caption = 'Quantity Entitled in Period';

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Quantity Entitled in Period"));
            end;
        }
        field(105; "Entitlement Period"; Integer)
        {
            Caption = 'Entitlement Period (Days)';
            InitValue = 365;
            MinValue = 1;

            trigger OnValidate()
            var
                StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
            begin
                StaffEntitlementFunctions.UpdateWardrobeWorksheetMatchingRecs(Rec, FieldNo("Entitlement Period"));
            end;
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
            Caption = 'Entitlement Value Group';
            TableRelation = "PDC Staff Entitlement Group".Code where(Type = const("Points Group"));
        }
        field(200; "Colour Code"; Code[20])
        {
            Caption = 'Colour Code';
            NotBlank = true;
        }
        field(1000; "Created By User ID"; Code[50])
        {
            Caption = 'Created By User ID';
        }
        field(1001; "Last Modification By User ID"; Code[50])
        {
            Caption = 'Last Modification By User ID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        PDCWardrobeWorksheet: Record "PDC Wardrobe Worksheet";
    begin
        if "Entry No." = 0 then begin
            "Entry No." := 10000;
            PDCWardrobeWorksheet.Reset();
            if PDCWardrobeWorksheet.FindLast() then
                "Entry No." += PDCWardrobeWorksheet."Entry No.";
        end;

        Validate("Created By User ID", UserId);
    end;

    trigger OnModify()
    begin
        Validate("Last Modification By User ID", UserId);
    end;
}

