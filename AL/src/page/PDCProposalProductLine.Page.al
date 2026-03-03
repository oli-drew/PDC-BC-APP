/// <summary>
/// Page PDC Proposal Product Line (ID 50079).
/// </summary>
page 50079 "PDC Proposal Product Line"
{
    AutoSplitKey = true;
    Caption = 'Proposal Product Line';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "PDC Proposal Product Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                }
                field(VendorItem; Rec."Vendor Item")
                {
                    ToolTip = 'Vendor Item';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
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
                field(SizeRange; Rec."Size Range")
                {
                    ToolTip = 'Size Range';
                    ApplicationArea = All;
                }
                field(STDSizes; Rec."STD Sizes")
                {
                    ToolTip = 'STD Sizes';
                    ApplicationArea = All;
                }
                field(SkipPrint; Rec."Skip Print")
                {
                    ToolTip = 'Skip Print';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Active';
                    ApplicationArea = All;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Item Code';
                    ApplicationArea = All;
                }
                field("Internal Notes"; Rec."Internal Notes")
                {
                    ToolTip = 'Internal Notes';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Costing)
            {
                ApplicationArea = All;
                Caption = 'Costing';
                ToolTip = 'Costing';
                Image = Currency;
                RunObject = Page "PDC Proposal Pr. Line Costing";
                RunPageLink = "Proposal No." = field("Proposal No."),
                              "Line No." = field("Line No.");
            }
            action(Branding)
            {
                ApplicationArea = All;
                Caption = 'Branding';
                ToolTip = 'Branding';
                Image = BOM;
                RunObject = Page "PDC Proposal Pr. Line Branding";
                RunPageLink = "Proposal No." = field("Proposal No."),
                              "Line No." = field("Line No.");
            }
        }
    }
}

