/// <summary>
/// PageExtension PDCJobQueueEntryCard (ID 50053) extends page Job Queue Entry Card.
/// </summary>
pageextension 50053 PDCJobQueueEntryCard extends "Job Queue Entry Card"
{
    layout
    {
        addafter("Recurring Job")
        {
            field(PDCForceRunningInError; Rec."PDC Force Running In Error")
            {
                ToolTip = 'Force Running In Error';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(PDCRunManual)
            {
                Caption = 'Run manually';
                ToolTip = 'Run manually';
                ApplicationArea = All;
                Image = Start;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Object ID to Run");
                    case Rec."Object Type to Run" OF
                        Rec."Object Type to Run"::Report:
                            REPORT.RUN(Rec."Object ID to Run");
                        Rec."Object Type to Run"::Codeunit:
                            CODEUNIT.RUN(Rec."Object ID to Run", Rec);
                    end;
                end;
            }
        }
    }
}

