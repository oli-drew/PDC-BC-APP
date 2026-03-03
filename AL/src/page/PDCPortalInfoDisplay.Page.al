/// <summary>
/// Page PDC Portal Info Display (ID 50070) connnected vie webservice to PDC info screen
/// </summary>
page 50070 "PDC Portal Info Display"
{
    Caption = 'Portal Info Display';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Integer";
    SourceTableView = where(Number = const(1));
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(ParcelsThisMonth; ParcelsThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsThisMonth';
                    tooltip = 'ParcelsThisMonth';
                }
                field(BagsThisMonth; BagsThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'BagsThisMonth';
                    Tooltip = 'BagsThisMonth';
                }
                field(BoxesThisMonth; BoxesThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'BoxesThisMonth';
                    tooltip = 'BoxesThisMonth';
                }
                field(ParcelsToday; ParcelsToday)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsToday';
                    tooltip = 'ParcelsToday';
                }
                field(BagsToday; BagsToday)
                {
                    ApplicationArea = All;
                    Caption = 'BagsToday';
                    tooltip = 'BagsToday';
                }
                field(BoxesToday; BoxesToday)
                {
                    ApplicationArea = All;
                    Caption = 'BoxesToday';
                    tooltip = 'BoxesToday';
                }
                field(ParcelsYest; ParcelsYest)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsYest';
                    tooltip = 'ParcelsYest';
                }
                field(ParcelsThisWeek; ParcelsThisWeek)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsThisWeek';
                    tooltip = 'ParcelsThisWeek';
                }
                field(ParcelsTransit; ParcelsTransit)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsTransit';
                    tooltip = 'ParcelsTransit';
                }
                field(ParcelsException; ParcelsException)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsException';
                    tooltip = 'ParcelsException';
                }
                field(ParcelsReturned; ParcelsReturned)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsReturned';
                    tooltip = 'ParcelsReturned';
                }
                field(ParcelsPackedToday; ParcelsPackedToday)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsPackedToday';
                    tooltip = 'ParcelsPackedToday';
                }
                field(ParcelsPackedYest; ParcelsPackedYest)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsPackedYest';
                    tooltip = 'ParcelsPackedYest';
                }
                field(SalesOrdersToday; SalesOrdersToday)
                {
                    ApplicationArea = All;
                    Caption = 'SalesOrdersToday';
                    tooltip = 'SalesOrdersToday';
                }
                field(SalesOrdersYest; SalesOrdersYest)
                {
                    ApplicationArea = All;
                    Caption = 'SalesOrdersYest';
                    tooltip = 'SalesOrdersYest';
                }
                field(PickNotes; PickNotes)
                {
                    ApplicationArea = All;
                    Caption = 'PickNotes';
                    tooltip = 'PickNotes';
                }
                field(PickNotesQty; PickNotesQty)
                {
                    ApplicationArea = All;
                    Caption = 'PickNotesQty';
                    tooltip = 'PickNotesQty';
                }
                field(PickNotesAmt; PickNotesAmt)
                {
                    ApplicationArea = All;
                    Caption = 'PickNotesAmt';
                    tooltip = 'PickNotesAmt';
                }
                field(PickNotesAmtPreCutOff; PickNotesAmtPreCutOff)
                {
                    ApplicationArea = All;
                    Caption = 'PickNotesAmtPreCutOff';
                    tooltip = 'PickNotesAmtPreCutOff';
                }
                field(PickNotesPreCutOffPrint; PickNotesPreCutOffPrint)
                {
                    ApplicationArea = All;
                    Caption = 'PickNotesPreCutOffPrint';
                    tooltip = 'PickNotesPreCutOffPrint';
                }
                field(PickNotesQtyPreCutOffPrint; PickNotesQtyPreCutOffPrint)
                {
                    ApplicationArea = All;
                    Caption = 'PickNotesQtyPreCutOffPrint';
                    tooltip = 'PickNotesQtyPreCutOffPrint';
                }
                field(SLA_Today; SLA_Today)
                {
                    ApplicationArea = All;
                    Caption = 'SLA_Today';
                    tooltip = 'SLA_Today';
                }
                field(SLA_Yest; SLA_Yest)
                {
                    ApplicationArea = All;
                    Caption = 'SLA_Yest';
                    tooltip = 'SLA_Yest';
                }
                field(SLA_Missed; SLA_Missed)
                {
                    ApplicationArea = All;
                    Caption = 'SLA_Missed';
                    tooltip = 'SLA_Missed';
                }
                field(SLA_Tomor; SLA_Tomor)
                {
                    ApplicationArea = All;
                    Caption = 'SLA_Tomor';
                    tooltip = 'SLA_Tomor';
                }
                field(SLA_MissReleased; SLA_MissReleased)
                {
                    ApplicationArea = All;
                    Caption = 'SLA_MissReleased';
                    tooltip = 'SLA_MissReleased';
                }
                field(SLA_Met; SLA_Met)
                {
                    ApplicationArea = All;
                    Caption = 'SLA_Met';
                    tooltip = 'SLA_Met';
                }
                field(ItemsDespatchedToday; ItemsDespatchedToday)
                {
                    ApplicationArea = All;
                    Caption = 'ItemsDespatchedToday';
                    tooltip = 'ItemsDespatchedToday';
                }
                field(ItemsDespatchedYesterday; ItemsDespatchedYesterday)
                {
                    ApplicationArea = All;
                    Caption = 'ItemsDespatchedYesterday';
                    tooltip = 'ItemsDespatchedYesterday';
                }
                field(StaffPacksToday; StaffPacksToday)
                {
                    ApplicationArea = All;
                    Caption = 'StaffPacksToday';
                    tooltip = 'StaffPacksToday';
                }
                field(StaffPacksYest; StaffPacksYest)
                {
                    ApplicationArea = All;
                    Caption = 'StaffPacksYest';
                    tooltip = 'StaffPacksYest';
                }
                field(ShipmentsToday; ShipmentsToday)
                {
                    ApplicationArea = All;
                    Caption = 'ShipmentsToday';
                    tooltip = 'ShipmentsToday';
                }
                field(ShipmentsYest; ShipmentsYest)
                {
                    ApplicationArea = All;
                    Caption = 'ShipmentsYest';
                    tooltip = 'ShipmentsYest';
                }
                field(ShipmentsThisWeek; ShipmentsThisWeek)
                {
                    ApplicationArea = All;
                    Caption = 'ShipmentsThisWeek';
                    tooltip = 'ShipmentsThisWeek';
                }
                field(InvoicedToday; InvoicedToday)
                {
                    ApplicationArea = All;
                    Caption = 'InvoicedToday';
                    tooltip = 'InvoicedToday';
                }
                field(InvoicedYest; InvoicedYest)
                {
                    ApplicationArea = All;
                    Caption = 'InvoicedYest';
                    tooltip = 'InvoicedYest';
                }
                field(InvoicedThisWeek; InvoicedThisWeek)
                {
                    ApplicationArea = All;
                    Caption = 'InvoicedThisWeek';
                    tooltip = 'InvoicedThisWeek';
                }
                field(InvoicedThisMonth; InvoicedThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'InvoicedThisMonth';
                    tooltip = 'InvoicedThisMonth';
                }
                field(Auto_Pick; JobQueueEntry.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Auto_Pick';
                    tooltip = 'Auto_Pick';
                }
                field(ReturnsOpen; ReturnsOpen)
                {
                    ApplicationArea = All;
                    Caption = 'ReturnsOpen';
                    tooltip = 'ReturnsOpen';
                }
                field(ReturnsReleased; ReturnsReleased)
                {
                    ApplicationArea = All;
                    Caption = 'ReturnsReleased';
                    tooltip = 'ReturnsReleased';
                }
                field(OrderValueToday; OrderValue[1])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValueToday';
                    tooltip = 'OrderValueToday';
                }
                field(OrderValueYest; OrderValue[2])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValueYest';
                    tooltip = 'OrderValueYest';
                }
                field(IPKStaffPacks; IPKStaffPacks)
                {
                    ApplicationArea = All;
                    Caption = 'IPKStaffPacks';
                    tooltip = 'IPKStaffPacks';
                }
                field(IPKStaffPacksPreCutoff; IPKStaffPacksPreCutoff)
                {
                    ApplicationArea = All;
                    Caption = 'IPKStaffPacksPreCutoff';
                    tooltip = 'IPKStaffPacksPreCutoff';
                }
                field(OrderCutOffTime; SalesReceivablesSetup."PDC Order Cut Off Time")
                {
                    ApplicationArea = All;
                    Caption = 'OrderCutOffTime';
                    tooltip = 'OrderCutOffTime';
                }
                field(DespatchCutOffTime; SalesReceivablesSetup."PDC Despatch Cut Off Time")
                {
                    ApplicationArea = All;
                    Caption = 'DespatchCutOffTime';
                    tooltip = 'DespatchCutOffTime';
                }
                field(TotalDraftOrders; TotalDraftOrders)
                {
                    ApplicationArea = All;
                    Caption = 'TotalDraftOrders';
                    ToolTip = 'TotalDraftOrders';
                }
                field(TotalDraftOrdersToday; TotalDraftOrdersToday)
                {
                    ApplicationArea = All;
                    Caption = 'TotalDraftOrdersToday';
                    ToolTip = 'TotalDraftOrdersToday';
                }
                field(TotalDraftOrdersValue; TotalDraftOrdersValue)
                {
                    ApplicationArea = All;
                    Caption = 'TotalDraftOrdersValue';
                    ToolTip = 'TotalDraftOrdersValue';
                }
                field(TotalDraftOrdersValueToday; TotalDraftOrdersValueToday)
                {
                    ApplicationArea = All;
                    Caption = 'TotalDraftOrdersValueToday';
                    ToolTip = 'TotalDraftOrdersValueToday';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        LastDocNo: Code[20];
    begin
        //Statusfilter OptionMembers = New,"In transit",Delivered,Exception,Returned;


        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', WorkDate()), CalcDate('<CM>', WorkDate())); //current month
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsThisMonth += PDCPortalInfoParcels.CountParcel;

        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetFilter(Shipping_Agent_Service_Code, '11..18'); //Boxes
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', WorkDate()), CalcDate('<CM>', WorkDate())); //current month
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            BoxesThisMonth += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetFilter(Shipping_Agent_Service_Code, '32..38');  //Bags
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', WorkDate()), CalcDate('<CM>', WorkDate())); //current month
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            BagsThisMonth += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, WorkDate() - 1); //Yesterday
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsYest += PDCPortalInfoParcels.CountParcel;

        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, WorkDate()); //today
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsToday += PDCPortalInfoParcels.CountParcel;

        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetFilter(Shipping_Agent_Service_Code, '11..18'); //Boxes
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, WorkDate());
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            BoxesToday += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetFilter(Shipping_Agent_Service_Code, '32..38');  //Bags
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, WorkDate());
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            BagsToday += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 2); //Delivered
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CW>', WorkDate()), CalcDate('<CW>', WorkDate())); //current week
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsThisWeek += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 1); //"In transit"
        PDCPortalInfoParcels.SetFilter(ShipmentDateFilter, '<>%1', WorkDate());
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsTransit += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 3); //Exception
        PDCPortalInfoParcels.SetFilter(ShipmentDateFilter, '<>%1', WorkDate());
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsException += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, 4); //Returned
        PDCPortalInfoParcels.SetFilter(ShipmentDateFilter, '<>%1', WorkDate());
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsReturned += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(ShipmentDateFilter, WorkDate() - 1); //yesterday
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsPackedYest += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(ShipmentDateFilter, WorkDate()); //today
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsPackedToday += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        for i := 0 to 1 do begin //today and yesterday
            Clear(PDCPortalInfoSalesOrders);
            PDCPortalInfoSalesOrders.SetRange(OrderDateFilter, WorkDate() - i);
            PDCPortalInfoSalesOrders.Open();
            while PDCPortalInfoSalesOrders.Read() do
                case i of
                    0:
                        begin
                            if PDCPortalInfoSalesOrders.QuantityInvoicedBaseSum = 0 then
                                SalesOrdersToday += 1;
                            if PDCPortalInfoSalesOrders.AmountInclVATSum <> 0 then
                                OrderValue[1] += round(PDCPortalInfoSalesOrders.OutstandingAmountSum / PDCPortalInfoSalesOrders.AmountInclVATSum * PDCPortalInfoSalesOrders.AmountSum, 0.01);
                        end;
                    1:
                        begin
                            if PDCPortalInfoSalesOrders.QuantityInvoicedBaseSum = 0 then
                                SalesOrdersYest += 1;
                            if PDCPortalInfoSalesOrders.AmountInclVATSum <> 0 then
                                OrderValue[i + 1] += round(PDCPortalInfoSalesOrders.OutstandingAmountSum / PDCPortalInfoSalesOrders.AmountInclVATSum * PDCPortalInfoSalesOrders.AmountSum, 0.01);
                        end;
                end;
            PDCPortalInfoSalesOrders.Close();

            Clear(PDCPortalInfoPostedInvoice);
            PDCPortalInfoPostedInvoice.SetRange(OrderDateFilter, WorkDate() - i);
            PDCPortalInfoPostedInvoice.Open();
            while PDCPortalInfoPostedInvoice.Read() do
                case i of
                    0:
                        begin
                            if PDCPortalInfoPostedInvoice.Sum_Amount <> 0 then
                                SalesOrdersToday += 1;
                            OrderValue[1] += PDCPortalInfoPostedInvoice.Sum_Amount;
                        end;
                    1:
                        begin
                            if PDCPortalInfoPostedInvoice.Sum_Amount <> 0 then
                                SalesOrdersYest += 1;
                            OrderValue[i + 1] += PDCPortalInfoPostedInvoice.Sum_Amount;
                        end;
                end;
            PDCPortalInfoSalesOrders.Close();
        end;

        Clear(PDCPortalInfoPickNotes);
        PDCPortalInfoPickNotes.Open();
        while PDCPortalInfoPickNotes.Read() do begin
            PickNotes += 1;
            PickNotesQty += PDCPortalInfoPickNotes.QuantitySum;
            PickNotesAmt += PDCPortalInfoPickNotes.AmtSum;
        end;
        PDCPortalInfoPickNotes.Close();

        clear(PDCPortalInfoPickNoteWearers);
        PDCPortalInfoPickNoteWearers.Open();
        while PDCPortalInfoPickNoteWearers.Read() do
            IPKStaffPacks += 1;
        PDCPortalInfoPickNoteWearers.Close();

        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."PDC Despatch Cut Off Time" <> 000000T then begin
            Clear(PDCPortalInfoPickNotes);
            PDCPortalInfoPickNotes.SetFilter(DateOfFirstPrinting, '<%1', WorkDate());
            PDCPortalInfoPickNotes.Open();
            while PDCPortalInfoPickNotes.Read() do begin
                PickNotesPreCutOffPrint += 1;
                PickNotesQtyPreCutOffPrint += PDCPortalInfoPickNotes.QuantitySum;
                PickNotesAmtPreCutOff += PDCPortalInfoPickNotes.AmtSum;
            end;
            PDCPortalInfoPickNotes.Close();

            Clear(PDCPortalInfoPickNotes);
            PDCPortalInfoPickNotes.SetRange(DateOfFirstPrinting, WorkDate());
            PDCPortalInfoPickNotes.SetFilter(TimeOfFirstPrinting, '<%1|%2', SalesReceivablesSetup."PDC Despatch Cut Off Time", 000000T);
            PDCPortalInfoPickNotes.Open();
            while PDCPortalInfoPickNotes.Read() do begin
                PickNotesPreCutOffPrint += 1;
                PickNotesQtyPreCutOffPrint += PDCPortalInfoPickNotes.QuantitySum;
                PickNotesAmtPreCutOff += PDCPortalInfoPickNotes.AmtSum;
            end;
            PDCPortalInfoPickNotes.Close();

            clear(PDCPortalInfoPickNoteWearers);
            PDCPortalInfoPickNoteWearers.SetFilter(DateOfFirstPrinting, '<%1', WorkDate());
            PDCPortalInfoPickNoteWearers.Open();
            while PDCPortalInfoPickNoteWearers.Read() do
                IPKStaffPacksPreCutoff += 1;
            PDCPortalInfoPickNoteWearers.Close();

            clear(PDCPortalInfoPickNoteWearers);
            PDCPortalInfoPickNoteWearers.SetRange(DateOfFirstPrinting, WorkDate());
            PDCPortalInfoPickNoteWearers.SetFilter(TimeOfFirstPrinting, '<%1|%2', SalesReceivablesSetup."PDC Despatch Cut Off Time", 000000T);
            PDCPortalInfoPickNoteWearers.Open();
            while PDCPortalInfoPickNoteWearers.Read() do
                IPKStaffPacksPreCutoff += 1;
            PDCPortalInfoPickNoteWearers.Close();
        end;

        Clear(PDCPortalInfoSalesOrders);
        PDCPortalInfoSalesOrders.SetRange(RequestedDeliveryDateFilter, WorkDate());
        PDCPortalInfoSalesOrders.SetRange(StatusFilter, Enum::"Sales Document Status"::Open);
        PDCPortalInfoSalesOrders.Open();
        while PDCPortalInfoSalesOrders.Read() do
            SLA_Today += 1;
        PDCPortalInfoSalesOrders.Close();

        Clear(PDCPortalInfoSalesOrders);
        PDCPortalInfoSalesOrders.SetRange(RequestedDeliveryDateFilter, WorkDate() - 1);
        PDCPortalInfoSalesOrders.SetRange(StatusFilter, Enum::"Sales Document Status"::Open);
        PDCPortalInfoSalesOrders.Open();
        while PDCPortalInfoSalesOrders.Read() do
            SLA_Yest += 1;
        PDCPortalInfoSalesOrders.Close();

        Clear(PDCPortalInfoSalesOrders);
        PDCPortalInfoSalesOrders.SetFilter(RequestedDeliveryDateFilter, '<%1', WorkDate());
        PDCPortalInfoSalesOrders.SetRange(StatusFilter, Enum::"Sales Document Status"::Open);
        PDCPortalInfoSalesOrders.Open();
        while PDCPortalInfoSalesOrders.Read() do
            SLA_Missed += 1;
        PDCPortalInfoSalesOrders.Close();

        Clear(PDCPortalInfoSalesOrders);
        PDCPortalInfoSalesOrders.SetRange(RequestedDeliveryDateFilter, WorkDate() + 1);
        PDCPortalInfoSalesOrders.SetRange(StatusFilter, Enum::"Sales Document Status"::Open);
        PDCPortalInfoSalesOrders.Open();
        while PDCPortalInfoSalesOrders.Read() do
            SLA_Tomor += 1;
        PDCPortalInfoSalesOrders.Close();

        Clear(PDCPortalInfoSalesOrders);
        PDCPortalInfoSalesOrders.SetFilter(RequestedDeliveryDateFilter, '<%1', WorkDate());
        PDCPortalInfoSalesOrders.SetRange(StatusFilter, Enum::"Sales Document Status"::Released);
        PDCPortalInfoSalesOrders.Open();
        while PDCPortalInfoSalesOrders.Read() do
            SLA_MissReleased += 1;
        PDCPortalInfoSalesOrders.Close();

        clear(LastDocNo);
        Clear(PDCPortalInfoShipmByWearer);
        PDCPortalInfoShipmByWearer.SetRange(PostingDateFilter, WorkDate());
        PDCPortalInfoShipmByWearer.Open();
        while PDCPortalInfoShipmByWearer.Read() do begin
            ItemsDespatchedToday += PDCPortalInfoShipmByWearer.Sum_Quantity;
            if PDCPortalInfoShipmByWearer.Sum_Quantity <> 0 then begin
                StaffPacksToday += 1;
                if (LastDocNo = '') or (LastDocNo <> PDCPortalInfoShipmByWearer.DocumentNo) then begin
                    ShipmentsToday += 1;
                    LastDocNo := PDCPortalInfoShipmByWearer.DocumentNo;
                end;
            end;
        end;
        PDCPortalInfoShipmByWearer.Close();
        Clear(LastDocNo);

        Clear(PDCPortalInfoShipmByWearer);
        PDCPortalInfoShipmByWearer.SetRange(PostingDateFilter, WorkDate() - 1);
        PDCPortalInfoShipmByWearer.Open();
        while PDCPortalInfoShipmByWearer.Read() do begin
            ItemsDespatchedYesterday += PDCPortalInfoShipmByWearer.Sum_Quantity;
            if PDCPortalInfoShipmByWearer.Sum_Quantity <> 0 then begin
                StaffPacksYest += 1;
                if (LastDocNo = '') or (LastDocNo <> PDCPortalInfoShipmByWearer.DocumentNo) then begin
                    ShipmentsYest += 1;
                    LastDocNo := PDCPortalInfoShipmByWearer.DocumentNo;
                end;
            end;
        end;
        PDCPortalInfoShipmByWearer.Close();
        Clear(LastDocNo);

        Clear(PDCPortalInfoShipmByWearer);
        PDCPortalInfoShipmByWearer.SetRange(PostingDateFilter, CalcDate('<-CW>', WorkDate()), CalcDate('<CW>', WorkDate())); //current week
        PDCPortalInfoShipmByWearer.Open();
        while PDCPortalInfoShipmByWearer.Read() do
            if (LastDocNo = '') or (LastDocNo <> PDCPortalInfoShipmByWearer.DocumentNo) then
                if PDCPortalInfoShipmByWearer.Sum_Quantity <> 0 then begin
                    ShipmentsThisWeek += 1;
                    LastDocNo := PDCPortalInfoShipmByWearer.DocumentNo;
                end;
        PDCPortalInfoShipmByWearer.Close();
        Clear(LastDocNo);

        Clear(PDCPortalInfoPostedInvoice);
        PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, WorkDate()); //today
        PDCPortalInfoPostedInvoice.Open();
        while PDCPortalInfoPostedInvoice.Read() do
            InvoicedToday += PDCPortalInfoPostedInvoice.Sum_Amount;
        PDCPortalInfoPostedInvoice.Close();
        Clear(PDCPortalInfoPostedCrMemo);
        PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, WorkDate()); //today
        PDCPortalInfoPostedCrMemo.Open();
        while PDCPortalInfoPostedCrMemo.Read() do
            InvoicedToday -= PDCPortalInfoPostedCrMemo.Sum_Amount;
        PDCPortalInfoPostedCrMemo.Close();

        Clear(PDCPortalInfoPostedInvoice);
        PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, WorkDate() - 1); //yesterday
        PDCPortalInfoPostedInvoice.Open();
        while PDCPortalInfoPostedInvoice.Read() do
            InvoicedYest += PDCPortalInfoPostedInvoice.Sum_Amount;
        PDCPortalInfoPostedInvoice.Close();
        Clear(PDCPortalInfoPostedCrMemo);
        PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, WorkDate() - 1); //yesterday
        PDCPortalInfoPostedCrMemo.Open();
        while PDCPortalInfoPostedCrMemo.Read() do
            InvoicedYest -= PDCPortalInfoPostedCrMemo.Sum_Amount;
        PDCPortalInfoPostedCrMemo.Close();

        Clear(PDCPortalInfoPostedInvoice);
        PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, CalcDate('<-CW>', WorkDate()), CalcDate('<CW>', WorkDate())); //current week
        PDCPortalInfoPostedInvoice.Open();
        while PDCPortalInfoPostedInvoice.Read() do
            InvoicedThisWeek += PDCPortalInfoPostedInvoice.Sum_Amount;
        PDCPortalInfoPostedInvoice.Close();
        Clear(PDCPortalInfoPostedCrMemo);
        PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, CalcDate('<-CW>', WorkDate()), CalcDate('<CW>', WorkDate())); //current week
        PDCPortalInfoPostedCrMemo.Open();
        while PDCPortalInfoPostedCrMemo.Read() do
            InvoicedThisWeek -= PDCPortalInfoPostedCrMemo.Sum_Amount;
        PDCPortalInfoPostedCrMemo.Close();

        Clear(PDCPortalInfoPostedInvoice);
        PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, CalcDate('<-CM>', WorkDate()), CalcDate('<CM>', WorkDate())); //current month
        PDCPortalInfoPostedInvoice.Open();
        while PDCPortalInfoPostedInvoice.Read() do
            InvoicedThisMonth += PDCPortalInfoPostedInvoice.Sum_Amount;
        PDCPortalInfoPostedInvoice.Close();
        Clear(PDCPortalInfoPostedCrMemo);
        PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, CalcDate('<-CM>', WorkDate()), CalcDate('<CM>', WorkDate())); //current month
        PDCPortalInfoPostedCrMemo.Open();
        while PDCPortalInfoPostedCrMemo.Read() do
            InvoicedThisMonth -= PDCPortalInfoPostedCrMemo.Sum_Amount;
        PDCPortalInfoPostedCrMemo.Close();

        Clear(JobQueueEntry);
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."object type to run"::Report);
        JobQueueEntry.SetRange("Object ID to Run", Report::"PDC Sales Orders Release/Pick");
        if JobQueueEntry.FindFirst() then;

        SalesHeader.SetRange("Document Type", SalesHeader."document type"::"Return Order");
        SalesHeader.SetRange("PDC Return Submitted", true);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        ReturnsOpen := SalesHeader.Count;
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        ReturnsReleased := SalesHeader.Count;

        Clear(PDCDraftOrderHeader);
        TotalDraftOrders := PDCDraftOrderHeader.Count();
        TotalDraftOrdersValue := 0;
        TotalDraftOrdersToday := 0;
        TotalDraftOrdersValueToday := 0;

        if PDCDraftOrderHeader.FindSet() then
            repeat
                TotalDraftOrdersValue += PDCPortalMgt.GetDraftOrderTotal(PDCDraftOrderHeader);
                if DT2Date(PDCDraftOrderHeader."Created Date") = Today() then begin
                    TotalDraftOrdersToday += 1;
                    TotalDraftOrdersValueToday += PDCPortalMgt.GetDraftOrderTotal(PDCDraftOrderHeader);
                end;
            until PDCDraftOrderHeader.Next() = 0;

    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        JobQueueEntry: Record "Job Queue Entry";
        SalesHeader: Record "Sales Header";
        PDCDraftOrderHeader: Record "PDC Draft Order Header";
        PDCPortalMgt: Codeunit "PDC Portal Mgt";
        PDCPortalInfoParcels: Query "PDC Portal Info Parcels";
        PDCPortalInfoSalesOrders: Query "PDC Portal Info SalesOrders";
        PDCPortalInfoPickNotes: Query "PDC Portal Info PickNotes";
        PDCPortalInfoPickNoteWearers: Query "PDC PortalInfo PickNoteWearers";
        PDCPortalInfoShipmByWearer: Query "PDC PortalInfo Shipm. ByWearer";
        PDCPortalInfoPostedInvoice: Query "PDC Portal Info Posted Invoice";
        PDCPortalInfoPostedCrMemo: Query "PDC Portal Info Posted Cr.Memo";
        i: Integer;
        ParcelsThisMonth: Integer;
        ParcelsYest: Integer;
        ParcelsToday: Integer;
        ParcelsThisWeek: Integer;
        ParcelsTransit: Integer;
        ParcelsException: Integer;
        ParcelsReturned: Integer;
        ParcelsPackedToday: Integer;
        ParcelsPackedYest: Integer;
        BagsThisMonth: Integer;
        BagsToday: Integer;
        BoxesThisMonth: Integer;
        BoxesToday: Integer;
        SalesOrdersToday: Integer;
        SalesOrdersYest: Integer;
        PickNotes: Integer;
        PickNotesQty: Decimal;
        PickNotesAmt: Decimal;
        PickNotesAmtPreCutOff: Decimal;
        PickNotesPreCutOffPrint: Integer;
        PickNotesQtyPreCutOffPrint: Decimal;
        SLA_Today: Integer;
        SLA_Yest: Integer;
        SLA_Missed: Integer;
        SLA_Tomor: Integer;
        SLA_MissReleased: Integer;
        SLA_Met: Integer;
        ItemsDespatchedToday: Decimal;
        ItemsDespatchedYesterday: Decimal;
        StaffPacksToday: Integer;
        StaffPacksYest: Integer;
        ShipmentsToday: Integer;
        ShipmentsYest: Integer;
        ShipmentsThisWeek: Integer;
        InvoicedToday: Decimal;
        InvoicedYest: Decimal;
        InvoicedThisWeek: Decimal;
        InvoicedThisMonth: Decimal;
        ReturnsOpen: Integer;
        ReturnsReleased: Integer;
        OrderValue: array[30] of Decimal;
        IPKStaffPacks: Integer;
        IPKStaffPacksPreCutoff: Integer;
        TotalDraftOrders: Integer;
        TotalDraftOrdersToday: Integer;
        TotalDraftOrdersValue: Decimal;
        TotalDraftOrdersValueToday: Decimal;
}

