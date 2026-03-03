query 50015 "PDCAPI - FirmProdOrdRoutQtyQue"
{
    Caption = 'Firm Planned Prod.Order Routing Quantity Query', Locked = true;
    QueryType = API;
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    APIVersion = 'v2.0';
    EntityName = 'firmPlannedProdOrderRoutingQuantityQuery';
    EntitySetName = 'firmPlannedProdOrderRoutingQuantityQueries';

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
            }
            dataitem(ProdRoutingLine; "Prod. Order Routing Line")
            {
                DataItemLink = Status = Production_Order.Status, "Prod. Order No." = Production_Order."No.";
                SqlJoinType = InnerJoin;

                dataitem(RoutingLine; "Routing Line")
                {
                    DataItemLink = "Routing No." = ProdRoutingLine."Routing No.", "Operation No." = ProdRoutingLine."Operation No.";
                    SqlJoinType = InnerJoin;

                    dataitem(Branding; "PDC Branding")
                    {
                        DataItemLink = "No." = RoutingLine."PDC Branding No.";
                        SqlJoinType = LeftOuterJoin;

                        column(RoutingQtySum; "Routing Qty.")
                        {
                            Method = Sum;
                        }
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
