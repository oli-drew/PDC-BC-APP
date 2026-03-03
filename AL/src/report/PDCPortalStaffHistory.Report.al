/// <summary>
/// Report PDC Portal - Staff History (ID 50024).
/// </summary>
Report 50024 "PDC Portal - Staff History"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalStaffHistory.rdlc';
    Caption = 'Portal - Staff History';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";

            column(CustomerNo; Customer."No.")
            {
            }
            dataitem(Staff; "PDC Branch Staff")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Staff ID") where(Blocked = const(false));

                column(StaffID; Staff."Staff ID")
                {
                }
                column(StaffName; Staff.Name)
                {
                }
                dataitem(Invoice; "Sales Invoice Line")
                {
                    DataItemLink = "PDC Staff ID" = field("Staff ID");
                    DataItemTableView = sorting("Sell-to Customer No.", Type, "Document No.") where(Type = const(Item), "No." = filter(<> ''));

                    column(IsInvoice; '1')
                    {
                    }
                    column(BranchNo_Invoice; Invoice."PDC Branch No.")
                    {
                    }
                    column(CustRef_Invoice; Invoice."PDC Customer Reference")
                    {
                    }
                    column(Type_Invoice; DocType)
                    {
                    }
                    column(DocNo_Invoice; Invoice."Document No.")
                    {
                    }
                    column(ShipNo_Invoice; SalesShipNo)
                    {
                    }
                    column(DocDate_Invoice; NAVPortalsMgt.FormatDate(Invoice."Posting Date"))
                    {
                    }
                    column(ItemNo_Invoice; Invoice."No.")
                    {
                    }
                    column(Description_Invoice; Invoice.Description)
                    {
                    }
                    column(Colour_Invoice; Item."PDC Colour")
                    {
                    }
                    column(Fit_Invoice; Item."PDC Fit")
                    {
                    }
                    column(Size_Invoice; Item."PDC Size")
                    {
                    }
                    column(Quantity_Invoice; Invoice.Quantity)
                    {
                    }
                    column(WebOrderNo_Invoice; Invoice."PDC Web Order No.")
                    {
                    }
                    column(WearerID_Invoice; Invoice."PDC Wearer ID")
                    {
                    }
                    column(WearerName_Invoice; Invoice."PDC Wearer Name")
                    {
                    }
                    column(OrderedByID_Invoice; Invoice."PDC Ordered By ID")
                    {
                    }
                    column(OrderedByName_Invoice; Invoice."PDC Ordered By Name")
                    {
                    }
                    column(Total_Invoice; Invoice."Amount Including VAT")
                    {
                    }
                    column(VAT_Invoice; Invoice."Amount Including VAT" - Invoice.Amount)
                    {
                    }
                    column(OrderDate_Invoice; NAVPortalsMgt.FormatDate(InvoiceHdr."Document Date"))
                    {
                    }
                    column(DeliveryDate_Invoice; NAVPortalsMgt.FormatDate(Invoice."Posting Date"))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InvoiceHdr.Get("Document No.");
                        Item.Get("No.");

                        DocType := InvoiceTypeTxt;

                        Clear(SalesShipNo);
                        ValueEntry.Reset();
                        ValueEntry.SetCurrentkey("Document No.");
                        ValueEntry.SetRange("Document No.", "Document No.");
                        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Sales Invoice");
                        ValueEntry.SetRange("Document Line No.", "Line No.");
                        if ValueEntry.Findset() then
                            repeat
                                ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
                                if ItemLedgEntry."Document Type" = ItemLedgEntry."document type"::"Sales Shipment" then
                                    SalesShipNo := ItemLedgEntry."Document No.";
                            until (ValueEntry.next() = 0) or (SalesShipNo <> '');

                        LinesInDataset += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PortalUser.Id <> '' then
                            SetRange("PDC Ordered By ID", PortalUser."Contact No.");
                        if ((StartDate <> 0D) and (EndDate <> 0D)) then
                            SetRange("Posting Date", StartDate, EndDate);
                        if BranchFilter <> '' then
                            SetFilter("PDC Branch No.", BranchFilter);

                        if typeFilter <> '' then
                            if StrPos(UpperCase(typeFilter), 'INVOICE=TRUE') = 0 then
                                CurrReport.Break();
                    end;
                }
                dataitem(CrMemo; "Sales Cr.Memo Line")
                {
                    DataItemLink = "PDC Staff ID" = field("Staff ID");
                    DataItemTableView = sorting("Sell-to Customer No.") where(Type = const(Item), "No." = filter(<> ''));

                    column(IsCrMemo; '1')
                    {
                    }
                    column(BranchNo_CrMemo; CrMemo."PDC Branch No.")
                    {
                    }
                    column(CustRef_CrMemo; CrMemo."PDC Customer Reference")
                    {
                    }
                    column(Type_CrMemo; DocType)
                    {
                    }
                    column(DocNo_CrMemo; CrMemo."Document No.")
                    {
                    }
                    column(ShipNo_CrMemo; SalesShipNo)
                    {
                    }
                    column(DocDate_CrMemo; NAVPortalsMgt.FormatDate(CrMemo."Posting Date"))
                    {
                    }
                    column(ItemNo_CrMemo; CrMemo."No.")
                    {
                    }
                    column(Description_CrMemo; CrMemo.Description)
                    {
                    }
                    column(Colour_CrMemo; Item."PDC Colour")
                    {
                    }
                    column(Fit_CrMemo; Item."PDC Fit")
                    {
                    }
                    column(Size_CrMemo; Item."PDC Size")
                    {
                    }
                    column(Quantity_CrMemo; CrMemo.Quantity)
                    {
                    }
                    column(WebOrderNo_CrMemo; CrMemo."PDC Web Order No.")
                    {
                    }
                    column(WearerID_CrMemo; CrMemo."PDC Wearer ID")
                    {
                    }
                    column(WearerName_CrMemo; CrMemo."PDC Wearer Name")
                    {
                    }
                    column(OrderedByID_CrMemo; CrMemo."PDC Ordered By ID")
                    {
                    }
                    column(OrderedByName_CrMemo; CrMemo."PDC Ordered By Name")
                    {
                    }
                    column(Total_CrMemo; CrMemo."Amount Including VAT")
                    {
                    }
                    column(VAT_CrMemo; CrMemo."Amount Including VAT" - Invoice.Amount)
                    {
                    }
                    column(OrderDate_CrMemo; NAVPortalsMgt.FormatDate(CrMemoHdr."Document Date"))
                    {
                    }
                    column(DeliveryDate_CrMemo; NAVPortalsMgt.FormatDate(CrMemo."Posting Date"))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CrMemoHdr.Get("Document No.");
                        Item.Get("No.");

                        DocType := CmMemoTypeTxt;

                        Clear(SalesShipNo);

                        LinesInDataset += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PortalUser.Id <> '' then
                            SetRange("PDC Ordered By ID", PortalUser."Contact No.");
                        if ((StartDate <> 0D) and (EndDate <> 0D)) then
                            SetRange("Posting Date", StartDate, EndDate);
                        if BranchFilter <> '' then
                            SetFilter("PDC Branch No.", BranchFilter);
                        if typeFilter <> '' then
                            if StrPos(UpperCase(typeFilter), 'CREDIT=TRUE') = 0 then
                                CurrReport.Break();
                    end;
                }
                dataitem("Order"; "Sales Line")
                {
                    CalcFields = "Posting Date";
                    DataItemLink = "PDC Staff ID" = field("Staff ID");
                    DataItemTableView = sorting("Sell-to Customer No.") where("Document Type" = const(Order), Type = const(Item), "No." = filter(<> ''));

                    column(IsOrder; '1')
                    {
                    }
                    column(BranchNo_Order; Order."PDC Branch No.")
                    {
                    }
                    column(CustRef_Order; Order."PDC Customer Reference")
                    {
                    }
                    column(Type_Order; DocType)
                    {
                    }
                    column(DocNo_Order; Order."Document No.")
                    {
                    }
                    column(ShipNo_Order; SalesShipNo)
                    {
                    }
                    column(DocDate_Order; NAVPortalsMgt.FormatDate(Order."Posting Date"))
                    {
                    }
                    column(ItemNo_Order; Order."No.")
                    {
                    }
                    column(Description_Order; Order.Description)
                    {
                    }
                    column(Colour_Order; Item."PDC Colour")
                    {
                    }
                    column(Fit_Order; Item."PDC Fit")
                    {
                    }
                    column(Size_Order; Item."PDC Size")
                    {
                    }
                    column(Quantity_Order; Order.Quantity)
                    {
                    }
                    column(WebOrderNo_Order; Order."PDC Web Order No.")
                    {
                    }
                    column(WearerID_Order; Order."PDC Wearer ID")
                    {
                    }
                    column(WearerName_Order; Order."PDC Wearer Name")
                    {
                    }
                    column(OrderedByID_Order; Order."PDC Ordered By ID")
                    {
                    }
                    column(OrderedByName_Order; Order."PDC Ordered By Name")
                    {
                    }
                    column(Total_Order; Order."Amount Including VAT")
                    {
                    }
                    column(VAT_Order; Order."Amount Including VAT" - Invoice.Amount)
                    {
                    }
                    column(OrderDate_Order; NAVPortalsMgt.FormatDate(OrderHdr."Document Date"))
                    {
                    }
                    column(DeliveryDate_Order; NAVPortalsMgt.FormatDate(Order."Posting Date"))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        OrderHdr.Get("Document Type", "Document No.");
                        Item.Get("No.");

                        DocType := OrderTypeTxt;

                        Clear(SalesShipNo);

                        LinesInDataset += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PortalUser.Id <> '' then
                            SetRange("PDC Ordered By ID", PortalUser."Contact No.");
                        if ((StartDate <> 0D) and (EndDate <> 0D)) then
                            SetRange("Posting Date", StartDate, EndDate);
                        if BranchFilter <> '' then
                            SetFilter("PDC Branch No.", BranchFilter);
                        if typeFilter <> '' then
                            if StrPos(UpperCase(typeFilter), 'ORDER=TRUE') = 0 then
                                CurrReport.Break();
                    end;
                }
                dataitem(Draft; "PDC Draft Order Item Line")
                {
                    DataItemLink = "Staff ID" = field("Staff ID");
                    DataItemTableView = sorting("Document No.", "Staff Line No.", "Line No.") where("Item No." = filter(<> ''));

                    column(IsDraft; '1')
                    {
                    }
                    column(BranchNo_Draft; Draft."Branch ID")
                    {
                    }
                    column(CustRef_Draft; DraftHdr."PO No.")
                    {
                    }
                    column(Type_Draft; DocType)
                    {
                    }
                    column(DocNo_Draft; DraftHdr."Document No.")
                    {
                    }
                    column(ShipNo_Draft; SalesShipNo)
                    {
                    }
                    column(DocDate_Draft; NAVPortalsMgt.FormatDate(Dt2Date(DraftHdr."Created Date")))
                    {
                    }
                    column(ItemNo_Draft; Draft."Item No.")
                    {
                    }
                    column(Description_Draft; Draft."Item Description")
                    {
                    }
                    column(Colour_Draft; Item."PDC Colour")
                    {
                    }
                    column(Fit_Draft; Item."PDC Fit")
                    {
                    }
                    column(Size_Draft; Item."PDC Size")
                    {
                    }
                    column(Quantity_Draft; Draft.Quantity)
                    {
                    }
                    column(WebOrderNo_Draft; Draft."Document No.")
                    {
                    }
                    column(WearerID_Draft; DraftStaffLine."Wearer ID")
                    {
                    }
                    column(WearerName_Draft; DraftStaffLine."Staff Name")
                    {
                    }
                    column(OrderedByID_Draft; PortalUser.Id)
                    {
                    }
                    column(OrderedByName_Draft; PortalUser.Name)
                    {
                    }
                    column(Total_Draft; Draft."Line Amount")
                    {
                    }
                    column(VAT_Draft; '0')
                    {
                    }
                    column(OrderDate_Draft; NAVPortalsMgt.FormatDate(Dt2Date(DraftHdr."Created Date")))
                    {
                    }
                    column(DeliveryDate_Draft; NAVPortalsMgt.FormatDate(DraftHdr."Requested Shipment Date"))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DraftHdr.Get("Document No.");
                        if PortalUser.Id <> '' then
                            if not (DraftHdr."Created By ID" = PortalUser."Contact No.") then CurrReport.Skip();
                        if ((StartDate <> 0D) and (EndDate <> 0D)) then
                            if not (Dt2Date(DraftHdr."Created Date") in [StartDate .. EndDate]) then
                                CurrReport.Skip();

                        DraftStaffLine.Get("Document No.", "Staff Line No.");
                        Item.Get("Item No.");

                        DocType := DraftTypeTxt;

                        Clear(SalesShipNo);

                        PortalUser.SetRange("Contact No.", DraftHdr."Created By ID");
                        if PortalUser.FindFirst() then;

                        LinesInDataset += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if BranchFilter <> '' then
                            SetFilter("Branch ID", BranchFilter);
                        if typeFilter <> '' then
                            if StrPos(UpperCase(typeFilter), 'DRAFT=TRUE') = 0 then
                                CurrReport.Break();
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                if CustNoFilter <> '' then
                    SetFilter("No.", CustNoFilter);

                if UpperCase(BranchFilter) = 'ALL' then
                    Clear(BranchFilter);

                if PortalUserID <> '' then begin
                    PortalUser.SetRange(Id, PortalUserID);
                    if PortalUser.FindFirst() then;
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
        CustomerLbl = 'Customer';
        StaffIDLbl = 'Staff ID';
        StaffNameLbl = 'Staff Name';
        BranchLbl = 'Branch';
        CustRefLbl = 'Customer Reference';
        TypeLbl = 'Type';
        DocNoLbl = 'Document No.';
        ShipNoLbl = 'Shipment No.';
        DateLbl = 'Date';
        ItemNoLbl = 'Item No.';
        DescriptionLbl = 'Description';
        ColourLbl = 'Colour';
        FitLbl = 'Fit';
        SizeLbl = 'Size';
        QtyLbl = 'Quantity';
        WebOrdNoLbl = 'Web Order No.';
        WearerIDLbl = 'Wearer ID';
        WearerNameLbl = 'Wearer Name';
        OrderedByIDLbl = 'Ordered By ID';
        OrderedByNameLbl = 'Ordered By Name';
        TotalLbl = 'Total';
        VATLbl = 'VAT';
        OrderDateLbl = 'Order Date';
        DeliveryDateLbl = 'Delivery Date';
    }

    var
        PortalUser: Record "PDC Portal User";
        InvoiceHdr: Record "Sales Invoice Header";
        CrMemoHdr: Record "Sales Cr.Memo Header";
        OrderHdr: Record "Sales Header";
        DraftHdr: Record "PDC Draft Order Header";
        DraftStaffLine: Record "PDC Draft Order Staff Line";
        Item: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        NAVPortalsMgt: Codeunit "PDC Portals Management";
        CustNoFilter: Text;
        PortalUserID: Text;
        BranchFilter: Text;
        InvoiceTypeTxt: label 'Invoice';
        SalesShipNo: Code[20];
        DocType: Text;
        CmMemoTypeTxt: label 'Credit Memo';
        OrderTypeTxt: label 'Order';
        DraftTypeTxt: label 'Draft';
        StartDate: Date;
        EndDate: Date;
        typeFilter: Text;
        LinesInDataset: Integer;

    procedure InitializeRequest(NewCustNoFilter: Text; NewPortalUserID: Text; NewStartDate: Date; NewEndDate: Date; NewbranchFilter: Text; NewtypeFilter: Text)
    begin
        CustNoFilter := NewCustNoFilter;
        PortalUserID := NewPortalUserID;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        BranchFilter := NewbranchFilter;
        typeFilter := NewtypeFilter;
    end;
}

