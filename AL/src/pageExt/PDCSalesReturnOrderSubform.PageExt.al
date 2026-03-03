/// <summary>
/// PageExtension PDCSalesReturnOrderSubform (ID 50062) extends Record Sales Return Order Subform.
/// </summary>
pageextension 50062 PDCSalesReturnOrderSubform extends "Sales Return Order Subform"
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
        addafter("Returns Deferral Start Date")
        {
            field(PDCWearerID; Rec."PDC Wearer ID")
            {
                ToolTip = 'Wearer ID';
                ApplicationArea = All;
            }
            field(PDCWearerName; Rec."PDC Wearer Name")
            {
                ToolTip = 'Wearer Name';
                ApplicationArea = All;
            }
            field(PDCCustomerReference; Rec."PDC Customer Reference")
            {
                ToolTip = 'Customer Reference';
                ApplicationArea = All;
            }
            field(PDCWebOrderNo; Rec."PDC Web Order No.")
            {
                ToolTip = 'Web Order No.';
                ApplicationArea = All;
            }
            field(PDCOrderedByID; Rec."PDC Ordered By ID")
            {
                ToolTip = 'Ordered By ID';
                ApplicationArea = All;
            }
            field(PDCOrderedByName; Rec."PDC Ordered By Name")
            {
                ToolTip = 'Ordered By Name';
                ApplicationArea = All;
            }
            field(PDCContractNo; Rec."PDC Contract No.")
            {
                ToolTip = 'Contract No.';
                ApplicationArea = All;
            }
            field(PDCOrderReasonCode; Rec."PDC Order Reason Code")
            {
                ToolTip = 'Order Reason Code';
                ApplicationArea = All;
            }
            field(PDCOrderReason; Rec."PDC Order Reason")
            {
                ToolTip = 'Order Reason';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

