query 50017 "PDCAPI - FinProdOrderSumQuery"
{
    Caption = 'Finished Prod.Order Sum Query', Locked = true;
    QueryType = API;
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    APIVersion = 'v2.0';
    EntityName = 'finishedProdOrderSumQuery';
    EntitySetName = 'finishedProdOrderSumQueries';

    elements
    {
        dataitem(Production_Order; "Production Order")
        {
            DataItemTableFilter = Status = const(Finished);

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
