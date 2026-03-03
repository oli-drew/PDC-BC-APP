/// <summary>
/// XmlPort PDC Portal Get Altern Stock (ID 50037).
/// </summary>
XmlPort 50037 "PDC Portal Get Altern Stock"
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
            tableelement(Buffer; Item)
            {
                MinOccurs = Zero;
                XmlName = 'stock';
                UseTemporary = true;
                textattribute(jsonarray2)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(productCode; Buffer."PDC Product Code")
                {
                }
                fieldelement(colour; Buffer."PDC Colour")
                {
                }
                fieldelement(size; Buffer."PDC Size")
                {
                }
                fieldelement(sizeDescription; Buffer."PDC Size Description")
                {
                }
                fieldelement(fit; Buffer."PDC Fit")
                {
                }
                fieldelement(fitDescription; Buffer."PDC Fit Description")
                {
                }
                textelement(freeStockQty)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                begin
                    if Buffer."PDC Size Description" = '' then
                        Buffer."PDC Size Description" := Buffer."PDC Size";
                    if Buffer."PDC Fit Description" = '' then
                        Buffer."PDC Fit Description" := Buffer."PDC Fit";

                    freeStockQty := format(Buffer."Unit Price", 0, 9);
                end;
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
    /// SetBuffer.
    /// </summary>
    /// <param name="FromBuffer">Temporary VAR Record Item.</param>
    procedure SetBuffer(var FromBuffer: Record Item temporary)
    begin
        if FromBuffer.FindSet() then
            repeat
                Buffer.Init();
                Buffer := FromBuffer;
                Buffer.Insert();
            until FromBuffer.next() = 0;
    end;
}

