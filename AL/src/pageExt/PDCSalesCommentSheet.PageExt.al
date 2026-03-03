/// <summary>
/// PageExtension PDCSalesCommentSheet (ID 50018) extends Record Sales Comment Sheet.
/// </summary>
pageextension 50018 PDCSalesCommentSheet extends "Sales Comment Sheet"
{
    layout
    {
        addafter("Code")
        {
            field(PDCCommentType; Rec."PDC Comment Type")
            {
                ToolTip = 'Comment Type';
                ApplicationArea = All;
            }
        }
    }
}

