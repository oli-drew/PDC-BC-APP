/// <summary>
/// Enum PDCShippingAgentConnectionType (ID 50002) used in Shipping Agent table. 
/// </summary>
enum 50002 PDCShippingAgentConnectionType
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; DPD)
    {
        Caption = 'DPD';
    }
    value(2; DX)
    {
        Caption = 'DX';
    }
}
