/// <summary>
/// Report PDCSalesPriceUpdDirectCostMarg (ID 50050).
/// </summary>
report 50050 "PDC SalesPriceUpdDirectCostMar"
{
    ProcessingOnly = true;
    Caption = 'Sales Price Update Direct Cost Margin';

    dataset
    {
        dataitem(SalesPrice; "Sales Price")
        {
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord()
            begin
                CalcDirectCostMargin();
            end;
        }
    }

}
