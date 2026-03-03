/// <summary>
/// XmlPort PDC Portal Sales Inv Card (ID 50026).
/// </summary>
XmlPort 50026 "PDC Portal Sales Inv Card"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(noFilter)
                {
                }
            }
            tableelement(salesinvoiceheader; "Sales Invoice Header")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'salesInvoiceHeader';
                UseTemporary = true;
                fieldelement(no; SalesInvoiceHeader."No.")
                {
                }
                fieldelement(customerName; SalesInvoiceHeader."Sell-to Customer Name")
                {
                }
                fieldelement(address; SalesInvoiceHeader."Sell-to Address")
                {
                }
                fieldelement(address2; SalesInvoiceHeader."Sell-to Address 2")
                {
                }
                fieldelement(city; SalesInvoiceHeader."Sell-to City")
                {
                }
                fieldelement(county; SalesInvoiceHeader."Sell-to County")
                {
                }
                fieldelement(postCode; SalesInvoiceHeader."Sell-to Post Code")
                {
                }
                fieldelement(country; SalesInvoiceHeader."Sell-to Country/Region Code")
                {
                }
                fieldelement(yourRef; SalesInvoiceHeader."Your Reference")
                {
                }
                fieldelement(branchNo; SalesInvoiceHeader."PDC Branch No.")
                {
                }
                textelement(salesinvoiceheader_branchname)
                {
                    XmlName = 'branchName';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();
                        Branch.SetRange("Branch No.", SalesInvoiceHeader."PDC Branch No.");

                        if Branch.FindFirst() then
                            salesinvoiceheader_branchname := Branch.Name;
                    end;
                }
                fieldelement(shipmentDate; SalesInvoiceHeader."Shipment Date")
                {
                }
                fieldelement(postingDate; SalesInvoiceHeader."Posting Date")
                {
                }
                textelement(salesinvoiceheader_pono)
                {
                    XmlName = 'poNo';
                }
                fieldelement(amount; SalesInvoiceHeader.Amount)
                {
                }
                fieldelement(returnReason; SalesInvoiceHeader."Reason Code")
                {
                }
            }
            tableelement(salesinvoiceline; "Sales Invoice Line")
            {
                MinOccurs = Zero;
                XmlName = 'salesInvoiceLines';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(lineNo; SalesInvoiceLine."Line No.")
                {
                }
                fieldelement(wearerName; SalesInvoiceLine."PDC Wearer Name")
                {
                }
                fieldelement(description; SalesInvoiceLine.Description)
                {
                }
                textelement(salesinvoiceline_colour)
                {
                    XmlName = 'colour';
                }
                textelement(salesinvoiceline_size)
                {
                    XmlName = 'size';
                }
                textelement(salesinvoiceline_fit)
                {
                    XmlName = 'fit';
                }
                fieldelement(qtyOrdered; SalesInvoiceLine.Quantity)
                {
                }
                fieldelement(total; SalesInvoiceLine.Amount)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then
                        if Item.Get(SalesInvoiceLine."No.") then begin
                            salesinvoiceline_colour := Item."PDC Colour";
                            salesinvoiceline_size := Item."PDC Size";
                            salesinvoiceline_fit := Item."PDC Fit";
                        end;
                end;
            }
            tableelement(salescommentline; "Sales Comment Line")
            {
                MinOccurs = Zero;
                XmlName = 'comments';
                UseTemporary = true;
                fieldelement(commentNo; SalesCommentLine."Line No.")
                {
                }
                fieldelement(orderNo; SalesCommentLine."No.")
                {
                }
                fieldelement(lineNo; SalesCommentLine."Document Line No.")
                {
                }
                fieldelement(comment; SalesCommentLine.Comment)
                {
                }
                fieldelement(date; SalesCommentLine.Date)
                {
                }
                fieldelement(documentType; SalesCommentLine."Document Type")
                {
                }
            }
        }
    }


    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="SalesInvoiceHeaderDb">Record "Sales Invoice Header".</param>
    procedure FilterData(SalesInvoiceHeaderDb: Record "Sales Invoice Header")
    var
        SalesInvoiceLineDb: Record "Sales Invoice Line";
        SalesCommentLineDb: Record "Sales Comment Line";
    begin
        SalesInvoiceHeaderDb.Get(noFilter);
        SalesInvoiceHeader.TransferFields(SalesInvoiceHeaderDb);
        SalesInvoiceHeader.Insert();

        SalesInvoiceLineDb.Reset();
        SalesInvoiceLineDb.SetRange("Document No.", noFilter);

        if not SalesInvoiceLineDb.FindSet() then exit;

        repeat
            SalesInvoiceLine.TransferFields(SalesInvoiceLineDb);
            SalesInvoiceLine.Insert();
        until SalesInvoiceLineDb.Next() = 0;

        SalesCommentLineDb.Reset();
        SalesCommentLineDb.SetRange("No.", noFilter);

        if not SalesCommentLineDb.FindSet() then exit;

        repeat
            SalesCommentLine.TransferFields(SalesCommentLineDb);
            SalesCommentLine.Insert();
        until SalesCommentLineDb.Next() = 0;
    end;

    /// <summary>
    /// GetInvoiceNo.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetInvoiceNo(): Text
    begin
        exit(noFilter);
    end;
}

