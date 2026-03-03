/// <summary>
/// Report PDC Portal - Contracts (ID 50020).
/// </summary>
Report 50020 "PDC Portal - Contracts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalContracts.rdlc';
    Caption = 'Portal - Contracts';

    dataset
    {
        dataitem(Contract; "PDC Contract")
        {

            column(Description_Contract; Contract.Description)
            {
                IncludeCaption = true;
            }
            column(CustomerNo_Contract; Contract."Customer No.")
            {
                IncludeCaption = true;
            }
            column(ContractCode_Contract; Contract."Contract Code")
            {
                IncludeCaption = true;
            }

            trigger OnAfterGetRecord()
            begin
                if Blocked then
                    CurrReport.Skip();

                LinesInDataset += 1;
            end;

            trigger OnPreDataItem()
            begin
                if CustNoFilter <> '' then
                    SetFilter("Customer No.", CustNoFilter);
            end;
        }
        dataitem(BlankReportLine; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(BlankLine; 'BlankLine')
            {
            }

            trigger OnPreDataItem()
            begin
                if LinesInDataset > 0 then
                    CurrReport.Break();
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

    var
        CustNoFilter: Text;
        LinesInDataset: Integer;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewCustNoFilter">Text.</param>
    procedure InitializeRequest(NewCustNoFilter: Text)
    begin
        CustNoFilter := NewCustNoFilter;
    end;
}

