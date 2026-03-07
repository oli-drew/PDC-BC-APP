/// <summary>
/// Page PDC Trolley List (ID 50092).
/// </summary>
page 50092 "PDC Trolley List"
{
    ApplicationArea = All;
    Caption = 'PDC Trolley List';
    PageType = List;
    SourceTable = "PDC Trolley";
    UsageCategory = Lists;
    CardPageId = "PDC Trolley List";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique code for the trolley (e.g. A, B, C, D).';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'A description of the trolley.';
                }
                field("Default Slots"; Rec."Default Slots")
                {
                    ApplicationArea = All;
                    ToolTip = 'The default number of slot positions on this trolley.';
                }
                field("Max Slots"; Rec."Max Slots")
                {
                    ApplicationArea = All;
                    ToolTip = 'The maximum number of slot positions this trolley can hold.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'If enabled, this trolley cannot be assigned to inventory picks.';
                }
                field("Active Picks"; Rec."Active Picks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of inventory picks currently using this trolley.';
                    StyleExpr = AvailabilityStyle;
                }
                field("Slots In Use"; Rec."Slots In Use")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of trolley slots currently assigned to this trolley.';
                }
                field("Slots Complete"; Rec."Slots Complete")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of trolley slots with status Complete for this trolley.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowSlots)
            {
                ApplicationArea = All;
                Caption = 'Trolley Slots';
                ToolTip = 'View all trolley slots for this trolley.';
                Image = ItemLines;
                RunObject = page "PDC Trolley Slot List";
                RunPageLink = "Trolley Code" = field(Code);
            }
        }
        area(Promoted)
        {
            actionref(ShowSlotsRef; ShowSlots) { }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Active Picks", "Slots In Use", "Slots Complete");
        if Rec."Active Picks" > 0 then
            AvailabilityStyle := 'Attention'
        else
            AvailabilityStyle := 'Favorable';
    end;

    var
        AvailabilityStyle: Text;
}
