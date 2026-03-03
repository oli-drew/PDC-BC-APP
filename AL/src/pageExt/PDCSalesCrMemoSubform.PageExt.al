/// <summary>
/// OnNewRecord.
/// </summary>
/// <param name="BelowxRec">Boolean.</param>
pageextension 50020 PDCSalesCrMemoSubform extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("No.")
        {
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field(PDCWearerID; Rec."PDC Wearer ID")
            {
                ToolTip = 'Wearer ID';
                ApplicationArea = All;
            }
            field(PDCWearerName; Rec."PDC Wearer Name")
            {
                ToolTip = 'Wearer Name';
                ApplicationArea = All;
            }
            field(PDCCustomerReference; Rec."PDC Customer Reference")
            {
                ToolTip = 'Customer Reference';
                ApplicationArea = All;
            }
            field(PDCWebOrderNo; Rec."PDC Web Order No.")
            {
                ToolTip = 'Web Order No.';
                ApplicationArea = All;
            }
            field(PDCOrderedByID; Rec."PDC Ordered By ID")
            {
                ToolTip = 'Ordered By ID';
                ApplicationArea = All;
            }
            field(PDCOrderedByName; Rec."PDC Ordered By Name")
            {
                ToolTip = 'Ordered By Name';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;
    end;
}

