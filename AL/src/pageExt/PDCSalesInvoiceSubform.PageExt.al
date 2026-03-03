/// <summary>
/// PageExtension PDCSalesInvoiceSubform (ID 50014) extends Record Sales Invoice Subform.
/// </summary>
pageextension 50014 PDCSalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
        addafter(Quantity)
        {
            field(PDCInventory; Rec.PDCInventory)
            {
                ToolTip = 'Inventory';
                ApplicationArea = All;
            }
        }
        addafter("Line No.")
        {
            field(ContractNo; Rec."PDC Contract No.")
            {
                ToolTip = 'Contract No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item; // PDC1 MM 04/07/14
    end;
}

