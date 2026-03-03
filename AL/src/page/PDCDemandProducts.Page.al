/// <summary>
/// OnAction.
/// </summary>
page 50051 "PDC Demand Products"
{
    Caption = 'Demand Products';
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Tasks,Reports,Plan';
    SourceTable = "PDC Demand Product";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field(ProductCode; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ColourCode; Rec."Colour Code")
                {
                    ToolTip = 'Colour Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ImportVendor; Rec."Import Vendor")
                {
                    ToolTip = 'Import Vendor';
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
            action(OpenDemandPlanRegister)
            {
                AccessByPermission = TableData "PDC Demand Plan Register" = R;
                ApplicationArea = All;
                Caption = 'Open &Demand Plan Register';
                ToolTip = 'Open Demand Plan Register';
                Ellipsis = true;
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+D';

                trigger OnAction()
                begin
                    Rec.OpenDemandPlanRegister();
                end;
            }
            action(AppendProduct)
            {
                ApplicationArea = All;
                Caption = 'Append Product';
                ToolTip = 'Append Product';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Item1: Record Item;
                    DemandProduct1: Record "PDC Demand Product";
                begin
                    Item1.SetFilter("PDC Product Code", '<>%1', '');
                    Item1.SetFilter("PDC Colour", '<>%1', '');
                    if Page.RunModal(0, Item1) = Action::LookupOK then begin
                        if not DemandProduct1.Get(Item1."PDC Product Code", Item1."PDC Colour") then begin
                            DemandProduct1.Init();
                            DemandProduct1.Validate("Product Code", Item1."PDC Product Code");
                            DemandProduct1.Validate("Colour Code", Item1."PDC Colour");
                            DemandProduct1.Insert(true);
                            Commit();
                        end;
                        Rec.Get(DemandProduct1."Product Code", DemandProduct1."Colour Code");
                    end;
                end;
            }
            group(Planning)
            {
                Caption = 'Planning';
                Image = Statistics;
                action(DemandInventory)
                {
                    ApplicationArea = All;
                    Caption = 'Demand Plan Inventory';
                    ToolTip = 'Demand Plan Inventory';
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Item1: Record Item;
                    begin
                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", Rec."Product Code");
                        Item1.SetRange("PDC Colour", Rec."Colour Code");
                        Page.Run(Page::"PDC Demand Plan Inventory", Item1);
                    end;
                }
                action(DemandInventoryWithPO)
                {
                    ApplicationArea = All;
                    Caption = 'Demand Plan Stock+PO-SO';
                    ToolTip = 'Demand Plan Stock+PO-SO';
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Item1: Record Item;
                    begin
                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", Rec."Product Code");
                        Item1.SetRange("PDC Colour", Rec."Colour Code");
                        Page.Run(Page::"PDC Demand Plan Stock+PO-SO", Item1);
                    end;
                }
                action(DemandMonthlyUsage)
                {
                    ApplicationArea = All;
                    Caption = 'Demand Plan Monthly Usage';
                    ToolTip = 'Demand Plan Monthly Usage';
                    Image = Archive;

                    trigger OnAction()
                    var
                        Item1: Record Item;
                    begin
                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", Rec."Product Code");
                        Item1.SetRange("PDC Colour", Rec."Colour Code");
                        Page.Run(Page::"PDC Demand Plan Monthly Usage", Item1);
                    end;
                }
                action(DemandMonthlyPO)
                {
                    ApplicationArea = All;
                    Caption = 'Demand Plan Purchase Orders';
                    ToolTip = 'Demand Plan Purchase Orders';
                    Image = Purchase;

                    trigger OnAction()
                    var
                        Item1: Record Item;
                    begin
                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", Rec."Product Code");
                        Item1.SetRange("PDC Colour", Rec."Colour Code");
                        Page.Run(Page::"PDC Demand Plan Purchase Order", Item1);
                    end;
                }
                action(DemandMonthlySO)
                {
                    ApplicationArea = All;
                    Caption = 'Demand Plan Sales Orders';
                    ToolTip = 'Demand Plan Sales Orders';
                    Image = Sales;

                    trigger OnAction()
                    var
                        Item1: Record Item;
                    begin
                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", Rec."Product Code");
                        Item1.SetRange("PDC Colour", Rec."Colour Code");
                        Page.Run(Page::"PDC Demand Plan Sales Orders", Item1);
                    end;
                }
            }
        }
    }
}

