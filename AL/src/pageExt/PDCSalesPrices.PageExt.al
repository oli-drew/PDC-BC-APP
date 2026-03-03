/// <summary>
/// PageExtension PDCSalesPrices (ID 50076) extends page Sales Prices.
/// </summary>
pageextension 50076 PDCSalesPrices extends "Sales Prices"
{
    layout
    {
        addlast(Control1)
        {
            field("PDC Product Code"; Rec."PDC Product Code")
            {
                ToolTip = 'Product Code';
                ApplicationArea = All;
            }

            field("PDC Item Description"; Rec."PDC Item Description")
            {
                ToolTip = 'Item Description';
                ApplicationArea = All;
            }
            field("PDC Vendor No."; Rec."PDC Vendor No.")
            {
                ToolTip = 'Vendor No.';
                ApplicationArea = All;
            }
            field("PDC Vendor Item No."; Rec."PDC Vendor Item No.")
            {
                ToolTip = 'Vendor Item No.';
                ApplicationArea = All;
            }
            field("PDC Direct Unit Cost"; Rec."PDC Direct Unit Cost")
            {
                ToolTip = 'Direct Unit Cost';
                ApplicationArea = All;
            }
            field("PDC Direct Unit Cost Starting Date"; Rec."PDC Direct Unit CostStart.Date")
            {
                ToolTip = 'Direct Unit Cost Starting Date';
                ApplicationArea = All;
            }
            field(PDCGross; Rec."PDC Gross")
            {
                ToolTip = 'Gross';
                ApplicationArea = All;
            }
            field(PDCMargin; Rec.PDCMargin)
            {
                ToolTip = 'Margin';
                ApplicationArea = All;
            }
            field("PDC Item Blocked"; Rec."PDC Item Blocked")
            {
                ToolTip = 'Item Blocked';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(PDCCalcDirectCostMargin)
            {
                Caption = 'Calculate Direct Cost&Margin';
                ToolTip = 'Calculate Direct Cost&Margin';
                Image = Cost;
                ApplicationArea = All;
                RunObject = report "PDC SalesPriceUpdDirectCostMar";
            }
        }
    }
}
