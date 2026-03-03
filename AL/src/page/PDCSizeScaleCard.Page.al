/// <summary>
/// Page PDC Size Scale Card (ID 50043).
/// </summary>
page 50043 "PDC Size Scale Card"
{
    Caption = 'Size Scale Card';
    PageType = Card;
    SourceTable = "PDC Size Scale Header";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                    Importance = Promoted;
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
            part(Lines; "PDC Size Scale Subform")
            {
                SubPageLink = "Size Scale Code" = field(Code);
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

