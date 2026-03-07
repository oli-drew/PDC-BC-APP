/// <summary>
/// Page PDC Trolley Slot List (ID 50094).
/// List page showing all trolley slots, optionally filtered by trolley.
/// </summary>
page 50094 "PDC Trolley Slot List"
{
    ApplicationArea = All;
    Caption = 'Trolley Slots';
    PageType = List;
    SourceTable = "PDC Trolley Slot";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Trolley Code"; Rec."Trolley Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The trolley this slot belongs to.';
                }
                field("Slot No."; Rec."Slot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The slot position number on the trolley.';
                }
                field("Inv Pick No."; Rec."Inv Pick No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The inventory pick this slot is assigned to.';
                }
                field("PDC Wearer ID"; Rec."PDC Wearer ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The wearer ID assigned to this slot.';
                }
                field("PDC Wearer Name"; Rec."PDC Wearer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The wearer name assigned to this slot.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'The completion status of this slot.';
                    StyleExpr = SlotStatusStyle;
                }
                field("Total Lines"; Rec."Total Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total number of pick lines in this slot.';
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total quantity to pick for this slot.';
                }
                field("Qty Handled"; Rec."Qty Handled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Quantity handled so far for this slot.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Complete:
                SlotStatusStyle := 'Favorable';
            else
                SlotStatusStyle := 'Standard';
        end;
    end;

    var
        SlotStatusStyle: Text;
}
