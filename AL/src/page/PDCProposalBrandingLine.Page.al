/// <summary>
/// Page PDC Proposal Branding Line (ID 50083).
/// </summary>
page 50083 "PDC Proposal Branding Line"
{
    AutoSplitKey = true;
    Caption = 'Proposal Branding Line';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "PDC Proposal Branding Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProposalNo; Rec."Proposal No.")
                {
                    ToolTip = 'Proposal No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ProposalLineNo; Rec."Proposal Line No.")
                {
                    ToolTip = 'Proposal Line No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ProductCode; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                }
                field(LineNo; Rec."Line No.")
                {
                    ToolTip = 'Line No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(BrandingNo; Rec."Branding No.")
                {
                    ToolTip = 'Branding No.';
                    ApplicationArea = All;
                }
                field(BrandingDescription; Rec."Branding Description")
                {
                    ToolTip = 'Branding Description';
                    ApplicationArea = All;
                }
                field(BrandingTypeCode; Rec."Branding Type Code")
                {
                    ToolTip = 'Branding Type Code';
                    ApplicationArea = All;
                }
                field(BrandingPositionCode; Rec."Branding Position Code")
                {
                    ToolTip = 'Branding Position Code';
                    ApplicationArea = All;
                }
                field(BrandingFile; Rec."Branding File")
                {
                    ToolTip = 'Branding File';
                    ApplicationArea = All;
                }
                field(ConsumingItemNo; Rec."Consuming Item No.")
                {
                    ToolTip = 'Consuming Item No.';
                    ApplicationArea = All;
                }
                field(ConsumingItemDescription; Rec."Consuming Item Description")
                {
                    ToolTip = 'Consuming Item Description';
                    ApplicationArea = All;
                }
                field(ConsumingItemQty; Rec."Consuming Item Qty.")
                {
                    ToolTip = 'Consuming Item Qty.';
                    ApplicationArea = All;
                }
                field(ItemComponentCost; Rec."Item Component Cost")
                {
                    ToolTip = 'Item Component Cost';
                    ApplicationArea = All;
                }
                field(ConsumingComponentCost; Rec."Consuming Component Cost")
                {
                    ToolTip = 'Consuming Component Cost';
                    ApplicationArea = All;
                }
                field(RoutingCost; Rec."Routing Cost")
                {
                    ToolTip = 'Routing Cost';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

