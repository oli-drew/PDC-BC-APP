/// <summary>
/// Page PDC Demand Plan Register (ID 50052).
/// </summary>
page 50052 "PDC Demand Plan Register"
{
    Caption = 'Demand Plan Register';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "PDC Demand Plan Register";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field(Year; Rec.Year)
                {
                    ToolTip = 'Year';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Month';
                    ApplicationArea = All;
                }
                field(LastYearStats; Rec.CalcLastYearStats(Rec."Product Code", Rec."Colour Code", Rec.Year, Rec.Month))
                {
                    ToolTip = 'LastYearStats';
                    ApplicationArea = All;
                    Caption = 'Last Year Stats';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupLastYearStats(Rec."Product Code", Rec."Colour Code", Rec.Year, Rec.Month);
                    end;
                }
                field(Demand; Rec.Demand)
                {
                    ToolTip = 'Demand';
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ToolTip = 'Notes';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

