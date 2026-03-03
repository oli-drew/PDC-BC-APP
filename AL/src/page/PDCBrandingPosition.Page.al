/// <summary>
/// Page PDC Branding Position (ID 50075).
/// </summary>
page 50075 "PDC Branding Position"
{
    Caption = 'Branding Position';
    PageType = List;
    SourceTable = "PDC Branding Position";
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
                field(Detail; Rec.Detail)
                {
                    ToolTip = 'Detail';
                    ApplicationArea = All;
                }
                field(Operations; Rec.Operations)
                {
                    ToolTip = 'Operations';
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

