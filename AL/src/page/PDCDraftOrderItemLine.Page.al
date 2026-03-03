/// <summary>
/// Page PDC Draft Order Item Line (ID 50035).
/// </summary>
page 50035 "PDC Draft Order Item Line"
{
    Caption = 'Draft Order Item Line';
    PageType = List;
    SourceTable = "PDC Draft Order Item Line";
    UsageCategory = Administration;
    ApplicationArea = All;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = ItemDescription;
                field(DocumentNo; Rec."Document No.")
                {
                    ToolTip = 'Document No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(StaffLineNo; Rec."Staff Line No.")
                {
                    ToolTip = 'Staff Line No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ToolTip = 'Line No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ToolTip = 'Item Description';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ProductCode; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FitCode; Rec."Fit Code")
                {
                    ToolTip = 'Fit Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ColourCode; Rec."Colour Code")
                {
                    ToolTip = 'Colour Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SizeCode; Rec."Size Code")
                {
                    ToolTip = 'Size Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Quantity';
                    ApplicationArea = All;
                }
                field(Entitlement; Rec.Entitlement)
                {
                    ToolTip = 'Entitlement';
                    ApplicationArea = All;
                }
                field(QuantityIssued; Rec."Quantity Issued")
                {
                    ToolTip = 'Quantity Issued';
                    ApplicationArea = All;
                }
                field(QuantityRemaining; Rec."Quantity Remaining")
                {
                    ToolTip = 'Quantity Remaining';
                    ApplicationArea = All;
                }
                field(LastDateTimeCalculated; Rec."Last DateTime Calculated")
                {
                    ToolTip = 'Last DateTime Calculated';
                    ApplicationArea = All;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ToolTip = 'Unit Price';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(UnitOfMeasureCode; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Unit Of Measure Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ToolTip = 'Line Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SLADate; Rec."SLA Date")
                {
                    ToolTip = 'SLA Date';
                    ApplicationArea = All;
                }
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;
                }
                field(BranchID; Rec."Branch ID")
                {
                    ToolTip = 'Branch ID';
                    ApplicationArea = All;
                }
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                }
                field(ApprovedOutsideSLA; Rec."Approved Outside SLA")
                {
                    ToolTip = 'Approved Outside SLA';
                    ApplicationArea = All;
                }
                field("Create Order No."; Rec."Create Order No.")
                {
                    ToolTip = 'Create Order No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested Shipment Date"; Rec."Requested Shipment Date")
                {
                    ToolTip = 'Requested Shipment Date';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Shipping Agent Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ToolTip = 'Shipping Agent Service Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Portal User Id"; Rec."Portal User Id")
                {
                    ToolTip = 'Portal User Id';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Out Of SLA"; Rec."Out Of SLA")
                {
                    ToolTip = 'Out Of SLA';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Over Entitlement Reason"; Rec."Over Entitlement Reason")
                {
                    ToolTip = 'Over Entitlement Reason';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UpdateQuantityIssuedRemaining)
            {
                ApplicationArea = All;
                Caption = '&Update Quantity Issued/Remaining';
                ToolTip = 'Update Quantity Issued/Remaining';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DraftOrderItemLine: Record "PDC Draft Order Item Line";
                    StaffEntitlement: Record "PDC Staff Entitlement";
                    WardrobeFunctions: Codeunit "PDC Staff Entitlement";
                begin
                    CurrPage.SetSelectionFilter(DraftOrderItemLine);
                    DraftOrderItemLine.FindSet();
                    repeat
                        DraftOrderItemLine.CalcFields("Staff ID", "Wardrobe ID");
                        StaffEntitlement.Reset();
                        StaffEntitlement.SetRange("Staff ID", DraftOrderItemLine."Staff ID");
                        StaffEntitlement.SetRange(Inactive, false);
                        StaffEntitlement.SetRange("Product Code", DraftOrderItemLine."Product Code");
                        WardrobeFunctions.UpdateStaffentitlementQuantities(StaffEntitlement);
                    until DraftOrderItemLine.Next() = 0;
                end;
            }
        }
    }
}
