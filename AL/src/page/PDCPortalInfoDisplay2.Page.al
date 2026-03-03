/// <summary>
/// Page PDC Portal Info Display2 (ID 50071) connnected vie webservice to PDC info screen
/// </summary>
page 50071 "PDC Portal Info Display2"
{
    Caption = 'Portal Info Display2';
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

                field(ParcelsLastMonth; ParcelsLastMonth)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsLastMonth';
                    tooltip = 'ParcelsLastMonth';
                }
                field(BagsLastMonth; BagsLastMonth)
                {
                    ApplicationArea = All;
                    Caption = 'BagsLastMonth';
                    tooltip = 'BagsLastMonth';
                }
                field(BoxesLastMonth; BoxesLastMonth)
                {
                    ApplicationArea = All;
                    Caption = 'BoxesLastMonth';
                    tooltip = 'BoxesLastMonth';
                }
                field(ParcelsLastWeek; ParcelsLastWeek)
                {
                    ApplicationArea = All;
                    Caption = 'ParcelsLastWeek';
                    tooltip = 'ParcelsLastWeek';
                }
                field(Parcels2Month; Parcels2Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels2Month';
                    tooltip = 'Parcels2Month';
                }
                field(Parcels3Month; Parcels3Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels3Month';
                    tooltip = 'Parcels3Month';
                }
                field(Parcels4Month; Parcels4Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels4Month';
                    tooltip = 'Parcels4Month';
                }
                field(Parcels5Month; Parcels5Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels5Month';
                    tooltip = 'Parcels5Month';
                }
                field(Parcels6Month; Parcels6Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels6Month';
                    tooltip = 'Parcels6Month';
                }
                field(Parcels7Month; Parcels7Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels7Month';
                    tooltip = 'Parcels7Month';
                }
                field(Parcels8Month; Parcels8Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels8Month';
                    tooltip = 'Parcels8Month';
                }
                field(Parcels9Month; Parcels9Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels9Month';
                    tooltip = 'Parcels9Month';
                }
                field(Parcels10Month; Parcels10Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels10Month';
                    tooltip = 'Parcels10Month';
                }
                field(Parcels11Month; Parcels11Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels11Month';
                    tooltip = 'Parcels11Month';
                }
                field(Parcels12Month; Parcels12Month)
                {
                    ApplicationArea = All;
                    Caption = 'Parcels12Month';
                    tooltip = 'Parcels12Month';
                }
                field(ShipmentsLastWeek; ShipmentsLastWeek)
                {
                    ApplicationArea = All;
                    Caption = 'ShipmentsLastWeek';
                    tooltip = 'ShipmentsLastWeek';
                }
                field(InvoicedLastWeek; InvoicedLastWeek)
                {
                    ApplicationArea = All;
                    Caption = 'InvoicedLastWeek';
                    tooltip = 'InvoicedLastWeek';
                }
                field(InvoicedLastMonth; InvoicedLastMonth)
                {
                    ApplicationArea = All;
                    Caption = 'InvoicedLastMonth';
                    tooltip = 'InvoicedLastMonth';
                }
                field(Invoiced2Month; Invoiced2Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced2Month';
                    tooltip = 'Invoiced2Month';
                }
                field(Invoiced3Month; Invoiced3Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced3Month';
                    tooltip = 'Invoiced3Month';
                }
                field(Invoiced4Month; Invoiced4Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced4Month';
                    tooltip = 'Invoiced4Month';
                }
                field(Invoiced5Month; Invoiced5Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced5Month';
                    tooltip = 'Invoiced5Month';
                }
                field(Invoiced6Month; Invoiced6Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced6Month';
                    tooltip = 'Invoiced6Month';
                }
                field(Invoiced7Month; Invoiced7Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced7Month';
                    tooltip = 'Invoiced7Month';
                }
                field(Invoiced8Month; Invoiced8Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced8Month';
                    tooltip = 'Invoiced8Month';
                }
                field(Invoiced9Month; Invoiced9Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced9Month';
                    tooltip = 'Invoiced9Month';
                }
                field(Invoiced10Month; Invoiced10Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced10Month';
                    tooltip = 'Invoiced10Month';
                }
                field(Invoiced11Month; Invoiced11Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced11Month';
                    tooltip = 'Invoiced11Month';
                }
                field(Invoiced12Month; Invoiced12Month)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced12Month';
                    tooltip = 'Invoiced12Month';
                }
                field(OrderValue2D; OrderValue[3])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue2D';
                    tooltip = 'OrderValue2D';
                }
                field(OrderValue3D; OrderValue[4])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue3D';
                    tooltip = 'OrderValue3D';
                }
                field(OrderValue4D; OrderValue[5])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue4D';
                    tooltip = 'OrderValue4D';
                }
                field(OrderValue5D; OrderValue[6])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue5D';
                    tooltip = 'OrderValue5D';
                }
                field(OrderValue6D; OrderValue[7])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue6D';
                    tooltip = 'OrderValue6D';
                }
                field(OrderValue7D; OrderValue[8])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue7D';
                    tooltip = 'OrderValue7D';
                }
                field(OrderValue8D; OrderValue[9])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue8D';
                    tooltip = 'OrderValue8D';
                }
                field(OrderValue9D; OrderValue[10])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue9D';
                    tooltip = 'OrderValue9D';
                }
                field(OrderValue10D; OrderValue[11])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue10D';
                    tooltip = 'OrderValue10D';
                }
                field(OrderValue11D; OrderValue[12])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue11D';
                    tooltip = 'OrderValue11D';
                }
                field(OrderValue12D; OrderValue[13])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue12D';
                    tooltip = 'OrderValue12D';
                }
                field(OrderValue13D; OrderValue[14])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue13D';
                    tooltip = 'OrderValue13D';
                }
                field(OrderValue14D; OrderValue[15])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue14D';
                    tooltip = 'OrderValue14D';
                }
                field(OrderValue15D; OrderValue[16])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue15D';
                    tooltip = 'OrderValue15D';
                }
                field(OrderValue16D; OrderValue[17])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue16D';
                    tooltip = 'OrderValue16D';
                }
                field(OrderValue17D; OrderValue[18])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue17D';
                    tooltip = 'OrderValue17D';
                }
                field(OrderValue18D; OrderValue[19])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue18D';
                    tooltip = 'OrderValue18D';
                }
                field(OrderValue19D; OrderValue[20])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue19D';
                    tooltip = 'OrderValue19D';
                }
                field(OrderValue20D; OrderValue[21])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue20D';
                    tooltip = 'OrderValue20D';
                }
                field(OrderValue21D; OrderValue[22])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue21D';
                    tooltip = 'OrderValue21D';
                }
                field(OrderValue22D; OrderValue[23])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue22D';
                    tooltip = 'OrderValue22D';
                }
                field(OrderValue23D; OrderValue[24])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue23D';
                    tooltip = 'OrderValue23D';
                }
                field(OrderValue24D; OrderValue[25])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue24D';
                    tooltip = 'OrderValue24D';
                }
                field(OrderValue25D; OrderValue[26])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue25D';
                    tooltip = 'OrderValue25D';
                }
                field(OrderValue26D; OrderValue[27])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue26D';
                    tooltip = 'OrderValue26D';
                }
                field(OrderValue27D; OrderValue[28])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue27D';
                    tooltip = 'OrderValue27D';
                }
                field(OrderValue28D; OrderValue[29])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue28D';
                    tooltip = 'OrderValue28D';
                }
                field(OrderValue29D; OrderValue[30])
                {
                    ApplicationArea = All;
                    Caption = 'OrderValue29D';
                    tooltip = 'OrderValue29D';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        tmpDate: Date;
        LastDocNo: Code[20];
    begin
        tmpDate := CalcDate('<-CM>', WorkDate()) - 1;

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, PDCPortalInfoParcels.Statusfilter::Delivered);
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', tmpDate), tmpDate); //last month
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsLastMonth += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetFilter(Shipping_Agent_Service_Code, '11..18'); //Boxes
        PDCPortalInfoParcels.SetRange(StatusFilter, PDCPortalInfoParcels.Statusfilter::Delivered);
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', tmpDate), tmpDate); //last month
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            BoxesLastMonth += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetFilter(Shipping_Agent_Service_Code, '32..38');  //Bags
        PDCPortalInfoParcels.SetRange(StatusFilter, PDCPortalInfoParcels.Statusfilter::Delivered);
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', tmpDate), tmpDate); //last month
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            BagsLastMonth += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        tmpDate := CalcDate('<-CM>', WorkDate()) - 1;  //last 11 months
        for i := 2 to 12 do begin
            tmpDate := CalcDate('<-CM>', tmpDate) - 1;
            Clear(PDCPortalInfoParcels);
            PDCPortalInfoParcels.SetRange(StatusFilter, PDCPortalInfoParcels.Statusfilter::Delivered);
            PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CM>', tmpDate), tmpDate);
            PDCPortalInfoParcels.Open();
            while PDCPortalInfoParcels.Read() do
                case i of
                    2:
                        Parcels2Month += PDCPortalInfoParcels.CountParcel;
                    3:
                        Parcels3Month += PDCPortalInfoParcels.CountParcel;
                    4:
                        Parcels4Month += PDCPortalInfoParcels.CountParcel;
                    5:
                        Parcels5Month += PDCPortalInfoParcels.CountParcel;
                    6:
                        Parcels6Month += PDCPortalInfoParcels.CountParcel;
                    7:
                        Parcels7Month += PDCPortalInfoParcels.CountParcel;
                    8:
                        Parcels8Month += PDCPortalInfoParcels.CountParcel;
                    9:
                        Parcels9Month += PDCPortalInfoParcels.CountParcel;
                    10:
                        Parcels10Month += PDCPortalInfoParcels.CountParcel;
                    11:
                        Parcels11Month += PDCPortalInfoParcels.CountParcel;
                    12:
                        Parcels12Month += PDCPortalInfoParcels.CountParcel;
                end;
            PDCPortalInfoParcels.Close();
        end;

        tmpDate := CalcDate('<-CW>', WorkDate()) - 1;
        Clear(PDCPortalInfoParcels);
        PDCPortalInfoParcels.SetRange(StatusFilter, PDCPortalInfoParcels.Statusfilter::Delivered);
        PDCPortalInfoParcels.SetRange(DeliveredDateFilter, CalcDate('<-CW>', tmpDate), tmpDate); //last week
        PDCPortalInfoParcels.Open();
        while PDCPortalInfoParcels.Read() do
            ParcelsLastWeek += PDCPortalInfoParcels.CountParcel;
        PDCPortalInfoParcels.Close();

        for i := 2 to 29 do begin
            Clear(PDCPortalInfoSalesOrders);
            PDCPortalInfoSalesOrders.SetRange(OrderDateFilter, WorkDate() - i);
            PDCPortalInfoSalesOrders.Open();
            while PDCPortalInfoSalesOrders.Read() do
                if PDCPortalInfoSalesOrders.AmountInclVATSum <> 0 then
                    OrderValue[i + 1] += round(PDCPortalInfoSalesOrders.OutstandingAmountSum / PDCPortalInfoSalesOrders.AmountInclVATSum * PDCPortalInfoSalesOrders.AmountSum, 0.01);
            PDCPortalInfoSalesOrders.Close();

            Clear(PDCPortalInfoPostedInvoice);
            PDCPortalInfoPostedInvoice.SetRange(OrderDateFilter, WorkDate() - i);
            PDCPortalInfoPostedInvoice.Open();
            while PDCPortalInfoPostedInvoice.Read() do
                OrderValue[i + 1] += PDCPortalInfoPostedInvoice.Sum_Amount;
            PDCPortalInfoSalesOrders.Close();
        end;

        tmpDate := CalcDate('<-CW>', WorkDate()) - 1;  //last week
        Clear(LastDocNo);
        Clear(PDCPortalInfoShipmByWearer);
        PDCPortalInfoShipmByWearer.SetRange(PostingDateFilter, CalcDate('<-CW>', tmpDate), tmpDate); //last week
        PDCPortalInfoShipmByWearer.Open();
        while PDCPortalInfoShipmByWearer.Read() do
            if (LastDocNo = '') or (LastDocNo <> PDCPortalInfoShipmByWearer.DocumentNo) then
                if PDCPortalInfoShipmByWearer.Sum_Quantity <> 0 then begin
                    ShipmentsLastWeek += 1;
                    LastDocNo := PDCPortalInfoShipmByWearer.DocumentNo;
                end;
        PDCPortalInfoShipmByWearer.Close();
        Clear(LastDocNo);

        tmpDate := CalcDate('<-CW>', WorkDate()) - 1;  //last week
        Clear(PDCPortalInfoPostedInvoice);
        PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, CalcDate('<-CW>', tmpDate), tmpDate); //last week
        PDCPortalInfoPostedInvoice.Open();
        while PDCPortalInfoPostedInvoice.Read() do
            InvoicedLastWeek += PDCPortalInfoPostedInvoice.Sum_Amount;
        PDCPortalInfoPostedInvoice.Close();
        Clear(PDCPortalInfoPostedCrMemo);
        PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, CalcDate('<-CW>', tmpDate), tmpDate); //last week
        PDCPortalInfoPostedCrMemo.Open();
        while PDCPortalInfoPostedCrMemo.Read() do
            InvoicedLastWeek -= PDCPortalInfoPostedCrMemo.Sum_Amount;
        PDCPortalInfoPostedCrMemo.Close();

        tmpDate := CalcDate('<-CM>', WorkDate()) - 1;
        Clear(PDCPortalInfoPostedInvoice);
        PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, CalcDate('<-CM>', tmpDate), tmpDate); //last month
        PDCPortalInfoPostedInvoice.Open();
        while PDCPortalInfoPostedInvoice.Read() do
            InvoicedLastMonth += PDCPortalInfoPostedInvoice.Sum_Amount;
        PDCPortalInfoPostedInvoice.Close();
        Clear(PDCPortalInfoPostedCrMemo);
        PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, CalcDate('<-CM>', tmpDate), tmpDate); //last month
        PDCPortalInfoPostedCrMemo.Open();
        while PDCPortalInfoPostedCrMemo.Read() do
            InvoicedLastMonth -= PDCPortalInfoPostedCrMemo.Sum_Amount;
        PDCPortalInfoPostedCrMemo.Close();

        tmpDate := CalcDate('<-CM>', WorkDate()) - 1;  //last 11 months
        for i := 2 to 12 do begin
            tmpDate := CalcDate('<-CM>', tmpDate) - 1;
            Clear(PDCPortalInfoPostedInvoice);
            PDCPortalInfoPostedInvoice.SetRange(PostingDateFilter, CalcDate('<-CM>', tmpDate), tmpDate);
            PDCPortalInfoPostedInvoice.Open();
            while PDCPortalInfoPostedInvoice.Read() do
                case i of
                    2:
                        Invoiced2Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    3:
                        Invoiced3Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    4:
                        Invoiced4Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    5:
                        Invoiced5Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    6:
                        Invoiced6Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    7:
                        Invoiced7Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    8:
                        Invoiced8Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    9:
                        Invoiced9Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    10:
                        Invoiced10Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    11:
                        Invoiced11Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                    12:
                        Invoiced12Month += PDCPortalInfoPostedInvoice.Sum_Amount;
                end;
            PDCPortalInfoPostedInvoice.Close();

            Clear(PDCPortalInfoPostedCrMemo);
            PDCPortalInfoPostedCrMemo.SetRange(PostingDateFilter, CalcDate('<-CM>', tmpDate), tmpDate);
            PDCPortalInfoPostedCrMemo.Open();
            while PDCPortalInfoPostedCrMemo.Read() do
                case i of
                    2:
                        Invoiced2Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    3:
                        Invoiced3Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    4:
                        Invoiced4Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    5:
                        Invoiced5Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    6:
                        Invoiced6Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    7:
                        Invoiced7Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    8:
                        Invoiced8Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    9:
                        Invoiced9Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    10:
                        Invoiced10Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    11:
                        Invoiced11Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                    12:
                        Invoiced12Month -= PDCPortalInfoPostedCrMemo.Sum_Amount;
                end;
            PDCPortalInfoPostedCrMemo.Close();
        end;
    end;

    var
        PDCPortalInfoParcels: Query "PDC Portal Info Parcels";
        PDCPortalInfoSalesOrders: Query "PDC Portal Info SalesOrders";
        PDCPortalInfoShipmByWearer: Query "PDC PortalInfo Shipm. ByWearer";
        PDCPortalInfoPostedInvoice: Query "PDC Portal Info Posted Invoice";
        PDCPortalInfoPostedCrMemo: Query "PDC Portal Info Posted Cr.Memo";
        i: Integer;
        ParcelsLastMonth: Integer;
        Parcels2Month: Integer;
        Parcels3Month: Integer;
        Parcels4Month: Integer;
        Parcels5Month: Integer;
        Parcels6Month: Integer;
        Parcels7Month: Integer;
        Parcels8Month: Integer;
        Parcels9Month: Integer;
        Parcels10Month: Integer;
        Parcels11Month: Integer;
        Parcels12Month: Integer;
        ParcelsLastWeek: Integer;
        BagsLastMonth: Integer;
        BoxesLastMonth: Integer;
        ShipmentsLastWeek: Integer;
        InvoicedLastWeek: Decimal;
        InvoicedLastMonth: Decimal;
        Invoiced2Month: Decimal;
        Invoiced3Month: Decimal;
        Invoiced4Month: Decimal;
        Invoiced5Month: Decimal;
        Invoiced6Month: Decimal;
        Invoiced7Month: Decimal;
        Invoiced8Month: Decimal;
        Invoiced9Month: Decimal;
        Invoiced10Month: Decimal;
        Invoiced11Month: Decimal;
        Invoiced12Month: Decimal;
        OrderValue: array[30] of Decimal;
}

