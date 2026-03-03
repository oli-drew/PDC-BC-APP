/// <summary>
/// Query PDC Portal Info Posted Cr.Memo (ID 50010).
/// </summary>
query 50010 "PDC Portal Info Posted Cr.Memo"
{

    elements
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            filter(PostingDateFilter; "Posting Date")
            {
            }
            dataitem(Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = Header."No.";
                DataItemTableFilter = Type = const(Item);
                SqlJoinType = InnerJoin;
                column(Sum_Amount; Amount)
                {
                    Method = Sum;
                }
            }
        }
    }
}

