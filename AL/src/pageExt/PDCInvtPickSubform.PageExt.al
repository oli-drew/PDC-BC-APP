/// <summary>
/// PageExtension PDCInvtPickSubform (ID 50066) extends Invt. Pick Subform.
/// </summary>
pageextension 50066 PDCInvtPickSubform extends "Invt. Pick Subform"
{
    layout
    {
        addafter("Assemble to Order")
        {
            field(PDCSlotNo; Rec."PDC Slot No.")
            {
                ApplicationArea = All;
                Tooltip = 'Slot No.';
                Editable = false;
            }
            field(PDCColour; Rec."PDC Colour")
            {
                ApplicationArea = All;
                Tooltip = 'Colour';
            }
            field(PDCSize; Rec."PDC Size")
            {
                ApplicationArea = All;
                Tooltip = 'Size';
            }
            field(PDCFit; Rec."PDC Fit")
            {
                ApplicationArea = All;
                Tooltip = 'Fit';
            }
            field(PDCInventory; Rec."PDC Inventory")
            {
                ApplicationArea = All;
                Tooltip = 'Inventory';
            }
            field(PDCVendorNo; Rec."PDC Vendor No.")
            {
                ApplicationArea = All;
                Tooltip = 'Vendor No.';
            }
            field(PDCVendorSKU; Rec."PDC Vendor SKU")
            {
                ApplicationArea = All;
                Tooltip = 'Vendor SKU';
            }
            field(PDCWearerID; Rec."PDC Wearer ID")
            {
                ApplicationArea = All;
                Tooltip = 'WearerID';
            }
            field(PDCWearerName; Rec."PDC Wearer Name")
            {
                ApplicationArea = All;
                Tooltip = 'Wearer Name';
            }
            field(PDCCustomerReference; Rec."PDC Customer Reference")
            {
                ApplicationArea = All;
                Tooltip = 'Customer Reference';
            }
            field(PDCWebOrderNo; Rec."PDC Web Order No.")
            {
                ApplicationArea = All;
                Tooltip = 'Web Order No.';
            }
            field(PDCOrderedByID; Rec."PDC Ordered By ID")
            {
                ApplicationArea = All;
                Tooltip = 'Ordered By ID';
            }
            field(PDCOrderedByName; Rec."PDC Ordered By Name")
            {
                ApplicationArea = All;
                Tooltip = 'Ordered By Name';
            }
            field("PDC SO Line Amount"; Rec."PDC SO Line Amount")
            {
                ApplicationArea = All;
                Tooltip = 'Sales Order Line Amount';
            }
        }

        modify("Qty. to Handle")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;
        }
    }
    actions
    {
    }

    /// <summary>
    /// PostAndPrintAndEmail.
    /// </summary>
    procedure PostAndPrintAndEmail()
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
        PDCFunctions: Codeunit "PDC Functions";
    begin
        WarehouseActivityLine.Copy(Rec);
        PDCFunctions.InvPickPostAndPrintAndEmail(WarehouseActivityLine);
        CurrPage.Update(false);
    end;
}

