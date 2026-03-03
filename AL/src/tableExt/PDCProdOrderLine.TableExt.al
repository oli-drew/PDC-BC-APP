/// <summary>
/// TableExtension PDCProdOrderLine (ID 50037) extends Record Prod. Order Line.
/// </summary>
tableextension 50037 PDCProdOrderLine extends "Prod. Order Line"
{
    fields
    {
        field(50000; "PDC Purchase Document No."; Code[20])
        {
            CalcFormula = lookup("Purchase Line"."Document No." where("Prod. Order No." = field("Prod. Order No."),
                                                                       "Prod. Order Line No." = field("Line No.")));
            Caption = 'Purchase Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

