/// <summary>
/// PageExtension PDCPostedSalesInvoices (ID 50072) extends Record Posted Sales Invoices.
/// </summary>
pageextension 50072 PDCPostedSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Posting Date")
        {
            field("PDC Order Date"; Rec."Order Date")
            {
                ToolTip = 'Order Date';
                ApplicationArea = All;
            }
        }
    }
}
