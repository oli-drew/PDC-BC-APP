query 50016 "PDCAPI - RelProdOrderSumQuery"
{
    Caption = 'Released Prod.Order Sum Query', Locked = true;
    QueryType = API;
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    APIVersion = 'v2.0';
    EntityName = 'releasedProdOrderSumQuery';
    EntitySetName = 'releasedProdOrderSumQueries';

    elements
    {
        dataitem(Production_Order; "Production Order")
        {
            DataItemTableFilter = Status = const(Released);

            filter(creationDateFilter; "Creation Date")
            {
            }
            filter(workCenterFilter; "PDC Work Center No.")
            {
            }
            column(quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }
}
