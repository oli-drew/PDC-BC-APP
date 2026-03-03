/// <summary>
/// Codeunit PDC Cust. Portal Mgt (ID 50018).
/// </summary>
Codeunit 50018 "PDC Portal Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        counter: Integer;

    /// <summary>
    /// GetCustomerNumber.
    /// </summary>
    /// <param name="NavPortalUser">Record "PDC Portal User".</param>
    /// <param name="CustomerNo">VAR Code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetCustomerNumber(NavPortalUser: Record "PDC Portal User"; var CustomerNo: Code[20]): Boolean
    var
        ContactBusRel: Record "Contact Business Relation";
    begin
        ContactBusRel.Reset();
        ContactBusRel.SetRange("Business Relation Code", 'CUST');
        ContactBusRel.SetRange("Contact No.", NavPortalUser."Company Contact No.");

        if (not ContactBusRel.FindFirst()) then exit(false);

        CustomerNo := ContactBusRel."No.";
        exit(true);
    end;

    /// <summary>
    /// FilterOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="Filtered">Boolean.</param>
    procedure FilterOrders(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header"; Filtered: Boolean)
    var
        CustomerNo: Code[20];
    begin
        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."document type"::Order);

        GetCustomerNumber(PortalUser, CustomerNo);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);

        if Filtered then
            SalesHeader.SetFilter("Document Date", '%1 .. %2', CalcDate('<-1W>', WorkDate()), WorkDate());
    end;

    /// <summary>
    /// FilterOrdersForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="Filtered">Boolean.</param>
    procedure FilterOrdersForMyBranches(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header"; Filtered: Boolean)
    var
        BranchFilter: Text;
    begin
        SalesHeader.Reset();
        BranchFilter := GetMyBranchesFilter(PortalUser);
        FilterOrdersForBranchFilter(PortalUser, SalesHeader, Filtered, BranchFilter);
    end;

    /// <summary>
    /// FilterOrdersForBranchFilter.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="Filtered">Boolean.</param>
    /// <param name="BranchFilter">Text.</param>
    procedure FilterOrdersForBranchFilter(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header"; Filtered: Boolean; BranchFilter: Text)
    var
        Line: Record "Sales Line";
    begin
        SalesHeader.Reset();
        FilterOrders(PortalUser, SalesHeader, Filtered);

        if not SalesHeader.FindSet() then
            exit;
        SalesHeader.ClearMarks();
        Line.Reset();
        Line.SetRange("Document Type", Line."document type"::Order);
        SalesHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Branch No.", GetBranchFilterWithChilds(PortalUser."Customer No.", BranchFilter));
        if not Line.FindSet() then begin
            SalesHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            SalesHeader.SetRange("No.", Line."Document No.");
            if SalesHeader.FindFirst() then
                SalesHeader.Mark(true);
        until Line.Next() = 0;
        SalesHeader.SetRange("No.");
        SalesHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// FilterOrdersForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="Filtered">Boolean.</param>
    procedure FilterOrdersForCreatedByMe(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header"; Filtered: Boolean)
    var
        Line: Record "Sales Line";
    begin
        SalesHeader.Reset();
        FilterOrders(PortalUser, SalesHeader, Filtered);

        if not SalesHeader.FindSet() then
            exit;
        SalesHeader.ClearMarks();
        Line.Reset();
        SalesHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Ordered By ID", PortalUser."Contact No.");
        if not Line.FindSet() then begin
            SalesHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            SalesHeader.SetRange("No.", Line."Document No.");
            if SalesHeader.FindFirst() then
                SalesHeader.Mark(true);
        until Line.Next() = 0;
        SalesHeader.SetRange("No.");
        SalesHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// FilterOrdersForApprovedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="Filtered">Boolean.</param>
    procedure FilterOrdersForApprovedByMe(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header"; Filtered: Boolean)
    var
        Line: Record "Sales Line";
    begin
        SalesHeader.Reset();
        FilterOrders(PortalUser, SalesHeader, Filtered);

        if not SalesHeader.FindSet() then
            exit;
        SalesHeader.ClearMarks();
        Line.Reset();
        SalesHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Created By ID", '<>%1&<>%2', PortalUser."Contact No.", '');
        Line.SetFilter("PDC Ordered By ID", PortalUser."Contact No.");
        if not Line.FindSet() then begin
            SalesHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            SalesHeader.SetRange("No.", Line."Document No.");
            if SalesHeader.FindFirst() then
                SalesHeader.Mark(true);
        until Line.Next() = 0;
        SalesHeader.SetRange("No.");
        SalesHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// CountOrdersForCreatedByMe.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountOrdersForCreatedByMe(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterOrdersForCreatedByMe(PortalUser, SalesHeader, false);
        exit(SalesHeader.Count);
    end;

    /// <summary>
    /// CountOrdersForApprovedByMe.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountOrdersForApprovedByMe(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterOrdersForApprovedByMe(PortalUser, SalesHeader, false);
        exit(SalesHeader.Count);
    end;

    /// <summary>
    /// FilterDraftOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    procedure FilterDraftOrders(var PortalUser: Record "PDC Portal User"; var DraftOrderHeader: Record "PDC Draft Order Header")
    var
        CustomerNo: Code[20];
    begin
        DraftOrderHeader.Reset();

        GetCustomerNumber(PortalUser, CustomerNo);

        DraftOrderHeader.SetRange("Sell-to Customer No.", CustomerNo);
    end;

    /// <summary>
    /// FilterDraftOrdersForBranchFilter.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    /// <param name="BranchFilter">Text.</param>
    procedure FilterDraftOrdersForBranchFilter(var PortalUser: Record "PDC Portal User"; var DraftOrderHeader: Record "PDC Draft Order Header"; BranchFilter: Text)
    var
        DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
        DraftOrderNoFilter: Text;
    begin
        DraftOrderHeader.Reset();

        FilterDraftOrders(PortalUser, DraftOrderHeader);

        if not DraftOrderHeader.FindSet() then
            exit;
        repeat
            if DraftOrderNoFilter <> '' then DraftOrderNoFilter := DraftOrderNoFilter + '|';
            DraftOrderNoFilter := DraftOrderNoFilter + DraftOrderHeader."Document No.";
        until DraftOrderHeader.Next() = 0;

        DraftOrderStaffLine.Reset();
        DraftOrderStaffLine.SetFilter("Document No.", DraftOrderNoFilter);
        DraftOrderStaffLine.SetFilter("Branch ID", GetBranchFilterWithChilds(PortalUser."Customer No.", BranchFilter));

        if not DraftOrderStaffLine.FindSet() then begin
            DraftOrderHeader.SetFilter("Document No.", '0&1');
            exit;
        end;

        DraftOrderNoFilter := '';

        repeat
            if DraftOrderNoFilter <> '' then DraftOrderNoFilter := DraftOrderNoFilter + '|';
            DraftOrderNoFilter := DraftOrderNoFilter + DraftOrderStaffLine."Document No.";
        until DraftOrderStaffLine.Next() = 0;

        DraftOrderHeader.SetFilter("Document No.", DraftOrderNoFilter);
    end;

    /// <summary>
    /// FilterDraftOrdersForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    procedure FilterDraftOrdersForMyBranches(var PortalUser: Record "PDC Portal User"; var DraftOrderHeader: Record "PDC Draft Order Header")
    var
        BranchFilter: Text;
    begin
        DraftOrderHeader.Reset();
        BranchFilter := GetMyBranchesFilter(PortalUser);
        FilterDraftOrdersForBranchFilter(PortalUser, DraftOrderHeader, BranchFilter);
    end;

    /// <summary>
    /// FilterDraftOrdersForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    procedure FilterDraftOrdersForCreatedByMe(var PortalUser: Record "PDC Portal User"; var DraftOrderHeader: Record "PDC Draft Order Header")
    begin
        DraftOrderHeader.Reset();
        FilterDraftOrders(PortalUser, DraftOrderHeader);
        DraftOrderHeader.SetRange("Created By ID", PortalUser."Contact No.");
    end;

    /// <summary>
    /// FilterDraftOrdersForMyApprovals.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    procedure FilterDraftOrdersForMyApprovals(var PortalUser: Record "PDC Portal User"; var DraftOrderHeader: Record "PDC Draft Order Header")
    var
        BranchFilter: Text;
    begin
        DraftOrderHeader.Reset();
        BranchFilter := GetMyBranchesFilter(PortalUser);
        FilterDraftOrdersForBranchFilter(PortalUser, DraftOrderHeader, BranchFilter);
        DraftOrderHeader.Setfilter("Created By ID", '<>%1', PortalUser."Contact No.");
        DraftOrderHeader.SetRange("Awaiting Approval", true);
    end;

    /// <summary>
    /// CountDraftOrdersForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountDraftOrdersForCreatedByMe(var PortalUser: Record "PDC Portal User"): Integer
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
    begin
        FilterDraftOrdersForCreatedByMe(PortalUser, DraftOrderHeader);
        exit(DraftOrderHeader.Count);
    end;

    /// <summary>
    /// CountDraftOrdersForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountDraftOrdersForCreatedByMeWaitingApproval(var PortalUser: Record "PDC Portal User"): Integer
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
    begin
        FilterDraftOrdersForCreatedByMe(PortalUser, DraftOrderHeader);
        DraftOrderHeader.SetRange("Awaiting Approval", true);
        exit(DraftOrderHeader.Count);
    end;

    /// <summary>
    /// CountDraftOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountDraftOrders(var PortalUser: Record "PDC Portal User"): Integer
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
    begin
        FilterDraftOrders(PortalUser, DraftOrderHeader);
        exit(DraftOrderHeader.Count);
    end;

    /// <summary>
    /// CountDraftOrdersForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountDraftOrdersForMyBranches(var PortalUser: Record "PDC Portal User"): Integer
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        BranchFilter: Text;
    begin
        BranchFilter := GetMyBranchesFilter(PortalUser);

        FilterDraftOrdersForBranchFilter(PortalUser, DraftOrderHeader, BranchFilter);
        exit(DraftOrderHeader.Count);
    end;

    /// <summary>
    /// CountDraftOrdersForMyApprovals.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountDraftOrdersForMyApprovals(var PortalUser: Record "PDC Portal User"): Integer
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
    begin
        FilterDraftOrdersForMyApprovals(PortalUser, DraftOrderHeader);
        exit(DraftOrderHeader.Count);
    end;

    /// <summary>
    /// FilterInvoices.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesInvHeader">VAR Record "Sales Invoice Header".</param>
    procedure FilterInvoices(var PortalUser: Record "PDC Portal User"; var SalesInvHeader: Record "Sales Invoice Header")
    var
        CustomerNo: Code[20];
    begin
        SalesInvHeader.Reset();

        GetCustomerNumber(PortalUser, CustomerNo);
        SalesInvHeader.SetRange("Sell-to Customer No.", CustomerNo);
    end;

    /// <summary>
    /// FilterCustLedgerEntries.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    procedure FilterCustLedgerEntries(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        CustomerNo: Code[20];
    begin
        CustLedgerEntry.Reset();

        GetCustomerNumber(PortalUser, CustomerNo);
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
    end;

    /// <summary>
    /// FIlterOpenCustLedgerEntries.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    /// <param name="DocumentType">Option.</param>
    procedure FilterOpenCustLedgerEntries(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry"; DocumentType: Enum "Gen. Journal Document Type")
    begin
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", DocumentType);
        CustLedgerEntry.SetRange(Open, true);
    end;

    /// <summary>
    /// FIlterClosedCustLedgerEntries.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    /// <param name="DocumentType">Enum "Gen. Journal Document Type".</param>
    procedure FilterClosedCustLedgerEntries(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry"; DocumentType: Enum "Gen. Journal Document Type")
    begin
        CustLedgerEntry.Reset();
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", DocumentType);
        CustLedgerEntry.SetRange(Open, false);
    end;

    /// <summary>
    /// FilterCustLedgerEntriesForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    procedure FilterCustLedgerEntriesForMyBranches(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        BranchFilter: Text;
    begin
        BranchFilter := GetMyBranchesFilter(PortalUser);
        FilterCustLedgerEntriesForBranchFilter(PortalUser, CustLedgerEntry, BranchFilter);
    end;

    /// <summary>
    /// FilterCustLedgerEntriesForBranchFilter.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    /// <param name="BranchFilter">Text.</param>
    procedure FilterCustLedgerEntriesForBranchFilter(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry"; BranchFilter: Text)
    var
        Line: Record "Sales Invoice Line";
    begin
        CustLedgerEntry.Reset();
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::Invoice);

        if not CustLedgerEntry.FindSet() then
            exit;
        CustLedgerEntry.ClearMarks();
        Line.Reset();
        CustLedgerEntry.Copyfilter("Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Branch No.", GetBranchFilterWithChilds(PortalUser."Customer No.", BranchFilter));
        if not Line.FindSet() then begin
            CustLedgerEntry.SetFilter("Document No.", '0&1');
            exit;
        end;
        repeat
            CustLedgerEntry.SetRange("Document No.", Line."Document No.");
            if CustLedgerEntry.FindFirst() then
                CustLedgerEntry.Mark(true);
        until Line.Next() = 0;
        CustLedgerEntry.SetRange("Document No.");
        CustLedgerEntry.MarkedOnly(true);

    end;

    /// <summary>
    /// FilterCustLedgerEntriesForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    procedure FilterCustLedgerEntriesForCreatedByMe(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        Line: Record "Sales Invoice Line";
    begin
        CustLedgerEntry.Reset();
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::Invoice);

        if not CustLedgerEntry.FindSet() then
            exit;

        CustLedgerEntry.ClearMarks();
        Line.Reset();
        CustLedgerEntry.Copyfilter("Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Ordered By ID", PortalUser."Contact No.");
        if not Line.FindSet() then begin
            CustLedgerEntry.SetFilter("Document No.", '0&1');
            exit;
        end;
        repeat
            CustLedgerEntry.SetRange("Document No.", Line."Document No.");
            if CustLedgerEntry.FindFirst() then
                CustLedgerEntry.Mark(true);
        until Line.Next() = 0;
        CustLedgerEntry.SetRange("Document No.");
        CustLedgerEntry.MarkedOnly(true);
    end;

    /// <summary>
    /// FilterCustLedgerEntriesForApprovedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    procedure FilterCustLedgerEntriesForApprovedByMe(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        Line: Record "Sales Invoice Line";
    begin
        CustLedgerEntry.Reset();
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::Invoice);

        if not CustLedgerEntry.FindSet() then
            exit;

        CustLedgerEntry.ClearMarks();
        Line.Reset();
        CustLedgerEntry.Copyfilter("Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Created By ID", '<>%1&<>%2', PortalUser."Contact No.", '');
        Line.SetFilter("PDC Ordered By ID", PortalUser."Contact No.");
        if not Line.FindSet() then begin
            CustLedgerEntry.SetFilter("Document No.", '0&1');
            exit;
        end;
        repeat
            CustLedgerEntry.SetRange("Document No.", Line."Document No.");
            if CustLedgerEntry.FindFirst() then
                CustLedgerEntry.Mark(true);
        until Line.Next() = 0;
        CustLedgerEntry.SetRange("Document No.");
        CustLedgerEntry.MarkedOnly(true);
    end;

    /// <summary>
    /// CountCustLedgerEntriesForCreatedByMe.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountCustLedgerEntriesForCreatedByMe(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"): Integer
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FilterCustLedgerEntriesForCreatedByMe(PortalUser, CustLedgerEntry);
        exit(CustLedgerEntry.Count);
    end;

    /// <summary>
    /// CountCustLedgerEntriesForApprovedByMe.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountCustLedgerEntriesForApprovedByMe(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"): Integer
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FilterCustLedgerEntriesForApprovedByMe(PortalUser, CustLedgerEntry);
        exit(CustLedgerEntry.Count);
    end;

    /// <summary>
    /// FilterCrMemos.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesCrMHeader">VAR Record "Sales Cr.Memo Header".</param>
    procedure FilterCrMemos(var PortalUser: Record "PDC Portal User"; var SalesCrMHeader: Record "Sales Cr.Memo Header")
    var
        CustomerNo: Code[20];
    begin
        SalesCrMHeader.Reset();
        GetCustomerNumber(PortalUser, CustomerNo);
        SalesCrMHeader.SetRange("Sell-to Customer No.", CustomerNo);
    end;

    /// <summary>
    /// FIlterOpenCrMemos.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    procedure FIlterOpenCrMemos(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::"Credit Memo");
        CustLedgerEntry.SetRange(Open, true);
    end;

    /// <summary>
    /// CountOpenCrMemos.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountOpenCrMemos(var PortalUser: Record "PDC Portal User"): Integer
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FIlterOpenCrMemos(PortalUser, CustLedgerEntry);
        exit(CustLedgerEntry.Count);
    end;

    /// <summary>
    /// FilterClosedCrMemos.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CustLedgerEntry">VAR Record "Cust. Ledger Entry".</param>
    procedure FilterClosedCrMemos(var PortalUser: Record "PDC Portal User"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::"Credit Memo");
        CustLedgerEntry.SetRange(Open, false);
    end;

    /// <summary>
    /// CountClosedCrMemos.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountClosedCrMemos(var PortalUser: Record "PDC Portal User"): Integer
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FilterClosedCrMemos(PortalUser, CustLedgerEntry);
        exit(CustLedgerEntry.Count);
    end;

    // procedure FilterDueDoc(var PortalUser: Record "PDC Portal User"; var CustLegtEntry: Record "Cust. Ledger Entry")
    // begin
    // end;    

    /// <summary>
    /// CountOrders.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountOrders(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        FilterOrders(PortalUser, SalesHeader, false);
        exit(SalesHeader.Count);
    end;

    /// <summary>
    /// CountReceivedReturnOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountReceivedReturnOrders(var PortalUser: Record "PDC Portal User"): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        FilterReceivedReturnOrders(PortalUser, SalesHeader);
        exit(SalesHeader.Count);
    end;

    /// <summary>
    /// CountReceivedReturnOrdersForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountReceivedReturnOrdersForMyBranches(var PortalUser: Record "PDC Portal User"): Integer
    var
        SalesHeader: Record "Sales Header";
        BranchFilter: Text;
    begin
        SalesHeader.Reset();
        BranchFilter := GetMyBranchesFilter(PortalUser);
        FilterReceivedReturnOrdersForBranchFilter(PortalUser, SalesHeader, BranchFilter);
        exit(SalesHeader.Count);
    end;

    /// <summary>
    /// CountCompletedReturnOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountCompletedReturnOrders(var PortalUser: Record "PDC Portal User"): Integer
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
        ReturnReceiptHeader.Reset();
        FilterCompletedReturnOrders(PortalUser, ReturnReceiptHeader);
        exit(ReturnReceiptHeader.Count);
    end;

    /// <summary>
    /// CountCompletedReturnOrdersForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountCompletedReturnOrdersForMyBranches(var PortalUser: Record "PDC Portal User"): Integer
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        BranchFilter: Text;
    begin
        ReturnReceiptHeader.Reset();

        BranchFilter := GetMyBranchesFilter(PortalUser);

        FilterCompletedReturnOrdersForBranchFilter(PortalUser, ReturnReceiptHeader, BranchFilter);
        exit(ReturnReceiptHeader.Count);
    end;

    /// <summary>
    /// FilterReceivedReturnOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    procedure FilterReceivedReturnOrders(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header")
    var
        CustomerNo: Code[20];
    begin
        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."document type"::"Return Order");

        GetCustomerNumber(PortalUser, CustomerNo);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
    end;

    /// <summary>
    /// FilterReceivedReturnOrdersForBranchFilter.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    /// <param name="BranchFilter">Text.</param>
    procedure FilterReceivedReturnOrdersForBranchFilter(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header"; BranchFilter: Text)
    var
        Line: Record "Sales Line";
    begin
        SalesHeader.Reset();
        FilterReceivedReturnOrders(PortalUser, SalesHeader);

        if not SalesHeader.FindSet() then
            exit;

        SalesHeader.ClearMarks();

        Line.Reset();
        Line.SetRange("Document Type", Line."document type"::"Return Order");
        SalesHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Branch No.", GetBranchFilterWithChilds(PortalUser."Customer No.", BranchFilter));
        if not Line.FindSet() then begin
            SalesHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            SalesHeader.SetRange("No.", Line."Document No.");
            if SalesHeader.FindFirst() then
                SalesHeader.Mark(true);
        until Line.Next() = 0;
        SalesHeader.SetRange("No.");
        SalesHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// FilterReceivedReturnOrdersForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    procedure FilterReceivedReturnOrdersForCreatedByMe(var PortalUser: Record "PDC Portal User"; var SalesHeader: Record "Sales Header")
    var
        Line: Record "Sales Line";
    begin
        SalesHeader.Reset();
        FilterReceivedReturnOrders(PortalUser, SalesHeader);

        if not SalesHeader.FindSet() then
            exit;

        SalesHeader.ClearMarks();
        Line.Reset();
        Line.SetRange("Document Type", Line."document type"::"Return Order");
        SalesHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Ordered By ID", PortalUser."Contact No.");
        if not Line.FindSet() then begin
            SalesHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            SalesHeader.SetRange("No.", Line."Document No.");
            if SalesHeader.FindFirst() then
                SalesHeader.Mark(true);
        until Line.Next() = 0;
        SalesHeader.SetRange("No.");
        SalesHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// FilterCompletedReturnOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="ReturnReceiptHeader">VAR Record "Return Receipt Header".</param>
    procedure FilterCompletedReturnOrders(var PortalUser: Record "PDC Portal User"; var ReturnReceiptHeader: Record "Return Receipt Header")
    var
        CustomerNo: Code[20];
    begin
        ReturnReceiptHeader.Reset();

        GetCustomerNumber(PortalUser, CustomerNo);

        ReturnReceiptHeader.SetRange("Sell-to Customer No.", CustomerNo);
        ReturnReceiptHeader.SetFilter("Return Order No.", '<>%1', '');
    end;

    /// <summary>
    /// FilterCompletedReturnOrdersForBranchFilter.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="ReturnReceiptHeader">VAR Record "Return Receipt Header".</param>
    /// <param name="BranchFilter">Text.</param>
    procedure FilterCompletedReturnOrdersForBranchFilter(var PortalUser: Record "PDC Portal User"; var ReturnReceiptHeader: Record "Return Receipt Header"; BranchFilter: Text)
    var
        Line: Record "Return Receipt Line";
    begin
        FilterCompletedReturnOrders(PortalUser, ReturnReceiptHeader);

        if not ReturnReceiptHeader.FindSet() then
            exit;

        ReturnReceiptHeader.ClearMarks();

        Line.Reset();
        ReturnReceiptHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Branch No.", GetBranchFilterWithChilds(PortalUser."Customer No.", BranchFilter));
        if not Line.FindSet() then begin
            ReturnReceiptHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            ReturnReceiptHeader.SetRange("No.", Line."Document No.");
            if ReturnReceiptHeader.FindFirst() then
                ReturnReceiptHeader.Mark(true);
        until Line.Next() = 0;
        ReturnReceiptHeader.SetRange("No.");
        ReturnReceiptHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// FilterCompletedReturnOrdersForCreatedByMe.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="ReturnReceiptHeader">VAR Record "Return Receipt Header".</param>
    procedure FilterCompletedReturnOrdersForCreatedByMe(var PortalUser: Record "PDC Portal User"; var ReturnReceiptHeader: Record "Return Receipt Header")
    var
        Line: Record "Return Receipt Line";
    begin
        ReturnReceiptHeader.Reset();
        FilterCompletedReturnOrders(PortalUser, ReturnReceiptHeader);

        if not ReturnReceiptHeader.FindSet() then
            exit;

        ReturnReceiptHeader.ClearMarks();
        Line.Reset();
        ReturnReceiptHeader.Copyfilter("Sell-to Customer No.", Line."Sell-to Customer No.");
        Line.SetFilter("PDC Ordered By ID", PortalUser."Contact No.");
        if not Line.FindSet() then begin
            ReturnReceiptHeader.SetFilter("No.", '0&1');
            exit;
        end;
        repeat
            ReturnReceiptHeader.SetRange("No.", Line."Document No.");
            if ReturnReceiptHeader.FindFirst() then
                ReturnReceiptHeader.Mark(true);
        until Line.Next() = 0;
        ReturnReceiptHeader.SetRange("No.");
        ReturnReceiptHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// GetInvoiceAmount.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetInvoiceAmount(var PortalUser: Record "PDC Portal User"): Decimal
    var
        Customer: Record Customer;
    begin
        if (Customer.Get(PortalUser."Customer No.")) then begin
            Customer.CalcFields("Balance (LCY)");
            exit(-Customer."Balance (LCY)");
        end;
    end;

    /// <summary>
    /// GetDueAmount.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetDueAmount(var PortalUser: Record "PDC Portal User"): Decimal
    var
        Customer: Record Customer;
        CustomerNo: Code[20];
    begin
        GetCustomerNumber(PortalUser, CustomerNo);
        if (Customer.Get(CustomerNo)) then
            exit(Customer.CalcOverdueBalance());
    end;

    /// <summary>
    /// GetInvCount.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetInvCount(var PortalUser: Record "PDC Portal User"): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.Reset();
        FIlterOpenCustLedgerEntries(PortalUser, CustLedgerEntry, CustLedgerEntry."document type"::Invoice);

        counter := CustLedgerEntry.Count;

        CustLedgerEntry.Reset();
        FIlterClosedCustLedgerEntries(PortalUser, CustLedgerEntry, CustLedgerEntry."document type"::Invoice);

        counter := counter + CustLedgerEntry.Count;

        CustLedgerEntry.Reset();
        FilterCustLedgerEntriesForCreatedByMe(PortalUser, CustLedgerEntry);
        counter := CustLedgerEntry.Count;

        exit(counter);
    end;

    /// <summary>
    /// GetOpenInvCount.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetOpenInvCount(var PortalUser: Record "PDC Portal User"): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FIlterOpenCustLedgerEntries(PortalUser, CustLedgerEntry, CustLedgerEntry."document type"::Invoice);
        exit(CustLedgerEntry.Count);
    end;

    /// <summary>
    /// GetClosedInvCount.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetClosedInvCount(var PortalUser: Record "PDC Portal User"): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FIlterClosedCustLedgerEntries(PortalUser, CustLedgerEntry, CustLedgerEntry."document type"::Invoice);
        exit(CustLedgerEntry.Count);
    end;


    /// <summary>
    /// FilterCompletedOrders.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="CompletedOrderHeader">VAR Record "Sales Invoice Header".</param>
    procedure FilterCompletedOrders(var PortalUser: Record "PDC Portal User"; var CompletedOrderHeader: Record "Sales Invoice Header")
    var
        CustomerNo: Code[20];
    begin
        CompletedOrderHeader.Reset();

        GetCustomerNumber(PortalUser, CustomerNo);
        CompletedOrderHeader.SetRange("Sell-to Customer No.", CustomerNo);
        CompletedOrderHeader.SetFilter("No.", '<>%1', '');
    end;

    /// <summary>
    /// CopyDocument.
    /// </summary>
    /// <param name="PostedInvoiceNo">Code[20].</param>
    /// <param name="ReturnOrderHeader">VAR Record "Sales Header".</param>
    procedure CopyDocument(PostedInvoiceNo: Code[20]; var ReturnOrderHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    begin
        ReturnOrderHeader.Init();
        ReturnOrderHeader."Document Type" := ReturnOrderHeader."document type"::"Return Order";
        ReturnOrderHeader.Insert(true);

        SalesSetup.Get();
        CopyDocMgt.SetProperties(true, false, false, false, true, SalesSetup."Exact Cost Reversing Mandatory", false);
        CopyDocMgt.CopySalesDoc(Enum::"Sales Document Type From"::"Posted Invoice", PostedInvoiceNo, ReturnOrderHeader);
    end;

    /// <summary>
    /// GetDraftOrderTotal.
    /// </summary>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetDraftOrderTotal(var DraftOrderHeader: Record "PDC Draft Order Header"): Decimal
    var
        DraftOrderItemLine: Record "PDC Draft Order Item Line";
        tot: Decimal;
        UnitPrice: Decimal;
    begin
        if DraftOrderHeader."Sell-to Customer No." = '' then exit;
        DraftOrderItemLine.SetRange("Document No.", DraftOrderHeader."Document No.");
        DraftOrderItemLine.SetFilter("Item No.", '<>%1', '');
        DraftOrderItemLine.SetFilter(Quantity, '>%1', 0);
        if DraftOrderItemLine.FindSet() then
            repeat
                UnitPrice := GetDrafrOrderItemUnitPrices(DraftOrderHeader, DraftOrderItemLine);
                tot := tot + UnitPrice * DraftOrderItemLine.Quantity;
            until DraftOrderItemLine.Next() = 0;
        exit(tot);
    end;

    /// <summary>
    /// GetDrafrOrderItemUnitPrices.
    /// </summary>
    /// <param name="DraftOrderHeader">VAR Record "PDC Draft Order Header".</param>
    /// <param name="DraftOrderItemLine">VAR Record "PDC Draft Order Item Line".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetDrafrOrderItemUnitPrices(var DraftOrderHeader: Record "PDC Draft Order Header"; var DraftOrderItemLine: Record "PDC Draft Order Item Line"): Decimal
    var
        Item: Record Item;
        SalesPriceMgt: Codeunit "PDC Portal Sales Price";
        UnitPrice: Decimal;
    begin
        if not Item.Get(DraftOrderItemLine."Item No.") then exit(0.0);
        UnitPrice := SalesPriceMgt.calcUnitPrice(DraftOrderHeader."Sell-to Customer No.", Item."No.", '', DraftOrderItemLine.Quantity,
                                                 DraftOrderItemLine."Unit Of Measure Code", '');
        exit(UnitPrice);
    end;

    /// <summary>
    /// AddOrUpdateDraftOrderItemLines.
    /// </summary>
    /// <param name="CustomerNo">Code[20].</param>
    /// <param name="DraftOrderNo">Code[20].</param>
    /// <param name="DraftOrderItemLine">VAR Record "PDC Draft Order Item Line".</param>
    /// <param name="StaffLineNo">Integer.</param>
    /// <param name="CalcItemNo">Boolean.</param>
    procedure AddOrUpdateDraftOrderItemLines(CustomerNo: Code[20]; DraftOrderNo: Code[20]; var DraftOrderItemLine: Record "PDC Draft Order Item Line"; StaffLineNo: Integer; CalcItemNo: Boolean)
    var
        DraftOrderHeaderDb: Record "PDC Draft Order Header";
        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
        DraftOrderItemLineDb2: Record "PDC Draft Order Item Line";
        NewLine: Boolean;
        ItemNo: Code[20];
    begin
        DraftOrderHeaderDb.Reset();
        DraftOrderHeaderDb.SetRange("Sell-to Customer No.", CustomerNo);
        DraftOrderHeaderDb.SetRange("Document No.", DraftOrderNo);

        if not DraftOrderHeaderDb.FindSet() then exit;
        if not DraftOrderItemLine.FindSet() then exit;

        repeat
            NewLine := DraftOrderItemLine."Line No." < 0;

            //search for existing same line
            if not NewLine then begin
                DraftOrderItemLineDb.SetRange("Document No.", DraftOrderNo);
                DraftOrderItemLineDb.SetRange("Staff Line No.", StaffLineNo);
                DraftOrderItemLineDb.SetRange("Product Code", DraftOrderItemLine."Product Code");
                DraftOrderItemLineDb.SetRange("Colour Code", DraftOrderItemLine."Colour Code");
                DraftOrderItemLineDb.SetRange("Fit Code", DraftOrderItemLine."Fit Code");
                DraftOrderItemLineDb.SetRange("Size Code", DraftOrderItemLine."Size Code");
                if not DraftOrderItemLineDb.FindFirst() then begin
                    //search for existing blank line
                    DraftOrderItemLineDb.SetRange("Colour Code");
                    DraftOrderItemLineDb.SetRange("Fit Code");
                    DraftOrderItemLineDb.SetRange("Size Code");
                    DraftOrderItemLineDb.SetRange("Item No.", ''); //blank Item No. means blank line
                    if not DraftOrderItemLineDb.FindFirst() then
                        NewLine := true;
                end;
                //reset filters
                DraftOrderItemLineDb.Reset();
            end;

            //create new line
            if NewLine then
                DraftOrderItemLineDb.Init();

            DraftOrderItemLineDb.TransferFields(DraftOrderItemLine);
            DraftOrderItemLineDb."Document No." := DraftOrderNo;

            if CalcItemNo then begin
                ItemNo := copystr(DraftOrderItemLine."Product Code" + DraftOrderItemLine."Colour Code" + DraftOrderItemLine."Size Code" + DraftOrderItemLine."Fit Code", 1, MaxStrLen(ItemNo));
                DraftOrderItemLineDb.Validate("Item No.", ItemNo);
                DraftOrderItemLineDb.Validate(Quantity, DraftOrderItemLine.Quantity);
                if (DraftOrderItemLine."Unit Price" = 0) then
                    DraftOrderItemLineDb.Validate("Unit Price", GetDrafrOrderItemUnitPrices(DraftOrderHeaderDb, DraftOrderItemLineDb))
                else
                    DraftOrderItemLineDb.Validate("Unit Price", DraftOrderItemLine."Unit Price");
            end;


            DraftOrderItemLineDb."Staff Line No." := StaffLineNo;

            if NewLine then begin
                DraftOrderItemLineDb."Line No." := GetNextItemLineNo(DraftOrderNo, StaffLineNo);
                DraftOrderItemLineDb.Insert(true)
            end else begin
                DraftOrderItemLineDb.Modify(true);

                if DraftOrderItemLine.Quantity = 0 then begin //clear data on delete
                    DraftOrderItemLineDb2.SetRange("Document No.", DraftOrderItemLineDb."Document No.");
                    DraftOrderItemLineDb2.SetRange("Staff Line No.", DraftOrderItemLineDb."Staff Line No.");
                    DraftOrderItemLineDb2.SetRange("Product Code", DraftOrderItemLineDb."Product Code");
                    DraftOrderItemLineDb2.SetFilter("Line No.", '<>%1', DraftOrderItemLineDb."Line No.");
                    if DraftOrderItemLineDb2.FindFirst() then //there are other lines with same Product
                        DraftOrderItemLineDb.Delete(true)
                    else begin //only one line with current Product, need to clear it
                        DraftOrderItemLineDb."Colour Code" := '';
                        DraftOrderItemLineDb."Unit Price" := 0;
                        DraftOrderItemLineDb."Unit Of Measure Code" := '';
                        DraftOrderItemLineDb."Line Amount" := 0;
                        DraftOrderItemLineDb."SLA Date" := 0D;
                        DraftOrderItemLineDb."Item No." := '';
                        DraftOrderItemLineDb."Item Description" := '';
                        DraftOrderItemLineDb."Fit Code" := '';
                        DraftOrderItemLineDb."Size Code" := '';
                        DraftOrderItemLineDb.Modify(true);
                    end;
                end;
            end;
        until DraftOrderItemLine.Next() = 0;
    end;

    local procedure GetNextItemLineNo(OrderNo: Code[20];
StaffLineNo: Integer): Integer
    var
        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
        CurrentMaximum: Integer;
    begin
        DraftOrderItemLineDb.Reset();

        DraftOrderItemLineDb.SetRange("Document No.", OrderNo);
        DraftOrderItemLineDb.SetRange("Staff Line No.", StaffLineNo);

        if not DraftOrderItemLineDb.FindSet() then exit(10000);

        CurrentMaximum := 0;

        repeat
            if DraftOrderItemLineDb."Line No." > CurrentMaximum then CurrentMaximum := DraftOrderItemLineDb."Line No."
        until DraftOrderItemLineDb.Next() = 0;

        exit(CurrentMaximum + 10000)
    end;

    local procedure FilterStaff(var PortalUser: Record "PDC Portal User"; var BranchStaff: Record "PDC Branch Staff"; filterString: Text)
    begin
        BranchStaff.SetFilter("Sell-to Customer No.", PortalUser."Customer No.");
        BranchStaff.SetFilter("Branch ID", filterString);
    end;

    // local procedure FilterActiveInactiveStaff(var PortalUser: Record "PDC Portal User"; var BranchStaff: Record "PDC Branch Staff"; IsInactive: Boolean)
    // var
    //     branchFilter: Text;
    // begin
    //     branchFilter := GetMyCustomerBranchesFilter(PortalUser);

    //     FilterStaff(PortalUser, BranchStaff, branchFilter);

    //     BranchStaff.SetRange(Blocked, IsInactive);
    // end;

    local procedure FilterActiveInactiveStaffForMyBranches(var PortalUser: Record "PDC Portal User"; var BranchStaff: Record "PDC Branch Staff"; IsInactive: Boolean)
    var
        branchFilter: Text;
    begin
        branchFilter := GetMyBranchesFilter(PortalUser);

        FilterStaff(PortalUser, BranchStaff, branchFilter);

        BranchStaff.SetRange(Blocked, IsInactive);
    end;

    /// <summary>
    /// CountStaff.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountStaff(var PortalUser: Record "PDC Portal User"): Integer
    var
        BranchStaff: Record "PDC Branch Staff";
        branchFilter: Text;
    begin
        BranchStaff.Reset();
        branchFilter := GetMyCustomerBranchesFilter(PortalUser);
        FilterStaff(PortalUser, BranchStaff, branchFilter);
        exit(BranchStaff.Count);
    end;

    /// <summary>
    /// CountStaffForMyBranches.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountStaffForMyBranches(var PortalUser: Record "PDC Portal User"): Integer
    var
        BranchStaff: Record "PDC Branch Staff";
        branchFilter: Text;
    begin
        BranchStaff.Reset();
        branchFilter := GetMyBranchesFilter(PortalUser);
        FilterStaff(PortalUser, BranchStaff, branchFilter);
        exit(BranchStaff.Count);
    end;

    /// <summary>
    /// CountActiveStaff.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountActiveStaff(var PortalUser: Record "PDC Portal User"): Integer
    var
        BranchStaff: Record "PDC Branch Staff";
    begin
        BranchStaff.Reset();
        FilterActiveInactiveStaffForMyBranches(PortalUser, BranchStaff, false);

        exit(BranchStaff.Count);
    end;

    /// <summary>
    /// CountInactiveStaff.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountInactiveStaff(var PortalUser: Record "PDC Portal User"): Integer
    var
        BranchStaff: Record "PDC Branch Staff";
    begin
        BranchStaff.Reset();
        FilterActiveInactiveStaffForMyBranches(PortalUser, BranchStaff, true);

        exit(BranchStaff.Count);
    end;

    procedure GetMyBranchesFilter(var PortalUser: Record "PDC Portal User"): Text
    var
        TempBranch: Record "PDC Branch" temporary;
        PortalsManagement: Codeunit "PDC Portals Management";
        BranchFilter: Text;
    begin
        PortalsManagement.GetPortalUserBranchList(TempBranch, PortalUser);
        if not TempBranch.FindSet() then exit('1&0');
        repeat
            if BranchFilter <> '' then BranchFilter := BranchFilter + '|';
            BranchFilter := BranchFilter + TempBranch."Branch No.";
        until TempBranch.Next() = 0;

        exit(BranchFilter);
    end;

    procedure GetBranchFilterWithChilds(CustomerNo: code[20]; var BranchFilter: Text): Text
    var
        Branch: Record "PDC Branch";
        TempBranch: Record "PDC Branch" temporary;
        PortalsManagement: Codeunit "PDC Portals Management";
    begin
        Branch.setrange("Customer No.", CustomerNo);
        Branch.setfilter("Branch No.", BranchFilter);
        if Branch.findset() then
            repeat
                TempBranch.init();
                TempBranch := Branch;
                if TempBranch.insert() then;
                PortalsManagement.SelectChildBranches(TempBranch, Branch);
            until Branch.Next() = 0;
        if not TempBranch.FindSet() then exit('1&0');
        clear(BranchFilter);
        repeat
            if BranchFilter <> '' then BranchFilter := BranchFilter + '|';
            BranchFilter := BranchFilter + TempBranch."Branch No.";
        until TempBranch.Next() = 0;

        exit(BranchFilter);
    end;

    local procedure GetMyCustomerBranchesFilter(var PortalUser: Record "PDC Portal User"): Text
    var
        Branch: Record "PDC Branch";
        filterString: Text;
    begin
        Branch.Reset();
        Branch.SetRange("Customer No.", PortalUser."Customer No.");

        if Branch.FindSet() then
            repeat

                if filterString <> '' then filterString := filterString + '|';

                filterString := filterString + Branch."Branch No.";

            until Branch.Next() = 0 else
            filterString := '1&0';

        exit(filterString);
    end;

    /// <summary>
    /// GetWardrobeLinePrices.
    /// </summary>
    /// <param name="WardrobeLine">VAR Record "PDC Wardrobe Line".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetWardrobeLinePrices(var WardrobeLine: Record "PDC Wardrobe Line"): Decimal
    var
        WardrobeHeader: Record "PDC Wardrobe Header";
        Item: Record Item;
        SalesPriceMgt: Codeunit "PDC Portal Sales Price";
        UnitPrice: Decimal;
    begin
        UnitPrice := 0;
        if WardrobeHeader.get(WardrobeLine."Wardrobe ID") then begin
            Item.Reset();
            Item.SetRange("PDC Product Code", WardrobeLine."Product Code");
            Item.SetRange(Blocked, false);
            if Item.FindFirst() then
                UnitPrice := SalesPriceMgt.calcUnitPrice(WardrobeHeader."Customer No.", Item."No.", '', 1,
                                                         Item."Base Unit of Measure", '');
        end;
        exit(UnitPrice);
    end;

    /// <summary>
    /// GetItemPrice.
    /// </summary>
    /// <param name="CustomerNo">Code[20].</param>
    /// <param name="ItemNo">Code[20].</param>
    /// <param name="ItemPrice">VAR Decimal.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetItemPrice(CustomerNo: Code[20]; ItemNo: Code[20]; var ItemPrice: Decimal): Boolean
    var
        // SalesHeader: Record "Sales Header" temporary;
        // SalesLine: Record "Sales Line" temporary;
        Item: Record Item;
        SalesPriceMgt: Codeunit "PDC Portal Sales Price";
    begin
        if not Item.Get(ItemNo) then exit(false);
        ItemPrice := SalesPriceMgt.calcUnitPrice(CustomerNo, Item."No.", '', 1, Item."Sales Unit of Measure", '');
        exit(true);
    end;

    /// <summary>
    /// CountEntitlement.
    /// </summary>
    /// <param name="PortalUser">Record "PDC Portal User".</param>
    /// <param name="EntitlementType">Option Remaining,Complete,Exceeded,Predicted.</param>
    /// <returns>Return variable Result of type Integer.</returns>
    procedure CountEntitlement(PortalUser: Record "PDC Portal User"; EntitlementType: Option Remaining,Complete,Exceeded,Predicted) Result: Integer
    var
        EntitlementCount: Query "PDCEntitlementCount";
        EntitlementPredictedCount: Query "PDCEntitlementPredictedCount";
        x: Integer;
        BranchFilter: Text;
    begin
        BranchFilter := GetMyBranchesFilter(PortalUser);

        if EntitlementType in [0 .. 2] then begin //remaining,Complete,Exceeded
            Clear(EntitlementCount);
            EntitlementCount.SetRange(Id_Filter, PortalUser.Id);
            EntitlementCount.SetFilter(BranchID_Filter, BranchFilter);
            EntitlementCount.SetRange(Wardobe_Discontinued_Filter, false);
            case EntitlementType of
                0:
                    EntitlementCount.SetFilter(QtyRemaining_Filter, '>0'); //remaining
                1:
                    EntitlementCount.SetFilter(QtyRemaining_Filter, '<>0'); //complete
                2:
                    EntitlementCount.SetFilter(QtyRemaining_Filter, '<0'); //Exceeded
            end; //case
            for x := 1 to 2 do begin
                if x = 1 then
                    EntitlementCount.SetFilter(Posponed_Days_Filter, '<>0')
                else
                    EntitlementCount.SetRange(Posponed_Days_Filter);
                EntitlementCount.Open();
                while EntitlementCount.Read() do
                    if ((EntitlementType in [0, 2]) and (EntitlementCount.EntitlementCount <> 0)) or
                       ((EntitlementType in [1]) and (EntitlementCount.EntitlementCount = 0))
                     then
                        if x = 1 then
                            Result -= 1
                        else
                            Result += 1;
                EntitlementCount.Close();
            end;
        end
        else begin //Predicted
            Clear(EntitlementPredictedCount);
            EntitlementPredictedCount.SetRange(Id_Filter, PortalUser.Id);
            EntitlementPredictedCount.SetFilter(BranchID_Filter, BranchFilter);
            EntitlementPredictedCount.SetRange(Wardobe_Discontinued_Filter, false);
            EntitlementPredictedCount.SetFilter(QtyRemaining_Filter, '>0'); //remaining
            EntitlementCount.Open();
            while EntitlementPredictedCount.Read() do
                Result += 1;
            EntitlementPredictedCount.Close();
        end;
    end;

    /// <summary>
    /// CountWardrobeItems.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountWardrobeItems(var PortalUser: Record "PDC Portal User"): Integer
    var
        Item: Record Item;
    begin
        Item.Reset();
        FilterWardrobeItems(PortalUser, Item, '');

        exit(Item.Count);
    end;

    /// <summary>
    /// FilterWardrobeItems.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="Item">VAR Record Item.</param>
    /// <param name="WardrobeID">Code[20].</param>
    procedure FilterWardrobeItems(var PortalUser: Record "PDC Portal User"; var Item: Record Item; WardrobeID: Code[20])
    var
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeColours: Record "PDC Wardrobe Item Option";
    begin
        Item.Reset();
        Item.ClearMarks();
        FilterWardrobes(PortalUser, Wardrobe);
        if WardrobeID <> '' then
            Wardrobe.setrange("Wardrobe ID", WardrobeID);
        if Wardrobe.FindSet() then
            repeat
                WardrobeLine.setrange("Wardrobe ID", Wardrobe."Wardrobe ID");
                WardrobeLine.setrange(Discontinued, false);
                if WardrobeLine.Findset() then
                    repeat
                        WardrobeColours.setrange("Wardrobe ID", WardrobeLine."Wardrobe ID");
                        WardrobeColours.setrange("Product Code", WardrobeLine."Product Code");
                        if WardrobeColours.Findset() then
                            repeat
                                Item.setrange("PDC Product Code", WardrobeColours."Product Code");
                                Item.SetRange("PDC Colour", WardrobeColours."Colour Code");
                                if Item.FindFirst() then
                                    Item.Mark(true);
                            until WardrobeColours.next() = 0;
                    until WardrobeLine.next() = 0;
            until Wardrobe.Next() = 0;

        Item.setrange("PDC Product Code");
        Item.SetRange("PDC Colour");
        Item.MarkedOnly(true);
    end;

    /// <summary>
    /// CountWardrobes.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountWardrobes(var PortalUser: Record "PDC Portal User"): Integer
    var
        Wardrobe: Record "PDC Wardrobe Header";
    begin
        FilterWardrobes(PortalUser, Wardrobe);
        exit(Wardrobe.Count);
    end;

    /// <summary>
    /// FilterWardrobes.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="Wardrobe">VAR Record "PDC Wardrobe Header".</param>
    procedure FilterWardrobes(var PortalUser: Record "PDC Portal User"; var Wardrobe: Record "PDC Wardrobe Header")
    var
        PortalUserWardrobe: Record "PDC Portal User Wardrobe";
        Wardrobe2: Record "PDC Wardrobe Header";
        PDCPortalsManagement: Codeunit "PDC Portals Management";
        CustomerNo: Code[20];
    begin
        Wardrobe.Reset();
        GetCustomerNumber(PortalUser, CustomerNo);
        Wardrobe.setrange("Customer No.", CustomerNo);

        Wardrobe2.ClearMarks();
        PortalUserWardrobe.Reset();
        PortalUserWardrobe.SetRange("Portal User ID", PortalUser.ID);
        PortalUserWardrobe.setrange("Sell-To Customer No.", PortalUser."Customer No.");
        if PortalUserWardrobe.FindSet() then begin
            repeat
                Wardrobe2.get(PortalUserWardrobe."Wardrobe ID");
                Wardrobe2.Mark(true);
            until PortalUserWardrobe.Next() = 0;
            Wardrobe2.MarkedOnly(true);
            Wardrobe.setfilter("Wardrobe ID", PDCPortalsManagement.GetUserWardrobeFilter(Wardrobe2));
        end;

        Wardrobe.SetRange(Disable, false);
    end;

    /// <summary>
    /// CountCountracts.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CountCountracts(var PortalUser: Record "PDC Portal User"): Integer
    var
        Contract: Record "PDC Contract";
    begin
        FilterContracts(PortalUser, Contract);
        exit(Contract.Count);
    end;

    local procedure FilterContracts(var PortalUser: Record "PDC Portal User"; var Contract: Record "PDC Contract")
    var
        CustomerNo: Code[20];
    begin
        Contract.Reset();
        GetCustomerNumber(PortalUser, CustomerNo);
        Contract.setrange("Customer No.", CustomerNo);
        Contract.setrange(Blocked, false);
    end;
}

