pageextension 50085 "PDC Item Lookup" extends "Item Lookup"
{
    layout
    {
        addafter("No.")
        {
            field(PDCSource; Rec."PDC Source")
            {
                ToolTip = 'Source';
                ApplicationArea = All;
            }
            field(PDCProductCode; Rec."PDC Product Code")
            {
                ToolTip = 'Product Code';
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field(PDCStyle; Rec."PDC Style")
            {
                ToolTip = 'Style';
                ApplicationArea = All;
            }
            field(PDCColour; Rec."PDC Colour")
            {
                ToolTip = 'Colour';
                ApplicationArea = All;
            }
            field(PDCFit; Rec."PDC Fit")
            {
                ToolTip = 'Fit';
                ApplicationArea = All;
            }
            field(PDCSize; Rec."PDC Size")
            {
                ToolTip = 'Size';
                ApplicationArea = All;
            }
        }
    }
}
