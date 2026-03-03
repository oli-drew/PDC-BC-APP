/// <summary>
/// Report PDC Proposal Print (ID 50036).
/// </summary>
Report 50036 "PDC Proposal Print"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/ProposalPrint.rdlc';
    Caption = 'Proposal';
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;

    dataset
    {
        dataitem(Header; "PDC Proposal Header")
        {
            RequestFilterFields = "No.", "Customer No.", "Contact No.";
            column(DocumentNo; Header."No.")
            {
            }
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
            column(Page_Lbl; PageLbl)
            {
            }
            dataitem(Line; "PDC Proposal Product Line")
            {
                CalcFields = "Branding Routing Cost", "Branding Component Cost";
                DataItemLink = "Proposal No." = field("No.");
                DataItemTableView = sorting("Proposal No.", "Line No.") where("Skip Print" = const(false));

                column(LineNo_Line; "Line No.")
                {
                }
                column(ProductCode; "Product Code")
                {
                    AutoFormatType = 1;
                }
                column(Description; Description)
                {
                }
                column(Colour; ProposalCostingLine.Colour)
                {
                }
                column(Size_Range; "Size Range")
                {
                }
                column(STD_Sizes; "STD Sizes")
                {
                }
                column(Price; ProductPrice)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    Clear(ProductPrice);
                    ProposalCostingLine.Reset();
                    ProposalCostingLine.SetRange("Proposal No.", Line."Proposal No.");
                    ProposalCostingLine.SetRange("Proposal Line No.", Line."Line No.");
                    if ProposalCostingLine.Findset() then
                        repeat
                            ProductPrice += ProposalCostingLine.Price;
                        until ProposalCostingLine.next() = 0;
                    ProposalCostingLine.setfilter(Colour, '<>%1', '');
                    if not ProposalCostingLine.FindFirst() then
                        clear(ProposalCostingLine);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if "Customer No." <> '' then
                    Customer.Get("Customer No.")
                else
                    if Contact.Get(Header."Contact No.") then begin
                        Customer.Init();
                        Customer.Name := Contact.Name;
                        Customer."Name 2" := Contact."Name 2";
                        Customer.Address := Contact.Address;
                        Customer."Address 2" := Contact."Address 2";
                        Customer.City := Contact.City;
                        Customer."Post Code" := Contact."Post Code";
                        Customer.County := Contact.County;
                        Customer."Country/Region Code" := Contact."Country/Region Code";
                    end;

                FormatAddr.FormatAddr(
                    CustAddr, Customer.Name, Customer."Name 2", Customer.Contact, Customer.Address, Customer."Address 2",
                    Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code");
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
        CompanyInfo.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();
    end;

    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        Contact: Record Contact;
        ProposalCostingLine: Record "PDC Proposal Costing Line";
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        ProductPrice: Decimal;
        CompanyInfoPhoneNoLbl: label 'Phone No.';
        PageLbl: label 'Page';
}

