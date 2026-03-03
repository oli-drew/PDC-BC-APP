/// <summary>
/// XmlPort PDC Export Purch. Order P003 (ID 50043).
/// </summary>
XmlPort 50043 "PDC Export Purch. Order P003"
{

    Caption = 'Export Purch. Order P003';
    Direction = Export;
    FieldDelimiter = '<None>';
    FileName = 'Exp P003.csv';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement(line; "Purchase Line")
            {
                XmlName = 'Lines';
                SourceTableView = where(Type = const(Item));
                textelement(PrCode)
                {
                }
                textelement(Qty)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Line."Vendor Item No." = '' then
                        Line."Vendor Item No." := '####';

                    PrCode := Line."Vendor Item No.";
                    Qty := Format(Line.Quantity, 0, 9);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        if Line.GetFilter("Document No.") <> '' then
            currXMLport.Filename := Line.GetFilter("Document No.") + '.csv';
    end;
}

