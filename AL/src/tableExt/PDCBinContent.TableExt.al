/// <summary>
/// TableExtension PDCBinContent (ID 50046) extends Record Bin Content.
/// </summary>
tableextension 50046 PDCBinContent extends "Bin Content"
{
    fields
    {
        field(50000; "PDC Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

