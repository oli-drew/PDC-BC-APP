/// <summary>
/// Table PDC Trolley (ID 50061).
/// </summary>
table 50061 "PDC Trolley"
{
    Caption = 'PDC Trolley';
    DataClassification = CustomerContent;
    LookupPageId = "PDC Trolley List";
    DrillDownPageId = "PDC Trolley List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(4; "Default Slots"; Integer)
        {
            Caption = 'Default Slots';
            InitValue = 8;
            MinValue = 1;
        }
        field(5; "Max Slots"; Integer)
        {
            Caption = 'Max Slots';
            InitValue = 16;
            MinValue = 1;
        }
        field(6; "Active Picks"; Integer)
        {
            Caption = 'Active Picks';
            FieldClass = FlowField;
            CalcFormula = count("Warehouse Activity Header" where(Type = const("Invt. Pick"),
                                                                   "PDC Trolley Code" = field("Code")));
            Editable = false;
        }
        field(7; "Slots In Use"; Integer)
        {
            Caption = 'Slots In Use';
            FieldClass = FlowField;
            CalcFormula = count("PDC Trolley Slot" where("Trolley Code" = field("Code")));
            Editable = false;
        }
        field(8; "Slots Complete"; Integer)
        {
            Caption = 'Slots Complete';
            FieldClass = FlowField;
            CalcFormula = count("PDC Trolley Slot" where("Trolley Code" = field("Code"),
                                                          Status = const(Complete)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        TrolleySlot: Record "PDC Trolley Slot";
    begin
        TrolleySlot.SetRange("Trolley Code", Code);
        if not TrolleySlot.IsEmpty() then
            Error('Cannot delete trolley %1 because it has active slot assignments.', Code);
    end;
}
