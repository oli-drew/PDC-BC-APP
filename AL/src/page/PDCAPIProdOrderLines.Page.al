/// <summary>
/// Page PDCAPI - Prod. Order Lines (ID 50006).
/// </summary>
page 50006 "PDCAPI - Prod. Order Lines"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Production Order Line';
    EntitySetCaption = 'Production Order Lines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'prodOrderLine';
    EntitySetName = 'prodOrderLines';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Prod. Order Line";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(prodOrderStatus; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(prodOrderNo; Rec."Prod. Order No.")
                {
                    Caption = 'Prod. Order No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(planningFlexibility; Rec."Planning Flexibility")
                {
                    Caption = 'Planning Flexibility';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(productionBOMNo; Rec."Production BOM No.")
                {
                    Caption = 'Production BOM No.';
                }
                field(routingNo; Rec."Routing No.")
                {
                    Caption = 'Routing No.';
                }
                field(routingVersionCode; Rec."Routing Version Code")
                {
                    Caption = 'Routing Version Code';
                }
                field(productionBOMVersionCode; Rec."Production BOM Version Code")
                {
                    Caption = 'Production BOM Version Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(startingDateTime; Rec."Starting Date-Time")
                {
                    Caption = 'Starting Date-Time';
                }
                field(startingTime; StartingTime)
                {
                    Caption = 'StartingTime';
                }
                field(startingDate; StartingDate)
                {
                    Caption = 'StartingDate';
                }
                field(endingDateTime; Rec."Ending Date-Time")
                {
                    Caption = 'Ending Date-Time';
                }
                field(endingTime; EndingTime)
                {
                    Caption = 'EndingTime';
                }
                field(endingDate; EndingDate)
                {
                    Caption = 'EndingDate';
                }
                field(scrap; Rec."Scrap %")
                {
                    Caption = 'Scrap %';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(reservedQuantity; Rec."Reserved Quantity")
                {
                    Caption = 'Reserved Quantity';
                }
                field(unitofMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(finishedQuantity; Rec."Finished Quantity")
                {
                    Caption = 'Finished Quantity';
                }
                field(remainingQuantity; Rec."Remaining Quantity")
                {
                    Caption = 'Remaining Quantity';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(costAmount; Rec."Cost Amount")
                {
                    Caption = 'Cost Amount';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field(shortcutDimCode3; ShortcutDimCode[3])
                {
                    Caption = 'ShortcutDimCode3';
                }
                field(shortcutDimCode4; ShortcutDimCode[4])
                {
                    Caption = 'ShortcutDimCode4';
                }
                field(shortcutDimCode5; ShortcutDimCode[5])
                {
                    Caption = 'ShortcutDimCode5';
                }
                field(shortcutDimCode6; ShortcutDimCode[6])
                {
                    Caption = 'ShortcutDimCode6';
                }
                field(shortcutDimCode7; ShortcutDimCode[7])
                {
                    Caption = 'ShortcutDimCode7';
                }
                field(shortcutDimCode8; ShortcutDimCode[8])
                {
                    Caption = 'ShortcutDimCode8';
                }
            }

        }

    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        GetStartingEndingDateAndTime(StartingTime, StartingDate, EndingTime, EndingDate);
    end;

    var
        StartingTime: Time;
        EndingTime: Time;
        StartingDate: Date;
        EndingDate: Date;

    protected var
        ShortcutDimCode: array[8] of Code[20];

    local procedure GetStartingEndingDateAndTime(var StartingTime1: Time; var StartingDate1: Date; var EndingTime1: Time; var EndingDate1: Date)
    begin
        StartingTime1 := DT2Time(Rec."Starting Date-Time");
        StartingDate1 := DT2Date(Rec."Starting Date-Time");
        EndingTime1 := DT2Time(Rec."Ending Date-Time");
        EndingDate1 := DT2Date(Rec."Ending Date-Time");
    end;

}