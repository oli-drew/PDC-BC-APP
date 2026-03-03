/// <summary>
/// Page PDCAPI - Prod. Order Components (ID 50007).
/// </summary>
page 50007 "PDCAPI - Prod.Order Components"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Prod. Order Component';
    EntitySetCaption = 'Prod. Order Components';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'prodOrderComponent';
    EntitySetName = 'prodOrderComponents';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Prod. Order Component";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(prodOrderStatus; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(prodOrderNo; Rec."Prod. Order No.")
                {
                    Caption = 'Prod. Order No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(dueDateTime; Rec."Due Date-Time")
                {
                    Caption = 'Due Date-Time';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(scrap; Rec."Scrap %")
                {
                    Caption = 'Scrap %';
                }
                field(calculationFormula; Rec."Calculation Formula")
                {
                    Caption = 'Calculation Formula';
                }
                field(length; Rec.Length)
                {
                    Caption = 'Length';
                }
                field(width; Rec.Width)
                {
                    Caption = 'Width';
                }
                field(weight; Rec.Weight)
                {
                    Caption = 'Weight';
                }
                field(depth; Rec.Depth)
                {
                    Caption = 'Depth';
                }
                field(quantityper; Rec."Quantity per")
                {
                    Caption = 'Quantity per';
                }
                field(reservedQuantity; Rec."Reserved Quantity")
                {
                    Caption = 'Reserved Quantity';
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(flushingMethod; Rec."Flushing Method")
                {
                    Caption = 'Flushing Method';
                }
                field(expectedQuantity; Rec."Expected Quantity")
                {
                    Caption = 'Expected Quantity';
                }
                field(remainingQuantity; Rec."Remaining Quantity")
                {
                    Caption = 'Remaining Quantity';
                }
                // field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                // {
                //     Caption = 'Shortcut Dimension 1 Code';
                // }
                // field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                // {
                //     Caption = 'Shortcut Dimension 2 Code';
                // }
                // field(shortcutDimCode3; ShortcutDimCode[3])
                // {
                //     Caption = 'ShortcutDimCode3';
                // }
                // field(shortcutDimCode4; ShortcutDimCode[4])
                // {
                //     Caption = 'ShortcutDimCode4';
                // }
                // field(shortcutDimCode5; ShortcutDimCode[5])
                // {
                //     Caption = 'ShortcutDimCode5';
                // }
                // field(shortcutDimCode6; ShortcutDimCode[6])
                // {
                //     Caption = 'ShortcutDimCode6';
                // }
                // field(shortcutDimCode7; ShortcutDimCode[7])
                // {
                //     Caption = 'ShortcutDimCode7';
                // }
                // field(shortcutDimCode8; ShortcutDimCode[8])
                // {
                //     Caption = 'ShortcutDimCode8';
                // }
                field(routingLinkCode; Rec."Routing Link Code")
                {
                    Caption = 'Routing Link Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(costAmount; Rec."Cost Amount")
                {
                    Caption = 'Cost Amount';
                }
                field(position; Rec.Position)
                {
                    Caption = 'Position';
                }
                field(position2; Rec."Position 2")
                {
                    Caption = 'Position 2';
                }
                field(position3; Rec."Position 3")
                {
                    Caption = 'Position 3';
                }
                field(leadTimeOffset; Rec."Lead-Time Offset")
                {
                    Caption = 'Lead-Time Offset';
                }
                field(qtyPicked; Rec."Qty. Picked")
                {
                    Caption = 'Qty. Picked';
                }
                field(qtyPickedBase; Rec."Qty. Picked (Base)")
                {
                    Caption = 'Qty. Picked (Base)';
                }
                field(substitutionAvailable; Rec."Substitution Available")
                {
                    Caption = 'Substitution Available';
                }
                field(vendorNo; Item."Vendor No.")
                {
                    Caption = 'Vendor No.';
                    Editable = false;
                }
                field(itemVendorNo; Item."Vendor Item No.")
                {
                    Caption = 'Vendor Item No.';
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // Rec.ShowShortcutDimCode(ShortcutDimCode);
        item.SetLoadFields("Vendor No.", "Vendor Item No.");
        if not item.get(Rec."Item No.") then clear(Item);
    end;

    var
        Item: Record Item;

    protected var
    // ShortcutDimCode: array[8] of Code[20];
}