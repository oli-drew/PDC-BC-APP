/// <summary>
/// Page PDC Proposal FactBox (ID 50084).
/// </summary>
page 50084 "PDC Proposal FactBox"
{
    Caption = 'Proposal Totals';
    PageType = CardPart;
    SourceTable = "PDC Proposal Header";

    layout
    {
        area(content)
        {
            field("Total Sales"; Rec."Total Sales")
            {
                ApplicationArea = All;
                Caption = 'Total Sales';
                ToolTip = 'Total Sales';
                Editable = false;
            }
            field("Total Cost"; Rec."Total Cost")
            {
                ApplicationArea = All;
                Caption = 'Total Cost';
                ToolTip = 'Total Cost';
            }
            field("Gross Profit"; Rec."Gross Profit Total")
            {
                ApplicationArea = All;
                Caption = 'Gross Profit';
                ToolTip = 'Gross Profit';
            }
            field("Margin %"; Margin)
            {
                ApplicationArea = All;
                Caption = 'Margin %';
                ToolTip = 'Margin %';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Total Sales" <> 0 then
            Margin := ROUND(Rec."Gross Profit Total" / Rec."Total Sales" * 100, 0.001)
        else
            Margin := 0;
    end;

    var
        Margin: Decimal;
}

