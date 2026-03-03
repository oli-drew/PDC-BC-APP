/// <summary>
/// Page PDC Roll-Out List (ID 50022).
/// </summary>
page 50022 "PDC Roll-Out List"
{
    Caption = 'Roll-Out List';
    PageType = List;
    SourceTable = "PDC Roll-out";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                }
                field("Deadline Date"; Rec."Deadline Date")
                {
                    ToolTip = 'Deadline Date';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Blocked';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

