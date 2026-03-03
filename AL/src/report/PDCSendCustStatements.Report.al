/// <summary>
/// Report PDC Send Cust. Statements (ID 50003).
/// </summary>
Report 50003 "PDC Send Cust. Statements"
{
    Caption = 'Send Customer Statements';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", Name, "PDC Default Branch No.";

            trigger OnAfterGetRecord()
            begin
                SendStatement(StartDate, EndDate, false, ShowOutstandingOnly);
            end;

            trigger OnPostDataItem()
            begin
                Message('All Statements have been successfully sent.');
            end;

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then
                    Error(BlankStartDateErr);
                if EndDate = 0D then
                    Error(BlankEndDateErr);
                if StartDate > EndDate then
                    Error(StartDateLaterTheEndDateErr);

                if not Confirm('Would you like to E-Mail the Customer Statement to the selected Customers?') then
                    Error('');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDateFLd; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Start Date';
                }
                field(EndDateFld; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'End Date';
                }
                field(ShowOutstandingOnlyFld; ShowOutstandingOnly)
                {
                    ApplicationArea = All;
                    Caption = 'Show Outstanding Balances Only';
                    ToolTip = 'Show Outstanding Balances Only';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            StartDate := CalcDate('<-CM>', WorkDate());
            EndDate := CalcDate('<CM>', WorkDate());
            ShowOutstandingOnly := true;
        end;
    }

    labels
    {
    }

    var
        StartDate: Date;
        EndDate: Date;
        BlankStartDateErr: label 'Start Date must have a value.';
        BlankEndDateErr: label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: label 'Start date must be earlier than End date.';
        ShowOutstandingOnly: Boolean;
}

