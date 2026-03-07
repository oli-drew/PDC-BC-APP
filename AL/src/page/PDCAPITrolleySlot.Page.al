/// <summary>
/// Page PDCAPI - Trolley Slot (ID 50121).
/// API page exposing PDC Trolley Slot records.
/// </summary>
page 50121 "PDCAPI - Trolley Slot"
{
    APIGroup = 'app1';
    APIPublisher = 'pdc';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'PDCAPI - Trolley Slot';
    DelayedInsert = true;
    EntityName = 'trolleySlot';
    EntitySetName = 'trolleySlots';
    PageType = API;
    SourceTable = "PDC Trolley Slot";
    ODataKeyFields = SystemId;
    Extensible = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(trolleyCode; Rec."Trolley Code")
                {
                    Caption = 'Trolley Code';
                }
                field(slotNo; Rec."Slot No.")
                {
                    Caption = 'Slot No.';
                }
                field(invPickNo; Rec."Inv Pick No.")
                {
                    Caption = 'Inv. Pick No.';
                }
                field(pdcWearerID; Rec."PDC Wearer ID")
                {
                    Caption = 'PDC Wearer ID';
                }
                field(pdcWearerName; Rec."PDC Wearer Name")
                {
                    Caption = 'PDC Wearer Name';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(totalLines; Rec."Total Lines")
                {
                    Caption = 'Total Lines';
                }
                field(totalQty; Rec."Total Qty")
                {
                    Caption = 'Total Qty.';
                }
                field(qtyHandled; Rec."Qty Handled")
                {
                    Caption = 'Qty. Handled';
                }
                field(splitFromEntryNo; Rec."Split From Entry No.")
                {
                    Caption = 'Split From Entry No.';
                }
            }
        }
    }

    /// <summary>
    /// Deletes this slot and moves its lines to the first remaining slot.
    /// Called as: POST /trolleySlots({id})/Microsoft.NAV.deleteSlot
    /// </summary>
    [ServiceEnabled]
    procedure deleteSlot(var ActionContext: WebServiceActionContext)
    var
        PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
    begin
        PDCPickStatusMgt.DeleteSlot(Rec."Entry No.");
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"PDCAPI - Trolley Slot");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;

    // Future API actions:
    // [ServiceEnabled] procedure splitSlot(numberOfSplits: Integer; var ActionContext: WebServiceActionContext)
    // [ServiceEnabled] procedure mergeSlot(sourceSlotSystemId: Guid; var ActionContext: WebServiceActionContext)
}
