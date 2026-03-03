query 50018 "PDCAPI - RelProdOrdOpCntQuery"
{
    Caption = 'Released Prod.Order Count Query', Locked = true;
    QueryType = API;
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    APIVersion = 'v2.0';
    EntityName = 'releasedProdOrderOperationCountQuery';
    EntitySetName = 'releasedProdOrderOperationCountQueries';

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
            dataitem(RoutingLine; "Prod. Order Routing Line")
            {
                DataItemLink = Status = Production_Order.Status, "Prod. Order No." = Production_Order."No.";
                SqlJoinType = InnerJoin;

                column(operationCount; "Input Quantity")
                {
                    Method = Sum;
                }
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
