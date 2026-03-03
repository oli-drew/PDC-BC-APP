/// <summary>
/// PageExtension PDCSegment (ID 50056) extends Record Segment.
/// </summary>
pageextension 50056 PDCSegment extends Segment
{
    layout
    {
    }
    actions
    {
        addafter("Print &Labels")
        {
            action(PDCPrintLabelsDN)
            {
                ApplicationArea = All;
                Caption = 'Print Labels DN';
                ToolTip = 'Print Labels DN';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SegmentHeader: Record "Segment Header";
                begin
                    SegmentHeader := Rec;
                    SegmentHeader.SetRecfilter();
                    Report.Run(Report::"PDC Segment - Labels DN", true, false, SegmentHeader);
                end;
            }
        }
    }
}

