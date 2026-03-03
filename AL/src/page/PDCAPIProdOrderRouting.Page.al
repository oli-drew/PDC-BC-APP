/// <summary>
/// Page PDCAPI - Prod. Order Components (ID 50013).
/// </summary>
page 50013 "PDCAPI - Prod. Order Routing"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Prod. Order Routing';
    EntitySetCaption = 'Prod. Order Routings';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'prodOrderRouting';
    EntitySetName = 'prodOrderRoutings';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Prod. Order Routing Line";
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
                    Editable = false;
                }
                field(prodOrderNo; Rec."Prod. Order No.")
                {
                    Caption = 'Prod. Order No.';
                }
                field(scheduleManually; Rec."Schedule Manually")
                {
                    Caption = 'Schedule Manually';
                }
                field(operationNo; Rec."Operation No.")
                {
                    Caption = 'Operation No.';
                }
                field(previousOperationNo; Rec."Previous Operation No.")
                {
                    Caption = 'Previous Operation No.';
                }
                field(nextOperationNo; Rec."Next Operation No.")
                {
                    Caption = 'Next Operation No.';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(flushingMethod; Rec."Flushing Method")
                {
                    Caption = 'Flushing Method';
                }
                field(startingDateTime; Rec."Starting Date-Time")
                {
                    Caption = 'Starting Date-Time';
                }
                field(startingTime; StartingTime)
                {
                    Caption = 'Starting Time';
                }
                field(startingDate; StartingDate)
                {
                    Caption = 'Starting Date';
                }
                field(endingDateTime; Rec."Ending Date-Time")
                {
                    Caption = 'Ending Date-Time';
                }
                field(endingTime; EndingTime)
                {
                    Caption = 'Ending Time';
                }
                field(endingDate; EndingDate)
                {
                    Caption = 'Ending Date';
                }
                field(setupTime; Rec."Setup Time")
                {
                    Caption = 'Setup Time';
                }
                field("setupTimeUnitofMeasCode"; Rec."Setup Time Unit of Meas. Code")
                {
                    Caption = 'Setup Time Unit of Meas. Code';
                }
                field(runTime; Rec."Run Time")
                {
                    Caption = 'Run Time';
                }
                field(runTimeUnitofMeasCode; Rec."Run Time Unit of Meas. Code")
                {
                    Caption = 'Run Time Unit of Meas. Code';
                }
                field(waitTime; Rec."Wait Time")
                {
                    Caption = 'Wait Time';
                }
                field(waitTimeUnitofMeasCode; Rec."Wait Time Unit of Meas. Code")
                {
                    Caption = 'Wait Time Unit of Meas. Code';
                }
                field(moveTime; Rec."Move Time")
                {
                    Caption = 'Move Time';
                }
                field(moveTimeUnitofMeasCode; Rec."Move Time Unit of Meas. Code")
                {
                    Caption = 'Move Time Unit of Meas. Code';
                }
                field(fixedScrapQuantity; Rec."Fixed Scrap Quantity")
                {
                    Caption = 'Fixed Scrap Quantity';
                }
                field(routingLinkCode; Rec."Routing Link Code")
                {
                    Caption = 'Routing Link Code';
                }
                field(scrapFactor; Rec."Scrap Factor %")
                {
                    Caption = 'Scrap Factor %';
                }
                field(sendAheadQuantity; Rec."Send-Ahead Quantity")
                {
                    Caption = 'Send-Ahead Quantity';
                }
                field(concurrentCapacities; Rec."Concurrent Capacities")
                {
                    Caption = 'Concurrent Capacities';
                }
                field(unitCostper; Rec."Unit Cost per")
                {
                    Caption = 'Unit Cost per';
                }
                field(lotSize; Rec."Lot Size")
                {
                    Caption = 'Lot Size';
                }
                field(expectedOperationCostAmt; Rec."Expected Operation Cost Amt.")
                {
                    Caption = 'Expected Operation Cost Amt.';
                }
                field(expectedCapacityOvhdCost; Rec."Expected Capacity Ovhd. Cost")
                {
                    Caption = 'Expected Capacity Ovhd. Cost';
                }
                field(expectedCapacityNeed; Rec."Expected Capacity Need" / ExpCapacityNeed())
                {
                    Caption = 'Expected Capacity Need';
                    DecimalPlaces = 0 : 5;
                }
                field(routingStatus; Rec."Routing Status")
                {
                    Caption = 'Routing Status';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(openShopFloorBinCode; Rec."Open Shop Floor Bin Code")
                {
                    Caption = 'Open Shop Floor Bin Code';
                }
                field(toProductionBinCode; Rec."To-Production Bin Code")
                {
                    Caption = 'To-Production Bin Code';
                }
                field(fromProductionBinCode; Rec."From-Production Bin Code")
                {
                    Caption = 'From-Production Bin Code';
                }
                field(brandingNo; RoutingLines."PDC Branding No.")
                {
                    Caption = 'Branding No.';
                    Editable = false;
                }
                field(brandingFile; Branding."Branding File")
                {
                    ToolTip = 'Branding File';
                    Editable = false;
                }
                field(brandingPositionCode; Branding."Branding Position Code")
                {
                    ToolTip = 'Branding Position Code';
                    Editable = false;
                }
                field(brandingPositionDescription; BrandingPosition.Description)
                {
                    ToolTip = 'Branding Position Description';
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.GetStartingEndingDateAndTime(StartingTime, StartingDate, EndingTime, EndingDate);

        clear(RoutingLines);
        clear(Branding);
        clear(BrandingPosition);
        RoutingLines.SetLoadFields("PDC Branding No.", "PDC Branding File", "PDC Branding Position Code");
        RoutingLines.SetRange("Routing No.", Rec."Routing No.");
        RoutingLines.setrange("Operation No.", Rec."Operation No.");
        if RoutingLines.FindFirst() then
            if Branding.get(RoutingLines."PDC Branding No.") then
                if BrandingPosition.Get(Branding."Branding Position Code") then;
    end;

    var
        RoutingLines: record "Routing Line";
        Branding: record "PDC Branding";
        BrandingPosition: record "PDC Branding Position";
        StartingTime: Time;
        EndingTime: Time;
        StartingDate: Date;
        EndingDate: Date;

    local procedure ExpCapacityNeed(): Decimal
    var
        WorkCenter: Record "Work Center";
        ShopCalendarManagement: Codeunit "Shop Calendar Management";
    begin
        if Rec."Work Center No." = '' then
            exit(1);
        WorkCenter.Get(Rec."Work Center No.");
        exit(ShopCalendarManagement.TimeFactor(WorkCenter."Unit of Measure Code"));
    end;

}