/// <summary>
/// Page PDC Item Category Lines (ID 50041).
/// </summary>
page 50041 "PDC Item Category Lines"
{
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "PDC Item Category Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ColourCode; Rec."Colour Code")
                {
                    ToolTip = 'Colour Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

