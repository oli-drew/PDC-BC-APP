/// <summary>
/// XmlPort PDC Export Purch. Order U005 (ID 50044).
/// </summary>
xmlport 50044 "PDC Export Purch. Order U005"
{
    Caption = 'Export Purch. Order U005';
    Direction = Export;
    FieldDelimiter = '<None>';
    FileName = 'Exp U005.csv';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement(PurchaseLine; "Purchase Line")
            {
                XmlName = 'Lines';
                SourceTableView = where(Type = const(Item));
                fieldelement(VendorItemNo; PurchaseLine."Vendor Item No.")
                {
                }
                fieldelement(Quantity; PurchaseLine.Quantity)
                {
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        if PurchaseLine.GetFilter("Document No.") <> '' then
            currXMLport.Filename := 'U005-' + PurchaseLine.GetFilter("Document No.") + '.csv';
    end;
}
