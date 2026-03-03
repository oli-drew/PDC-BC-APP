/// <summary>
/// PageExtension PDCItemJournal (ID 50008) extends Record Item Journal.
/// </summary>
pageextension 50008 PDCItemJournal extends "Item Journal"
{
    layout
    {
        addafter("Reason Code")
        {
            field(PDCComment; Rec."PDC Comment")
            {
                ToolTip = 'Comment';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

