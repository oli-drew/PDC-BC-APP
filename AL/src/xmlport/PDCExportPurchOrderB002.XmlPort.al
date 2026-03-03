/// <summary>
/// XmlPort PDC Export Purch. Order B002 (ID 50040).
/// </summary>
XmlPort 50040 "PDC Export Purch. Order B002"
{

    Caption = 'Export Purch. Order B002';
    Direction = Export;
    FieldDelimiter = '<None>';
    FileName = 'Exp B002.csv';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement(fileheader; Integer)
            {
                XmlName = 'FileHeader';
                SourceTableView = sorting(Number) order(ascending) where(Number = const(1));
                textelement(SKU_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SKU_cpt := 'SKU';
                    end;
                }
                textelement(Size_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Size_cpt := 'Size';
                    end;
                }
                textelement(Quantity_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Quantity_cpt := 'Quantity';
                    end;
                }
            }
            tableelement(line; "Purchase Line")
            {
                XmlName = 'Lines';
                SourceTableView = where(Type = const(Item));
                textelement(SKU)
                {
                }
                textelement(Size)
                {
                }
                fieldelement(Quantity; Line.Quantity)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Line."Vendor Item No." = '' then
                        Line."Vendor Item No." := '####';

                    if StrPos(Line."Vendor Item No.", ' ') <> 0 then begin
                        SKU := CopyStr(Line."Vendor Item No.", 1, StrPos(Line."Vendor Item No.", ' ') - 1);
                        Size := CopyStr(Line."Vendor Item No.", StrPos(Line."Vendor Item No.", ' ') + 1);
                    end
                    else begin
                        SKU := Line."Vendor Item No.";
                        Clear(Size);
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        if Line.GetFilter("Document No.") <> '' then
            currXMLport.Filename := 'B002-' + Line.GetFilter("Document No.") + '.csv';
    end;
}

