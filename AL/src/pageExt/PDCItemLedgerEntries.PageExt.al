/// <summary>
/// PageExtension PDCItemLedgerEntries (ID 50007) extends Record Item Ledger Entries.
/// </summary>
pageextension 50007 PDCItemLedgerEntries extends "Item Ledger Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field(PDCProductCode; Rec."PDC Product Code")
            {
                ToolTip = 'ProductCode';
                ApplicationArea = All;
            }
        }
        addafter("Job Task No.")
        {
            field(PDCStaffID; Rec."PDC Staff ID")
            {
                ToolTip = 'Staff ID';
                ApplicationArea = All;
            }
            field(PDCWardrobeID; Rec."PDC Wardrobe ID")
            {
                ToolTip = 'Wardrobe ID';
                ApplicationArea = All;
            }
            field(PDCColourCode; Rec."PDC Colour Code")
            {
                ToolTip = 'Colour Code';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

