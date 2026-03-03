/// <summary>
/// Page PDC Proposal Costing Line (ID 50081).
/// </summary>
page 50081 "PDC Proposal Costing Line"
{
    AutoSplitKey = true;
    Caption = 'Proposal Costing Line';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "PDC Proposal Costing Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProposalLineNo; Rec."Proposal Line No.")
                {
                    ToolTip = 'Proposal Line No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ToolTip = 'Line No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ProductCode; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                }
                field(VendorItemNo; Rec."Vendor Item No.")
                {
                    ToolTip = 'Vendor Item No.';
                    ApplicationArea = All;
                }
                field(Colour; Rec.Colour)
                {
                    ToolTip = 'Colour';
                    ApplicationArea = All;
                }
                field(Fit; Rec.Fit)
                {
                    ToolTip = 'Fit';
                    ApplicationArea = All;
                }
                field(Size; Rec.Size)
                {
                    ToolTip = 'Size';
                    ApplicationArea = All;
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ToolTip = 'Item Description';
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Price';
                    ApplicationArea = All;
                }
                field(Issue; Rec.Issue)
                {
                    ToolTip = 'Issue';
                    ApplicationArea = All;
                }
                field(Staff; Rec.Staff)
                {
                    ToolTip = 'Staff';
                    ApplicationArea = All;
                }
                field(ChurnPct; Rec."Churn Pct.")
                {
                    ToolTip = 'Churn Pct.';
                    ApplicationArea = All;
                }
                field(AnnualUsage; Rec."Annual Usage")
                {
                    ToolTip = 'Annual Usage';
                    ApplicationArea = All;
                }
                field(ItemCost; Rec."Item Cost")
                {
                    ToolTip = 'Item Cost';
                    ApplicationArea = All;
                }
                field(BrandingRoutingCost; Rec."Branding Routing Cost")
                {
                    ToolTip = 'Branding Routing Cost';
                    ApplicationArea = All;
                }
                field(BrandingComponentCost; Rec."Branding Component Cost")
                {
                    ToolTip = 'Branding Component Cost';
                    ApplicationArea = All;
                }
                field(CostRollUp; Rec."Cost Roll Up")
                {
                    ToolTip = 'Cost Roll Up';
                    ApplicationArea = All;
                }
                field(GrossProfit; Rec."Gross Profit")
                {
                    ToolTip = 'Gross Profit';
                    ApplicationArea = All;
                }
                field(Margin; Rec.Margin)
                {
                    ToolTip = 'Margin';
                    ApplicationArea = All;
                }
                field(TotalSales; Rec."Total Sales")
                {
                    ToolTip = 'Total Sales';
                    ApplicationArea = All;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ToolTip = 'Total Cost';
                    ApplicationArea = All;
                }
                field(GrossProfitTotal; Rec."Gross Profit Total")
                {
                    ToolTip = 'Gross Profit Total';
                    ApplicationArea = All;
                }
                field(ProductionBOMNo; Rec."Production BOM No.")
                {
                    ToolTip = 'Production BOM No.';
                    ApplicationArea = All;
                }
                field(RoutingNo; Rec."Routing No.")
                {
                    ToolTip = 'Routing No.';
                    ApplicationArea = All;
                }
                field(SizeScaleCode; Rec."Size Scale Code")
                {
                    ToolTip = 'Size Scale Code';
                    ApplicationArea = All;
                }
                field(SLA; Rec.SLA)
                {
                    ToolTip = 'SLA';
                    ApplicationArea = All;
                }
                field(ReturnPeriod; Rec."Return Period")
                {
                    ToolTip = 'Return Period';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PDCProposalProductLine.Get(Rec."Proposal No.", Rec."Proposal Line No.");
        Rec."Product Code" := PDCProposalProductLine."Product Code";
    end;

    var
        PDCProposalProductLine: Record "PDC Proposal Product Line";
}

