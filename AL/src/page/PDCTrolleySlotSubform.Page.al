/// <summary>
/// Page PDC Trolley Slot Subform (ID 50093).
/// ListPart showing slots for an inventory pick, used as a FactBox on the Inventory Pick card.
/// </summary>
page 50093 "PDC Trolley Slot Subform"
{
    ApplicationArea = All;
    Caption = 'Trolley Slots';
    PageType = ListPart;
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
                field("Slot No."; Rec."Slot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The slot position number on the trolley.';
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

    actions
    {
        area(Processing)
        {
            action(SplitSlot)
            {
                ApplicationArea = All;
                Caption = 'Split Slot';
                ToolTip = 'Split this slot into multiple slots, distributing lines evenly.';

                trigger OnAction()
                var
                    PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
                    NumberOfSplits: Integer;
                    InputText: Text;
                begin
                    InputText := '2';
                    if Evaluate(NumberOfSplits, InputText) then;
                    if NumberOfSplits < 2 then
                        NumberOfSplits := 2;
                    PDCPickStatusMgt.SplitSlot(Rec."Entry No.", NumberOfSplits);
                    CurrPage.Update(false);
                end;
            }
            action(MergeSlot)
            {
                ApplicationArea = All;
                Caption = 'Merge Slots';
                ToolTip = 'Merge another slot into this one.';

                trigger OnAction()
                var
                    PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
                    TargetSlot: Record "PDC Trolley Slot";
                begin
                    TargetSlot.SetRange("Inv Pick No.", Rec."Inv Pick No.");
                    TargetSlot.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
                    if Page.RunModal(Page::"PDC Trolley Slot Subform", TargetSlot) = Action::LookupOK then begin
                        PDCPickStatusMgt.MergeSlots(Rec."Entry No.", TargetSlot."Entry No.");
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(DeleteSlot)
            {
                ApplicationArea = All;
                Caption = 'Delete Slot';
                ToolTip = 'Delete this slot. Its lines will be moved to the first remaining slot.';

                trigger OnAction()
                var
                    PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
                begin
                    if not Confirm('Delete slot %1? Its lines will be moved to the first remaining slot.', false, Rec."Slot No.") then
                        exit;
                    PDCPickStatusMgt.DeleteSlot(Rec."Entry No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetSlotStatusStyle();
    end;

    var
        SlotStatusStyle: Text;

    local procedure SetSlotStatusStyle()
    begin
        case Rec.Status of
            Rec.Status::Complete:
                SlotStatusStyle := 'Favorable';
            else
                SlotStatusStyle := 'Standard';
        end;
    end;
}
