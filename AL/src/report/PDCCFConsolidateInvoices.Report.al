/// <summary>
/// Report PDC CF Consolidate Invoices (ID 50066).
/// </summary>
Report 50066 "PDC CF Consolidate Invoices"
{

    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/CFConsolidateInvoices.rdlc';
    Caption = 'CF Consolidate Invoices';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(ConsolidationBuffer; "PDC Consolidation Buffer")
        {
            DataItemTableView = sorting(Type, "Customer No.", "Branch No.", "Customer Reference", "Invoice No.", "Shipment No.", "Item No.", "Wearer ID", "Contract No.");
            RequestFilterFields = "Customer No.", "Branch No.", "Customer Reference", "Invoice No.";
            UseTemporary = true;

            column(GroupBy; g_GroupBy)
            {
            }
            column(CustomerNo_ConsolidationBuffer; ConsolidationBuffer."Customer No.")
            {
            }
            column(CustomerName_ConsolidationBuffer; g_Customer.Name)
            {
            }
            column(BranchNo_ConsolidationBuffer; ConsolidationBuffer."Branch No.")
            {
            }
            column(CustomerReference_ConsolidationBuffer; ConsolidationBuffer."Customer Reference")
            {
            }
            column(InvoiceNo_ConsolidationBuffer; ConsolidationBuffer."Invoice No.")
            {
            }
            column(ShipmentNo_ConsolidationBuffer; ConsolidationBuffer."Shipment No.")
            {
            }
            column(ItemNo_ConsolidationBuffer; ConsolidationBuffer."Item No.")
            {
            }
            column(Date_ConsolidationBuffer; ConsolidationBuffer.Date)
            {
            }
            column(OrderDate_ConsolidationBuffer; ConsolidationBuffer."Order Date")
            {
            }
            column(DeliveryDate_ConsolidationBuffer; ConsolidationBuffer."Delivery Date")
            {
            }
            column(Type_ConsolidationBuffer; ConsolidationBuffer.Type)
            {
            }
            column(StaffID_ConsolidationBuffer; ConsolidationBuffer."Staff ID")
            {
            }
            column(WearerID_ConsolidationBuffer; ConsolidationBuffer."Wearer ID")
            {
            }
            column(WearerName_ConsolidationBuffer; ConsolidationBuffer."Wearer Name")
            {
            }
            column(WebOrderNo_ConsolidationBuffer; ConsolidationBuffer."Web Order No.")
            {
            }
            column(OrderedByID_ConsolidationBuffer; ConsolidationBuffer."Ordered By ID")
            {
            }
            column(OrderedByName_ConsolidationBuffer; ConsolidationBuffer."Ordered By Name")
            {
            }
            column(OrderedByPhone_ConsolidationBuffer; ConsolidationBuffer."Ordered By Phone")
            {
            }
            column(Quantity_ConsolidationBuffer; ConsolidationBuffer.Quantity)
            {
            }
            column(LineTotal_ConsolidationBuffer; ConsolidationBuffer."Line Total")
            {
            }
            column(LineTotalIncludingVAT_ConsolidationBuffer; ConsolidationBuffer."Line Total Including VAT")
            {
            }
            column(ProtexSKU; g_Item."PDC Product Code")
            {
            }
            column(Colur; g_Item."PDC Colour")
            {
            }
            column(Size; g_Item."PDC Size")
            {
            }
            column(Fit; g_Item."PDC Fit")
            {
            }
            column(Style; g_Item."PDC Style")
            {
            }
            column(Description; g_Item.Description)
            {
            }
            column(ProductGroupCode; g_Item."Item Category Code")
            {
            }
            column(ContractNo_ConsolidationBuffer; g_Contract."Contract Code")
            {
            }
            column(ContractName; g_Contract.Description)
            {
            }
            column(OrderReason_ConsolidationBuffer; ConsolidationBuffer."Order Reason")
            {
            }
            column(CreatedByID_ConsolidationBuffer; ConsolidationBuffer."Created By ID")
            {
            }
            column(CreatedByName_ConsolidationBuffer; ConsolidationBuffer."Created By Name")
            {
            }
            column(OrderNo; g_SalesInvHdr."Order No.")
            {
            }
            column(WardrobeID; g_WardrobeHeader."Wardrobe ID")
            {
            }
            column(WardrobeDescription; g_WardrobeHeader.Description)
            {
            }
            column(ItemNetWeight; g_Item."Net Weight")
            {
            }
            column(CarbonEmissionsCO2e; ConsolidationBuffer."Carbon Emissions CO2e")
            {
            }
            column(ContractItem; ConsolidationBuffer."Contract Item") { }
            column(ContractColour; ConsolidationBuffer."Contract Colour") { }
            column(ContractSize; ConsolidationBuffer."Contract Size") { }
            column(ContractBranding; ConsolidationBuffer."Contract Branding") { }
            column(ShipToPostCode; ConsolidationBuffer."Ship-to Post Code") { }
            column(BranchLevel0; ConsolidationBuffer."Branch Level 0") { }
            column(BranchLevel1; ConsolidationBuffer."Branch Level 1") { }
            column(BranchLevel2; ConsolidationBuffer."Branch Level 2") { }
            column(BranchLevel3; ConsolidationBuffer."Branch Level 3") { }
            column(CFAttr12; ConsolidationBuffer."CF Attr 12") { }
            column(CFAttr13; ConsolidationBuffer."CF Attr 13") { }
            column(CFAttr14; ConsolidationBuffer."CF Attr 14") { }
            column(CFAttr15; ConsolidationBuffer."CF Attr 15") { }
            column(CFAttr16; ConsolidationBuffer."CF Attr 16") { }
            column(CFAttr17; ConsolidationBuffer."CF Attr 17") { }
            column(CFAttr18; ConsolidationBuffer."CF Attr 18") { }
            column(CFAttr19; ConsolidationBuffer."CF Attr 19") { }
            column(CFAttr20; ConsolidationBuffer."CF Attr 20") { }
            column(CFAttr21; ConsolidationBuffer."CF Attr 21") { }
            column(CFAttr22; ConsolidationBuffer."CF Attr 22") { }
            column(CFAttr23; ConsolidationBuffer."CF Attr 23") { }
            column(CFAttr24; ConsolidationBuffer."CF Attr 24") { }
            column(CFAttr25; ConsolidationBuffer."CF Attr 25") { }
            column(CFAttr26; ConsolidationBuffer."CF Attr 26") { }
            column(CFAttr27; ConsolidationBuffer."CF Attr 27") { }
            column(CFAttr28; ConsolidationBuffer."CF Attr 28") { }
            column(CFAttr29; ConsolidationBuffer."CF Attr 29") { }
            column(CFAttr30; ConsolidationBuffer."CF Attr 30") { }
            column(CFAttr31; ConsolidationBuffer."CF Attr 31") { }
            column(CFAttr32; ConsolidationBuffer."CF Attr 32") { }
            column(CFAttr33; ConsolidationBuffer."CF Attr 33") { }
            column(CFAttr34; ConsolidationBuffer."CF Attr 34") { }
            column(CFAttr35; ConsolidationBuffer."CF Attr 35") { }
            column(CFAttr36; ConsolidationBuffer."CF Attr 36") { }
            column(CFAttr37; ConsolidationBuffer."CF Attr 37") { }
            column(CFAttr38; ConsolidationBuffer."CF Attr 38") { }
            column(CFAttr39; ConsolidationBuffer."CF Attr 39") { }
            column(CFAttr40; ConsolidationBuffer."CF Attr 40") { }
            column(CFAttr41; ConsolidationBuffer."CF Attr 41") { }
            column(CFAttr42; ConsolidationBuffer."CF Attr 42") { }
            column(CFAttr43; ConsolidationBuffer."CF Attr 43") { }
            column(CFAttr44; ConsolidationBuffer."CF Attr 44") { }
            column(CFAttr45; ConsolidationBuffer."CF Attr 45") { }
            column(CFAttr46; ConsolidationBuffer."CF Attr 46") { }
            column(CFAttr47; ConsolidationBuffer."CF Attr 47") { }
            column(CFAttr48; ConsolidationBuffer."CF Attr 48") { }
            column(CFAttr49; ConsolidationBuffer."CF Attr 49") { }
            column(CFAttr50; ConsolidationBuffer."CF Attr 50") { }
            column(CFAttr51; ConsolidationBuffer."CF Attr 51") { }
            column(CFAttr52; ConsolidationBuffer."CF Attr 52") { }
            column(CFAttr53; ConsolidationBuffer."CF Attr 53") { }
            column(CFAttr54; ConsolidationBuffer."CF Attr 54") { }
            column(CFAttr55; ConsolidationBuffer."CF Attr 55") { }
            column(CFAttr56; ConsolidationBuffer."CF Attr 56") { }
            column(CFAttr57; ConsolidationBuffer."CF Attr 57") { }
            column(CFAttr58; ConsolidationBuffer."CF Attr 58") { }
            column(CFAttr59; ConsolidationBuffer."CF Attr 59") { }
            column(CFAttr60; ConsolidationBuffer."CF Attr 60") { }
            column(CFAttr61; ConsolidationBuffer."CF Attr 61") { }
            column(CFAttr62; ConsolidationBuffer."CF Attr 62") { }
            column(CFAttr63; ConsolidationBuffer."CF Attr 63") { }
            column(CFAttr64; ConsolidationBuffer."CF Attr 64") { }
            column(CFAttr65; ConsolidationBuffer."CF Attr 65") { }
            column(CFAttr66; ConsolidationBuffer."CF Attr 66") { }
            column(CFAttr67; ConsolidationBuffer."CF Attr 67") { }
            column(CFAttr68; ConsolidationBuffer."CF Attr 68") { }
            column(CFAttr69; ConsolidationBuffer."CF Attr 69") { }
            column(CFAttr70; ConsolidationBuffer."CF Attr 70") { }

            trigger OnAfterGetRecord()
            begin
                g_Customer.get(ConsolidationBuffer."Customer No.");

                if not g_Item.Get(ConsolidationBuffer."Item No.") then begin
                    g_Item."PDC Product Code" := '';
                    g_Item."PDC Colour" := '';
                    g_Item."PDC Size" := '';
                    g_Item."PDC Fit" := '';
                    g_Item."PDC Style" := '';
                    g_Item.Description := 'G/L Account';
                    g_Item."Item Category Code" := '';
                end;

                if not g_Contract.Get("Customer No.", "Contract No.") then Clear(g_Contract);

                if not g_SalesInvHdr.get("Invoice No.") then clear(g_SalesInvHdr);

                if not g_WardrobeHeader.get(ConsolidationBuffer."Wardrobe ID") then clear(g_WardrobeHeader);

                LinesInDataset += 1;
            end;

            trigger OnPreDataItem()
            begin
                g_ConsBufferFilter.CopyFilters(ConsolidationBuffer);
                g_SalesInvLine.SetRange("Posting Date", g_StartDate, g_EndDate);
                g_SalesInvLine.SetFilter(Type, '<>%1', g_SalesInvLine.Type::" ");
                g_SalesInvLine.SetFilter(Quantity, '<>0');

                g_CrMemoLine.SetRange("Posting Date", g_StartDate, g_EndDate);
                g_CrMemoLine.SetFilter(Type, '<>%1', g_CrMemoLine.Type::" ");
                g_CrMemoLine.SetFilter(Quantity, '<>0');

                if CustNoFilter <> '' then
                    SetFilter("Customer No.", CustNoFilter);

                if GetFilter("Customer No.") <> '' then begin
                    g_SalesInvLine.SetFilter("Sell-to Customer No.", GetFilter("Customer No."));
                    g_CrMemoLine.SetFilter("Sell-to Customer No.", GetFilter("Customer No."));
                end;

                if GetFilter("Invoice No.") <> '' then begin
                    g_SalesInvLine.SetFilter("Document No.", GetFilter("Invoice No."));
                    g_CrMemoLine.SetFilter("Document No.", GetFilter("Invoice No."));
                end;

                if GetFilter("Branch No.") <> '' then begin
                    g_SalesInvLine.SetFilter("PDC Branch No.", GetFilter("Branch No."));
                    g_CrMemoLine.SetFilter("PDC Branch No.", GetFilter("Branch No."));
                end;

                if GetFilter("Item No.") <> '' then begin
                    g_SalesInvLine.SetFilter("No.", GetFilter("Item No."));
                    g_CrMemoLine.SetFilter("No.", GetFilter("Item No."));
                end;

                ConsolidationBuffer.Reset();
                ConsolidationBuffer.DeleteAll();

                if g_SalesInvLine.Findset() then
                    repeat
                        AddToBuffer2(0, g_SalesInvLine."Document No.", g_SalesInvLine."Line No.");
                    until g_SalesInvLine.next() = 0;

                if g_CrMemoLine.Findset() then
                    repeat
                        AddToBuffer2(1, g_CrMemoLine."Document No.", g_CrMemoLine."Line No.");
                    until g_CrMemoLine.next() = 0;


                ConsolidationBuffer.CopyFilters(g_ConsBufferFilter);
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
                field(StartDate; g_StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Start Date';
                }
                field(EndDate; g_EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'End Date';
                }
                field(GroupBy; g_GroupBy)
                {
                    ApplicationArea = All;
                    Caption = 'Group By';
                    ToolTip = 'Group By';
                    OptionCaption = 'Cust. Acc.+Branch No.,Cust. Acc.+Branch No.+Cust. Ref,Cust .Acc + Contract,Cust .Acc + Cust. Ref,Cust. Acc.,Do Not Group';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            g_StartDate := Today;
            g_EndDate := Today;
        end;
    }

    labels
    {
        BranchLbl = 'Branch No.';
        CustomerNoLbl = 'Customer No.';
        CustomerNameLbl = 'Customer Name';
        CustomerRefLbl = 'Customer Reference';
        TypeLbl = 'Type';
        InvNoLbl = 'Invoice No.';
        ShipmentLbl = 'Shipment No.';
        DateLbl = 'Date';
        ItemNoLbl = 'Item No.';
        ColourLbl = 'Colour';
        FitLbl = 'Fit';
        SizeLbl = 'Size';
        QtyLbl = 'Quantity';
        WebOrderNoLbl = 'Web Order No.';
        WearerIDLbl = 'Wearer ID';
        WearerNameLbl = 'Wearer Name';
        WardrobeIDLbl = 'Wardrobe ID';
        WardrobeDescriptionLbl = 'Wardrobe Name';
        OrderedByIDLbl = 'Ordered By ID';
        OrderedByLbl = 'Ordered By';
        TotalLbl = 'Total';
        TotalVATLbl = 'VAT';
        OrderDateLbl = 'Order Date';
        DelivDateLbl = 'Delivery Date';
        ContractNoLbl = 'Contract No.';
        ContractNameLbl = 'Contract Name';
        OrderReasonLbl = 'Order Reason';
        CreatedByIDLbl = 'Created By ID';
        CreatedByNameLbl = 'Created By Name';
        OrderNoLbl = 'Order No.';
        NetWeightLbl = 'Net Weight';
        CarbonEmissionLbl = 'Carbon Emissions CO2e';
        StaffIDLbl = 'Staff ID';
    }

    trigger OnPostReport()
    begin
        ConsolidationBuffer.Reset();
    end;

    trigger OnPreReport()
    begin
        if (g_StartDate = 0D) or (g_EndDate = 0D) then
            Error('The Start and End Date cannot be empty.');

        if g_EndDate < g_StartDate then
            Error('The End Date cannot be earlier than the Start Date');
    end;

    var

        g_SalesInvHdr: Record "Sales Invoice header";
        g_SalesInvLine: Record "Sales Invoice Line";
        g_ShipmentLine: Record "Sales Shipment Line";
        g_CrMemoLine: Record "Sales Cr.Memo Line";
        g_Item: Record Item;
        g_WardrobeHeader: Record "PDC Wardrobe Header";
        g_ConsBufferFilter: Record "PDC Consolidation Buffer";
        g_Customer: Record Customer;
        g_Contract: Record "PDC Contract";
        g_StartDate: Date;
        g_EndDate: Date;
        g_GroupBy: Option;
        g_LineTotal: Decimal;
        g_LineTotalIncVAT: Decimal;
        g_LineQty: Decimal;
        CustNoFilter: Text;

        LinesInDataset: Integer;

    local procedure AddToBuffer(pType: Option Invoice,"Credit Memo"; pDocNo: Code[20]; pLineNo: Integer)
    var
        l_SalesInvHdr: Record "Sales Invoice Header";
        l_SalesInvLine: Record "Sales Invoice Line";
        l_CrMemoLine: Record "Sales Cr.Memo Line";
        l_CrMemoHdr: Record "Sales Cr.Memo Header";
        l_ValueEntry: Record "Value Entry";
        l_ItemLedgEntry: Record "Item Ledger Entry";
    begin
        Clear(ConsolidationBuffer);

        if pType = Ptype::Invoice then begin
            l_SalesInvHdr.Get(pDocNo);
            l_SalesInvLine.Get(pDocNo, pLineNo);

            // get the related shipment lines
            l_ValueEntry.SetRange("Document No.", l_SalesInvLine."Document No.");
            l_ValueEntry.SetRange("Item No.", l_SalesInvLine."No.");
            if l_ValueEntry.FindLast() then begin
                l_ItemLedgEntry.Get(l_ValueEntry."Item Ledger Entry No.");
                g_ShipmentLine.SetRange("Document No.", l_ItemLedgEntry."Document No.");
                g_ShipmentLine.SetRange("Order Line No.", pLineNo);
                g_ShipmentLine.SetFilter(Quantity, '<>0');
                if g_ShipmentLine.FindFirst() then begin
                    ConsolidationBuffer."Shipment No." := g_ShipmentLine."Document No.";
                    ConsolidationBuffer."Delivery Date" := g_ShipmentLine."Posting Date";
                    g_LineTotal := ROUND((l_SalesInvLine.Amount / l_SalesInvLine.Quantity) * g_ShipmentLine.Quantity, 0.01);
                    g_LineTotalIncVAT := ROUND(((l_SalesInvLine."Amount Including VAT" - l_SalesInvLine.Amount) / l_SalesInvLine.Quantity) * g_ShipmentLine.Quantity, 0.01);
                    g_LineQty := g_ShipmentLine.Quantity;
                end else begin
                    ConsolidationBuffer."Shipment No." := '';
                    ConsolidationBuffer."Delivery Date" := 0D;
                    g_LineTotal := l_SalesInvLine.Amount;
                    g_LineTotalIncVAT := l_SalesInvLine."Amount Including VAT" - l_SalesInvLine.Amount;
                    g_LineQty := l_SalesInvLine.Quantity;
                end;

                // check if the buffer exists, if not insert, of yes increase quantity and totals
                ConsolidationBuffer.SetRange(Type, pType);
                ConsolidationBuffer.SetRange("Customer No.", l_SalesInvLine."Sell-to Customer No.");
                if g_GroupBy <> 2 then
                    ConsolidationBuffer.SetRange("Branch No.", l_SalesInvLine."PDC Branch No.");
                if g_GroupBy = 1 then
                    ConsolidationBuffer.SetRange("Customer Reference", l_SalesInvLine."PDC Customer Reference");
                ConsolidationBuffer.SetRange("Invoice No.", l_SalesInvLine."Document No.");
                ConsolidationBuffer.SetRange("Shipment No.", g_ShipmentLine."Document No.");
                ConsolidationBuffer.SetRange("Item No.", l_SalesInvLine."No.");
                if l_SalesInvLine."PDC Wearer ID" = '' then
                    ConsolidationBuffer.SetRange("Wearer ID", COPYSTR(l_SalesInvLine."PDC Wearer Name", 1, MaxStrLen(ConsolidationBuffer."Wearer ID")))
                else
                    ConsolidationBuffer.SetRange("Wearer ID", l_SalesInvLine."PDC Wearer ID");
                ConsolidationBuffer.SetRange("Wardrobe ID", l_SalesInvLine."PDC Wardrobe ID");
                ConsolidationBuffer.SetRange("Staff ID", l_SalesInvLine."PDC Staff ID");
                if ConsolidationBuffer.FindFirst() then begin
                    ConsolidationBuffer.Quantity += g_LineQty;
                    ConsolidationBuffer."Line Total" += g_LineTotal;
                    ConsolidationBuffer."Line Total Including VAT" += g_LineTotalIncVAT;
                    ConsolidationBuffer.Modify();
                end else
                    InsertBuffer(pType, l_SalesInvHdr, l_SalesInvLine);
            end;
        end else begin
            l_CrMemoLine.Get(pDocNo, pLineNo);
            if not ConsolidationBuffer.Get(pType, l_CrMemoLine."Sell-to Customer No.", l_CrMemoLine."PDC Branch No.", '', l_CrMemoLine."Document No.", '', l_CrMemoLine."No.", '', '') then begin
                ConsolidationBuffer.Init();
                ConsolidationBuffer."Customer No." := l_CrMemoLine."Sell-to Customer No.";
                ConsolidationBuffer."Branch No." := l_CrMemoLine."PDC Branch No.";
                ConsolidationBuffer."Invoice No." := l_CrMemoLine."Document No.";
                ConsolidationBuffer."Item No." := l_CrMemoLine."No.";
                ConsolidationBuffer.Type := pType;
                l_CrMemoHdr.Get(pDocNo);
                ConsolidationBuffer.Quantity := l_CrMemoLine.Quantity;
                ConsolidationBuffer."Line Total" := -g_CrMemoLine.Amount;
                ConsolidationBuffer."Line Total Including VAT" := -(g_CrMemoLine."Amount Including VAT" - g_CrMemoLine.Amount);
                ConsolidationBuffer.Date := l_CrMemoLine."Posting Date";
                ConsolidationBuffer.Insert();
            end else begin
                ConsolidationBuffer.Quantity += l_CrMemoLine.Quantity;
                ConsolidationBuffer."Line Total" -= g_CrMemoLine.Amount;
                ConsolidationBuffer."Line Total Including VAT" -= (g_CrMemoLine."Amount Including VAT" - g_CrMemoLine.Amount);
                ConsolidationBuffer.modify();
            end;
        end;
    end;

    local procedure InsertBuffer(pType: Option; p_SalesInvHdr: Record "Sales Invoice Header"; p_SalesInvLine: Record "Sales Invoice Line")
    begin
        ConsolidationBuffer.Type := pType;
        ConsolidationBuffer."Customer No." := p_SalesInvLine."Sell-to Customer No.";
        ConsolidationBuffer."Branch No." := p_SalesInvLine."PDC Branch No.";
        ConsolidationBuffer."Customer Reference" := p_SalesInvLine."PDC Customer Reference";

        ConsolidationBuffer."Invoice No." := p_SalesInvLine."Document No.";
        ConsolidationBuffer."Item No." := p_SalesInvLine."No.";
        if p_SalesInvLine."PDC Wearer ID" = '' then
            ConsolidationBuffer."Wearer ID" := COPYSTR(p_SalesInvLine."PDC Wearer Name", 1, MaxStrLen(ConsolidationBuffer."Wearer ID"))
        else
            ConsolidationBuffer."Wearer ID" := p_SalesInvLine."PDC Wearer ID";
        ConsolidationBuffer."Wardrobe ID" := p_SalesInvLine."PDC Wardrobe ID";
        ConsolidationBuffer."Staff ID" := p_SalesInvLine."PDC Staff ID";
        ConsolidationBuffer."Shipment No." := g_ShipmentLine."Document No.";
        ConsolidationBuffer.Quantity += g_LineQty;
        ConsolidationBuffer."Line Total" += g_LineTotal;
        ConsolidationBuffer."Line Total Including VAT" += g_LineTotalIncVAT;
        ConsolidationBuffer.Date := g_SalesInvLine."Posting Date";
        ConsolidationBuffer."Order Date" := p_SalesInvHdr."Order Date";
        ConsolidationBuffer."Wearer Name" := p_SalesInvLine."PDC Wearer Name";
        ConsolidationBuffer."Web Order No." := p_SalesInvLine."PDC Web Order No.";
        ConsolidationBuffer."Ordered By ID" := p_SalesInvLine."PDC Ordered By ID";
        ConsolidationBuffer."Ordered By Name" := p_SalesInvLine."PDC Ordered By Name";
        ConsolidationBuffer."Ordered By Phone" := p_SalesInvLine."PDC Ordered By Phone";
        ConsolidationBuffer."Contract No." := p_SalesInvLine."PDC Contract No.";
        ConsolidationBuffer."Order Reason" := p_SalesInvLine."PDC Order Reason";
        ConsolidationBuffer."Created By ID" := p_SalesInvLine."PDC Created By ID";
        ConsolidationBuffer."Created By Name" := p_SalesInvLine."PDC Created By Name";
        ConsolidationBuffer."Carbon Emissions CO2e" := p_SalesInvLine."PDC Carbon Emissions CO2e";
        PopulateAttributes(p_SalesInvLine."No.");
        PopulateBranchHierarchy(p_SalesInvLine."Sell-to Customer No.", p_SalesInvLine."PDC Branch No.");
        PopulateShipToPostCode(p_SalesInvLine."Document No.");
        ConsolidationBuffer.Insert();
    end;

    local procedure InsertBufferCrMemo(pType: Option; p_SalesCrMemoHdr: Record "Sales Cr.Memo Header"; p_SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        ConsolidationBuffer.Type := pType;
        ConsolidationBuffer."Customer No." := p_SalesCrMemoLine."Sell-to Customer No.";
        ConsolidationBuffer."Branch No." := p_SalesCrMemoLine."PDC Branch No.";
        ConsolidationBuffer."Customer Reference" := p_SalesCrMemoLine."PDC Customer Reference";
        ConsolidationBuffer."Invoice No." := p_SalesCrMemoLine."Document No.";
        ConsolidationBuffer."Item No." := p_SalesCrMemoLine."No.";
        if p_SalesCrMemoLine."PDC Wearer ID" = '' then
            ConsolidationBuffer."Wearer ID" := COPYSTR(p_SalesCrMemoLine."PDC Wearer Name", 1, MaxStrLen(ConsolidationBuffer."Wearer ID"))
        else
            ConsolidationBuffer."Wearer ID" := p_SalesCrMemoLine."PDC Wearer ID";
        ConsolidationBuffer."Wardrobe ID" := p_SalesCrMemoLine."PDC Wardrobe ID";
        ConsolidationBuffer."Staff ID" := p_SalesCrMemoLine."PDC Staff ID";
        ConsolidationBuffer."Shipment No." := g_ShipmentLine."Document No.";
        ConsolidationBuffer.Quantity += -g_LineQty;
        ConsolidationBuffer."Line Total" += -g_LineTotal;
        ConsolidationBuffer."Line Total Including VAT" += -g_LineTotalIncVAT;
        ConsolidationBuffer.Date := g_CrMemoLine."Posting Date";
        ConsolidationBuffer."Wearer Name" := p_SalesCrMemoLine."PDC Wearer Name";
        ConsolidationBuffer."Web Order No." := p_SalesCrMemoLine."PDC Web Order No.";
        ConsolidationBuffer."Ordered By ID" := p_SalesCrMemoLine."PDC Ordered By ID";
        ConsolidationBuffer."Ordered By Name" := p_SalesCrMemoLine."PDC Ordered By Name";
        ConsolidationBuffer."Contract No." := p_SalesCrMemoLine."PDC Contract No.";
        ConsolidationBuffer."Order Reason" := '';
        ConsolidationBuffer."Created By ID" := p_SalesCrMemoLine."PDC Created By ID";
        ConsolidationBuffer."Created By Name" := p_SalesCrMemoLine."PDC Created By Name";
        ConsolidationBuffer."Carbon Emissions CO2e" := p_SalesCrMemoLine."PDC Carbon Emissions CO2e";
        PopulateAttributes(p_SalesCrMemoLine."No.");
        PopulateBranchHierarchy(p_SalesCrMemoLine."Sell-to Customer No.", p_SalesCrMemoLine."PDC Branch No.");
        ConsolidationBuffer."Ship-to Post Code" := p_SalesCrMemoHdr."Ship-to Post Code";
        ConsolidationBuffer.Insert();
    end;

    local procedure PopulateAttributes(ItemNo: Code[20])
    var
        ItemAttrValueMapping: Record "Item Attribute Value Mapping";
        ItemAttrValue: Record "Item Attribute Value";
        AttrID: Integer;
        FieldNo: Integer;
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        // Contract attributes (IDs 8-11 → Boolean fields 27-30)
        for AttrID := 8 to 11 do begin
            ItemAttrValueMapping.SetRange("Table ID", Database::Item);
            ItemAttrValueMapping.SetRange("No.", ItemNo);
            ItemAttrValueMapping.SetRange("Item Attribute ID", AttrID);
            FieldNo := AttrID + 19; // 8→27, 9→28, 10→29, 11→30
            case FieldNo of
                27:
                    ConsolidationBuffer."Contract Item" := ItemAttrValueMapping.FindFirst();
                28:
                    ConsolidationBuffer."Contract Colour" := ItemAttrValueMapping.FindFirst();
                29:
                    ConsolidationBuffer."Contract Size" := ItemAttrValueMapping.FindFirst();
                30:
                    ConsolidationBuffer."Contract Branding" := ItemAttrValueMapping.FindFirst();
            end;
        end;

        // Fabric attributes (IDs 12-70 → Decimal fields 36-94, mapping: FieldID = AttrID + 24)
        ItemAttrValueMapping.Reset();
        ItemAttrValueMapping.SetRange("Table ID", Database::Item);
        ItemAttrValueMapping.SetRange("No.", ItemNo);
        ItemAttrValueMapping.SetFilter("Item Attribute ID", '%1..%2', 12, 70);
        if ItemAttrValueMapping.FindSet() then begin
            RecRef.GetTable(ConsolidationBuffer);
            repeat
                FieldNo := ItemAttrValueMapping."Item Attribute ID" + 24;
                if ItemAttrValue.Get(ItemAttrValueMapping."Item Attribute ID", ItemAttrValueMapping."Item Attribute Value ID") then begin
                    FldRef := RecRef.Field(FieldNo);
                    FldRef.Value := ItemAttrValue."Numeric Value";
                end;
            until ItemAttrValueMapping.Next() = 0;
            RecRef.SetTable(ConsolidationBuffer);
        end;
    end;

    local procedure PopulateBranchHierarchy(CustomerNo: Code[20]; BranchNo: Code[20])
    var
        Branch: Record "PDC Branch";
        ParentBranch: Record "PDC Branch";
    begin
        if BranchNo = '' then
            exit;
        if not Branch.Get(CustomerNo, BranchNo) then
            exit;

        case Branch.Indentation of
            0:
                ConsolidationBuffer."Branch Level 0" := CopyStr(Branch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 0"));
            1:
                begin
                    ConsolidationBuffer."Branch Level 1" := CopyStr(Branch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 1"));
                    if ParentBranch.Get(CustomerNo, Branch."Parent Branch No.") then
                        ConsolidationBuffer."Branch Level 0" := CopyStr(ParentBranch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 0"));
                end;
            2:
                begin
                    ConsolidationBuffer."Branch Level 2" := CopyStr(Branch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 2"));
                    if ParentBranch.Get(CustomerNo, Branch."Parent Branch No.") then begin
                        ConsolidationBuffer."Branch Level 1" := CopyStr(ParentBranch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 1"));
                        if Branch.Get(CustomerNo, ParentBranch."Parent Branch No.") then
                            ConsolidationBuffer."Branch Level 0" := CopyStr(Branch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 0"));
                    end;
                end;
            3:
                begin
                    ConsolidationBuffer."Branch Level 3" := CopyStr(Branch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 3"));
                    if ParentBranch.Get(CustomerNo, Branch."Parent Branch No.") then begin
                        ConsolidationBuffer."Branch Level 2" := CopyStr(ParentBranch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 2"));
                        if Branch.Get(CustomerNo, ParentBranch."Parent Branch No.") then begin
                            ConsolidationBuffer."Branch Level 1" := CopyStr(Branch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 1"));
                            if ParentBranch.Get(CustomerNo, Branch."Parent Branch No.") then
                                ConsolidationBuffer."Branch Level 0" := CopyStr(ParentBranch.Name, 1, MaxStrLen(ConsolidationBuffer."Branch Level 0"));
                        end;
                    end;
                end;
        end;
    end;

    local procedure PopulateShipToPostCode(InvoiceNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        if SalesInvHeader.Get(InvoiceNo) then
            ConsolidationBuffer."Ship-to Post Code" := SalesInvHeader."Ship-to Post Code";
    end;

    local procedure AddToBuffer2(pType: Option Invoice,"Credit Memo"; pDocNo: Code[20]; pLineNo: Integer)
    var
        l_SalesInvHdr: Record "Sales Invoice Header";
        l_SalesInvLine: Record "Sales Invoice Line";
        l_CrMemoLine: Record "Sales Cr.Memo Line";
        l_CrMemoHdr: Record "Sales Cr.Memo Header";
        l_ValueEntry: Record "Value Entry";
        l_ItemLedgEntry: Record "Item Ledger Entry";
    begin
        Clear(ConsolidationBuffer);

        if pType = Ptype::Invoice then begin
            l_SalesInvHdr.Get(pDocNo);
            l_SalesInvLine.Get(pDocNo, pLineNo);

            // get the related shipment lines
            l_ValueEntry.SetRange("Document No.", l_SalesInvLine."Document No.");
            l_ValueEntry.SetRange("Item No.", l_SalesInvLine."No.");
            if l_ValueEntry.FindLast() then begin
                l_ItemLedgEntry.Get(l_ValueEntry."Item Ledger Entry No.");
                g_ShipmentLine.SetRange("Document No.", l_ItemLedgEntry."Document No.");
                g_ShipmentLine.SetRange("Order Line No.", pLineNo);
                g_ShipmentLine.SetFilter(Quantity, '<>0');
                if g_ShipmentLine.FindFirst() then begin
                    ConsolidationBuffer."Shipment No." := g_ShipmentLine."Document No.";
                    ConsolidationBuffer."Delivery Date" := g_ShipmentLine."Posting Date";
                    g_LineTotal := ROUND((l_SalesInvLine.Amount / l_SalesInvLine.Quantity) * g_ShipmentLine.Quantity, 0.01);
                    g_LineTotalIncVAT := ROUND(((l_SalesInvLine."Amount Including VAT" - l_SalesInvLine.Amount) / l_SalesInvLine.Quantity) * g_ShipmentLine.Quantity, 0.01);
                    g_LineQty := g_ShipmentLine.Quantity;
                end else begin
                    ConsolidationBuffer."Shipment No." := '';
                    ConsolidationBuffer."Delivery Date" := 0D;
                    g_LineTotal := l_SalesInvLine.Amount;
                    g_LineTotalIncVAT := l_SalesInvLine."Amount Including VAT" - l_SalesInvLine.Amount;
                    g_LineQty := l_SalesInvLine.Quantity;
                end;
            end
            else begin
                ConsolidationBuffer."Shipment No." := '';
                ConsolidationBuffer."Delivery Date" := 0D;
                g_LineTotal := l_SalesInvLine.Amount;
                g_LineTotalIncVAT := l_SalesInvLine."Amount Including VAT" - l_SalesInvLine.Amount;
                g_LineQty := l_SalesInvLine.Quantity;
            end;

            // check if the buffer exists, if not insert, of yes increase quantity and totals
            ConsolidationBuffer.SetRange(Type, pType);
            ConsolidationBuffer.SetRange("Customer No.", l_SalesInvLine."Sell-to Customer No.");
            if g_GroupBy in [0, 1] then
                ConsolidationBuffer.SetRange("Branch No.", l_SalesInvLine."PDC Branch No.");
            if g_GroupBy in [1, 3] then
                ConsolidationBuffer.SetRange("Customer Reference", l_SalesInvLine."PDC Customer Reference");
            if g_GroupBy in [2] then
                ConsolidationBuffer.SetRange("Contract No.", l_SalesInvLine."PDC Contract No.");
            ConsolidationBuffer.SetRange("Invoice No.", l_SalesInvLine."Document No.");
            ConsolidationBuffer.SetRange("Shipment No.", g_ShipmentLine."Document No.");
            ConsolidationBuffer.SetRange("Item No.", l_SalesInvLine."No.");
            if l_SalesInvLine."PDC Wearer ID" = '' then
                ConsolidationBuffer.SetRange("Wearer ID", COPYSTR(l_SalesInvLine."PDC Wearer Name", 1, MaxStrLen(ConsolidationBuffer."Wearer ID")))
            else
                ConsolidationBuffer.SetRange("Wearer ID", l_SalesInvLine."PDC Wearer ID");
            ConsolidationBuffer.setrange("Wardrobe ID", l_SalesInvLine."PDC Wardrobe ID");
            ConsolidationBuffer.setrange("Staff ID", l_SalesInvLine."PDC Staff ID");
            if ConsolidationBuffer.FindFirst() then begin
                ConsolidationBuffer.Quantity += g_LineQty;
                ConsolidationBuffer."Line Total" += g_LineTotal;
                ConsolidationBuffer."Line Total Including VAT" += g_LineTotalIncVAT;
                ConsolidationBuffer.Modify();
            end else
                InsertBuffer(pType, l_SalesInvHdr, l_SalesInvLine);
        end else begin
            l_CrMemoHdr.Get(pDocNo);
            l_CrMemoLine.Get(pDocNo, pLineNo);

            // get the related shipment lines
            l_ValueEntry.SetRange("Document No.", l_CrMemoLine."Document No.");
            l_ValueEntry.SetRange("Item No.", l_CrMemoLine."No.");
            if l_ValueEntry.FindLast() then begin
                l_ItemLedgEntry.Get(l_ValueEntry."Item Ledger Entry No.");
                g_ShipmentLine.SetRange("Document No.", l_ItemLedgEntry."Document No.");
                g_ShipmentLine.SetRange("Order Line No.", pLineNo);
                g_ShipmentLine.SetFilter(Quantity, '<>0');
                if g_ShipmentLine.FindFirst() then begin
                    ConsolidationBuffer."Shipment No." := g_ShipmentLine."Document No.";
                    ConsolidationBuffer."Delivery Date" := g_ShipmentLine."Posting Date";
                    g_LineTotal := ROUND((l_CrMemoLine.Amount / l_CrMemoLine.Quantity) * g_ShipmentLine.Quantity, 0.01);
                    g_LineTotalIncVAT := ROUND(((l_CrMemoLine."Amount Including VAT" - l_CrMemoLine.Amount) / l_CrMemoLine.Quantity) * g_ShipmentLine.Quantity, 0.01);
                    g_LineQty := g_ShipmentLine.Quantity;
                end else begin
                    ConsolidationBuffer."Shipment No." := '';
                    ConsolidationBuffer."Delivery Date" := 0D;
                    g_LineTotal := l_CrMemoLine.Amount;
                    g_LineTotalIncVAT := l_CrMemoLine."Amount Including VAT" - l_CrMemoLine.Amount;
                    g_LineQty := l_CrMemoLine.Quantity;
                end;
            end
            else begin
                ConsolidationBuffer."Shipment No." := '';
                ConsolidationBuffer."Delivery Date" := 0D;
                g_LineTotal := l_CrMemoLine.Amount;
                g_LineTotalIncVAT := l_CrMemoLine."Amount Including VAT" - l_CrMemoLine.Amount;
                g_LineQty := l_CrMemoLine.Quantity;
            end;

            // check if the buffer exists, if not insert, of yes increase quantity and totals
            ConsolidationBuffer.SetRange(Type, pType);
            ConsolidationBuffer.SetRange("Customer No.", l_CrMemoLine."Sell-to Customer No.");
            if g_GroupBy in [0, 1] then
                ConsolidationBuffer.SetRange("Branch No.", l_CrMemoLine."PDC Branch No.");
            if g_GroupBy in [1, 3] then
                ConsolidationBuffer.SetRange("Customer Reference", l_CrMemoLine."PDC Customer Reference");
            if g_GroupBy in [2] then
                ConsolidationBuffer.SetRange("Contract No.", l_CrMemoLine."PDC Contract No.");
            ConsolidationBuffer.SetRange("Invoice No.", l_CrMemoLine."Document No.");
            ConsolidationBuffer.SetRange("Shipment No.", g_ShipmentLine."Document No.");
            ConsolidationBuffer.SetRange("Item No.", l_CrMemoLine."No.");
            if l_CrMemoLine."PDC Wearer ID" = '' then
                ConsolidationBuffer.SetRange("Wearer ID", COPYSTR(l_CrMemoLine."PDC Wearer Name", 1, MaxStrLen(ConsolidationBuffer."Wearer ID")))
            else
                ConsolidationBuffer.SetRange("Wearer ID", l_CrMemoLine."PDC Wearer ID");
            ConsolidationBuffer.setrange("Wardrobe ID", l_CrMemoLine."PDC Wardrobe ID");
            ConsolidationBuffer.setrange("Staff ID", l_CrMemoLine."PDC Staff ID");
            if ConsolidationBuffer.FindFirst() then begin
                ConsolidationBuffer.Quantity += -g_LineQty;
                ConsolidationBuffer."Line Total" += -g_LineTotal;
                ConsolidationBuffer."Line Total Including VAT" += -g_LineTotalIncVAT;
                ConsolidationBuffer.Modify();
            end else
                InsertBufferCrMemo(pType, l_CrMemoHdr, l_CrMemoLine);
        end;

    end;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewCustNoFilter">Text.</param>
    /// <param name="NewGroupBy">Option.</param>
    /// <param name="NewStartDate">Date.</param>
    /// <param name="NewEndDate">Date.</param>
    procedure InitializeRequest(NewCustNoFilter: Text; NewGroupBy: Option; NewStartDate: Date; NewEndDate: Date)
    begin
        //19.06.2019 JEMEL J.Jemeljanovs #3003
        CustNoFilter := NewCustNoFilter;
        g_GroupBy := NewGroupBy;
        g_StartDate := NewStartDate;
        g_EndDate := NewEndDate;
    end;
}
