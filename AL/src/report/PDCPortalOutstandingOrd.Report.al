/// <summary>
/// Report PDC Portal - Outstanding Ord. (ID 50052).
/// </summary>
Report 50052 "PDC Portal - Outstanding Ord."
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalOutstandingOrders.rdlc';
    Caption = 'Portal - Outstanding Orders';

    dataset
    {
        dataitem(Header; "Sales Header")
        {
            DataItemTableView = where("Document Type" = CONST(Order));

            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                CalcFields = "PDC Contract Code";

                column(OrderNo; Header."No.")
                {
                    IncludeCaption = true;
                }
                column(Ship_to_Address; Header."Ship-to Address")
                {
                    IncludeCaption = true;
                }
                column(Ship_to_Address2; Header."Ship-to Address 2")
                {
                    IncludeCaption = true;
                }
                column(Ship_to_City; Header."Ship-to City")
                {
                    IncludeCaption = true;
                }
                column(Ship_to_County; Header."Ship-to County")
                {
                    IncludeCaption = true;
                }
                column(Ship_to_Post_Code; Header."Ship-to Post Code")
                {
                    IncludeCaption = true;
                }
                column(Ship_to_Country_Region_Code; Header."Ship-to Country/Region Code")
                {
                    IncludeCaption = true;
                }
                column(Order_Date; Header."Order Date")
                {
                    IncludeCaption = true;
                }
                column(Order_Date_Formatted; PortalsMgt.FormatDate(Header."Order Date"))
                {
                }
                column(ItemNo; "No.")
                {
                    IncludeCaption = true;
                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Qty__Shipped_Not_Invoiced; "Qty. Shipped Not Invoiced")
                {
                    IncludeCaption = true;
                }
                column(Outstanding_Quantity; "Outstanding Quantity")
                {
                    IncludeCaption = true;
                }
                column(Unit_Price; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(Wearer_Name; "PDC Wearer Name")
                {
                    IncludeCaption = true;
                }
                column(Wearer_ID; "PDC Wearer ID")
                {
                    IncludeCaption = true;
                }
                column(Ordered_By_Name; "PDC Ordered By Name")
                {
                    IncludeCaption = true;
                }
                column(Ordered_By_ID; "PDC Ordered By ID")
                {
                    IncludeCaption = true;
                }
                column(Branch_No_; "PDC Branch No.")
                {
                    IncludeCaption = true;
                }
                column(Customer_Reference; "PDC Customer Reference")
                {
                    IncludeCaption = true;
                }
                column(ContractNo; "PDC Contract Code")
                {
                    IncludeCaption = true;
                }

                trigger OnPreDataItem()
                begin
                    if branchFilter <> '' then
                        setfilter("PDC Branch No.", branchFilter);
                end;

            }

            trigger OnPreDataItem()
            begin
                setfilter("Sell-to Customer No.", CustomerNo);
            end;


            trigger OnAfterGetRecord()
            begin

                LinesInDataset += 1;
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

    trigger OnPreReport()
    begin
        if not PortalUser.get(PortalUserID) then clear(PortalUser);
        branchFilter := GetMyBranchesFilter(PortalUser)
    end;


    var
        PortalUser: Record "PDC Portal User";
        PortalsMgt: Codeunit "PDC Portals Management";

        CustomerNo: Text;
        PortalUserID: Text;
        branchFilter: Text;
        LinesInDataset: Integer;

    /// <summary>
    /// GetMyBranchesFilter.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Text.</returns>
    procedure InitializeRequest(NewCustomerNo: text; NewPortalUserID: Text)
    begin
        CustomerNo := NewCustomerNo;
        PortalUserID := NewPortalUserID;
    end;

    local procedure GetMyBranchesFilter(var PortalUser1: Record "PDC Portal User"): Text
    var
        PortalUserBranch: Record "PDC Portal User Branch";
        BranchFilter1: Text;
    begin

        PortalUserBranch.Reset();
        PortalUserBranch.SetRange("Portal User ID", PortalUser1.Id);
        if not PortalUserBranch.FindSet() then exit('1&0');

        repeat
            if BranchFilter1 <> '' then BranchFilter1 := BranchFilter1 + '|';
            BranchFilter1 := BranchFilter1 + PortalUserBranch."Branch ID";
        until PortalUserBranch.Next() = 0;

        exit(BranchFilter1);
    end;
}

