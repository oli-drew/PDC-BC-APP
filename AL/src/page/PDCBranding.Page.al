/// <summary>
/// Page PDC Branding (ID 50076).
/// </summary>
page 50076 "PDC Branding"
{
    Caption = 'Branding';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "PDC Branding";
    UsageCategory = Tasks;
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(BrandingTypeCode; Rec."Branding Type Code")
                {
                    ToolTip = 'Branding Type Code';
                    ApplicationArea = All;
                }
                field(BrandingTypeDescription; Rec."Branding Type Description")
                {
                    ToolTip = 'Branding Type Description';
                    ApplicationArea = All;
                }
                field(BrandingPositionCode; Rec."Branding Position Code")
                {
                    ToolTip = 'Branding Position Code';
                    ApplicationArea = All;
                }
                field(BrandingPositDescription; Rec."Branding Posit. Description")
                {
                    ToolTip = 'Branding Posit. Description';
                    ApplicationArea = All;
                }
                field(BrandingFile; Rec."Branding File")
                {
                    ToolTip = 'Branding File';
                    ApplicationArea = All;
                }
                field(BrandingDescription; Rec."Branding Description")
                {
                    ToolTip = 'Branding Description';
                    ApplicationArea = All;
                }
                field(Consuming; Rec.Consuming)
                {
                    ToolTip = 'Consuming';
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
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Sell-to Customer No.';
                    ApplicationArea = All;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Sell-to Customer Name';
                    ApplicationArea = All;
                }
                field(Routing; Rec.Routing)
                {
                    ToolTip = 'Routing';
                    ApplicationArea = All;
                }
                field(RoutingQty; Rec."Routing Qty.")
                {
                    ToolTip = 'Routing Qty.';
                    ApplicationArea = All;
                }
                field(RoutingCost; Rec."Routing Cost")
                {
                    ToolTip = 'Routing Cost';
                    ApplicationArea = All;
                }
                field(RoutingCalcCost; Rec."Routing Calc. Cost")
                {
                    ToolTip = 'Routing Calc. Cost';
                    ApplicationArea = All;
                }
                field(RoutingSetUpCost; Rec."Routing Set Up Cost")
                {
                    ToolTip = 'Routing Set Up Cost';
                    ApplicationArea = All;
                }
                field(RoutingCostFinal; Rec."Routing Cost Final")
                {
                    ToolTip = 'Routing Cost Final';
                    ApplicationArea = All;
                }
                field(RunTimeMultiplier; Rec."Run Time Multiplier")
                {
                    ToolTip = 'Run Time Multiplier';
                    ApplicationArea = All;
                }
                field(RoutingType; Rec."Routing Type")
                {
                    ToolTip = 'Routing Type';
                    ApplicationArea = All;
                }
                field(RoutingNo; Rec."Routing No.")
                {
                    ToolTip = 'Routing No.';
                    ApplicationArea = All;
                }
                field(RoutingRunTimeMins; Rec."Routing Run Time Mins")
                {
                    ToolTip = 'Routing Run Time Mins';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50045), "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(UpdateLine)
                {
                    ApplicationArea = All;
                    Caption = 'Update Cost';
                    ToolTip = 'Update Cost';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        UpdateLines();
                    end;
                }
            }
        }
    }

    local procedure UpdateLines()
    var
        Branding: Record "PDC Branding";
    begin
        CurrPage.SetSelectionFilter(Branding);
        Branding.CopyFilters(Rec);
        if Branding.FindSet(true) then
            repeat
                Branding.Update();
                Branding.Modify();
                Branding.UpdateCostOnLinkedRouting();
            until Branding.Next() = 0;
        CurrPage.Update(false);
    end;
}

