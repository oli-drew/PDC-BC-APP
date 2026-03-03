/// <summary>
/// Page PDC Size Scale List (ID 50042).
/// </summary>
page 50042 "PDC Size Scale List"
{
    Caption = 'Size Scale List';
    CardPageID = "PDC Size Scale Card";
    Editable = false;
    PageType = List;
    SourceTable = "PDC Size Scale Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field("Size Group"; Rec."Size Group")
                {
                    ToolTip = 'Size Group';
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
    }
}

