/// <summary>
/// PageExtension PDCSalesInvoice (ID 50011) extends Record Sales Invoice.
/// </summary>
pageextension 50011 PDCSalesInvoice extends "Sales Invoice"
{
    layout
    {
        addafter("Incoming Document Entry No.")
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

