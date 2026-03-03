/// <summary>
/// Report PDC Portal - Draft Order (ID 50032).
/// </summary>
Report 50032 "PDC Portal - Draft Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalDraftOrder.rdlc';
    Caption = 'Draft Order';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;

    dataset
    {
        dataitem(Header; "PDC Draft Order Header")
        {
            DataItemTableView = sorting("Document No.");
            RequestFilterFields = "Document No.", "Sell-to Customer No.";

            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoLbl)
            {
            }
            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyGiroNo_Lbl; CompanyInfoGiroNoLbl)
            {
            }
            column(CompanyBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyBankName_Lbl; CompanyInfoBankNameLbl)
            {
            }
            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyBankBranchNo_Lbl; CompanyInfo.FieldCaption("Bank Branch No."))
            {
            }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoLbl)
            {
            }
            column(CompanyIBAN; CompanyInfo.Iban)
            {
            }
            column(CompanyIBAN_Lbl; CompanyInfo.FieldCaption(Iban))
            {
            }
            column(CompanySWifT; CompanyInfo."SWifT Code")
            {
            }
            column(CompanySWifT_Lbl; CompanyInfo.FieldCaption("SWifT Code"))
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber())
            {
            }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl())
            {
            }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl())
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl())
            {
            }
            column(CompanyLegalOffice; '') //CompanyInfo.GetLegalOffice())
            {
            }
            column(CompanyLegalOffice_Lbl; '') //CompanyInfo.GetLegalOfficeLbl())
            {
            }
            column(CompanyCustomGiro; '') //CompanyInfo.GetCustomGiro())
            {
            }
            column(CompanyCustomGiro_Lbl; '') //CompanyInfo.GetCustomGiroLbl())
            {
            }
            column(CompanyLegalStatement; GetLegalStatement())
            {
            }
            column(CustomerAddress1; CustAddr[1])
            {
            }
            column(CustomerAddress2; CustAddr[2])
            {
            }
            column(CustomerAddress3; CustAddr[3])
            {
            }
            column(CustomerAddress4; CustAddr[4])
            {
            }
            column(CustomerAddress5; CustAddr[5])
            {
            }
            column(CustomerAddress6; CustAddr[6])
            {
            }
            column(CustomerAddress7; CustAddr[7])
            {
            }
            column(CustomerAddress8; CustAddr[8])
            {
            }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
            {
            }
            column(YourReference; "PO No.")
            {
            }
            column(YourReference_Lbl; FieldCaption("Your Reference"))
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(ShipmentMethodDescription_Lbl; ShptMethodDescLbl)
            {
            }
            column(ShipmentDate; Format(Dt2Date(Header."Created Date"), 0, 4))
            {
            }
            column(ShipmentDate_Lbl; PostedShipmentDateLbl)
            {
            }
            column(Shipment_Lbl; ShipmentLbl)
            {
            }
            column(ShowShippingAddress; ShowShippingAddr)
            {
            }
            column(ShipToAddress_Lbl; ShiptoAddrLbl)
            {
            }
            column(ShipToAddress1; ShipToAddr[1])
            {
            }
            column(ShipToAddress2; ShipToAddr[2])
            {
            }
            column(ShipToAddress3; ShipToAddr[3])
            {
            }
            column(ShipToAddress4; ShipToAddr[4])
            {
            }
            column(ShipToAddress5; ShipToAddr[5])
            {
            }
            column(ShipToAddress6; ShipToAddr[6])
            {
            }
            column(ShipToAddress7; ShipToAddr[7])
            {
            }
            column(ShipToAddress8; ShipToAddr[8])
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentTermsDescription_Lbl; PaymentTermsDescLbl)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(PaymentMethodDescription_Lbl; PaymentMethodDescLbl)
            {
            }
            column(DocumentCopyText; StrSubstNo(DocumentCaption(), CopyText))
            {
            }
            column(BilltoCustumerNo; "Sell-to Customer No.")
            {
            }
            column(BilltoCustomerNo_Lbl; FieldCaption("Sell-to Customer No."))
            {
            }
            column(DocumentDate; Format(Dt2Date(Header."Created Date"), 0, 4))
            {
            }
            column(DocumentDate_Lbl; DocumentDate_Lbl)
            {
            }
            column(DueDate; Format(Dt2Date(Header."Created Date"), 0, 4))
            {
            }
            column(DueDate_Lbl; DueDate_Lbl)
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentNo_Lbl; DocNoLbl)
            {
            }
            column(OrderNo; "PO No.")
            {
            }
            column(OrderNo_Lbl; FieldCaption("PO No."))
            {
            }
            column(SalesPerson_Lbl; SalespersonLbl)
            {
            }
            column(SalesPersonBlank_Lbl; SalesPersonText)
            {
            }
            column(SalesPersonName; SalespersonPurchaser.Name)
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerNo_Lbl; FieldCaption("Sell-to Customer No."))
            {
            }
            column(VATRegistrationNo; Cust."VAT Registration No.")
            {
            }
            column(VATRegistrationNo_Lbl; Cust.FieldCaption("VAT Registration No."))
            {
            }
            column(LegalEntityType; Cust.GetLegalEntityType())
            {
            }
            column(LegalEntityType_Lbl; Cust.GetLegalEntityTypeLbl())
            {
            }
            column(Copy_Lbl; CopyLbl)
            {
            }
            column(EMail_Header_Lbl; EMailLbl)
            {
            }
            column(HomePage_Header_Lbl; HomePageLbl)
            {
            }
            column(InvoiceDiscountBaseAmount_Lbl; InvDiscBaseAmtLbl)
            {
            }
            column(InvoiceDiscountAmount_Lbl; InvDiscountAmtLbl)
            {
            }
            column(LineAmountAfterInvoiceDiscount_Lbl; LineAmtAfterInvDiscLbl)
            {
            }
            column(LocalCurrency_Lbl; LocalCurrencyLbl)
            {
            }
            column(ExchangeRateAsText; ExchangeRateText)
            {
            }
            column(Page_Lbl; PageLbl)
            {
            }
            column(SalesInvoiceLineDiscount_Lbl; SalesInvLineDiscLbl)
            {
            }
            column(DocumentTitle_Lbl; DocumentLbl)
            {
            }
            column(Subtotal_Lbl; SubtotalLbl)
            {
            }
            column(Total_Lbl; TotalLbl)
            {
            }
            column(VATAmount_Lbl; VATAmtLbl)
            {
            }
            column(VATBase_Lbl; VATBaseLbl)
            {
            }
            column(VATAmountSpecification_Lbl; VATAmtSpecificationLbl)
            {
            }
            column(VATClauses_Lbl; VATClausesLbl)
            {
            }
            column(VATIdentifier_Lbl; VATIdentifierLbl)
            {
            }
            column(VATPercentage_Lbl; VATPercentageLbl)
            {
            }
            column(CustomerReference; "Your Reference")
            {
            }
            column(CustomerReference_Lbl; FieldCaption("Your Reference"))
            {
            }
            column(User_ID; Header."Created By ID")
            {
            }
            column(User_Name; PortalUser.Name)
            {
            }
            column(User_ID_Lbl; User_ID_Lbl)
            {
            }
            column(User_Name_Lbl; User_Name_Lbl)
            {
            }
            dataitem(StaffLine; "PDC Draft Order Staff Line")
            {
                CalcFields = "Staff Name", "Wearer ID", "Branch ID";
                DataItemLink = "Document No." = field("Document No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ReportForNavId_1000000032; 1000000032)
                {
                }
                dataitem(Line; "PDC Draft Order Item Line")
                {
                    DataItemLink = "Document No." = field("Document No."), "Staff Line No." = field("Line No.");
                    DataItemLinkReference = StaffLine;
                    DataItemTableView = sorting("Product Code", "Colour Sequence", "Fit Sequence", "Size Sequence") where("Item No." = filter(<> ''), Quantity = filter(<> 0));
                    column(ReportForNavId_1570; 1570)
                    {
                    }
                    column(LineNo_Line; "Line No.")
                    {
                    }
                    column(AmountExcludingVAT_Line; "Line Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(AmountExcludingVAT_Line_Lbl; FieldCaption("Line Amount"))
                    {
                    }
                    column(AmountIncludingVAT_Line; "Line Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(AmountIncludingVAT_Line_Lbl; FieldCaption("Line Amount"))
                    {
                        AutoFormatType = 1;
                    }
                    column(Description_Line; "Item Description")
                    {
                    }
                    column(Description_Line_Lbl; FieldCaption("Item Description"))
                    {
                    }
                    column(LineDiscountPercent_Line; 0)
                    {
                    }
                    column(LineDiscountPercentText_Line; LineDiscountPctText)
                    {
                    }
                    column(LineAmount_Line; "Line Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(LineAmount_Line_Lbl; FieldCaption("Line Amount"))
                    {
                    }
                    column(Type_Line; 'Item')
                    {
                    }
                    column(ItemNo_Line; "Item No.")
                    {
                    }
                    column(ItemNo_Line_Lbl; FieldCaption("Item No."))
                    {
                    }
                    column(Quantity_Line; Quantity)
                    {
                    }
                    column(Quantity_Line_Lbl; FieldCaption(Quantity))
                    {
                    }
                    column(UnitPrice; "Unit Price")
                    {
                        AutoFormatType = 1;
                    }
                    column(UnitPrice_Lbl; FieldCaption("Unit Price"))
                    {
                    }
                    column(UnitOfMeasure; "Unit Of Measure Code")
                    {
                    }
                    column(UnitOfMeasure_Lbl; FieldCaption("Unit Of Measure Code"))
                    {
                    }
                    column(VATPct_Line; VATPostingSetup."VAT %")
                    {
                    }
                    column(VATPct_Line_Lbl; VATPostingSetup.FieldCaption("VAT %"))
                    {
                    }
                    column(TransHeaderAmount; TransHeaderAmount)
                    {
                        AutoFormatType = 1;
                    }
                    column(ProtexSKU; "Product Code")
                    {
                    }
                    column(ProtexSKU_Lbl; FieldCaption("Product Code"))
                    {
                    }
                    column(Colour; Item."PDC Colour")
                    {
                    }
                    column(Size; Item."PDC Size")
                    {
                    }
                    column(Fit; Item."PDC Fit")
                    {
                    }
                    column(Colour_Lbl; Item.FieldCaption("PDC Colour"))
                    {
                    }
                    column(Size_Lbl; Item.FieldCaption("PDC Size"))
                    {
                    }
                    column(Fit_Lbl; Item.FieldCaption("PDC Fit"))
                    {
                    }
                    column(CustomerReferenceLineTD; Header."PO No.")
                    {
                    }
                    column(WebOrderTD; Header."PO No.")
                    {
                    }
                    column(WearerIDTD; StaffLine."Wearer ID")
                    {
                    }
                    column(WearerNameTD; StaffLine."Staff Name")
                    {
                    }
                    column(OrderedByIDTD; Header."Created By ID")
                    {
                    }
                    column(OrderedByNameTD; Header."Created By ID")
                    {
                    }
                    column(BranchNoTD; StaffLine."Branch ID")
                    {
                    }
                    column(OrderedByPhoneTD; Header."Ship-to Mobile Phone No.")
                    {
                    }
                    column(ShipmentCheckTD; Line."Document No.")
                    {
                    }
                    column(StaffName_Lbl; StaffName_Lbl)
                    {
                    }
                    column(StaffID_Lbl; StaffID_Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Item.Get("Item No.");

                        LineDiscountPctText := '';

                        if VATPostingSetup.Get(Cust."VAT Bus. Posting Group", Item."VAT Prod. Posting Group") then begin
                            VATAmountLine.Init();
                            VATAmountLine."VAT Identifier" := VATPostingSetup."VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := '';
                            VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                            VATAmountLine."VAT Base" := "Line Amount";
                            VATAmountLine."Amount Including VAT" := ROUND("Line Amount" * (1 + VATPostingSetup."VAT %" / 100), 0.01);
                            VATAmountLine."Line Amount" := "Line Amount";
                            VATAmountLine."Inv. Disc. Base Amount" := 0;
                            VATAmountLine."Invoice Discount Amount" := 0;
                            VATAmountLine."VAT Clause Code" := '';
                            if (VATAmountLine."VAT %" <> 0) or (VATAmountLine."Line Amount" <> VATAmountLine."Amount Including VAT") then
                                VATAmountLine.InsertLine();
                        end
                        else
                            Clear(VATPostingSetup);

                        TransHeaderAmount += PrevLineAmount;
                        PrevLineAmount := "Line Amount";
                        TotalSubTotal += "Line Amount";
                        TotalInvDiscAmount -= 0;
                        TotalAmount += "Line Amount";
                        TotalAmountVAT += ROUND("Line Amount" * (1 + VATPostingSetup."VAT %" / 100), 0.01) - "Line Amount";
                        TotalAmountInclVAT += ROUND("Line Amount" * (1 + VATPostingSetup."VAT %" / 100), 0.01);
                        TotalPaymentDiscOnVAT += -("Line Amount" - 0 - ROUND("Line Amount" * (1 + VATPostingSetup."VAT %" / 100), 0.01));

                        if FirstLineHasBeenOutput then
                            Clear(CompanyInfo.Picture);
                        FirstLineHasBeenOutput := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATAmountLine.DeleteAll();
                        TransHeaderAmount := 0;
                        PrevLineAmount := 0;
                        FirstLineHasBeenOutput := false;
                        CompanyInfo.CalcFields(Picture);
                    end;
                }
            }
            dataitem(CarriageLine; "Integer")
            {
                DataItemLinkReference = StaffLine;
                DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));

                column(LineNo_Carriage; Number)
                {
                }
                column(AmountExcludingVAT_Carriage; ShippingAgentServices."PDC Carriage Charge")
                {
                    AutoFormatType = 1;
                }
                column(Description_Carriage; ShippingAgentServices.Description)
                {
                }
                column(LineDiscountPercent_Carriage; 0)
                {
                }
                column(LineAmount_Carriage; ShippingAgentServices."PDC Carriage Charge")
                {
                    AutoFormatType = 1;
                }
                column(Type_Carriage; ShippingAgentServices."PDC Carriage Charge Type")
                {
                }
                column(ItemNo_Carriage; '')
                {
                }
                column(Quantity_Carriage; '1')
                {
                }
                column(UnitPrice_Carriage; ShippingAgentServices."PDC Carriage Charge")
                {
                    AutoFormatType = 1;
                }
                column(VATPct_Carriage; VATPostingSetup."VAT %")
                {
                }
                column(TransHeaderAmount_Carriage; TransHeaderAmount)
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord()
                var
                    Customer: Record Customer;
                    GLAcc1: Record "G/L Account";
                    Item1: Record Item;
                    Charge1: Record "Item Charge";
                    VATProd: Record "VAT Product Posting Group";
                    ShipAgentServPerCustomer: Record "PDC Ship.Agent Serv. Per Cust.";
                begin
                    Customer.Get(Header."Sell-to Customer No.");

                    ShippingAgentServices.Reset();
                    ShippingAgentServices.SetCurrentkey("Shipping Agent Code", "PDC Country/Region Code", "PDC Portal Sequence");
                    ShippingAgentServices.setrange("Shipping Agent Code", Customer."Shipping Agent Code");
                    ShippingAgentServices.SetFilter("PDC Carriage Charge Limit", '>%1', 0);
                    ShippingAgentServices.SetRange("PDC Show On Portal", true);
                    ShippingAgentServices.SetFilter("PDC Country/Region Code", '%1|%2', Header."Ship-to Country/Region Code", '');
                    if not ShippingAgentServices.FindFirst() then
                        CurrReport.Skip();
                    if Customer."PDC Carriage Charge Limit" > 0 then
                        ShippingAgentServices."PDC Carriage Charge Limit" := Customer."PDC Carriage Charge Limit";

                    if ShippingAgentServices."PDC Check Carriage Limit" then
                        if ShippingAgentServices."PDC Carriage Charge Limit" <= TotalAmount then
                            CurrReport.Skip();

                    ShipAgentServPerCustomer.Reset();
                    ShipAgentServPerCustomer.SetRange("Shipping Agent Code", ShippingAgentServices."Shipping Agent Code");
                    ShipAgentServPerCustomer.SetRange("Shipping Agent Service Code", ShippingAgentServices.Code);
                    ShipAgentServPerCustomer.SetRange("Customer No.", Header."Sell-to Customer No.");
                    if ShipAgentServPerCustomer.FindFirst() then
                        ShippingAgentServices."PDC Carriage Charge" := ShipAgentServPerCustomer."Carriage Charge";

                    Clear(VATProd);
                    if (ShippingAgentServices."PDC Carriage Charge Type".AsInteger() = 1) and (GLAcc1.Get(ShippingAgentServices."PDC Carriage Charge No.")) then begin
                        ShippingAgentServices.Description := GLAcc1.Name;
                        if VATProd.Get(GLAcc1."VAT Prod. Posting Group") then;
                    end
                    else
                        if (ShippingAgentServices."PDC Carriage Charge Type".AsInteger() = 2) and (Item1.Get(ShippingAgentServices."PDC Carriage Charge No.")) then begin
                            ShippingAgentServices.Description := Item1.Description;
                            if VATProd.Get(Item1."VAT Prod. Posting Group") then;
                        end
                        else
                            if (ShippingAgentServices."PDC Carriage Charge Type".AsInteger() = 3) and (Charge1.Get(ShippingAgentServices."PDC Carriage Charge No.")) then begin
                                ShippingAgentServices.Description := Charge1.Description;
                                if VATProd.Get(Charge1."VAT Prod. Posting Group") then;
                            end;

                    if VATProd.Code <> '' then
                        if VATPostingSetup.Get(Cust."VAT Bus. Posting Group", VATProd.Code) then begin
                            VATAmountLine.Init();
                            VATAmountLine."VAT Identifier" := VATPostingSetup."VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := '';
                            VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                            VATAmountLine."VAT Base" := ShippingAgentServices."PDC Carriage Charge";
                            VATAmountLine."Amount Including VAT" := ROUND(ShippingAgentServices."PDC Carriage Charge" * (1 + VATPostingSetup."VAT %" / 100), 0.01);
                            VATAmountLine."Line Amount" := ShippingAgentServices."PDC Carriage Charge";
                            VATAmountLine."Inv. Disc. Base Amount" := 0;
                            VATAmountLine."Invoice Discount Amount" := 0;
                            VATAmountLine."VAT Clause Code" := '';
                            if (VATAmountLine."VAT %" <> 0) or (VATAmountLine."Line Amount" <> VATAmountLine."Amount Including VAT") then
                                VATAmountLine.InsertLine();
                        end
                        else
                            Clear(VATPostingSetup);

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := ShippingAgentServices."PDC Carriage Charge";
                    TotalSubTotal += ShippingAgentServices."PDC Carriage Charge";
                    TotalInvDiscAmount -= 0;
                    TotalAmount += ShippingAgentServices."PDC Carriage Charge";
                    TotalAmountVAT += ROUND(ShippingAgentServices."PDC Carriage Charge" * (1 + VATPostingSetup."VAT %" / 100), 0.01) - ShippingAgentServices."PDC Carriage Charge";
                    TotalAmountInclVAT += ROUND(ShippingAgentServices."PDC Carriage Charge" * (1 + VATPostingSetup."VAT %" / 100), 0.01);
                    TotalPaymentDiscOnVAT += -(ShippingAgentServices."PDC Carriage Charge" - 0 - ROUND(ShippingAgentServices."PDC Carriage Charge" * (1 + VATPostingSetup."VAT %" / 100), 0.01));
                end;
            }

            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;

                column(InvoiceDiscountAmount_VATAmountLine; "Invoice Discount Amount")
                {
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountAmount_VATAmountLine_Lbl; FieldCaption("Invoice Discount Amount"))
                {
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine_Lbl; FieldCaption("Inv. Disc. Base Amount"))
                {
                }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                    AutoFormatType = 1;
                }
                column(LineAmount_VatAmountLine_Lbl; FieldCaption("Line Amount"))
                {
                }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                    AutoFormatType = 1;
                }
                column(VATAmount_VatAmountLine_Lbl; FieldCaption("VAT Amount"))
                {
                }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY)
                {
                }
                column(VATAmountLCY_VATAmountLine_Lbl; VATAmountLCYLbl)
                {
                }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                    AutoFormatType = 1;
                }
                column(VATBase_VatAmountLine_Lbl; FieldCaption("VAT Base"))
                {
                }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY)
                {
                }
                column(VATBaseLCY_VATAmountLine_Lbl; VATBaseLCYLbl)
                {
                }
                column(VATIdentifier_VatAmountLine; "VAT Identifier")
                {
                }
                column(VATIdentifier_VatAmountLine_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(VATPct_VatAmountLine; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATPct_VatAmountLine_Lbl; FieldCaption("VAT %"))
                {
                }
                column(NoOfVATIdentifiers; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY := GetBaseLCY(WorkDate(), '', 0);
                    VATAmountLCY := GetAmountLCY(WorkDate(), '', 0);

                    TotalVATBaseLCY += VATBaseLCY;
                    TotalVATAmountLCY += VATAmountLCY;
                end;

                trigger OnPreDataItem()
                begin
                    TotalVATBaseLCY := 0;
                    TotalVATAmountLCY := 0;
                end;
            }
            dataitem(ReportTotalsLine; "Report Totals Buffer")
            {
                DataItemTableView = sorting("Line No.");
                UseTemporary = true;

                column(Description_ReportTotalsLine; Description)
                {
                }
                column(Amount_ReportTotalsLine; Amount)
                {
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted")
                {
                }
                column(FontBold_ReportTotalsLine; "Font Bold")
                {
                }
                column(FontUnderline_ReportTotalsLine; "Font Underline")
                {
                }

                trigger OnPreDataItem()
                begin
                    CreateReportTotalLines();
                end;
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_99; 99)
                {
                }
                column(TotalNetAmount; TotalAmount)
                {
                    AutoFormatType = 1;
                }
                column(TotalVATBaseLCY; TotalVATBaseLCY)
                {
                }
                column(TotalAmountIncludingVAT; TotalAmountInclVAT)
                {
                    AutoFormatType = 1;
                }
                column(TotalVATAmount; TotalAmountVAT)
                {
                    AutoFormatType = 1;
                }
                column(TotalVATAmountLCY; TotalVATAmountLCY)
                {
                }
                column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
                {
                    AutoFormatType = 1;
                }
                column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
                {
                }
                column(TotalVATAmountText; VATAmountLine.VATAmountText())
                {
                }
                column(TotalExcludingVATText; TotalExclVATText)
                {
                }
                column(TotalIncludingVATText; TotalInclVATText)
                {
                }
                column(TotalSubTotal; TotalSubTotal)
                {
                    AutoFormatType = 1;
                }
                column(TotalSubTotalMinusInvoiceDiscount; TotalSubTotal + TotalInvDiscAmount)
                {
                }
                column(TotalText; TotalText)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                SalespersonPurchaser.Init();
                SalesPersonText := '';

                GLSetup.TestField("LCY Code");
                TotalText := StrSubstNo(TotalTextLbl, GLSetup."LCY Code");
                TotalInclVATText := StrSubstNo(TotalInclVATTextLbl, GLSetup."LCY Code");
                TotalExclVATText := StrSubstNo(TotalExclVATTextLbl, GLSetup."LCY Code");

                FormatAddr.FormatAddr(
                    CustAddr, "Sell-to Customer Name", "Sell-to Customer Name 2", "Sell-to Contact", "Sell-to Address", "Sell-to Address 2",
                    "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code");
                if not Cust.Get("Sell-to Customer No.") then
                    Clear(Cust);

                PaymentTerms.Init();
                PaymentMethod.Init();
                ShipmentMethod.Init();

                FormatAddr.FormatAddr(
                    ShipToAddr, "Ship-to Name", "Ship-to Name 2", "Ship-to Contact", "Ship-to Address", "Ship-to Address 2",
                    "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code");

                ShowShippingAddr := true;

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;

                PortalUser.SetRange("Contact No.", "Created By ID");
                if not PortalUser.FindFirst() then Clear(PortalUser);
            end;

            trigger OnPreDataItem()
            begin
                FirstLineHasBeenOutput := false;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATPostingSetup: Record "VAT Posting Setup";
        PortalUser: Record "PDC Portal User";
        Item: Record Item;
        ShippingAgentServices: Record "Shipping Agent Services";
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        LineDiscountPctText: Text;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TransHeaderAmount: Decimal;
        CompanyLogoPosition: Integer;
        FirstLineHasBeenOutput: Boolean;
        ExchangeRateText: Text;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        PrevLineAmount: Decimal;
        DocumentDate_Lbl: label 'Document Date';
        DueDate_Lbl: label 'Due Date';
        User_ID_Lbl: label 'User ID';
        User_Name_Lbl: label 'User Name';
        StaffName_Lbl: label 'Staff Name';
        StaffID_Lbl: label 'Staff ID';
        TotalTextLbl: label 'Total %1', Comment = '%1=currency';
        TotalInclVATTextLbl: label 'Total %1 Incl. VAT', Comment = '%1=currency';
        DocumentNoLbl: label 'Draft Order %1', Comment = '%1=document';
        TotalExclVATTextLbl: label 'Total %1 Excl. VAT', Comment = '%1=currency';
        SalespersonLbl: label 'Sales person';
        CompanyInfoBankAccNoLbl: label 'Account No.';
        CompanyInfoBankNameLbl: label 'Bank';
        CompanyInfoGiroNoLbl: label 'Giro No.';
        CompanyInfoPhoneNoLbl: label 'Phone No.';
        CopyLbl: label 'Copy';
        EMailLbl: label 'Email';
        HomePageLbl: label 'Home Page';
        InvDiscBaseAmtLbl: label 'Invoice Discount Base Amount';
        InvDiscountAmtLbl: label 'Invoice Discount';
        DocNoLbl: label 'Draft Order No.';
        LineAmtAfterInvDiscLbl: label 'Payment Discount on VAT';
        LocalCurrencyLbl: label 'Local Currency';
        PageLbl: label 'Page';
        PaymentTermsDescLbl: label 'Payment Terms';
        PaymentMethodDescLbl: label 'Payment Method';
        PostedShipmentDateLbl: label 'Shipment Date';
        SalesInvLineDiscLbl: label 'Discount %';
        DocumentLbl: label 'Draft Order';
        ShipmentLbl: label 'Shipment';
        ShiptoAddrLbl: label 'Ship-to Address';
        ShptMethodDescLbl: label 'Shipment Method';
        SubtotalLbl: label 'Subtotal';
        TotalLbl: label 'Total';
        VATAmtSpecificationLbl: label 'VAT Amount Specification';
        VATAmtLbl: label 'VAT Amount';
        VATAmountLCYLbl: label 'VAT Amount (LCY)';
        VATBaseLbl: label 'VAT Base';
        VATBaseLCYLbl: label 'VAT Base (LCY)';
        VATClausesLbl: label 'VAT Clause';
        VATIdentifierLbl: label 'VAT Identifier';
        VATPercentageLbl: label 'VAT %';

    local procedure DocumentCaption(): Text[250]
    begin
        exit(DocumentNoLbl);
    end;

    local procedure CreateReportTotalLines()
    begin
        ReportTotalsLine.DeleteAll();
        if (TotalInvDiscAmount <> 0) or (TotalAmountVAT <> 0) then
            ReportTotalsLine.Add(SubtotalLbl, TotalSubTotal, true, false, false);
        if TotalInvDiscAmount <> 0 then begin
            ReportTotalsLine.Add(InvDiscountAmtLbl, TotalInvDiscAmount, false, false, false);
            if TotalAmountVAT <> 0 then
                ReportTotalsLine.Add(TotalExclVATText, TotalAmount, true, false, false);
        end;
        if TotalAmountVAT <> 0 then
            ReportTotalsLine.Add(VATAmountLine.VATAmountText(), TotalAmountVAT, false, true, false);
    end;

    local procedure GetLegalStatement(): Text
    begin
        SalesSetup.Get();
        exit(SalesSetup.GetLegalStatement());
    end;
}

