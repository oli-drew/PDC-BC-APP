/// <summary>
/// Query PDC PortalInfo SalesArchOrders (ID 50006).
/// </summary>
query 50006 "PDC PortalInfo SalesArchOrders"
{
    // 23.04.2020 JEMEL J.Jemeljanovs #3279 * new fields: AmountSum

    Caption = 'Count Purchase Orders';

    elements
    {
        dataitem(Header; "Sales Header Archive")
        {
            DataItemTableFilter = "Document Type" = const(Order);
            filter(PostingDateFilter; "Posting Date")
            {
            }
            filter(RequestedDeliveryDateFilter; "Requested Delivery Date")
            {
            }
            filter(OrderDateFilter; "Order Date")
            {
            }
            filter(StatusFilter; Status)
            {
            }
            column(DocNo; "No.")
            {
            }
            column(Version_No; "Version No.")
            {
            }
            dataitem(Line; "Sales Line Archive")
            {
                DataItemLink = "Document Type" = Header."Document Type", "Document No." = Header."No.", "Version No." = Header."Version No.";
                DataItemTableFilter = Type = const(Item);
                column(QuantitySum; "Qty. to Ship")
                {
                    Method = Sum;
                }
                column(AmountSum; Amount)
                {
                    Method = Sum;
                }
            }
        }
    }
}

