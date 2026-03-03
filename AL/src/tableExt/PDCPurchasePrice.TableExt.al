/// <summary>
/// TableExtension PDCPurchasePrice (ID 50001) extends Record Purchase Price.
/// </summary>
tableextension 50001 PDCPurchasePrice extends "Purchase Price"
{
    fields
    {
        field(50000; "PDC Vendor Item No."; Code[50])
        {
            Caption = 'Vendor Item No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Vendor"."Vendor Item No." where("Item No." = field("Item No.")));
            Editable = false;
        }
        field(50001; "PDC Item Blocked"; Boolean)
        {
            Caption = 'Item Blocked';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
            Editable = false;
        }

    }
}
