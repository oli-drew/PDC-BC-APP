/// <summary>
/// Page PDC Size Scale Subform (ID 50044).
/// </summary>
page 50044 "PDC Size Scale Subform"
{
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "PDC Size Scale Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Size; Rec.Size)
                {
                    ToolTip = 'Size';
                    ApplicationArea = All;
                }
                field(SizeSequence; Rec."Size Sequence")
                {
                    ToolTip = 'Size Sequence';
                    ApplicationArea = All;
                }
                field(SizeDescription; Rec."Size Description")
                {
                    ToolTip = 'Size Description';
                    ApplicationArea = All;
                }
                field(SizeLabel; Rec."Size Label")
                {
                    ToolTip = 'Size Label';
                    ApplicationArea = All;
                }
                field(Fit; Rec.Fit)
                {
                    ToolTip = 'Fit';
                    ApplicationArea = All;
                }
                field(FitSequence; Rec."Fit Sequence")
                {
                    ToolTip = 'Fit Sequence';
                    ApplicationArea = All;
                }
                field(FitDescription; Rec."Fit Description")
                {
                    ToolTip = 'Fit Description';
                    ApplicationArea = All;
                }
                field(FitLabel; Rec."Fit Label")
                {
                    ToolTip = 'Fit Label';
                    ApplicationArea = All;
                }
                field(MeasureTypeSize; Rec."Measure Type Size")
                {
                    ToolTip = 'Measure Type Size';
                    ApplicationArea = All;
                }
                field(GarmentSize; Rec."Garment Size")
                {
                    ToolTip = 'Garment Size';
                    ApplicationArea = All;
                }
                field(SizeEase; Rec."Size Ease")
                {
                    ToolTip = 'Size Ease';
                    ApplicationArea = All;
                }
                field(GarmentFit; Rec."Garment Fit")
                {
                    ToolTip = 'Garment Fit';
                    ApplicationArea = All;
                }
                field(GarmentEase; Rec."Garment Ease")
                {
                    ToolTip = 'Garment Ease';
                    ApplicationArea = All;
                }
                field(MeasureTypeFit; Rec."Measure Type Fit")
                {
                    ToolTip = 'Measure Type Fit';
                    ApplicationArea = All;
                }
                field(ECM; Rec.ECM)
                {
                    ToolTip = 'ECM';
                    ApplicationArea = All;
                }
                field(EHM; Rec.EHM)
                {
                    ToolTip = 'EHM';
                    ApplicationArea = All;
                }
                field("Profile"; Rec.Profile)
                {
                    ToolTip = 'Profile';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

