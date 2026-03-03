/// <summary>
/// Table PDC Wardrobe Item Option (ID 50021).
/// </summary>
table 50021 "PDC Wardrobe Item Option"
{

    Caption = 'Wardrobe Item Option';

    fields
    {
        field(1; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
        }
        field(2; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = "PDC Wardrobe Line"."Product Code" where("Wardrobe ID" = field("Wardrobe ID"));
        }
        field(3; "Colour Code"; Code[10])
        {
            Caption = 'Colour Code';
            NotBlank = true;
            TableRelation = "PDC Product colour";

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if "Product Code" <> '' then begin
                    Item.SetRange("PDC Product Code", "Product Code");
                    Item.SetRange("PDC Colour", "Colour Code");
                    if Item.IsEmpty() then
                        Error(ItemColourErr, "Product Code", "Colour Code");
                end;
            end;
        }
        field(10; "Has Unblocked Item Sizes"; Boolean)
        {
            CalcFormula = exist(Item where("PDC Product Code" = field("Product Code"),
                                           "PDC Colour" = field("Colour Code"),
                                           Blocked = const(false),
                                           "PDC Size" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Wardrobe ID", "Product Code", "Colour Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PDCDraftOrderItemLine: Record "PDC Draft Order Item Line";
        ErrInUseLbl: Label 'This Wardrobe Item Line is in use in one or more draft orders.', Comment = 'This Wardrobe Item Line is in use in one or more draft orders.';
    begin
        PDCDraftOrderItemLine.Reset();

        PDCDraftOrderItemLine.SetRange("Wardrobe ID", "Wardrobe ID");
        PDCDraftOrderItemLine.SetRange("Product Code", "Product Code");
        PDCDraftOrderItemLine.SetRange("Colour Code", "Colour Code");

        if PDCDraftOrderItemLine.Get() then Error(ErrInUseLbl);
    end;

    trigger OnInsert()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        StaffEntitlementFunctions.UpdateStaffEntitlementFromWardrobeItemOption(Rec); //DOC PDCP9 JF 31/07/2017 -+
    end;

    var
        ItemColourErr: label 'The combination of Product Code %1 and Colour Code %2 does not exist.', Comment = '%1 is Product Code, %2 is Colour Code.';
}

