/// <summary>
/// Page PDC Wardrobe Item Option List (ID 50036).
/// </summary>
page 50036 "PDC Wardrobe Item Option List"
{
    Caption = 'Wardrobe Item Option List';
    PageType = List;
    SourceTable = "PDC Wardrobe Item Option";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                    Editable = false;
                }
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
                }
            }
        }
    }

    actions
    {
    }
}

