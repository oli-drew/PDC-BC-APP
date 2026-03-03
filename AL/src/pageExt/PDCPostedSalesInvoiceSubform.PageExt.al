/// <summary>
/// PageExtension PDCPostedSalesInvoiceSubform (ID 50028) extends Record Posted Sales Invoice Subform.
/// </summary>
pageextension 50028 PDCPostedSalesInvoiceSubform extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify("Line Discount %")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field(PDCBranchNo; Rec."PDC Branch No.")
            {
                ToolTip = 'Branch No.';
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
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
            field(PDCContractCode; Rec."PDC Contract Code")
            {
                ToolTip = 'Contract Code';
                ApplicationArea = All;
            }
            field(PDCConsignmentNo; Rec."PDC Consignment No.")
            {
                ToolTip = 'Consignment No.';
                ApplicationArea = All;
            }
            field(PDCCreatedByID; Rec."PDC Created By ID")
            {
                ToolTip = 'Created By ID';
                ApplicationArea = All;
            }
            field(PDCCreatedByName; Rec."PDC Created By Name")
            {
                ToolTip = 'Created By Name';
                ApplicationArea = All;
            }
            field("PDC Item Net Weight"; Rec."PDC Item Net Weight")
            {
                ToolTip = 'Item Net Weight';
                ApplicationArea = All;
            }
            field("PDC Item Country of Origin Code"; Rec."PDC Item Country of OriginCode")
            {
                ToolTip = 'Item Country of Origin Code';
                ApplicationArea = All;
            }
            field("PDC Item Commodity Code"; Rec."PDC Item Commodity Code")
            {
                ToolTip = 'Item Commodity Code';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

