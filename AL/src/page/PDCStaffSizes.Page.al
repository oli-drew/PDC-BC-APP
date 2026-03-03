/// <summary>
/// Page PDC Staff Sizes (ID 50066).
/// </summary>
page 50066 "PDC Staff Sizes"
{
    Caption = 'Staff Sizes';
    Editable = false;
    PageType = List;
    SourceTable = "PDC Staff Size";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;
                }
                field(SizeScaleCode; Rec."Size Scale Code")
                {
                    ToolTip = 'Size Scale Code';
                    ApplicationArea = All;
                }
                field(Fit; Rec.Fit)
                {
                    ToolTip = 'Fit';
                    ApplicationArea = All;
                }
                field(Size; Rec.Size)
                {
                    ToolTip = 'Size';
                    ApplicationArea = All;
                }
                field(CreatedByItemNo; Rec."Created By Item No.")
                {
                    ToolTip = 'Created By Item No.';
                    ApplicationArea = All;
                }
                field(CreatedBy; Rec."Created By")
                {
                    ToolTip = 'Created By';
                    ApplicationArea = All;
                }
                field(CreatedAt; Rec."Created At")
                {
                    ToolTip = 'Created At';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

