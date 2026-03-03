/// <summary>
/// PageExtension PDCCustomerList (ID 50002) extends Record Customer List.
/// </summary>
PageExtension 50002 PDCCustomerList extends "Customer List"
{
    layout
    {

        addafter("Credit Limit (LCY)")
        {
            field(PDCBalanceLCY; Rec."Balance (LCY)")
            {
                ToolTip = 'Balance (LCY)';
                ApplicationArea = All;
            }
        }
        addafter("Base Calendar Code")
        {
            field(PDCDefaultBranchNo; Rec."PDC Default Branch No.")
            {
                ToolTip = 'Default Branch No.';
                ApplicationArea = All;
            }
            field(PDCBranchMandatory; Rec."PDC Branch Mandatory")
            {
                ToolTip = 'Branch Mandatory';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

