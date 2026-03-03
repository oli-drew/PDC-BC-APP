/// <summary>
/// Report PDC Portal - Staff Entitlement (ID 50026).
/// </summary>
Report 50026 "PDC Portal - Staff Entitlement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalStaffEntitlement.rdlc';
    Caption = 'Portal - Staff Entitlement';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            dataitem(Staff; "PDC Branch Staff")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Staff ID") where(Blocked = const(false));
                dataitem(Entitlement; "PDC Staff Entitlement")
                {
                    DataItemLink = "Customer No." = field("Sell-to Customer No."), "Staff ID" = field("Staff ID");
                    column(CustomerNo_Entitlement; Entitlement."Customer No.")
                    {
                        IncludeCaption = true;
                    }
                    column(BranchID; Staff."Branch ID")
                    {
                    }
                    column(StaffID_Entitlement; Entitlement."Staff ID")
                    {
                        IncludeCaption = true;
                    }
                    column(WearerID; Staff."Wearer ID")
                    {
                    }
                    column(StaffName_Entitlement; Entitlement."Staff Name")
                    {
                        IncludeCaption = true;
                    }
                    column(StaffBodyTypeGender_Entitlement; Entitlement."Staff Body Type/Gender")
                    {
                        IncludeCaption = true;
                    }
                    column(WardrobeID_Entitlement; Entitlement."Wardrobe ID")
                    {
                        IncludeCaption = true;
                    }
                    column(WardrobeName; WardrobeHeader.Description)
                    {
                    }
                    column(ProductCode_Entitlement; Entitlement."Product Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ProductName; LineDescription)
                    {
                    }
                    column(EntitlementPeriodDays_Entitlement; Entitlement."Entitlement Period (Days)")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityEntitledinPeriod_Entitlement; Entitlement."Quantity Entitled in Period")
                    {
                        IncludeCaption = true;
                    }
                    column(StartDate_Entitlement; Entitlement."Start Date")
                    {
                        IncludeCaption = true;
                    }
                    column(EndDate_Entitlement; Entitlement."End Date")
                    {
                        IncludeCaption = true;
                    }
                    column(CalculatedQuantityIssued_Entitlement; Entitlement."Calculated Quantity Issued")
                    {
                        IncludeCaption = true;
                    }
                    column(CalcQtyRemaininginPeriod_Entitlement; Entitlement."Calc. Qty. Remaining in Period")
                    {
                        IncludeCaption = true;
                    }
                    column(LastDateTimeCalculated_Entitlement; Entitlement."Last DateTime Calculated")
                    {
                        IncludeCaption = true;
                    }

                    trigger OnAfterGetRecord()
                    var
                        WardrobeGroup: Record "PDC Wardrobe Entitlement Group";
                        Item: Record Item;
                    begin
                        if not WardrobeHeader.Get("Wardrobe ID") then Clear(WardrobeHeader);

                        if "Group Type" = "Group Type"::" " then begin
                            Item.SetRange("PDC Product Code", Entitlement."Product Code");
                            if not Item.FindFirst() then Clear(Item);
                            LineDescription := Item.Description;
                        end
                        else begin
                            "Product Code" := "Group Code";
                            CalcFields("Group Entitlement Period", "Group Value Entitled");
                            "Entitlement Period (Days)" := "Group Entitlement Period";
                            "Quantity Entitled in Period" := "Group Value Entitled";
                            if WardrobeGroup.get("Wardrobe ID", "Group Type", "Group Code") then
                                LineDescription := WardrobeGroup.Description;
                        end;

                        LinesInDataset += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if typeFilter <> '' then
                            if StrPos(UpperCase(typeFilter), 'OVER') <> 0 then
                                SetFilter("Calc. Qty. Remaining in Period", '<%1', 0)
                            else
                                if StrPos(UpperCase(typeFilter), 'UNDER') <> 0 then
                                    SetFilter("Calc. Qty. Remaining in Period", '>%1', 0);
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

                if UpperCase(BranchFilter) = 'ALL' then
                    Clear(BranchFilter);
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
        BranchIDLbl = 'Branch ID';
        WardrobeNameLbl = 'Wardrobe Name';
        ProductNameLbl = 'Product Name';
        UsedLbl = 'Used';
        EntitlementLbl = 'Entitlement';
        WearerIDLbl = 'Wearer ID';
    }

    var
        WardrobeHeader: Record "PDC Wardrobe Header";
        CustNoFilter: Text;
        PortalUserID: Text;
        BranchFilter: Text;
        typeFilter: Text;
        LinesInDataset: Integer;
        LineDescription: Text;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewCustNoFilter">Text.</param>
    /// <param name="NewPortalUserID">Text.</param>
    /// <param name="NewbranchFilter">Text.</param>
    /// <param name="NewtypeFilter">Text.</param>
    procedure InitializeRequest(NewCustNoFilter: Text; NewPortalUserID: Text; NewbranchFilter: Text; NewtypeFilter: Text)
    begin
        CustNoFilter := NewCustNoFilter;
        PortalUserID := NewPortalUserID;
        BranchFilter := NewbranchFilter;
        typeFilter := NewtypeFilter;
    end;
}

