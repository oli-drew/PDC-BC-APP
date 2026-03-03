/// <summary>
/// TableExtension PDCSalesCommentLine (ID 50011) extends Record Sales Comment Line.
/// </summary>
tableextension 50011 PDCSalesCommentLine extends "Sales Comment Line"
{
    fields
    {
        field(50000; "PDC Comment Type"; Option)
        {
            Caption = 'Comment Type';
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
    }
}

