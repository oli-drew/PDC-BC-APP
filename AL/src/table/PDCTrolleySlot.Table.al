/// <summary>
/// Table PDC Trolley Slot (ID 50062).
/// </summary>
table 50062 "PDC Trolley Slot"
{
    Caption = 'PDC Trolley Slot';
    DataClassification = CustomerContent;
    LookupPageId = "PDC Trolley Slot List";
    DrillDownPageId = "PDC Trolley Slot List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Trolley Code"; Code[20])
        {
            Caption = 'Trolley Code';
            TableRelation = "PDC Trolley";
        }
        field(3; "Slot No."; Integer)
        {
            Caption = 'Slot No.';
        }
        field(4; "Inv Pick No."; Code[20])
        {
            Caption = 'Inv Pick No.';
            TableRelation = "Warehouse Activity Header"."No." where(Type = const("Invt. Pick"));
        }
        field(5; "PDC Wearer ID"; Code[30])
        {
            Caption = 'Wearer ID';
        }
        field(6; "PDC Wearer Name"; Text[50])
        {
            Caption = 'Wearer Name';
        }
        field(7; Status; Enum "PDC Slot Status")
        {
            Caption = 'Status';
        }
        field(8; "Total Lines"; Integer)
        {
            Caption = 'Total Lines';
            FieldClass = FlowField;
            CalcFormula = count("Warehouse Activity Line" where("Activity Type" = const("Invt. Pick"),
                                                                 "No." = field("Inv Pick No."),
                                                                 "PDC Wearer ID" = field("PDC Wearer ID"),
                                                                 "PDC Slot No." = field("Slot No.")));
            Editable = false;
        }
        field(9; "Total Qty"; Decimal)
        {
            Caption = 'Total Qty';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line".Quantity where("Activity Type" = const("Invt. Pick"),
                                                                       "No." = field("Inv Pick No."),
                                                                       "PDC Wearer ID" = field("PDC Wearer ID"),
                                                                       "PDC Slot No." = field("Slot No.")));
            Editable = false;
        }
        field(10; "Qty Handled"; Decimal)
        {
            Caption = 'Qty Handled';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line"."Qty. to Handle" where("Activity Type" = const("Invt. Pick"),
                                                                                "No." = field("Inv Pick No."),
                                                                                "PDC Wearer ID" = field("PDC Wearer ID"),
                                                                                "PDC Slot No." = field("Slot No.")));
            Editable = false;
        }
        field(11; "Split From Entry No."; Integer)
        {
            Caption = 'Split From Entry No.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(TrolleySlot; "Trolley Code", "Slot No.")
        {
        }
        key(PickWearer; "Inv Pick No.", "PDC Wearer ID")
        {
        }
    }
}
