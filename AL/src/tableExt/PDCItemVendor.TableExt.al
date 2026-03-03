/// <summary>
/// TableExtension PDCItemVendor (ID 50016) extends Record Item Vendor.
/// </summary>
tableextension 50016 PDCItemVendor extends "Item Vendor"
{
    fields
    {
        field(50000; "PDC Vendor Inventory"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50001; "PDC Vendor Inventory DT"; DateTime)
        {
            Caption = 'Vendor Inventory DT';
        }
        field(50002; "PDC Item Blocked"; Boolean)
        {
            Caption = 'Item Blocked';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
            Editable = false;
        }
    }
}

