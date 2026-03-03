/// <summary>
/// XmlPort PDC Portal Posted Cr.M. Card (ID 50058).
/// </summary>
XmlPort 50058 "PDC Portal Posted Cr.M. Card"
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
            tableelement(crmemoheader; "Sales Cr.Memo Header")
            {
                MinOccurs = Zero;
                XmlName = 'crmemo';
                UseTemporary = true;
                fieldelement(no; CrMemoHeader."No.")
                {
                }
                tableelement(selltoaddrbuff; "Name/Value Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'sellToAddr';
                    UseTemporary = true;
                    fieldelement(text; SellToAddrBuff.Value)
                    {
                    }
                }
                tableelement(billtoaddrbuff; "Name/Value Buffer")
                {
                    XmlName = 'billToAddr';
                    fieldelement(text; BillToAddrBuff.Value)
                    {
                    }
                }
                tableelement(shiptoaddrbuff; "Name/Value Buffer")
                {
                    XmlName = 'shipToAddr';
                    fieldelement(text; ShipToAddrBuff.Value)
                    {
                    }
                }
                textelement(crmemoheader_postingdate)
                {
                    XmlName = 'postingDate';
                }
                textelement(crmemoheader_documentdate)
                {
                    XmlName = 'documentDate';
                }
                textelement(crmemoheader_shipmentdate)
                {
                    XmlName = 'shipmentDate';
                }
                fieldelement(amount; CrMemoHeader.Amount)
                {
                }
                fieldelement(amountInclVat; CrMemoHeader."Amount Including VAT")
                {
                }
                fieldelement(currencyCode; CrMemoHeader."Currency Code")
                {
                }
                fieldelement(paymentTermsCode; CrMemoHeader."Payment Terms Code")
                {
                }
                fieldelement(paymentMethodCode; CrMemoHeader."Payment Method Code")
                {
                }
                fieldelement(transactionType; CrMemoHeader."Transaction Type")
                {
                }
                fieldelement(paid; CrMemoHeader.Paid)
                {
                }
                textelement(comment)
                {
                }
                tableelement(crmemoline; "Sales Cr.Memo Line")
                {
                    LinkFields = "Document No." = field("No.");
                    LinkTable = CrMemoHeader;
                    MinOccurs = Zero;
                    XmlName = 'line';
                    SourceTableView = where(Quantity = filter(<> 0));
                    textattribute(jsonarray)
                    {
                        Occurrence = Optional;
                        XmlName = 'json_Array';
                    }
                    fieldelement(type; CrMemoLine.Type)
                    {
                    }
                    fieldelement(no; CrMemoLine."No.")
                    {
                    }
                    fieldelement(description; CrMemoLine.Description)
                    {
                    }
                    fieldelement(quantity; CrMemoLine.Quantity)
                    {
                    }
                    fieldelement(unitPrice; CrMemoLine."Unit Price")
                    {
                    }
                    fieldelement(amount; CrMemoLine.Amount)
                    {
                    }
                    fieldelement(unitOfMeasure; CrMemoLine."Unit of Measure")
                    {
                    }
                    fieldelement(wearerId; CrMemoLine."PDC Wearer ID")
                    {
                    }
                    fieldelement(wearerName; CrMemoLine."PDC Wearer Name")
                    {
                    }
                    fieldelement(custReference; CrMemoLine."PDC Customer Reference")
                    {
                    }
                    fieldelement(orderedId; CrMemoLine."PDC Ordered By ID")
                    {
                    }
                    fieldelement(orderedName; CrMemoLine."PDC Ordered By Name")
                    {
                    }
                    fieldelement(branch; CrMemoLine."PDC Branch No.")
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
                        Clear(colour);
                        Clear(size);
                        Clear(fit);
                        if CrMemoLine.Type = CrMemoLine.Type::Item then
                            if Item.Get(CrMemoLine."No.") then begin
                                colour := Item."PDC Colour";
                                size := Item."PDC Size";
                                fit := Item."PDC Fit";
                            end;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    Line1: Record "Sales Cr.Memo Line";
                begin
                    FormatAddr.SalesCrMemoSellTo(SellToAddr, CrMemoHeader);
                    SetAddress(SellToAddr, SellToAddrBuff);

                    FormatAddr.SalesCrMemoBillTo(BillToAddr, CrMemoHeader);
                    SetAddress(BillToAddr, BillToAddrBuff);

                    FormatAddr.SalesCrMemoShipTo(ShipToAddr, SellToAddr, CrMemoHeader);
                    SetAddress(ShipToAddr, ShipToAddrBuff);

                    CrMemoHeader_PostingDate := PortalsMgt.FormatDate(CrMemoHeader."Posting Date");
                    CrMemoHeader_DocumentDate := PortalsMgt.FormatDate(CrMemoHeader."Document Date");
                    CrMemoHeader_ShipmentDate := PortalsMgt.FormatDate(CrMemoHeader."Shipment Date");

                    Line1.SetRange("Document No.", CrMemoHeader."No.");
                    Line1.SetRange(Type, 0);
                    Line1.SetFilter(Description, '<>%1', '');
                    if not Line1.FindFirst() then Clear(Line1);
                    comment := Line1.Description;
                end;
            }

            trigger OnBeforePassVariable()
            begin
                CompanyInfo.Get();
            end;
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
        SellToAddr: array[8] of Text[80];
        BillToAddr: array[8] of Text[80];
        ShipToAddr: array[8] of Text[50];


    procedure InitData()
    begin
    end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User")
    var
        CrMemoHeaderDb: Record "Sales Cr.Memo Header";
    begin
        CrMemoHeaderDb.Reset();
        CustPortalMgt.FilterCrMemos(PortalUser, CrMemoHeaderDb);
        CrMemoHeaderDb.SetRange("No.", f_noFilter);

        if (CrMemoHeaderDb.FindFirst()) then begin
            CrMemoHeader.TransferFields(CrMemoHeaderDb);
            CrMemoHeader.Insert();
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

