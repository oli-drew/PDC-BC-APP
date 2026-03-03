/// <summary>
/// XmlPort PDC Portal Get Item Stock (ID 50036).
/// </summary>
XmlPort 50036 "PDC Portal Get Item Stock"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                textelement(f_orderId)
                {
                    XmlName = 'orderId';
                }
                textelement(f_itemno)
                {
                    XmlName = 'itemNo';
                }
            }
            textelement(freeStockQty)
            {
                MinOccurs = Zero;
            }
            textelement(leadTimeCalculation)
            {
                MinOccurs = Zero;
            }
            textelement(replenishmentSystem)
            {
                MinOccurs = Zero;
            }
        }
    }

    /// <summary>
    /// GetFilters.
    /// </summary>
    /// <param name="p_orderId">VAR Code[20].</param>
    /// <param name="p_itemno">VAR Code[20].</param>
    procedure GetFilters(var p_orderId: Code[20]; var p_itemno: Code[20])
    begin
        p_orderId := f_orderId;
        p_itemno := f_itemno;
    end;

    /// <summary>
    /// SetFreeStockQty.
    /// </summary>
    /// <param name="val">Text.</param>
    procedure SetFreeStockQty(val: Text)
    begin
        freeStockQty := val;
    end;

    /// <summary>
    /// SetLeadTimeCalculation
    /// </summary>
    /// <param name="val"></param>
    procedure SetLeadTimeCalculation(val: Text)
    begin
        leadTimeCalculation := val;
    end;

    /// <summary>
    /// SetReplenishmentSystem
    /// </summary>
    /// <param name="val"></param>
    procedure SetReplenishmentSystem(val: Text)
    begin
        replenishmentSystem := val;
    end;
}

