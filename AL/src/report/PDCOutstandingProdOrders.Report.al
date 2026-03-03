/// <summary>
/// Report PDC Outstanding Prod. Orders (ID 50047).
/// </summary>
report 50047 "PDC Outstanding Prod. Orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/OutstandingProdOrders.rdlc';
    Caption = 'Outstanding Prod. Orders';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(ProductionOrder; "Production Order")
        {
            DataItemTableView = where(Status = CONST(Released));
            RequestFilterFields = "PDC Released D/T";
            column(No_; "No.")
            {
                IncludeCaption = true;
            }
            column(Description; Description)
            {
                IncludeCaption = true;
            }
            column(DueDate; FORMAT("Due Date"))
            {
            }
            column(HasShortage; HasShortage)
            {
            }

            trigger OnAfterGetRecord()
            var
                PDCFunctions: Codeunit "PDC Functions";
            begin
                clear(HasShortage);
                if PDCFunctions.ProdOrderHasShortage(ProductionOrder) then
                    HasShortage := '1';
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
    }

    var
        HasShortage: Text[1];

}
