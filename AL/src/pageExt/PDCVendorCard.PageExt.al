/// <summary>
/// PageExtension PDCVendorCard (ID 50004) extends Record Vendor Card.
/// </summary>
pageextension 50004 PDCVendorCard extends "Vendor Card"
{
    layout
    {
        addafter("Customized Calendar")
        {
            field(PDCExportPOXmlport; Rec."PDC Export PO Xmlport")
            {
                ToolTip = 'Export PO Xmlport';
                ApplicationArea = All;
            }
            field("PDC Print Purchase Order Labels"; Rec."PDC Print Purch. Order Labels")
            {
                ToolTip = 'Print Purchase Order Labels';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}

