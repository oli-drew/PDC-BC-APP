/// <summary>
/// Report PDC Portal - Staff Sizes (ID 50023).
/// </summary>
Report 50023 "PDC Portal - Staff Sizes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalStaffSizes.rdlc';
    Caption = 'Portal - Contracts';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            column(No_Customer; Customer."No.")
            {
            }
            dataitem(Staff; "PDC Branch Staff")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Staff ID") where(Blocked = const(false));
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                dataitem(StaffSize; "PDC Staff Size")
                {
                    DataItemLink = "Staff ID" = field("Staff ID");
                    DataItemTableView = sorting("Staff ID", "Size Scale Code");

                    column(StaffID_StaffSize; StaffSize."Staff ID")
                    {
                        IncludeCaption = true;
                    }
                    column(WearerID_Staff; Staff."Wearer ID")
                    {
                        IncludeCaption = true;
                    }
                    column(WearerName_Staff; Staff.Name)
                    {
                    }
                    column(SizeScaleCode_StaffSize; StaffSize."Size Scale Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SizeScale; StaffScale.Description)
                    {
                    }
                    column(Description_Caption_SizeScale; StaffScale.FieldCaption(Description))
                    {
                    }
                    column(Fit_StaffSize; StaffSize.Fit)
                    {
                        IncludeCaption = true;
                    }
                    column(Size_StaffSize; StaffSize.Size)
                    {
                        IncludeCaption = true;
                    }
                    column(CreatedBy_StaffSize; StaffSize."Created By")
                    {
                        IncludeCaption = true;
                    }
                    column(CreatedAt_StaffSize; StaffSize."Created At")
                    {
                        IncludeCaption = true;
                    }
                    column(CreatedByName; PortalUser.Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not StaffScale.Get("Size Scale Code") then
                            Clear(StaffScale);

                        PortalUser.Reset();
                        PortalUser.SetFilter("Contact No.", '%1', StaffSize."Created By");
                        if not PortalUser.FindFirst() then Clear(PortalUser);

                        LinesInDataset += 1;
                    end;
                }

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

                Clear(BranchFilter);
                PortalUser.SetRange(Id, PortalUserID);
                if PortalUser.FindFirst() then begin
                    UserBranch.SetRange("Portal User ID", PortalUser.Id);
                    if UserBranch.Findset() then begin
                        repeat
                            BranchFilter += '|' + UserBranch."Branch ID";
                        until UserBranch.next() = 0;
                        BranchFilter := CopyStr(BranchFilter, 2);
                    end;
                end;
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
        UniqueIDLbl = 'Unique ID';
        DescriptionLbl = 'Description';
        WearerIDLbl = 'Wearer ID';
        WearerNameLbl = 'Wearer Name';
        CreatedByNameLbl = 'Created By Name';
    }

    var
        PortalUser: Record "PDC Portal User";
        UserBranch: Record "PDC Portal User Branch";
        StaffScale: Record "PDC Size Scale Header";
        CustNoFilter: Text;
        PortalUserID: Text;
        BranchFilter: Text;
        LinesInDataset: Integer;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewCustNoFilter">Text.</param>
    /// <param name="NewPortalUserID">Text.</param>
    procedure InitializeRequest(NewCustNoFilter: Text; NewPortalUserID: Text)
    begin
        CustNoFilter := NewCustNoFilter;
        PortalUserID := NewPortalUserID;
    end;
}

