query 50013 "PDCAPI - FirmProdOrderSumQuery"
{
    Caption = 'Firm Planned Prod.Order Sum Query', Locked = true;
    QueryType = API;
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    APIVersion = 'v2.0';
    EntityName = 'firmPlannedProdOrderSumQuery';
    EntitySetName = 'firmPlannedProdOrderSumQueries';

    elements
    {
        dataitem(Production_Order; "Production Order")
        {
            DataItemTableFilter = Status = const("Firm Planned");

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
