/// <summary>
/// TableExtension PDCRequisitionLine (ID 50027) extends Record Requisition Line.
/// </summary>
tableextension 50027 PDCRequisitionLine extends "Requisition Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                "PDC Prepaid" := Item."PDC Prepaid";
            end;
        }
        field(50000; "PDC Source"; enum PDCItemSource)
        {
            Caption = 'Source';
        }
        field(50001; "PDC Prepaid"; Boolean)
        {
            Caption = 'Prepaid';
        }
    }

    var
        Item: Record Item;
}

