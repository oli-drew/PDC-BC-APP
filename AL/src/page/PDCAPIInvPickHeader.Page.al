/// <summary>
/// Page PDCAPI - Inv Pick Header (ID 50119).
/// API page exposing Warehouse Activity Headers filtered to Inventory Picks.
/// </summary>
page 50119 "PDCAPI - Inv Pick Header"
{
    APIGroup = 'app1';
    APIPublisher = 'pdc';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'PDCAPI - Inv Pick Header';
    DelayedInsert = true;
    EntityName = 'inventoryPick';
    EntitySetName = 'inventoryPicks';
    PageType = API;
    SourceTable = "Warehouse Activity Header";
    SourceTableView = where(Type = const("Invt. Pick"));
    ODataKeyFields = SystemId;
    Extensible = false;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(sourceNo; Rec."Source No.")
                {
                    Caption = 'Source No.';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(assignedUserID; Rec."Assigned User ID")
                {
                    Caption = 'Assigned User ID';
                }
                field(pdcSalesDocCreatedAt; Rec."PDC Sales Doc. Created At")
                {
                    Caption = 'Sales Doc. Created At';
                }
                field(pdcShippingAgentCode; Rec."PDC Shipping Agent Code")
                {
                    Caption = 'Shipping Agent Code';
                }
                field(pdcShippingAgentServCode; Rec."PDC Shipping Agent Serv. Code")
                {
                    Caption = 'Shipping Agent Service Code';
                }
                field(pdcNumberOfPackages; Rec."PDC Number Of Packages")
                {
                    Caption = 'Number Of Packages';
                }
                field(pdcDateOfFirstPrinting; Rec."PDC Date of First Printing")
                {
                    Caption = 'Date of First Printing';
                }
                field(pdcTimeOfFirstPrinting; Rec."PDC Time of First Printing")
                {
                    Caption = 'Time of First Printing';
                }
                field(pdcShipToPostCode; Rec."PDC Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }
                field(pdcShipToCountryRegCode; Rec."PDC Ship-to Country/Reg. Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(pdcUrgent; Rec."PDC Urgent")
                {
                    Caption = 'Urgent';
                }
                field(pdcPackageType; Rec."PDC Package Type")
                {
                    Caption = 'Package Type';
                }
                field(pdcPickStatus; Rec."PDC Pick Status")
                {
                    Caption = 'Pick Status';
                }
                field(pdcTrolleyCode; Rec."PDC Trolley Code")
                {
                    Caption = 'Trolley Code';
                }
                field(pdcPickedBy; Rec."PDC Picked By")
                {
                    Caption = 'Picked By';
                }
                field(pdcPickStartedAt; Rec."PDC Pick Started At")
                {
                    Caption = 'Pick Started At';
                }
                field(pdcPickCompletedAt; Rec."PDC Pick Completed At")
                {
                    Caption = 'Pick Completed At';
                }
                field(pdcTotalQuantity; Rec."PDC Total Quantity")
                {
                    Caption = 'Total Quantity';
                }
                field(pdcUniqueWearers; Rec."PDC Unique Wearers")
                {
                    Caption = 'Unique Wearers';
                }
                field(pdcTotalLines; Rec."PDC Total Lines")
                {
                    Caption = 'Total Lines';
                }
                field(pdcTrolleyDefaultSlots; Rec."PDC Trolley Default Slots")
                {
                    Caption = 'Trolley Default Slots';
                }
                field(pdcTrolleyMaxSlots; Rec."PDC Trolley Max Slots")
                {
                    Caption = 'Trolley Max Slots';
                }
                part(inventoryPickLines; "PDCAPI - Inv Pick Line")
                {
                    Caption = 'Inventory Pick Lines';
                    EntityName = 'inventoryPickLine';
                    EntitySetName = 'inventoryPickLines';
                    SubPageLink = "No." = field("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
    begin
        if Rec."PDC Unique Wearers" = 0 then begin
            PDCPickStatusMgt.RecalcUniqueWearers(Rec."No.");
            Rec.Find();
        end;
    end;
}
