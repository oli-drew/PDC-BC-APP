/// <summary>
/// Report PDC Portal - Staff List (ID 50027).
/// </summary>
Report 50027 "PDC Portal - Staff List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalStaffList.rdlc';
    Caption = 'Portal - Contracts';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(Staff; "PDC Branch Staff")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Staff ID") where(Blocked = const(false));
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(StaffID_Staff; Staff."Staff ID")
                {
                    IncludeCaption = true;
                }
                column(SelltoCustomerNo_Staff; Staff."Sell-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(BranchID_Staff; Staff."Branch ID")
                {
                    IncludeCaption = true;
                }
                column(FirstName_Staff; Staff."First Name")
                {
                    IncludeCaption = true;
                }
                column(LastName_Staff; Staff."Last Name")
                {
                    IncludeCaption = true;
                }
                column(BodyTypeGender_Staff; Staff."Body Type/Gender")
                {
                    IncludeCaption = true;
                }
                column(WearerID_Staff; Staff."Wearer ID")
                {
                    IncludeCaption = true;
                }
                column(WardrobeID_Staff; Staff."Wardrobe ID")
                {
                    IncludeCaption = true;
                }
                column(WardrobeDescription_Staff; Staff."Wardrobe Description")
                {
                    IncludeCaption = true;
                }
                column(ContractID_Staff; Staff."Contract ID")
                {
                    IncludeCaption = true;
                }
                column(EmailAddress_Staff; Staff."Email Address")
                {
                    IncludeCaption = true;
                }
                column(Blocked_Staff; Staff.Blocked)
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    LinesInDataset += 1;
                end;

                trigger OnPreDataItem()
                begin
                    if BranchFilter <> '' then
                        SetFilter("Branch ID", BranchFilter);
                end;
            }

            trigger OnPreDataItem()
            begin
                if CustNoFilter <> '' then
                    SetFilter("No.", CustNoFilter);

                if UpperCase(BranchFilter) = 'ALL' then
                    Clear(BranchFilter);
            end;
        }
        dataitem(BlankReportLine; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(ReportForNavId_1000000011; 1000000011)
            {
            }
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Customer Filter"; CustNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Filter';
                        ToolTip = 'Customer Filter';
                        TableRelation = Customer;
                    }
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

    var
        CustNoFilter: Text;
        PortalUserID: Text;
        BranchFilter: Text;
        LinesInDataset: Integer;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewCustNoFilter">Text.</param>
    /// <param name="NewPortalUserID">Text.</param>
    /// <param name="NewbranchFilter">Text.</param>
    procedure InitializeRequest(NewCustNoFilter: Text; NewPortalUserID: Text; NewbranchFilter: Text)
    begin
        CustNoFilter := NewCustNoFilter;
        PortalUserID := NewPortalUserID;
        BranchFilter := NewbranchFilter;
    end;
}

