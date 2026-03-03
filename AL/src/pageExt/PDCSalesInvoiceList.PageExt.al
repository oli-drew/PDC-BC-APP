/// <summary>
/// PageExtension PDCSalesInvoiceList (ID 50033) extends Record Sales Invoice List.
/// </summary>
pageextension 50033 PDCSalesInvoiceList extends "Sales Invoice List"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field(PDCEmployeeName; Rec."PDC Employee Name")
            {
                ToolTip = 'Employee Name';
                ApplicationArea = All;
            }
            field(PDCCustomerReference; Rec."PDC Customer Reference")
            {
                ToolTip = 'Customer Reference';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

