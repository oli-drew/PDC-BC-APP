/// <summary>
/// Query PDC Portal Info PurchOrders (ID 50005).
/// </summary>
query 50005 "PDC Portal Info PurchOrders"
{
    Caption = 'Count Purchase Orders';

    elements
    {
        dataitem(Header; "Purchase Header")
        {
            DataItemTableFilter = "Document Type" = const(Order);
            filter(PostingDateFilter; "Posting Date")
            {
            }
            filter(VendorFilter; "Buy-from Vendor No.")
            {
            }
            filter(CountryFilter; "Buy-from Country/Region Code")
            {
            }
            filter(StatusFilter; Status)
            {
            }
            dataitem(Line; "Purchase Line")
            {
                DataItemLink = "Document Type" = Header."Document Type", "Document No." = Header."No.";
                DataItemTableFilter = Type = const(Item);
                column(ItemNo; "No.")
                {
                }
                column(QuantitySum; Quantity)
                {
                    Method = Sum;
                }
                column(QuantityRcvdSum; "Quantity Received")
                {
                    Method = Sum;
                }
            }
        }
    }
}

