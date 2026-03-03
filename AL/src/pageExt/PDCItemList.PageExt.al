/// <summary>
/// PageExtension PDCItemList (ID 50006) extends Record Item List.
/// </summary>
pageextension 50006 PDCItemList extends "Item List"
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
        addafter("Unit Cost")
        {
            field(PDCZeroPriceBlock; Rec."PDC Zero Price Block")
            {
                ToolTip = 'Zero Price Block';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Identifiers)
        {
            action("PDC Demand Product")
            {
                ApplicationArea = All;
                Caption = 'Demand Product';
                ToolTip = 'Demand Product';
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.OpenDemandProduct();
                end;
            }
        }
    }
}

