/// <summary>
/// PageExtension PDCSOProcessorActivities (ID 50031) extends page SO Processor Activities.
/// </summary>
pageextension 50031 PDCSOProcessorActivities extends "SO Processor Activities"
{
    layout
    {
        modify("Average Days Delayed")
        {
            Visible = false;
        }

        addfirst(Content)
        {
            cuegroup(PDCSalesOrdersRequestedDeliveryDate)
            {
                Caption = 'Sales Orders Requested Delivery Date';
                field(PDCToday; Rec."PDC SLA Today")
                {
                    ApplicationArea = All;
                    Caption = 'Today';
                    ToolTip = 'Today';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowSLAOrders(1); //08.11.2019 JEMEL J.Jemeljanovs #3127
                    end;
                }
                field(PDCMissedOpen; Rec."PDC SLA Missed Open")
                {
                    ApplicationArea = All;
                    Caption = 'Missed Open';
                    ToolTip = 'Missed Open';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowSLAOrders(3); //08.11.2019 JEMEL J.Jemeljanovs #3127
                    end;
                }
                field(PDCMissedReleased; Rec."PDC SLA Missed Released")
                {
                    ApplicationArea = All;
                    Caption = 'Missed Released';
                    ToolTip = 'Missed Released';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowSLAOrders(2); //08.11.2019 JEMEL J.Jemeljanovs #3127
                    end;
                }
                field(PDCTomorrow; Rec."PDC SLA Tomorrow")
                {
                    ApplicationArea = All;
                    Caption = 'Tomorrow';
                    ToolTip = 'Tomorrow';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowSLAOrders(4); //08.11.2019 JEMEL J.Jemeljanovs #3127
                    end;
                }
            }
        }
        addafter("Sales Orders - Open")
        {
            field(PDCSalesOrdersNotReady; Rec."PDC Sales Orders - Not Ready")
            {
                ApplicationArea = All;
                Caption = 'Sales Orders - Not Ready';
                ToolTip = 'Sales Orders - Not Ready';

                trigger OnDrillDown()
                begin
                    Rec.ShowSOReadyToReleasePick(2);
                end;
            }
            field(PDCSalesOrdersReadytoRelease; Rec."PDC Sales Orders-Ready to Rel.")
            {
                ApplicationArea = All;
                Caption = 'Sales Orders - Ready to Release';
                ToolTip = 'Sales Orders - Ready to Release';

                trigger OnDrillDown()
                begin
                    Rec.ShowSOReadyToReleasePick(0);
                end;
            }
        }
        addafter("Average Days Delayed")
        {
            field(PDCSalesOrdersReadytoPick; Rec."PDC Sales Orders-Ready to Pick")
            {
                ApplicationArea = All;
                Caption = 'Sales Orders - Ready to Pick';
                ToolTip = 'Sales Orders - Ready to Pick';

                trigger OnDrillDown()
                begin
                    Rec.ShowSOReadyToReleasePick(1);
                end;
            }
        }
        addafter("Sales Return Orders - Open")
        {
            field(PDCSalesReturnOrdersReleased; Rec."PDC Sales Return Orders-Releas")
            {
                ApplicationArea = All;
                Caption = 'Sales Return Orders - Released';
                ToolTip = 'Sales Return Orders - Released';
                DrillDownPageID = "Sales Return Order List";
            }
        }
        addafter(Returns)
        {
            cuegroup(PDCProdOrders)
            {
                Caption = 'Production';
                field("PDC Firm Pl.Prod.Ord.-NotReady"; Rec."PDC Firm Pl.Prod.Ord.-NotReady")
                {
                    ApplicationArea = All;
                    Caption = 'Firm Planned Production Orders - Not Ready';
                    ToolTip = 'Firm Planned Production Orders - Not Ready';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowFirmPlannedProdOrder(false);
                    end;
                }
            }
            cuegroup(PDCCustomers)
            {
                Caption = 'Customers';
                field(PDCCustomersBlocked; Rec."PDC Customers - Blocked")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Customer List";
                    Image = People;
                    Caption = 'Customers - Blocked';
                    ToolTip = 'Customers - Blocked';

                }
                field(PDCCustomersOverCreditLimit; Rec."PDC Customers-Over Cred. Limit")
                {
                    ApplicationArea = All;
                    Image = People;
                    Caption = 'Customers - Over Credit Limit';
                    ToolTip = 'Customers - Over Credit Limit';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowCustomers();
                    end;
                }
                field(PDCCustomersonStop; Rec."PDC Customers - On Stop")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Customer List";
                    Image = People;
                    Caption = 'Customers - On Stop';
                    ToolTip = 'Customers - On Stop';
                }
            }
            cuegroup(PDCDelivery)
            {
                Caption = 'Delivery';
                Visible = false;

                field(PDCParcelsDeliveredThisMonth; Rec."PDC Parcels Deliv. This Month")
                {
                    ApplicationArea = All;
                    Image = Time;
                    Caption = 'Parcels Delivered This Month';
                    ToolTip = 'Parcels Delivered This Month';
                }
                field(PDCParcelsDeliveredLastMonth; Rec."PDC Parcels Deliv. Last Month")
                {
                    ApplicationArea = All;
                    Image = Time;
                    Caption = 'Parcels Delivered Last Month';
                    ToolTip = 'Parcels Delivered Last Month';
                }
                field(PDCParcelsInTransit; Rec."PDC Parcels In Transit")
                {
                    ApplicationArea = All;
                    Image = Time;
                    Caption = 'Parcels In Transit';
                    ToolTip = 'Parcels In Transit';
                }
                field(PDCParcelsException; Rec."PDC Parcels Exception")
                {
                    ApplicationArea = All;
                    Image = Time;
                    Caption = 'Parcels Exception';
                    ToolTip = 'Parcels Exception';
                }
            }
        }
    }
    actions
    {
    }

    var
        tmpDate: Date;

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("PDC Date Filter3", CALCDATE('<-CM>', WORKDATE()), CALCDATE('<CM>', WORKDATE())); //current month
        tmpDate := CALCDATE('<-CM>', WORKDATE()) - 1;
        Rec.SETRANGE("PDC Date Filter4", CALCDATE('<-CM>', tmpDate), tmpDate); //last month
    end;

    trigger OnAfterGetCurrRecord()
    var
        TaskParameters: Dictionary of [Text, Text];
    begin
        if CalcTaskId <> 0 then
            if CurrPage.CancelBackgroundTask(CalcTaskId) then;
        CurrPage.EnqueueBackgroundTask(CalcTaskId, Codeunit::"PDC Sales Cue Background", TaskParameters, 120000, PageBackgroundTaskErrorLevel::Error);
    end;

    // trigger OnAfterGetRecord()
    // begin
    //     PDCCalculateCueFieldValues();
    // end;

    var
        CalcTaskId: Integer;

    // local procedure PDCCalculateCueFieldValues()
    // var
    //     Customer: Record Customer;
    // begin
    //     Rec."PDC Customers-Over Cred. Limit" := 0;
    //     Customer.RESET();
    //     if Customer.FINDSET() then
    //         repeat
    //             if Customer.CalcAvailableCredit() < 0 then
    //                 Rec."PDC Customers-Over Cred. Limit" += 1;
    //         until Customer.next() = 0;

    //     Rec."PDC Sales Orders-Ready to Rel." := Rec.CalcSOReadyToReleasePick(0);
    //     Rec."PDC Sales Orders-Ready to Pick" := Rec.CalcSOReadyToReleasePick(1);
    //     Rec."PDC Sales Orders - Not Ready" := Rec.CalcSOReadyToReleasePick(2);

    //     Rec."PDC SLA Today" := Rec.CalcSLA(1);
    //     Rec."PDC SLA Missed Released" := Rec.CalcSLA(2);
    //     Rec."PDC SLA Missed Open" := Rec.CalcSLA(3);
    //     Rec."PDC SLA Tomorrow" := Rec.CalcSLA(4);

    //     Rec."PDC Firm Pl.Prod.Ord.-NotReady" := Rec.CalcFirmPlannedProdOrder(false);
    // end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    begin
        if TaskId <> CalcTaskId then
            exit;

        Evaluate(Rec."PDC Customers-Over Cred. Limit", Results.get(Rec.fieldname("PDC Customers-Over Cred. Limit")));

        Evaluate(Rec."PDC Sales Orders-Ready to Rel.", Results.get(Rec.fieldname("PDC Sales Orders-Ready to Rel.")));
        Evaluate(Rec."PDC Sales Orders-Ready to Pick", Results.get(Rec.fieldname("PDC Sales Orders-Ready to Pick")));
        Evaluate(Rec."PDC Sales Orders - Not Ready", Results.get(Rec.fieldname("PDC Sales Orders - Not Ready")));

        Evaluate(Rec."PDC SLA Today", Results.get(Rec.fieldname("PDC SLA Today")));
        Evaluate(Rec."PDC SLA Missed Released", Results.get(Rec.fieldname("PDC SLA Missed Released")));
        Evaluate(Rec."PDC SLA Missed Open", Results.get(Rec.fieldname("PDC SLA Missed Open")));
        Evaluate(Rec."PDC SLA Tomorrow", Results.get(Rec.fieldname("PDC SLA Tomorrow")));

        Evaluate(Rec."PDC Firm Pl.Prod.Ord.-NotReady", Results.get(Rec.fieldname("PDC Firm Pl.Prod.Ord.-NotReady")));

    end;
}

