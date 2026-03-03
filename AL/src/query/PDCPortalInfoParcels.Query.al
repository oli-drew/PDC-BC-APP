/// <summary>
/// Query PDC Portal Info Parcels (ID 50000).
/// </summary>
query 50000 "PDC Portal Info Parcels"
{
    Caption = 'Count Purchase Orders';

    elements
    {
        dataitem(CourierShipmentHeader; PDCCourierShipmentHeader)
        {
            filter(Shipping_Agent_Code; "Shipping Agent Code")
            {
            }
            filter(Shipping_Agent_Service_Code; "Shipping Agent Service Code")
            {
            }
            dataitem(Parcels_Info; "PDC Parcels Info")
            {
                DataItemLink = ConsignmentNumber = CourierShipmentHeader.consignmentNumber;
                DataItemTableFilter = "Stop Tracking" = const(false), Deleted = const(false);
                filter(DeliveredDateFilter; "Delivered Date")
                {
                }
                filter(StatusFilter; Status)
                {
                }
                filter(ShipmentDateFilter; "Shipment Date")
                {
                }
                column(ConsignmentNumber; ConsignmentNumber)
                {
                }
                column(CountParcel)
                {
                    Method = Count;
                }
            }
        }
    }
}

