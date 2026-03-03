/// <summary>
/// Query PDCItemLEByStaff (ID 50012).
/// </summary>
query 50012 PDCItemLEByStaff
{
    Caption = 'ItemLYByStaff';
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(Staff_ID_Flt; "PDC Staff ID")
            {
            }
            filter(Posting_Date_Flt; "Posting Date")
            {
            }
            column(QuantitySum; Quantity)
            {
                Method = Sum;
            }
            column(RecCnt)
            {
                Method = Count;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
