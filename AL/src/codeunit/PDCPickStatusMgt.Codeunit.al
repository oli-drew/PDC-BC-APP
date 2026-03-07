/// <summary>
/// Codeunit PDC Pick Status Mgt (ID 50022).
/// Manages trolley/slot assignment, pick status tracking, and slot operations
/// for the paperless inventory picking system.
/// </summary>
codeunit 50022 "PDC Pick Status Mgt"
{
    /// <summary>
    /// Creates slot records for an inventory pick based on distinct Wearer IDs.
    /// Slot numbers are sequential across all picks on the same trolley.
    /// </summary>
    /// <param name="InvPickNo">The inventory pick number.</param>
    /// <param name="TrolleyCode">The trolley code to assign slots to.</param>
    procedure CreateSlotsForPick(InvPickNo: Code[20]; TrolleyCode: Code[20])
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        TrolleySlot: Record "PDC Trolley Slot";
        TempWearerBuffer: Record "PDC Trolley Slot" temporary;
        NextSlotNo: Integer;
    begin
        // Get the next slot number on this trolley
        NextSlotNo := GetNextSlotNo(TrolleyCode);

        // Collect distinct wearers from the pick lines
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", InvPickNo);
        if WhseActivityLine.FindSet() then
            repeat
                TempWearerBuffer.SetRange("PDC Wearer ID", WhseActivityLine."PDC Wearer ID");
                if TempWearerBuffer.IsEmpty() then begin
                    TempWearerBuffer.Init();
                    TempWearerBuffer."Entry No." := NextSlotNo;
                    TempWearerBuffer."PDC Wearer ID" := WhseActivityLine."PDC Wearer ID";
                    TempWearerBuffer."PDC Wearer Name" := WhseActivityLine."PDC Wearer Name";
                    TempWearerBuffer.Insert();
                    NextSlotNo += 1;
                end;
                TempWearerBuffer.Reset();
            until WhseActivityLine.Next() = 0;

        // Create actual slot records and stamp slot numbers on lines
        TempWearerBuffer.Reset();
        if TempWearerBuffer.FindSet() then
            repeat
                TrolleySlot.Init();
                TrolleySlot."Entry No." := 0; // AutoIncrement
                TrolleySlot."Trolley Code" := TrolleyCode;
                TrolleySlot."Slot No." := TempWearerBuffer."Entry No."; // We stored the slot no. in Entry No.
                TrolleySlot."Inv Pick No." := InvPickNo;
                TrolleySlot."PDC Wearer ID" := TempWearerBuffer."PDC Wearer ID";
                TrolleySlot."PDC Wearer Name" := TempWearerBuffer."PDC Wearer Name";
                TrolleySlot.Status := TrolleySlot.Status::Pending;
                TrolleySlot.Insert(true);

                // Stamp slot number on matching lines
                StampSlotNoOnLines(InvPickNo, TempWearerBuffer."PDC Wearer ID", TempWearerBuffer."Entry No.");
            until TempWearerBuffer.Next() = 0;

        // Update unique wearer count on header
        RecalcUniqueWearers(InvPickNo);
    end;

    /// <summary>
    /// Deletes all slot records for an inventory pick and re-sequences
    /// remaining slots on the trolley.
    /// </summary>
    /// <param name="InvPickNo">The inventory pick number.</param>
    /// <param name="TrolleyCode">The trolley code.</param>
    procedure DeleteSlotsForPick(InvPickNo: Code[20]; TrolleyCode: Code[20])
    var
        TrolleySlot: Record "PDC Trolley Slot";
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        // Clear slot numbers on lines
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", InvPickNo);
        WhseActivityLine.ModifyAll("PDC Slot No.", 0);

        // Delete slot records for this pick
        TrolleySlot.SetRange("Inv Pick No.", InvPickNo);
        TrolleySlot.DeleteAll();

        // Re-sequence remaining slots on the trolley
        ResequenceTrolleySlots(TrolleyCode);

        // Update unique wearer count on header
        RecalcUniqueWearers(InvPickNo);
    end;

    /// <summary>
    /// Deletes a single slot. Its pick lines are moved to the first remaining slot on the same pick.
    /// If it's the last slot, an error is raised.
    /// </summary>
    /// <param name="SlotEntryNo">The entry number of the slot to delete.</param>
    procedure DeleteSlot(SlotEntryNo: Integer)
    var
        SlotToDelete: Record "PDC Trolley Slot";
        TargetSlot: Record "PDC Trolley Slot";
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        SlotToDelete.Get(SlotEntryNo);

        // Find another slot on the same pick to absorb the lines
        TargetSlot.SetRange("Inv Pick No.", SlotToDelete."Inv Pick No.");
        TargetSlot.SetFilter("Entry No.", '<>%1', SlotToDelete."Entry No.");
        if not TargetSlot.FindFirst() then
            Error('Cannot delete the last slot. Clear the trolley assignment instead.');

        // Move lines to the target slot
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", SlotToDelete."Inv Pick No.");
        WhseActivityLine.SetRange("PDC Slot No.", SlotToDelete."Slot No.");
        WhseActivityLine.ModifyAll("PDC Slot No.", TargetSlot."Slot No.");

        // Delete the slot and resequence
        SlotToDelete.Delete();
        ResequenceTrolleySlots(TargetSlot."Trolley Code");
    end;

    /// <summary>
    /// Splits a slot into multiple slots. Lines are distributed evenly (round-robin).
    /// </summary>
    /// <param name="SlotEntryNo">The entry number of the slot to split.</param>
    /// <param name="NumberOfSplits">How many slots to split into (including the original).</param>
    procedure SplitSlot(SlotEntryNo: Integer; NumberOfSplits: Integer)
    var
        SourceSlot: Record "PDC Trolley Slot";
        NewSlot: Record "PDC Trolley Slot";
        WhseActivityLine: Record "Warehouse Activity Line";
        LineCount: Integer;
        CurrentSplit: Integer;
        NextSlotNo: Integer;
        SlotNos: array[50] of Integer;
        i: Integer;
    begin
        if NumberOfSplits < 2 then
            Error('Number of splits must be at least 2.');

        SourceSlot.Get(SlotEntryNo);
        NextSlotNo := GetNextSlotNo(SourceSlot."Trolley Code");

        // First slot keeps the original slot number
        SlotNos[1] := SourceSlot."Slot No.";

        // Create new slot records for splits 2..N
        for i := 2 to NumberOfSplits do begin
            NewSlot.Init();
            NewSlot."Entry No." := 0; // AutoIncrement
            NewSlot."Trolley Code" := SourceSlot."Trolley Code";
            NewSlot."Slot No." := NextSlotNo;
            NewSlot."Inv Pick No." := SourceSlot."Inv Pick No.";
            NewSlot."PDC Wearer ID" := SourceSlot."PDC Wearer ID";
            NewSlot."PDC Wearer Name" := SourceSlot."PDC Wearer Name";
            NewSlot.Status := NewSlot.Status::Pending;
            NewSlot."Split From Entry No." := SlotEntryNo;
            NewSlot.Insert(true);
            SlotNos[i] := NextSlotNo;
            NextSlotNo += 1;
        end;

        // Distribute lines round-robin across the slots
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", SourceSlot."Inv Pick No.");
        WhseActivityLine.SetRange("PDC Wearer ID", SourceSlot."PDC Wearer ID");
        WhseActivityLine.SetRange("PDC Slot No.", SourceSlot."Slot No.");
        CurrentSplit := 1;
        if WhseActivityLine.FindSet() then
            repeat
                WhseActivityLine."PDC Slot No." := SlotNos[CurrentSplit];
                WhseActivityLine.Modify();
                CurrentSplit += 1;
                if CurrentSplit > NumberOfSplits then
                    CurrentSplit := 1;
            until WhseActivityLine.Next() = 0;

        // Reset source slot status since lines may have moved
        SourceSlot.Status := SourceSlot.Status::Pending;
        SourceSlot.Modify();
    end;

    /// <summary>
    /// Moves a single warehouse activity line from its current slot to a target slot.
    /// </summary>
    /// <param name="WhseActivityLine">The line to move.</param>
    /// <param name="TargetSlotEntryNo">The entry number of the destination slot.</param>
    procedure MoveLineToSlot(var WhseActivityLine: Record "Warehouse Activity Line"; TargetSlotEntryNo: Integer)
    var
        TargetSlot: Record "PDC Trolley Slot";
        SourceSlot: Record "PDC Trolley Slot";
        OldSlotNo: Integer;
    begin
        TargetSlot.Get(TargetSlotEntryNo);

        // Validate same pick
        if WhseActivityLine."No." <> TargetSlot."Inv Pick No." then
            Error('Cannot move line to a slot on a different inventory pick.');

        OldSlotNo := WhseActivityLine."PDC Slot No.";

        // Update the line
        WhseActivityLine."PDC Slot No." := TargetSlot."Slot No.";
        WhseActivityLine.Modify();

        // Check if source slot is now empty and should be deleted
        CleanupEmptySlots(WhseActivityLine."No.", OldSlotNo);

        // Recheck slot statuses
        CheckSlotComplete(TargetSlot);
    end;

    /// <summary>
    /// Merges two slots into one. All lines from slot 2 move to slot 1.
    /// Slot 2 is deleted.
    /// </summary>
    /// <param name="SlotEntryNo1">The entry number of the slot to keep.</param>
    /// <param name="SlotEntryNo2">The entry number of the slot to merge into slot 1.</param>
    procedure MergeSlots(SlotEntryNo1: Integer; SlotEntryNo2: Integer)
    var
        Slot1: Record "PDC Trolley Slot";
        Slot2: Record "PDC Trolley Slot";
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        Slot1.Get(SlotEntryNo1);
        Slot2.Get(SlotEntryNo2);

        if Slot1."Inv Pick No." <> Slot2."Inv Pick No." then
            Error('Cannot merge slots from different inventory picks.');

        // Move all lines from slot 2 to slot 1
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", Slot2."Inv Pick No.");
        WhseActivityLine.SetRange("PDC Slot No.", Slot2."Slot No.");
        WhseActivityLine.ModifyAll("PDC Slot No.", Slot1."Slot No.");

        // Delete slot 2
        Slot2.Delete();

        // Re-sequence and recheck
        ResequenceTrolleySlots(Slot1."Trolley Code");
        CheckSlotComplete(Slot1);
    end;

    /// <summary>
    /// Checks if a slot is complete (all lines fully handled) and updates its status.
    /// </summary>
    /// <param name="TrolleySlot">The slot record to check.</param>
    procedure CheckSlotComplete(var TrolleySlot: Record "PDC Trolley Slot")
    begin
        TrolleySlot.CalcFields("Total Qty", "Qty Handled");
        if (TrolleySlot."Total Qty" > 0) and (TrolleySlot."Qty Handled" >= TrolleySlot."Total Qty") then begin
            if TrolleySlot.Status <> TrolleySlot.Status::Complete then
                TrolleySlot.Status := TrolleySlot.Status::Complete;
        end else begin
            if TrolleySlot.Status <> TrolleySlot.Status::Pending then
                TrolleySlot.Status := TrolleySlot.Status::Pending;
        end;
        // Always modify to ensure FactBox FlowFields (Qty Handled, Total Qty) refresh
        TrolleySlot.Modify();
    end;

    /// <summary>
    /// Checks if all slots for a pick are complete, and updates the pick header status accordingly.
    /// </summary>
    /// <param name="InvPickNo">The inventory pick number.</param>
    procedure CheckPickComplete(InvPickNo: Code[20])
    var
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        TrolleySlot: Record "PDC Trolley Slot";
        AllComplete: Boolean;
    begin
        if not WhseActivityHeader.Get(WhseActivityHeader.Type::"Invt. Pick", InvPickNo) then
            exit;

        // Only check if the pick is actively being worked on
        if WhseActivityHeader."PDC Pick Status" = WhseActivityHeader."PDC Pick Status"::Pending then
            exit;

        TrolleySlot.SetRange("Inv Pick No.", InvPickNo);
        if TrolleySlot.IsEmpty() then begin
            // No slots — check line-level completion
            AllComplete := true;
            WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
            WhseActivityLine.SetRange("No.", InvPickNo);
            if WhseActivityLine.FindSet() then
                repeat
                    if WhseActivityLine."Qty. to Handle" <> WhseActivityLine.Quantity then
                        AllComplete := false;
                until (WhseActivityLine.Next() = 0) or (not AllComplete);
        end else begin
            // Slots exist — check slot-level completion
            AllComplete := true;
            TrolleySlot.FindSet();
            repeat
                if TrolleySlot.Status <> TrolleySlot.Status::Complete then
                    AllComplete := false;
            until (TrolleySlot.Next() = 0) or (not AllComplete);
        end;

        if AllComplete then begin
            if WhseActivityHeader."PDC Pick Status" <> WhseActivityHeader."PDC Pick Status"::Complete then begin
                WhseActivityHeader."PDC Pick Status" := WhseActivityHeader."PDC Pick Status"::Complete;
                WhseActivityHeader."PDC Pick Completed At" := CurrentDateTime;
                WhseActivityHeader.Modify();
            end;
        end else begin
            if WhseActivityHeader."PDC Pick Status" = WhseActivityHeader."PDC Pick Status"::Complete then begin
                WhseActivityHeader."PDC Pick Status" := WhseActivityHeader."PDC Pick Status"::"In Progress";
                WhseActivityHeader."PDC Pick Completed At" := 0DT;
                WhseActivityHeader.Modify();
            end;
        end;
    end;

    /// <summary>
    /// Recalculates the unique wearer count on a warehouse activity header.
    /// </summary>
    /// <param name="InvPickNo">The inventory pick number.</param>
    procedure RecalcUniqueWearers(InvPickNo: Code[20])
    var
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        WearerDict: Dictionary of [Code[30], Boolean];
    begin
        if not WhseActivityHeader.Get(WhseActivityHeader.Type::"Invt. Pick", InvPickNo) then
            exit;

        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", InvPickNo);
        if WhseActivityLine.FindSet() then
            repeat
                if not WearerDict.ContainsKey(WhseActivityLine."PDC Wearer ID") then
                    WearerDict.Add(WhseActivityLine."PDC Wearer ID", true);
            until WhseActivityLine.Next() = 0;

        if WhseActivityHeader."PDC Unique Wearers" <> WearerDict.Count() then begin
            WhseActivityHeader."PDC Unique Wearers" := WearerDict.Count();
            WhseActivityHeader.Modify();
        end;
    end;

    /// <summary>
    /// Re-sequences all slots on a trolley to close gaps after deletion.
    /// Updates slot numbers on lines accordingly.
    /// </summary>
    /// <param name="TrolleyCode">The trolley code to re-sequence.</param>
    procedure ResequenceTrolleySlots(TrolleyCode: Code[20])
    var
        TrolleySlot: Record "PDC Trolley Slot";
        WhseActivityLine: Record "Warehouse Activity Line";
        NewSlotNo: Integer;
        OldSlotNo: Integer;
    begin
        NewSlotNo := 1;
        TrolleySlot.SetCurrentKey("Trolley Code", "Slot No.");
        TrolleySlot.SetRange("Trolley Code", TrolleyCode);
        if TrolleySlot.FindSet() then
            repeat
                OldSlotNo := TrolleySlot."Slot No.";
                if OldSlotNo <> NewSlotNo then begin
                    // Update lines first
                    WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
                    WhseActivityLine.SetRange("No.", TrolleySlot."Inv Pick No.");
                    WhseActivityLine.SetRange("PDC Slot No.", OldSlotNo);
                    WhseActivityLine.ModifyAll("PDC Slot No.", NewSlotNo);

                    // Update slot record
                    TrolleySlot."Slot No." := NewSlotNo;
                    TrolleySlot.Modify();
                end;
                NewSlotNo += 1;
            until TrolleySlot.Next() = 0;
    end;

    /// <summary>
    /// Event subscriber: after a warehouse activity line is modified,
    /// check slot and pick completion status.
    /// Fires after the record is saved, so FlowFields read current data.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyWhseActivityLine(var Rec: Record "Warehouse Activity Line"; var xRec: Record "Warehouse Activity Line"; RunTrigger: Boolean)
    var
        TrolleySlot: Record "PDC Trolley Slot";
    begin
        if Rec."Activity Type" <> Rec."Activity Type"::"Invt. Pick" then
            exit;

        // Check slot completion if slots are assigned
        if Rec."PDC Slot No." <> 0 then begin
            TrolleySlot.SetRange("Inv Pick No.", Rec."No.");
            TrolleySlot.SetRange("Slot No.", Rec."PDC Slot No.");
            if TrolleySlot.FindFirst() then
                CheckSlotComplete(TrolleySlot);
        end;

        CheckPickComplete(Rec."No.");
    end;

    local procedure GetNextSlotNo(TrolleyCode: Code[20]): Integer
    var
        TrolleySlot: Record "PDC Trolley Slot";
    begin
        TrolleySlot.SetCurrentKey("Trolley Code", "Slot No.");
        TrolleySlot.SetRange("Trolley Code", TrolleyCode);
        if TrolleySlot.FindLast() then
            exit(TrolleySlot."Slot No." + 1)
        else
            exit(1);
    end;

    local procedure StampSlotNoOnLines(InvPickNo: Code[20]; WearerID: Code[30]; SlotNo: Integer)
    var
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", InvPickNo);
        WhseActivityLine.SetRange("PDC Wearer ID", WearerID);
        WhseActivityLine.ModifyAll("PDC Slot No.", SlotNo);
    end;

    local procedure CleanupEmptySlots(InvPickNo: Code[20]; SlotNo: Integer)
    var
        TrolleySlot: Record "PDC Trolley Slot";
        WhseActivityLine: Record "Warehouse Activity Line";
    begin
        // Check if any lines still reference this slot number
        WhseActivityLine.SetRange("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SetRange("No.", InvPickNo);
        WhseActivityLine.SetRange("PDC Slot No.", SlotNo);
        if WhseActivityLine.IsEmpty() then begin
            // No lines left — delete the slot
            TrolleySlot.SetRange("Inv Pick No.", InvPickNo);
            TrolleySlot.SetRange("Slot No.", SlotNo);
            if TrolleySlot.FindFirst() then begin
                TrolleySlot.Delete();
                ResequenceTrolleySlots(TrolleySlot."Trolley Code");
            end;
        end;
    end;
}
