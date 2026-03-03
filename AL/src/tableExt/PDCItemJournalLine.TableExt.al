/// <summary>
/// TableExtension PDCItemJournalLine (ID 50013) extends Record Item Journal Line.
/// </summary>
tableextension 50013 PDCItemJournalLine extends "Item Journal Line"
{
    fields
    {

        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                "PDC Product Code" := Item."PDC Product Code";

                "PDC Colour Code" := Item."PDC Colour";
            end;
        }
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50001; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
        field(50002; "PDC Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";
        }
        field(50003; "PDC Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";
        }
        field(50004; "PDC Colour Code"; Code[10])
        {
            Caption = 'Colour Code';
            TableRelation = "PDC Product colour";
        }
        field(50005; "PDC Wearer ID"; Code[30])
        {
            Caption = 'Wearer ID';
        }
        field(50006; "PDC Wearer Name"; Text[50])
        {
            Caption = 'Wearer Name';
        }
        field(50007; "PDC Customer Reference"; Text[50])
        {
            Caption = 'Customer Reference';
        }
        field(50008; "PDC Web Order No."; Code[10])
        {
            Caption = 'Web Order No.';
        }
        field(50009; "PDC Ordered By ID"; Code[20])
        {
            Caption = 'Ordered By ID';
        }
        field(50010; "PDC Ordered By Name"; Text[100])
        {
            Caption = 'Ordered By Name';
        }
        field(50011; "PDC Draft Order No."; Code[20])
        {
            Caption = 'Draft Order No.';
        }
        field(50012; "PDC Draft Order Staff Line No."; Integer)
        {
            Caption = 'Draft Order Staff Line No.';
        }
        field(50013; "PDC Draft Order Item Line No."; Integer)
        {
            Caption = 'Draft Order Item Line No.';
        }
        field(50014; "PDC Order Reason Code"; Code[10])
        {
            Caption = 'Order Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(50015; "PDC Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "PDC Contract"."No.";
        }
        field(50016; "PDC Comment"; Text[100])
        {
            Caption = 'Comment';
        }
        field(50017; "PDC Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Vendor No." where("No." = field("Item No.")));
        }
        field(50018; "PDC Replenishment System"; Enum "Replenishment System")
        {
            Caption = 'Replenishment System';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Replenishment System" where("No." = field("Item No.")));
        }
    }

    var
        Item: Record Item;
}

