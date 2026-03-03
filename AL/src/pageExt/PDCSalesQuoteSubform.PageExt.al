/// <summary>
/// PageExtension PDCSalesQuoteSubform (ID 50019) extends Record Sales Quote Subform.
/// </summary>
pageextension 50019 PDCSalesQuoteSubform extends "Sales Quote Subform"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = FreeAttention;
        }
        modify(Description)
        {
            StyleExpr = FreeAttention;
        }
        addafter("Qty. to Assemble to Order")
        {
            field(PDCAvailable; g_Free)
            {
                ApplicationArea = All;
                Caption = 'Available';
                ToolTip = 'Available';
                DecimalPlaces = 0 : 0;
                Editable = false;
                StyleExpr = FreeAttention;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field(PDCWearerID; Rec."PDC Wearer ID")
            {
                ToolTip = 'Wearer ID';
                ApplicationArea = All;
            }
            field(PDCWearerName; Rec."PDC Wearer Name")
            {
                ToolTip = 'Wearer Name';
                ApplicationArea = All;
            }
            field(PDCCustomerReference; Rec."PDC Customer Reference")
            {
                ToolTip = 'Customer Reference';
                ApplicationArea = All;
            }
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
            field(PDCWebOrderNo; Rec."PDC Web Order No.")
            {
                ToolTip = 'Web Order No.';
                ApplicationArea = All;
            }
            field(PDCOrderedByID; Rec."PDC Ordered By ID")
            {
                ToolTip = 'Ordered By ID';
                ApplicationArea = All;
            }
            field(PDCOrderedByName; Rec."PDC Ordered By Name")
            {
                ToolTip = 'Ordered By Name';
                ApplicationArea = All;
            }
            field(PDCContractNo; Rec."PDC Contract No.")
            {
                ToolTip = 'Contract No.';
                ApplicationArea = All;
            }
            field(PDCOrderReason; Rec."PDC Order Reason")
            {
                ToolTip = 'Order Reason';
                ApplicationArea = All;
            }
            field(PDCStaffID; Rec."PDC Staff ID")
            {
                ToolTip = 'Staff ID';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

    var
        Item: Record Item;
        g_Free: Decimal;
        FreeAttention: Text;

    trigger OnAfterGetRecord()
    begin
        CLEAR(g_Free);
        if Rec.Type = Rec.Type::Item then
            if Item.GET(Rec."No.") AND (Rec."Qty. per Unit of Measure" <> 0) then begin
                Item.SETRANGE("Variant Filter", Rec."Variant Code");
                Item.SETRANGE("Location Filter", Rec."Location Code");
                Item.SETRANGE("Drop Shipment Filter", FALSE);
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Component Lines");
                g_Free := ROUND((Item.Inventory - Item."Qty. on Sales Order" - Item."Qty. on Component Lines" - Rec."Quantity (Base)") /
                                Rec."Qty. per Unit of Measure", 0.00001);
            end;

        if g_Free < 0 then
            FreeAttention := 'Attention'
        else
            FreeAttention := 'Standard'
    end;
}

