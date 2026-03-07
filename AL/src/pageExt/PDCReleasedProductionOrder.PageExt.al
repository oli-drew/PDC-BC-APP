/// <summary>
/// PageExtension "PDC Released"ProductionOrder (ID 50039) extends Record Released Production Order.
/// </summary>
pageextension 50039 PDCReleasedProductionOrder extends "Released Production Order"
{
    layout
    {
        addlast(content)
        {
            group(PDCProduction)
            {
                Caption = 'PDC Production';

                field("PDC Production Bin"; Rec."PDC Production Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Bin';
                }
                field("PDC Production Bin Changed"; Rec."PDC Production Bin Changed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Bin Changed';
                    Editable = false;
                }
                field("PDC Issue"; Rec."PDC Issue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Issue';
                }
                field("PDC Urgent"; Rec."PDC Urgent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Urgent';
                }
                field("PDC Production Status"; Rec."PDC Production Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Status';
                }
                field("PDC Production Status Changed"; Rec."PDC Production Status Changed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Status Changed';
                    Editable = false;
                }
                field("PDC Priority"; Rec."PDC Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Priority';
                }
            }
        }
    }
    actions
    {
        addafter("Shortage List")
        {
            action("PDC Production Order Labels")
            {
                ApplicationArea = All;
                Caption = 'Production Order Labels';
                ToolTip = 'Production Order Labels';
                Image = PrintForm;

                trigger OnAction()
                var
                    ProdOrder1: Record "Production Order";
                begin
                    ProdOrder1.Get(Rec.Status, Rec."No.");
                    ProdOrder1.SetRecfilter();
                    Report.Run(Report::"PDC Production Order Labels", true, false, ProdOrder1);
                end;
            }

            action("PDC Production Order Pick Note")
            {
                ApplicationArea = All;
                Caption = 'Production Order Pick Note';
                ToolTip = 'Production Order Pick Note';
                Image = PrintCheck;

                trigger OnAction()
                var
                    ProdOrder1: Record "Production Order";
                begin
                    ProdOrder1.Get(Rec.Status, Rec."No.");
                    ProdOrder1.SetRecfilter();
                    Report.Run(Report::"PDC Prod. Order PickNote", true, false, ProdOrder1);
                end;
            }
        }
        addlast(Category_Print)
        {
            actionref("PDC Production Order Labels_Promoted"; "PDC Production Order Labels")
            {
            }
            actionref("PDC Production Order Pick Note_Promoted"; "PDC Production Order Pick Note")
            {
            }
        }
    }
}

