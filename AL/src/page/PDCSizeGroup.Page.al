/// <summary>
/// Page PDC Size Group (ID 50048).
/// </summary>
page 50048 "PDC Size Group"
{
    Caption = 'Size Group';
    PageType = List;
    SourceTable = "PDC Size Group";
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
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
            }
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

