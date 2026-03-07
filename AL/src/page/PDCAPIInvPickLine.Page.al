/// <summary>
/// Page PDCAPI - Inv Pick Line (ID 50120).
/// API page exposing Warehouse Activity Lines for inventory picks.
/// Used as a subpage of PDCAPI - Inv Pick Header and independently.
/// </summary>
page 50120 "PDCAPI - Inv Pick Line"
{
    APIGroup = 'app1';
    APIPublisher = 'pdc';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'PDCAPI - Inv Pick Line';
    DelayedInsert = true;
    EntityName = 'inventoryPickLine';
    EntitySetName = 'inventoryPickLines';
    PageType = API;
    SourceTable = "Warehouse Activity Line";
    SourceTableView = where("Activity Type" = const("Invt. Pick"));
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
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(sourceNo; Rec."Source No.")
                {
                    Caption = 'Source No.';
                }
                field(sourceLineNo; Rec."Source Line No.")
                {
                    Caption = 'Source Line No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(qtyOutstanding; Rec."Qty. Outstanding")
                {
                    Caption = 'Qty. Outstanding';
                }
                field(qtyToHandle; Rec."Qty. to Handle")
                {
                    Caption = 'Qty. to Handle';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(pdcProductCode; Rec."PDC Product Code")
                {
                    Caption = 'Product Code';
                }
                field(pdcWearerID; Rec."PDC Wearer ID")
                {
                    Caption = 'Wearer ID';
                }
                field(pdcWearerName; Rec."PDC Wearer Name")
                {
                    Caption = 'Wearer Name';
                }
                field(pdcCustomerReference; Rec."PDC Customer Reference")
                {
                    Caption = 'Customer Reference';
                }
                field(pdcWebOrderNo; Rec."PDC Web Order No.")
                {
                    Caption = 'Web Order No.';
                }
                field(pdcOrderedByID; Rec."PDC Ordered By ID")
                {
                    Caption = 'Ordered By ID';
                }
                field(pdcOrderedByName; Rec."PDC Ordered By Name")
                {
                    Caption = 'Ordered By Name';
                }
                field(pdcBranchNo; Rec."PDC Branch No.")
                {
                    Caption = 'Branch No.';
                }
                field(pdcOrderedByPhone; Rec."PDC Ordered By Phone")
                {
                    Caption = 'Ordered By Phone';
                }
                field(pdcSlotNo; Rec."PDC Slot No.")
                {
                    Caption = 'Slot No.';
                }
                field(pdcColour; Rec."PDC Colour")
                {
                    Caption = 'Colour';
                }
                field(pdcSize; Rec."PDC Size")
                {
                    Caption = 'Size';
                }
                field(pdcFit; Rec."PDC Fit")
                {
                    Caption = 'Fit';
                }
                field(pdcInventory; Rec."PDC Inventory")
                {
                    Caption = 'Inventory';
                }
                field(pdcVendorNo; Rec."PDC Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(pdcVendorSKU; Rec."PDC Vendor SKU")
                {
                    Caption = 'Vendor SKU';
                }
            }
        }
    }
}
