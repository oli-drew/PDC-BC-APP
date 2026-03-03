/// <summary>
/// Page PDC Sales Price Generator (ID 50059).
/// </summary>
page 50059 "PDC Sales Price Generator"
{
    Caption = 'Sales Price Generator';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "PDC Sales Price Generator";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ToolTip = 'Variant Code';
                    ApplicationArea = All;
                }
                field(SalesType; Rec."Sales Type")
                {
                    ToolTip = 'Sales Type';
                    ApplicationArea = All;
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ToolTip = 'Sales Code';
                    ApplicationArea = All;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Unit of Measure Code';
                    ApplicationArea = All;
                }
                field(MinimumQuantity; Rec."Minimum Quantity")
                {
                    ToolTip = 'Minimum Quantity';
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ToolTip = 'Currency Code';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ToolTip = 'Unit Price';
                    ApplicationArea = All;
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ToolTip = 'Price Includes VAT';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ToolTip = 'Allow Invoice Disc.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ToolTip = 'Allow Line Disc.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ToolTip = 'VAT Bus. Posting Gr. (Price)';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ToolTip = 'Starting Date';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ToolTip = 'Ending Date';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SuggestItemonWksh)
                {
                    ApplicationArea = All;
                    Caption = 'Suggest &Item on Wksh.';
                    ToolTip = 'Suggest &Item on Wksh.';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"PDC Sugg. Items On Price Wksh.", true, true);
                    end;
                }
                action(InsertSalesPrices)
                {
                    ApplicationArea = All;
                    Caption = 'I&nsert Sales Prices';
                    ToolTip = 'Insert Sales Prices';
                    Ellipsis = true;
                    Image = Insert;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"PDC Implement Item Prices", true, true, Rec);
                    end;
                }
            }
        }
    }
}

