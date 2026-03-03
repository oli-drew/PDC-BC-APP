/// <summary>
/// XmlPort PDC Export Purch. Order F010 (ID 50045).
/// Exports Purchase Order lines as CSV for Vendor F010 (Footsure/Gardiners).
/// </summary>
XmlPort 50045 "PDC Export Purch. Order F010"
{

    Caption = 'Export Purch. Order F010';
    Direction = Export;
    FieldDelimiter = '<None>';
    FileName = 'Exp F010.csv';
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
                textelement(sku_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        sku_cpt := 'SKU';
                    end;
                }
                textelement(barcode_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        barcode_cpt := 'Barcode';
                    end;
                }
                textelement(customer_sku_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        customer_sku_cpt := 'Customer SKU';
                    end;
                }
                textelement(quantity_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        quantity_cpt := 'Quantity';
                    end;
                }
                textelement(order_reference_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        order_reference_cpt := 'Order Reference';
                    end;
                }
                textelement(order_line_reference_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        order_line_reference_cpt := 'Order Line Reference';
                    end;
                }
                textelement(customer_id_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        customer_id_cpt := 'CustomerID';
                    end;
                }
                textelement(name_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        name_cpt := 'Name';
                    end;
                }
                textelement(address_line_1_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        address_line_1_cpt := 'Address Line 1';
                    end;
                }
                textelement(address_line_2_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        address_line_2_cpt := 'Address Line 2';
                    end;
                }
                textelement(address_line_3_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        address_line_3_cpt := 'Address Line 3';
                    end;
                }
                textelement(address_line_4_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        address_line_4_cpt := 'Address Line 4';
                    end;
                }
                textelement(postcode_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        postcode_cpt := 'Postcode';
                    end;
                }
                textelement(country_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        country_cpt := 'Country';
                    end;
                }
                textelement(delivery_service_code_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        delivery_service_code_cpt := 'Delivery Service Code';
                    end;
                }
                textelement(contact_name_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        contact_name_cpt := 'Contact Name';
                    end;
                }
                textelement(contact_phone_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        contact_phone_cpt := 'Contact Phone/SMS';
                    end;
                }
                textelement(contact_email_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        contact_email_cpt := 'Contact Email';
                    end;
                }
                textelement(pdf_file_name_cpt)
                {

                    trigger OnBeforePassVariable()
                    begin
                        pdf_file_name_cpt := 'PDF File Name';
                    end;
                }
            }
            tableelement(line; "Purchase Line")
            {
                XmlName = 'Lines';
                SourceTableView = where(Type = const(Item));
                textelement(sku)
                {
                }
                textelement(barcode)
                {
                }
                textelement(customer_sku)
                {
                }
                textelement(quantity)
                {
                }
                textelement(order_reference)
                {
                }
                textelement(order_line_reference)
                {
                }
                textelement(customer_id)
                {
                }
                textelement(delivery_name)
                {
                }
                textelement(address_line_1)
                {
                }
                textelement(address_line_2)
                {
                }
                textelement(address_line_3)
                {
                }
                textelement(address_line_4)
                {
                }
                textelement(postcode)
                {
                }
                textelement(country)
                {
                }
                textelement(delivery_service_code)
                {
                }
                textelement(contact_name)
                {
                }
                textelement(contact_phone)
                {
                }
                textelement(contact_email)
                {
                }
                textelement(pdf_file_name)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Header."No." <> Line."Document No." then
                        Header.Get(Line."Document Type", Line."Document No.");

                    sku := Line."Vendor Item No.";
                    barcode := '';
                    customer_sku := '';
                    quantity := Format(Line.Quantity, 0, 9);
                    order_reference := Header."No.";
                    order_line_reference := Format(Line."Line No.", 0, 9);
                    customer_id := '';
                    delivery_name := Header."Ship-to Name";
                    address_line_1 := Header."Ship-to Address";
                    address_line_2 := Header."Ship-to Address 2";
                    address_line_3 := Header."Ship-to City";
                    address_line_4 := Header."Ship-to County";
                    postcode := Header."Ship-to Post Code";
                    country := Header."Ship-to Country/Region Code";
                    delivery_service_code := '';
                    contact_name := Header."Ship-to Contact";
                    contact_phone := Header."Ship-to Phone No.";
                    contact_email := 'purchasing@peterdrew.com';
                    pdf_file_name := '';
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        if Line.GetFilter("Document No.") <> '' then
            currXMLport.Filename := 'F010-' + Line.GetFilter("Document No.") + '.csv';
    end;

    var
        Header: Record "Purchase Header";
}
