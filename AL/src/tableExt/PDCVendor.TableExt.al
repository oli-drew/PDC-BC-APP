/// <summary>
/// TableExtension PDCVendor (ID 50003) extends Record Vendor.
/// </summary>
tableextension 50003 PDCVendor extends Vendor
{
    fields
    {
        field(50000; "PDC Export PO Xmlport"; Integer)
        {
            Caption = 'Export PO Xmlport';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(XMLport));
        }
        field(50001; "PDC Print Purch. Order Labels"; Boolean)
        {
            Caption = 'Print Purchase Order Labels';
        }
    }
}

