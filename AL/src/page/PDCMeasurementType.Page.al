/// <summary>
/// Page PDC Measurement Type (ID 50049).
/// </summary>
page 50049 "PDC Measurement Type"
{
    Caption = 'Measurement Type';
    PageType = List;
    SourceTable = "PDC Measurement Type";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                }
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
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Gender';
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

