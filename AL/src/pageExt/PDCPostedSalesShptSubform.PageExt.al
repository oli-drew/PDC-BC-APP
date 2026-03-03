/// <summary>
/// PageExtension PDCPostedSalesShptSubform (ID 50026) extends Record Posted Sales Shpt. Subform.
/// </summary>
pageextension 50026 PDCPostedSalesShptSubform extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter(Correction)
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
        }
    }
    actions
    {
    }
}

