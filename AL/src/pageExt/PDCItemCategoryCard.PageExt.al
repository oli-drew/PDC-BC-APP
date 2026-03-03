/// <summary>
/// PageExtension PDCItemCategoryCard (ID 50042) extends Record Item Category Card.
/// </summary>
pageextension 50042 PDCItemCategoryCard extends "Item Category Card"
{
    layout
    {
        addafter(Attributes)
        {
            part(PDCLines; "PDC Item Category Lines")
            {
                SubPageLink = "Item Category Code" = field("Code");
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

