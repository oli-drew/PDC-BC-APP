/// <summary>
/// OnBeforePassVariable.
/// </summary>
XmlPort 50041 "PDC Export Purch. Order R007"
{

    Caption = 'Export Purch. Order R007';
    Direction = Export;
    FieldDelimiter = '<None>';
    FileName = 'Exp R007.csv';
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
                textelement(order_no_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        order_no_cpt := 'order_no';
                    end;
                }
                textelement(customer_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        customer_cpt := 'customer';
                    end;
                }
                textelement(contact_name_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        contact_name_cpt := 'contact_name';
                    end;
                }
                textelement(date_ordered_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        date_ordered_cpt := 'date_ordered';
                    end;
                }
                textelement(product_sku_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        product_sku_cpt := 'product_sku';
                    end;
                }
                textelement(order_qty_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        order_qty_cpt := 'order_qty';
                    end;
                }
                textelement(specialins_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        specialins_cpt := 'specialins';
                    end;
                }
                textelement(delivery_address1_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_address1_cpt := 'delivery_address1';
                    end;
                }
                textelement(delivery_address2_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_address2_cpt := 'delivery_address2';
                    end;
                }
                textelement(delivery_address3_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_address3_cpt := 'delivery_address3';
                    end;
                }
                textelement(delivery_address4_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_address4_cpt := 'delivery_address4';
                    end;
                }
                textelement(delivery_address5_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_address5_cpt := 'delivery_address5';
                    end;
                }
                textelement(delivery_address6_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_address6_cpt := 'delivery_address6';
                    end;
                }
            }
            tableelement(line; "Purchase Line")
            {
                XmlName = 'Lines';
                SourceTableView = where(Type = const(Item));
                textelement(order_no)
                {
                }
                textelement(customer)
                {
                }
                textelement(contact_name)
                {
                }
                textelement(date_ordered)
                {
                }
                textelement(product_sku)
                {
                }
                textelement(order_qty)
                {
                }
                textelement(specialins)
                {
                }
                textelement(delivery_address1)
                {
                }
                textelement(delivery_address2)
                {
                }
                textelement(delivery_address3)
                {
                }
                textelement(delivery_address4)
                {
                }
                textelement(delivery_address5)
                {
                }
                textelement(delivery_address6)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Header."No." <> Line."Document No." then
                        Header.Get(Line."Document Type", Line."Document No.");

                    if not Purchaser.Get(Header."Purchaser Code") then
                        Clear(Purchaser);

                    if Line."Vendor Item No." = '' then
                        Line."Vendor Item No." := '####';

                    order_no := Header."No.";
                    customer := 'PE316';
                    contact_name := Purchaser.Name;
                    date_ordered := Format(Header."Order Date", 0, '<Day,2>/<Month,2>/<Year4>');
                    product_sku := Line."Vendor Item No.";
                    order_qty := Format(Line.Quantity, 0, 9);
                    specialins := '';
                    delivery_address1 := Header."Ship-to Name";
                    delivery_address2 := Header."Ship-to Address";
                    delivery_address3 := Header."Ship-to Address 2";
                    delivery_address4 := Header."Ship-to County";
                    delivery_address5 := Header."Ship-to Post Code";
                    delivery_address6 := Header."Ship-to Country/Region Code";
                end;
            }
        }
    }


    trigger OnPreXmlPort()
    begin
        if Line.GetFilter("Document No.") <> '' then
            currXMLport.Filename := 'PE316-' + Line.GetFilter("Document No.") + '.csv';
    end;

    var
        Header: Record "Purchase Header";
        Purchaser: Record "Salesperson/Purchaser";
}

