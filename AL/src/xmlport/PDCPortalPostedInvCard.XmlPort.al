/// <summary>
/// XmlPort PDC Portal Posted Inv. Card (ID 50057).
/// </summary>
XmlPort 50057 "PDC Portal Posted Inv. Card"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(data)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            tableelement(compaddrbuff; "Name/Value Buffer")
            {
                MinOccurs = Zero;
                XmlName = 'companyAddr';
                UseTemporary = true;
                fieldelement(text; CompAddrBuff.Value)
                {
                }
            }
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(f_nofilter)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'noFilter';
                }
            }
            tableelement(invoiceheader; "Sales Invoice Header")
            {
                MinOccurs = Zero;
                XmlName = 'invoice';
                UseTemporary = true;
                fieldelement(no; InvoiceHeader."No.")
                {
                }
                tableelement(buyfromaddrbuff; "Name/Value Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'buyFromAddr';
                    UseTemporary = true;
                    fieldelement(text; BuyFromAddrBuff.Value)
                    {
                    }
                }
                tableelement(paytoaddrbuff; "Name/Value Buffer")
                {
                    XmlName = 'payToAddr';
                    fieldelement(text; PayToAddrBuff.Value)
                    {
                    }
                }
                textelement(invoiceheader_postingdate)
                {
                    XmlName = 'postingDate';
                }
                textelement(invoiceheader_documentdate)
                {
                    XmlName = 'documentDate';
                }
                textelement(invoiceheader_duedate)
                {
                    XmlName = 'dueDate';
                }
                fieldelement(amount; InvoiceHeader.Amount)
                {
                }
                fieldelement(amountInclVat; InvoiceHeader."Amount Including VAT")
                {
                }
                fieldelement(currencyCode; InvoiceHeader."Currency Code")
                {
                }
                fieldelement(paymentTermsCode; InvoiceHeader."Payment Terms Code")
                {
                }
                fieldelement(paymentMethodCode; InvoiceHeader."Payment Method Code")
                {
                }
                fieldelement(transactionType; InvoiceHeader."Transaction Type")
                {
                }
                textelement(invoiceheader_paid)
                {
                    XmlName = 'paid';

                    trigger OnBeforePassVariable()
                    var
                        CustLE: Record "Cust. Ledger Entry";
                    begin
                        CustLE.setrange("Entry No.", invoiceheader."Cust. Ledger Entry No.");
                        CustLE.setrange(Open, true);
                        if CustLE.IsEmpty then
                            InvoiceHeader_Paid := 'Yes'
                        else
                            InvoiceHeader_Paid := 'No';
                    end;
                }
                tableelement(invoiceline; "Sales Invoice Line")
                {
                    LinkFields = "Document No." = field("No.");
                    LinkTable = InvoiceHeader;
                    MinOccurs = Zero;
                    XmlName = 'line';
                    SourceTableView = where(Quantity = filter(<> 0));
                    textattribute(jsonarray)
                    {
                        Occurrence = Optional;
                        XmlName = 'json_Array';
                    }
                    fieldelement(type; InvoiceLine.Type)
                    {
                    }
                    fieldelement(no; InvoiceLine."No.")
                    {
                    }
                    fieldelement(description; InvoiceLine.Description)
                    {
                    }
                    fieldelement(quantity; InvoiceLine.Quantity)
                    {
                    }
                    fieldelement(unitPrice; InvoiceLine."Unit Price")
                    {
                    }
                    fieldelement(amount; InvoiceLine.Amount)
                    {
                    }
                    fieldelement(unitOfMeasure; InvoiceLine."Unit of Measure")
                    {
                    }
                    fieldelement(wearerId; InvoiceLine."PDC Wearer ID")
                    {
                    }
                    fieldelement(wearerName; InvoiceLine."PDC Wearer Name")
                    {
                    }
                    fieldelement(custReference; InvoiceLine."PDC Customer Reference")
                    {
                    }
                    fieldelement(orderedId; InvoiceLine."PDC Ordered By ID")
                    {
                    }
                    fieldelement(orderedName; InvoiceLine."PDC Ordered By Name")
                    {
                    }
                    fieldelement(branch; InvoiceLine."PDC Branch No.")
                    {
                    }
                    fieldelement(overEntitlementReason; InvoiceLine."PDC Over Entitlement Reason")
                    {
                    }
                    textelement(colour)
                    {
                    }
                    textelement(size)
                    {
                    }
                    textelement(fit)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InvoiceHeader.CalcFields(Amount);
                        Clear(colour);
                        Clear(size);
                        Clear(fit);
                        if InvoiceLine.Type = InvoiceLine.Type::Item then
                            if Item.Get(InvoiceLine."No.") then begin
                                colour := Item."PDC Colour";
                                size := Item."PDC Size";
                                fit := Item."PDC Fit";
                            end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    FormatAddr.SalesInvSellTo(BuyFromAddr, InvoiceHeader);
                    SetAddress(BuyFromAddr, BuyFromAddrBuff);

                    FormatAddr.SalesInvBillTo(PayToAddr, InvoiceHeader);
                    SetAddress(PayToAddr, PayToAddrBuff);

                    InvoiceHeader_PostingDate := PortalsMgt.FormatDate(InvoiceHeader."Posting Date");
                    InvoiceHeader_DocumentDate := PortalsMgt.FormatDate(InvoiceHeader."Document Date");

                    InvoiceHeader_DueDate := PortalsMgt.FormatDate(InvoiceHeader."Due Date");
                end;
            }

            trigger OnBeforePassVariable()
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                SetAddress(CompanyAddr, CompAddrBuff);
            end;
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
        jsonArray := 'true';
    end;

    var
        CompanyInfo: Record "Company Information";
        Item: Record Item;
        PortalsMgt: Codeunit "PDC Portals Management";
        CustPortalMgt: Codeunit "PDC Portal Mgt";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[80];
        BuyFromAddr: array[8] of Text[80];
        PayToAddr: array[8] of Text[80];

    procedure InitData()
    begin
    end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User")
    var
        InvoiceHeaderDb: Record "Sales Invoice Header";
    begin
        InvoiceHeaderDb.Reset();
        CustPortalMgt.FilterInvoices(PortalUser, InvoiceHeaderDb);
        InvoiceHeaderDb.SetRange("No.", f_noFilter);

        if (InvoiceHeaderDb.FindFirst()) then begin
            InvoiceHeaderDb.CalcFields(Amount);
            InvoiceHeader.TransferFields(InvoiceHeaderDb);
            InvoiceHeader.Insert();
        end;
    end;

    local procedure SetAddress(var AddressData: array[8] of Text[80]; var AddressBuffer: Record "Name/Value Buffer" temporary)
    var
        i: Integer;
    begin
        AddressBuffer.Reset();
        AddressBuffer.DeleteAll();
        for i := 1 to 8 do
            if (AddressData[i] <> '') then begin
                AddressBuffer.Init();
                AddressBuffer.ID := i;
                AddressBuffer.Name := AddressData[i];
                AddressBuffer.Value := AddressData[i];
                AddressBuffer.Insert();
            end;
    end;
}

