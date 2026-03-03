/// <summary>
/// XmlPort PDC Export Purch. Order O002 (ID 50042).
/// </summary>
XmlPort 50042 "PDC Export Purch. Order O002"
{

    Caption = 'Export Purch. Order O002';
    Direction = Export;
    FieldDelimiter = '<None>';
    FileName = 'Exp O002.csv';
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
                textelement(AccountNo_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        AccountNo_cpt := 'AccountNo';
                    end;
                }
                textelement(OrderRef_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        OrderRef_cpt := 'OrderRef';
                    end;
                }
                textelement(PrCode_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PrCode_cpt := 'PrCode';
                    end;
                }
                textelement(Qty_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Qty_cpt := 'Qty';
                    end;
                }
            }
            tableelement(line; "Purchase Line")
            {
                XmlName = 'Lines';
                SourceTableView = where(Type = const(Item));
                textelement(AccountNo)
                {
                }
                textelement(OrderRef)
                {
                }
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

                    AccountNo := 'PET01';
                    OrderRef := Line."Document No.";
                    PrCode := Line."Vendor Item No.";
                    Qty := Format(Line.Quantity, 0, 9);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        if Line.GetFilter("Document No.") <> '' then
            currXMLport.Filename := 'PET01.csv';
    end;
}

