/// <summary>
/// PageExtension PDCPurchaseOrderList (ID 50036) extends Record Purchase Order List.
/// </summary>
pageextension 50036 PDCPurchaseOrderList extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(PDCRollOutNo; Rec."PDC Roll-Out No.")
            {
                ToolTip = 'Roll-Out No.';
                ApplicationArea = All;
            }
        }
        addafter("Job Queue Status")
        {
            field(PDCProdOrderNo; Rec."PDC Prod. Order No.")
            {
                ToolTip = 'Prod. Order No.';
                ApplicationArea = All;
            }
            field(PDCEstimatedReceiptDate; Rec."PDC Estimated Receipt Date")
            {
                ToolTip = 'Estimated Receipt Date';
                ApplicationArea = All;
            }
            field(PDCVendorOrderNo; Rec."Vendor Order No.")
            {
                ToolTip = 'Vendor Order No.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

