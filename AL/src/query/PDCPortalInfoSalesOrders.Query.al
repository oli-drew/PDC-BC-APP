/// <summary>
/// Query PDC Portal Info SalesOrders (ID 50001).
/// </summary>
query 50001 "PDC Portal Info SalesOrders"
{
    // 23.04.2020 JEMEL J.Jemeljanovs #3279 * new fields: AmountSum

    Caption = 'Count Sales Orders';

    elements
    {
        dataitem(Sales_Header; "Sales Header")
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
            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "Document Type" = Sales_Header."Document Type", "Document No." = Sales_Header."No.";
                DataItemTableFilter = Type = const(Item);
                column(QuantitySum; "Qty. to Ship")
                {
                    Method = Sum;
                }
                column(QuantityInvoicedBaseSum; "Qty. Invoiced (Base)")
                {
                    Method = Sum;
                }
                column(AmountSum; Amount)
                {
                    Method = Sum;
                }
                column(AmountInclVATSum; "Amount Including VAT")
                {
                    Method = Sum;
                }
                column(OutstandingAmountSum; "Outstanding Amount")
                {
                    Method = Sum;
                }
            }
        }
    }
}

