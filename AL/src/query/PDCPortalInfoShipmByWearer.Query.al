/// <summary>
/// Query PDC PortalInfo Shipm. ByWearer (ID 50003).
/// </summary>
query 50003 "PDC PortalInfo Shipm. ByWearer"
{
    OrderBy = ascending(DocumentNo), ascending(Wearer_ID);

    elements
    {
        dataitem(Header; "Sales Shipment Header")
        {
            filter(PostingDateFilter; "Posting Date")
            {
            }
            column(DocumentNo; "No.")
            {
            }
            dataitem(Line; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = Header."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Type = const(Item);
                column(Wearer_ID; "PDC Wearer ID")
                {
                }
                column(Sum_Quantity; Quantity)
                {
                    Method = Sum;
                }
            }
        }
    }
}

