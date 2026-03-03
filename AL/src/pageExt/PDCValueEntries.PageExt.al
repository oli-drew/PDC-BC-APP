/// <summary>
/// PageExtension PDCValueEntries (ID 50060) extends Record Value Entries.
/// </summary>
pageextension 50060 PDCValueEntries extends "Value Entries"
{
    layout
    {

        addafter("Item No.")
        {
            field(PDCProductCode; Rec."PDC Product Code")
            {
                ToolTip = 'Product Code';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

