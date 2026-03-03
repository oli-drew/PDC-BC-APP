/// <summary>
/// Report PDC Period Consolid. Invoice (ID 50034).
/// </summary>
Report 50034 "PDC Period Consolid. Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PeriodConsolidatedInvoice.rdlc';
    Caption = 'Period Consolidated Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Date Filter";

            column(Name_Customer; Customer.Name)
            {
            }
            column(Name2_Customer; Customer."Name 2")
            {
            }
            column(Address_Customer; Customer.Address)
            {
            }
            column(Address2_Customer; Customer."Address 2")
            {
            }
            column(City_Customer; Customer.City)
            {
            }
            column(PostCode_Customer; Customer."Post Code")
            {
            }
            column(InvPeriodTxt; InvPeriodTxt)
            {
            }
            column(InvDate; Format(PeriodTo, 0, '<Day,2>. <Month Text> <Year4>'))
            {
            }
            column(InvNo; InvNo)
            {
            }
            column(InvAmt; Amt)
            {
            }
            column(InvVatAmt; AmtInclVAT - Amt)
            {
            }
            column(InvAmtInclVAT; AmtInclVAT)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Amt);
                Clear(AmtInclVAT);

                SalesInvHdr.SetRange("Sell-to Customer No.", "No.");
                SalesInvHdr.SetRange("Posting Date", PeriodFrom, PeriodTo);
                if SalesInvHdr.Findset() then
                    repeat
                        SalesInvHdr.CalcFields(Amount, "Amount Including VAT");
                        Amt += SalesInvHdr.Amount;
                        AmtInclVAT += SalesInvHdr."Amount Including VAT";
                    until SalesInvHdr.next() = 0;

                SalesCMHdr.SetRange("Sell-to Customer No.", "No.");
                SalesCMHdr.SetRange("Posting Date", PeriodFrom, PeriodTo);
                if SalesCMHdr.Findset() then
                    repeat
                        SalesCMHdr.CalcFields(Amount, "Amount Including VAT");
                        Amt -= SalesCMHdr.Amount;
                        AmtInclVAT -= SalesCMHdr."Amount Including VAT";
                    until SalesCMHdr.next() = 0;

                InvNo := "No." + Format(PeriodTo, 0, '<Year4><Month,2><Day,2>');
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

    labels
    {
    }

    trigger OnPreReport()
    begin
        PeriodFrom := Customer.GetRangeMin("Date Filter");
        PeriodTo := Customer.GetRangemax("Date Filter");

        InvPeriodTxt := StrSubstNo(InvPeriodLbl,
                                   Format(PeriodFrom, 0, '<Day,2>/<Month,2>/<Year4>'),
                                   Format(PeriodTo, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;

    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCMHdr: Record "Sales Cr.Memo Header";
        InvPeriodTxt: Text;
        InvPeriodLbl: label 'Consolidated Invoice range %1 .. %2', Comment = '%1,%2=period';
        PeriodFrom: Date;
        PeriodTo: Date;
        Amt: Decimal;
        AmtInclVAT: Decimal;
        InvNo: Text;
}

