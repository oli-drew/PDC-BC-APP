/// <summary>
/// Query PDCDraftOrdItemByStaffProd (ID 50011).
/// </summary>
query 50011 PDCDraftOrdItemByStaffProd
{
    QueryType = Normal;

    elements
    {
        dataitem(DraftOrderItemLine; "PDC Draft Order Item Line")
        {
            filter(ProductCodeFilter; "Product Code")
            {
            }
            filter(StaffIDFilter; "Staff ID")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
