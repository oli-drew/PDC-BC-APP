/// <summary>
/// Page PDCAPI - Trolley (ID 50118).
/// API page exposing PDC Trolley master data.
/// </summary>
page 50118 "PDCAPI - Trolley"
{
    APIGroup = 'app1';
    APIPublisher = 'pdc';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'PDCAPI - Trolley';
    DelayedInsert = true;
    EntityName = 'trolley';
    EntitySetName = 'trolleys';
    PageType = API;
    SourceTable = "PDC Trolley";
    ODataKeyFields = SystemId;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(defaultSlots; Rec."Default Slots")
                {
                    Caption = 'Default Slots';
                }
                field(maxSlots; Rec."Max Slots")
                {
                    Caption = 'Max Slots';
                }
                field(activePicks; Rec."Active Picks")
                {
                    Caption = 'Active Picks';
                }
                field(slotsInUse; Rec."Slots In Use")
                {
                    Caption = 'Slots In Use';
                }
                field(slotsComplete; Rec."Slots Complete")
                {
                    Caption = 'Slots Complete';
                }
            }
        }
    }
}
