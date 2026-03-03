/// <summary>
/// Page PDC Branding Type (ID 50074).
/// </summary>
page 50074 "PDC Branding Type"
{
    Caption = 'Branding Type';
    PageType = List;
    SourceTable = "PDC Branding Type";
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
                field(Routing; Rec.Routing)
                {
                    ToolTip = 'Routing';
                    ApplicationArea = All;
                }
                field(RoutingCost; Rec."Routing Cost")
                {
                    ToolTip = 'Routing Cost';
                    ApplicationArea = All;
                }
                field(Consuming; Rec.Consuming)
                {
                    ToolTip = 'Consuming';
                    ApplicationArea = All;
                }
                field(RunTimeMultiplier; Rec."Run Time Multiplier")
                {
                    ToolTip = 'Run Time Multiplier';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                }
                field(No; Rec."No.")
                {
                    ToolTip = 'No.';
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

