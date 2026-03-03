/// <summary>
/// XmlPort PDC Portal Get Item Price (ID 50029).
/// </summary>
XmlPort 50029 "PDC Portal Get Item Price"
{

    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                textelement(f_itemno)
                {
                    XmlName = 'itemNo';
                }
            }
            textelement(price)
            {
                MinOccurs = Zero;
            }
        }
    }

    /// <summary>
    /// GetItemNo.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetItemNo(): Code[20]
    begin
        exit(f_itemNo);
    end;

    /// <summary>
    /// SetItemPrice.
    /// </summary>
    /// <param name="itemPrice">Decimal.</param>
    procedure SetItemPrice(itemPrice: Decimal)
    begin
        price := Format(itemPrice, 0, 9);
    end;
}

