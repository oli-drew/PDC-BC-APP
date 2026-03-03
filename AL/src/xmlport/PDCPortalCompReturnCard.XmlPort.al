/// <summary>
/// XmlPort PDC Portal Comp Return Card (ID 50023).
/// </summary>
XmlPort 50023 "PDC Portal Comp Return Card"
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
            tableelement(returnreceiptheader; "Return Receipt Header")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'completedOrder';
                UseTemporary = true;
                fieldelement(no; ReturnReceiptHeader."No.")
                {
                }
                fieldelement(customerName; ReturnReceiptHeader."Sell-to Customer Name")
                {
                }
                fieldelement(address; ReturnReceiptHeader."Sell-to Address")
                {
                }
                fieldelement(address2; ReturnReceiptHeader."Sell-to Address 2")
                {
                }
                fieldelement(city; ReturnReceiptHeader."Sell-to City")
                {
                }
                fieldelement(county; ReturnReceiptHeader."Bill-to County")
                {
                }
                fieldelement(postCode; ReturnReceiptHeader."Sell-to Post Code")
                {
                }
                fieldelement(country; ReturnReceiptHeader."Sell-to Country/Region Code")
                {
                }
                fieldelement(status; ReturnReceiptHeader."Reason Code")
                {
                }
                fieldelement(yourRef; ReturnReceiptHeader."Your Reference")
                {
                }
                textelement(branchNo)
                {
                }
                textelement(returnreceiptheader_branchn)
                {
                    XmlName = 'branchName';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();

                        if not Branch.FindFirst() then exit;

                        ReturnReceiptHeader_BranchN := Branch.Name;
                    end;
                }
                textelement(shipmentDate)
                {
                }
                textelement(postingDate)
                {
                }
                textelement(returnreceiptheader_pono)
                {
                    XmlName = 'poNo';

                    trigger OnBeforePassVariable()
                    var
                        Line1: Record "Return Receipt Line";
                    begin
                        Line1.SetRange("Document No.", ReturnReceiptHeader."No.");
                        Line1.SetRange(Type, Line1.Type::Item);
                        Line1.SetFilter("No.", '<>%1', '');
                        Line1.SetFilter(Quantity, '<>%1', 0);
                        if Line1.FindFirst() then
                            ReturnReceiptHeader_PONo := Line1."PDC Customer Reference";
                    end;
                }
                textelement(returnreceiptheader_amount)
                {
                    XmlName = 'amount';
                }
                fieldelement(returnReason; ReturnReceiptHeader."Reason Code")
                {
                }
                //08.12.2020 JEMEL J.Jemeljanovs #3521 >>
                textelement(packType)
                {
                    MinOccurs = Zero;
                    trigger OnBeforePassVariable()
                    begin
                        packType := format(ReturnReceiptHeader."PDC Package Type")
                    end;
                }
                fieldelement(packNo; ReturnReceiptHeader."PDC Number Of Packages")
                {
                    MinOccurs = Zero;
                }
                fieldelement(returnRef; ReturnReceiptHeader."PDC Collection Reference")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    Line: Record "Return Receipt Line";
                begin
                    if SalesInvHeader.Get(ReturnReceiptHeader."PDC Return From Invoice No.") then
                        ReturnReceiptHeader."Shipment Date" := SalesInvHeader."Shipment Date";

                    ReturnReceiptHeader."PDC Branch No." := '';
                    Line.Reset();
                    Line.SetRange("Document No.", ReturnReceiptHeader."No.");
                    Line.SetRange(Type, Line.Type::Item);
                    Line.SetFilter("No.", '<>%1', '');
                    if Line.Findset() then
                        repeat
                            ReturnReceiptHeader."PDC Branch No." := Line."PDC Branch No.";
                        until (Line.next() = 0) or (ReturnReceiptHeader."PDC Branch No." <> '');

                    shipmentDate := PortalsMgt.FormatDate(ReturnReceiptHeader."Shipment Date");
                    postingDate := PortalsMgt.FormatDate(ReturnReceiptHeader."Posting Date");
                end;
            }
            tableelement(returnreceiptline; "Return Receipt Line")
            {
                MinOccurs = Zero;
                XmlName = 'completedOrderLines';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(lineNo; ReturnReceiptLine."Line No.")
                {
                }
                fieldelement(returnreceiptline_wearername; ReturnReceiptLine."PDC Wearer Name")
                {
                    XmlName = 'wearerName';
                }
                fieldelement(description; ReturnReceiptLine.Description)
                {
                }
                textelement(returnreceiptline_colour)
                {
                    XmlName = 'colour';
                }
                textelement(returnreceiptline_size)
                {
                    XmlName = 'size';
                }
                textelement(returnreceiptline_fit)
                {
                    XmlName = 'fit';
                }
                fieldelement(qtyOrdered; ReturnReceiptLine.Quantity)
                {
                }
                fieldelement(qtyShipped; ReturnReceiptLine."Quantity Invoiced")
                {
                }
                textelement(returnreceiptline_qtyremaining)
                {
                    XmlName = 'qtyToShip';
                }
                fieldelement(total; ReturnReceiptLine."Item Charge Base Amount")
                {
                }
                textelement(commentLines)
                {
                }
                fieldelement(reason; ReturnReceiptLine."PDC Order Reason")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    if ReturnReceiptLine.Type <> ReturnReceiptLine.Type::Item then exit;
                    Item.Get(ReturnReceiptLine."No.");
                    ReturnReceiptLine_Colour := Item."PDC Colour";
                    ReturnReceiptLine_Fit := Item."PDC Fit";
                    ReturnReceiptLine_Size := Item."PDC Size";
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
            }
        }
    }

    var
        PortalsMgt: Codeunit "PDC Portals Management";

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="ReturnReceiptHeaderDb">Record "Return Receipt Header".</param>
    procedure FilterData(ReturnReceiptHeaderDb: Record "Return Receipt Header")
    var
        ReturnReceiptLineDb: Record "Return Receipt Line";
        SalesCommentLineDb: Record "Sales Comment Line";
    begin
        ReturnReceiptHeaderDb.Get(noFilter);
        ReturnReceiptHeader.TransferFields(ReturnReceiptHeaderDb);
        ReturnReceiptHeader.Insert();

        ReturnReceiptLineDb.Reset();
        ReturnReceiptLineDb.SetRange("Document No.", noFilter);

        if not ReturnReceiptLineDb.FindSet() then exit;

        repeat
            ReturnReceiptLine.TransferFields(ReturnReceiptLineDb);
            ReturnReceiptLine.Insert();
        until ReturnReceiptLineDb.Next() = 0;

        SalesCommentLineDb.Reset();
        SalesCommentLineDb.SetRange("No.", noFilter);

        if not SalesCommentLineDb.FindSet() then exit;

        repeat
            SalesCommentLine.TransferFields(SalesCommentLineDb);
            SalesCommentLine.Insert();
        until SalesCommentLineDb.Next() = 0;
    end;
}

