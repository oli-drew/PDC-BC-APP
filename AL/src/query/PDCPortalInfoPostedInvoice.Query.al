/// <summary>
/// Query PDC Portal Info Posted Invoice (ID 50004).
/// </summary>
query 50004 "PDC Portal Info Posted Invoice"
{

    elements
    {
        dataitem(Header; "Sales Invoice Header")
        {
            filter(PostingDateFilter; "Posting Date")
            {
            }
            filter(OrderDateFilter; "Order Date")
            {
            }
            column(DocNo; "No.")
            {
            }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = Header."No.";
                //DataItemTableFilter = Type = const(Item);
                SqlJoinType = InnerJoin;
                column(Sum_Amount; Amount)
                {
                    Method = Sum;
                }
                column(Sum_Quantity; Quantity)
                {
                    Method = Sum;
                }
            }
        }
    }
}

