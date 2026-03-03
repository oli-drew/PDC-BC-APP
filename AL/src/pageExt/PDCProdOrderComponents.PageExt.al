/// <summary>
/// PageExtension PDCProdOrderComponents (ID 50079) extends Record Prod. Order Components.
/// </summary>
pageextension 50079 PDCProdOrderComponents extends "Prod. Order Components"
{
    layout
    {
        addafter("Reserved Quantity")
        {
            field(PDCReservedFromItemLedgerFld; Rec.ReservedFromItemLedger())
            {
                Caption = 'Reserved from Stock';
                ToolTip = 'Reserved from Stock';
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
        }
    }
}
