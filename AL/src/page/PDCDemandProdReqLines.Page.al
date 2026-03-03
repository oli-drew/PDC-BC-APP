/// <summary>
/// Page PDC Demand Prod. Req. Lines (ID 50058).
/// </summary>
page 50058 "PDC Demand Prod. Req. Lines"
{
    Caption = 'Demand Prod. Requisition Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "PDC Demand Item Req. Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field(RequesterID; Rec."Requester ID")
                {
                    ToolTip = 'Requester ID';
                    ApplicationArea = All;
                }
                field(LineNo; Rec."Line No.")
                {
                    ToolTip = 'Line No.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Quantity';
                    ApplicationArea = All;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Unit of Measure Code';
                    ApplicationArea = All;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ToolTip = 'Vendor No.';
                    ApplicationArea = All;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ToolTip = 'Order Date';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DueDate; Rec."Due Date")
                {
                    ToolTip = 'Due Date';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

