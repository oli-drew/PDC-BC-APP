/// <summary>
/// Page PDCAPI - Pstd Sales Invoices (ID 50110).
/// </summary>
page 50110 "PDCAPI - Pstd Sales Invoices"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Posted Sales Invoice';
    EntitySetCaption = 'Posted Sales Invoices';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    Editable = false;
    EntityName = 'pstdSalesInvoice';
    EntitySetName = 'pstdSalesInvoices';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Sales Invoice Header";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                }
                field(externalDocumentNumber; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(invoiceDate; Rec."Document Date")
                {
                    Caption = 'Invoice Date';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(customerPurchaseOrderReference; Rec."Your Reference")
                {
                    Caption = 'Customer Purchase Order Reference',;
                }
                field(customerNumber; Rec."Sell-to Customer No.")
                {
                    Caption = 'Customer No.';

                }
                field(customerId; customerSystemId)
                {
                    Caption = 'Customer Id';
                }
                field(customerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-To Name';
                    Editable = false;
                }
                field(billToCustomerNumber; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-To Customer No.';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';
                }
                field(sellToAddressLine1; Rec."Sell-to Address")
                {
                    Caption = 'Sell-to Address Line 1';
                }
                field(sellToAddressLine2; Rec."Sell-to Address 2")
                {
                    Caption = 'Sell-to Address Line 2';
                }
                field(sellToCity; Rec."Sell-to City")
                {
                    Caption = 'Sell-to City';
                }
                field(sellToCountry; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Sell-to Country/Region Code';
                }
                field(sellToState; Rec."Sell-to County")
                {
                    Caption = 'Sell-to State';
                }
                field(sellToPostCode; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code';
                }
                field(billToAddressLine1; Rec."Bill-To Address")
                {
                    Caption = 'Bill-to Address Line 1';
                    Editable = false;
                }
                field(billToAddressLine2; Rec."Bill-To Address 2")
                {
                    Caption = 'Bill-to Address Line 2';
                    Editable = false;
                }
                field(billToCity; Rec."Bill-To City")
                {
                    Caption = 'Bill-to City';
                    Editable = false;
                }
                field(billToCountry; Rec."Bill-To Country/Region Code")
                {
                    Caption = 'Bill-to Country/Region Code';
                    Editable = false;
                }
                field(billToState; Rec."Bill-To County")
                {
                    Caption = 'Bill-to State';
                    Editable = false;
                }
                field(billToPostCode; Rec."Bill-To Post Code")
                {
                    Caption = 'Bill-to Post Code';
                    Editable = false;
                }
                field(shipToAddressLine1; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address Line 1';
                }
                field(shipToAddressLine2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address Line 2';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shipToState; Rec."Ship-to County")
                {
                    Caption = 'Ship-to State';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }
                field(currencyCode; CurrencyCodeTxt)
                {
                    Caption = 'Currency Code';
                }
                field(orderNumber; Rec."Order No.")
                {
                    Caption = 'Order No.';
                    Editable = false;
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code';
                }
                field(salesperson; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson';
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Include Tax';
                    Editable = false;
                }
                field(phoneNumber; Rec."Sell-to Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(email; Rec."Sell-to E-Mail")
                {
                    Caption = 'Email';
                }
                field(branchNo; Rec."PDC Branch No.")
                {
                    Caption = 'Branch No.';
                }
                field(consignmentNo; Rec."PDC Consignment No.")
                {
                    Caption = 'Consignment No.';
                }
                field(customerReference; Rec."PDC Customer Reference")
                {
                    Caption = 'Customer Reference';
                }
                field(employeeID; Rec."PDC Employee ID")
                {
                    Caption = 'Employee ID';
                }
                field(employeeName; Rec."PDC Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(checkedBy; Rec."PDC Checked By")
                {
                    Caption = 'Checked By';
                }
                field(homeAddress; Rec."PDC Home Address")
                {
                    Caption = 'Home Address';
                }
                field(notes; Rec."PDC Notes")
                {
                    Caption = 'Notes';
                }
                field(orderSource; Rec."PDC Order Source")
                {
                    Caption = 'Order Source';
                }
                field(orderStatus; Rec."PDC Order Status")
                {
                    Caption = 'Order Status';
                }
                field(shipToEMail; Rec."PDC Ship-to E-Mail")
                {
                    Caption = 'Ship-to E-Mail';
                }
                field(warehouseDocumentNo; Rec."PDC Warehouse Document No.")
                {
                    Caption = 'Warehouse Document No.';
                }
                field(webOrderNo; Rec."PDC WebOrder No.")
                {
                    Caption = 'WebOrder No.';
                }
                part(salesInvoiceLines; "PDCAPI - Pstd Sales Inv Lines")
                {
                    Caption = 'Lines';
                    EntityName = 'pstdSalesInvoiceLine';
                    EntitySetName = 'pstdSalesInvoiceLines';
                    SubPageLink = "PDC Document Id" = field(SystemId);
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
    end;

    var
        CurrencyCodeTxt: Text;
        customerSystemId: Guid;

    local procedure SetCalculatedFields()
    var
        Customer: Record Customer;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];
    begin
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
        clear(customerSystemId);
        if Customer.get(Rec."Sell-to Customer No.") then
            customerSystemId := Customer.SystemId;
    end;
}