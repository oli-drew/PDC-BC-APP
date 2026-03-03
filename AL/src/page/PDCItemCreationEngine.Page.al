/// <summary>
/// Page PDC Item Creation Engine (ID 50045).
/// </summary>
page 50045 "PDC Item Creation Engine"
{
    Caption = 'Item Creation Engine';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "PDC Item Creation Engine";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(CurrBatchName; CurrBatchName)
            {
                ApplicationArea = All;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the ABC Worksheet.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    Commit();
                    if PAGE.RunModal(0, BatchName) = ACTION::LookupOK then begin
                        CurrBatchName := BatchName.Name;
                        CurrBatchType := BatchName.Type;
                        Rec.FilterGroup := 2;
                        Rec.SetRange("Journal Batch Name", CurrBatchName);
                        Rec.FilterGroup := 0;
                        if Rec.Find('-') then;
                    end;
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CurrBatchNameOnAfterValidate();
                end;
            }
            repeater(RepeaterControl)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ToolTip = 'Item Description';
                    ApplicationArea = All;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ToolTip = 'Unit Cost';
                    ApplicationArea = All;
                    StyleExpr = UnitCostLineStyle;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ToolTip = 'Unit Price';
                    ApplicationArea = All;
                    StyleExpr = UnitPriceLineStyle;
                }
                field(Margin; Rec.Margin())
                {
                    Caption = 'Margin';
                    ToolTip = 'Margin';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ToolTip = 'Lead Time Calculation';
                    ApplicationArea = All;
                }
                field("Contract Item"; Rec."Contract Item")
                {
                    ToolTip = 'Contract Item';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Normal;
                }
                field(ReturnPeriod; Rec."Return Period")
                {
                    ToolTip = 'Return Period';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Normal;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ToolTip = 'Vendor No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Normal;
                }
                field(VendorItemNo; Rec."Vendor Item No.")
                {
                    ToolTip = 'Vendor Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Normal;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Normal;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Gender';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Normal;
                }
                field(ConfigTemplateCode; Rec."Config. Template Code")
                {
                    ToolTip = 'Config. Template Code';
                    ApplicationArea = All;
                }
                field(RoutingNo; Rec."Routing No.")
                {
                    ToolTip = 'Routing No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingGarmetItemNo; Rec."Consuming Garmet Item No.")
                {
                    ToolTip = 'Consuming Garmet Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingBrand1ItemNo; Rec."Consuming Brand 1 Item No.")
                {
                    ToolTip = 'Consuming Brand 1 Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingBrand2ItemNo; Rec."Consuming Brand 2 Item No.")
                {
                    ToolTip = 'Consuming Brand 2 Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingBrand3ItemNo; Rec."Consuming Brand 3 Item No.")
                {
                    ToolTip = 'Consuming Brand 3 Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingBrand4ItemNo; Rec."Consuming Brand 4 Item No.")
                {
                    ToolTip = 'Consuming Brand 4 Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingBrand5ItemNo; Rec."Consuming Brand 5 Item No.")
                {
                    ToolTip = 'Consuming Brand 5 Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(ConsumingBrand6ItemNo; Rec."Consuming Brand 6 Item No.")
                {
                    ToolTip = 'Consuming Brand 5 Item No.';
                    ApplicationArea = All;
                    Visible = CurrBatchType = CurrBatchType::Production;
                }
                field(Include; Rec.Include)
                {
                    ToolTip = 'Include';
                    ApplicationArea = All;
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
                    var
                        SuggestItem: report "PDC Suggest Items on Wksh.";
                        SuggestProdItem: Report "PDC Suggest Prod. Items Wksh.";
                    begin
                        case CurrBatchType of
                            CurrBatchType::Normal:
                                begin
                                    SuggestItem.Initialize(Rec."Journal Batch Name");
                                    SuggestItem.Run();
                                end;
                            CurrBatchType::Production:
                                begin
                                    SuggestProdItem.Initialize(Rec."Journal Batch Name");
                                    SuggestProdItem.Run();
                                end;
                        end;
                    end;
                }
                action(InsertItems)
                {
                    ApplicationArea = All;
                    Caption = 'I&nsert Items';
                    ToolTip = 'Insert Items';
                    Ellipsis = true;
                    Image = Insert;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        ImplementItems: report "PDC Implement Items";
                    begin
                        ImplementItems.Initialize(Rec."Journal Batch Name");
                        ImplementItems.RunModal();
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BatchName.Get(Rec."Journal Batch Name");
        CurrBatchType := BatchName.Type;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Unit Price" = 0 then
            UnitPriceLineStyle := 'Attention'
        else
            UnitPriceLineStyle := 'Standard';
        if Rec."Unit Cost" = 0 then
            UnitCostLineStyle := 'Attention'
        else
            UnitCostLineStyle := 'Standard';
    end;

    trigger OnOpenPage()
    begin
        if Rec."Journal Batch Name" <> '' then // called from batch
            CurrBatchName := Rec."Journal Batch Name";

        if not BatchName.Get(CurrBatchName) then
            if not BatchName.FindFirst() then begin
                BatchName.Name := DefaultNameTxt;
                BatchName.Description := DefaultNameTxt;
                BatchName.Insert();
            end;
        CurrBatchName := BatchName.Name;
        CurrBatchType := BatchName.Type;

        Rec.FilterGroup := 2;
        Rec.SetRange("Journal Batch Name", CurrBatchName);
        Rec.FilterGroup := 0;
    end;

    var
        BatchName: Record "PDC Item Creation Batch";
        CurrBatchName: Code[10];
        CurrBatchType: Enum "PDC Item Create Type";
        DefaultNameTxt: Label 'Default';
        UnitPriceLineStyle: Text;
        UnitCostLineStyle: Text;

    local procedure CurrBatchNameOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        Commit();

        BatchName.Get(CurrBatchName);
        CurrBatchType := BatchName.Type;

        Rec.FilterGroup := 2;
        Rec.SetRange("Journal Batch Name", CurrBatchName);
        Rec.FilterGroup := 0;
        if Rec.Find('-') then;
        CurrPage.Update(false);
    end;
}

