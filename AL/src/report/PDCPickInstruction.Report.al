/// <summary>
/// Report PDC Pick Instruction (ID 50005).
/// </summary>
Report 50005 "PDC Pick Instruction"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PDCPickInstruction.rdlc';
    Caption = 'Pick Instruction';

    dataset
    {
        dataitem(CopyLoop; "Integer")
        {
            DataItemTableView = sorting(Number);
            PrintOnlyIfDetail = true;
            column(Number; Number)
            {
            }
            column(CompanyNameText; CompNameText)
            {
            }
            column(DateText; DateTxt)
            {
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
                RequestFilterFields = "No.";

                column(No_SalesHeader; "No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerNo_SalesHeader; "Sell-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerName_SalesHeader; "Sell-to Customer Name")
                {
                    IncludeCaption = true;
                }
                column(ShipToPostCode; "Ship-to Post Code")
                {
                }
                column(createdAt_SalesHeader; Format("PDC Created At", 0, '<Day,2>/<Month,2>/<Year,2> <Hours24>:<Minutes,2>'))
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const(Item));
                    column(LineNo_SalesLine; "Line No.")
                    {
                    }
                    column(ItemNo_SalesLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SalesLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(VariantCode_SalesLine; "Variant Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_SalesLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_SalesLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ShipmentDate_SalesLine; Format("Shipment Date"))
                    {
                    }
                    column(Quantity_SalesLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitOfMeasure_SalesLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityToShip_SalesLine; "Qty. to Ship")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityShipped_SalesLine; "Quantity Shipped")
                    {
                        IncludeCaption = true;
                    }
                    column(QtyToAsm; QtyToAsm)
                    {
                    }
                    column(WearerID; "PDC Wearer ID")
                    {
                        IncludeCaption = true;
                    }
                    column(WearerName; "PDC Wearer Name")
                    {
                        IncludeCaption = true;
                    }
                    column(ProtexSKU; "PDC Product Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Colour; Item."PDC Colour")
                    {
                        IncludeCaption = true;
                    }
                    column(Size; Item."PDC Size")
                    {
                        IncludeCaption = true;
                    }
                    column(Fit; Item."PDC Fit")
                    {
                        IncludeCaption = true;
                    }
                    column(Style; Item."PDC Style")
                    {
                        IncludeCaption = true;
                    }
                    column(Inventory; Item.Inventory)
                    {
                    }
                    column(SLQty; SLQty)
                    {
                    }
                    column(BranchNo; "PDC Branch No.")
                    {
                    }
                    column(VendorNo; Item."Vendor No.")
                    {
                    }
                    column(VendorSKU; Item."Vendor Item No.")
                    {
                    }
                    dataitem("Warehouse Comment Line"; "Warehouse Comment Line")
                    {
                        DataItemLink = "No." = field("Document No."), "Line No." = field("Line No.");
                        column(Comment_WarehouseCommentLine; "Warehouse Comment Line".Comment)
                        {
                        }
                    }
                    dataitem("Assembly Line"; "Assembly Line")
                    {
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        column(No_AssemblyLine; "No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_AssemblyLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(VariantCode_AssemblyLine; "Variant Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Quantity_AssemblyLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityPer_AssemblyLine; "Quantity per")
                        {
                            IncludeCaption = true;
                        }
                        column(UnitOfMeasure_AssemblyLine; GetUOM("Unit of Measure Code"))
                        {
                        }
                        column(LocationCode_AssemblyLine; "Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(BinCode_AssemblyLine; "Bin Code")
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityToConsume_AssemblyLine; "Quantity to Consume")
                        {
                            IncludeCaption = true;
                        }

                        trigger OnPreDataItem()
                        begin
                            if not AsmExists then
                                CurrReport.Break();
                            SetRange("Document Type", AsmHeader."Document Type");
                            SetRange("Document No.", AsmHeader."No.");
                        end;
                    }
                    dataitem("Sales Comment Line"; "Sales Comment Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "No." = field("Document No."), "Document Line No." = field("Line No.");
                        DataItemTableView = where("PDC Comment Type" = const(Internal));

                        column(SalesCommentLine_Type; WhsTxt)
                        {
                        }
                        column(SalesCommentLine_Comment; "Sales Comment Line".Comment)
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    var
                        AssembleToOrderLink: Record "Assemble-to-Order Link";
                        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
                        g_Free: Decimal;
                    begin
                        AssembleToOrderLink.Reset();
                        AssembleToOrderLink.SetCurrentkey(Type, "Document Type", "Document No.", "Document Line No.");
                        AssembleToOrderLink.SetRange(Type, AssembleToOrderLink.Type::Sale);
                        AssembleToOrderLink.SetRange("Document Type", "Document Type");
                        AssembleToOrderLink.SetRange("Document No.", "Document No.");
                        AssembleToOrderLink.SetRange("Document Line No.", "Line No.");
                        AsmExists := AssembleToOrderLink.FindFirst();
                        QtyToAsm := 0;
                        if AsmExists then
                            if AsmHeader.Get(AssembleToOrderLink."Assembly Document Type", AssembleToOrderLink."Assembly Document No.") then
                                QtyToAsm := AsmHeader."Quantity to Assemble"
                            else
                                AsmExists := false;

                        Item.Get("No.");
                        Item.SetRange("Location Filter", "Location Code");
                        Item.CalcFields(Inventory);
                        if Item.Inventory = 0 then
                            CurrReport.Skip();
                        if "Sales Line"."Quantity Shipped" = Quantity then
                            CurrReport.Skip();

                        g_Free := SalesInfoPaneMgt.CalcAvailableInventory("Sales Line") - SalesInfoPaneMgt.CalcGrossRequirements("Sales Line");

                        CheckInvPick := false;
                        rWarehouseActivityLine.Reset();
                        rWarehouseActivityLine.SetRange("Source No.", "Sales Header"."No.");
                        rWarehouseActivityLine.SetRange("Source Line No.", "Sales Line"."Line No.");
                        if rWarehouseActivityLine.FindFirst() then begin
                            CheckInvPick := true;
                            SLQty := rWarehouseActivityLine.Quantity;
                        end
                        else
                            SLQty := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";

                        if (g_Free < 0) and not (CheckInvPick) then
                            CurrReport.Skip();

                        ItemVendor.SetRange("Vendor No.", Item."Vendor No.");
                        ItemVendor.SetRange("Item No.", Item."No.");
                        if ItemVendor.FindFirst() and (ItemVendor."Vendor Item No." <> '') then
                            Item."Vendor Item No." := ItemVendor."Vendor Item No.";
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    l_SalesHeader: Record "Sales Header";
                begin
                    if not CurrReport.Preview then begin
                        l_SalesHeader.Get("Document Type", "No.");
                        l_SalesHeader.LockTable();
                        l_SalesHeader."PDC Pick Instruction Print No." += 1;
                        l_SalesHeader.modify();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if SalesHeader.GetFilters <> '' then
                        "Sales Header".CopyFilters(SalesHeader);
                    if Customer.Get("Sales Header"."Sell-to Customer No.") then;
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, NoOfCopies + 1);
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
                    field("No of Copies"; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No of Copies';
                        ToolTip = 'No of Copies';
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
        OrderPickingListCaption = 'Pick Instruction';
        PageCaption = 'Page';
        ItemNoCaption = 'Item  No.';
        OrderNoCaption = 'Order No.';
        CustomerNoCaption = 'Customer No.';
        CustomerNameCaption = 'Customer Name';
        QtyToAssembleCaption = 'Quantity to Assemble';
        QtyAssembledCaption = 'Quantity Assembled';
        ShipmentDateCaption = 'Shipment Date';
        QtyPickedCaption = 'Qty. Picked';
        UOMCaption = 'Unit of Measure';
        QtyConsumedCaption = 'Quantity Consumed';
        CopyCaption = 'Copy';
    }

    trigger OnPreReport()
    begin
        DateTxt := Format(Today);
        CompNameText := COMPANYNAME;
        PrintPickNote := false;
        SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
        SalesLine.SetRange("Document No.", "Sales Header".GetFilter("No."));
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.Findset() then
            repeat
                Item.Get(SalesLine."No.");
                Item.SetRange("Location Filter", SalesLine."Location Code");
                if SalesLine.Quantity > SalesLine."Quantity Shipped" then begin
                    Item.CalcFields(Inventory);
                    if Item.Inventory > 0 then
                        PrintPickNote := true;
                end;
            until (SalesLine.next() = 0) or (PrintPickNote);

        if not PrintPickNote then
            if GuiAllowed then begin
                Message('There is no available line to pick.');
                Error('');
            end else
                CurrReport.Quit();
    end;

    var
        AsmHeader: Record "Assembly Header";
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        ItemVendor: Record "Item Vendor";
        rWarehouseActivityLine: Record "Warehouse Activity Line";
        NoOfCopies: Integer;
        DateTxt: Text;
        CompNameText: Text;
        QtyToAsm: Decimal;
        AsmExists: Boolean;
        PrintPickNote: Boolean;
        CheckInvPick: Boolean;
        SLQty: Decimal;
        WhsTxt: label 'WAREHOUSE';

    procedure GetUOM(UOMCode: Code[10]): Text
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.Get(UOMCode) then
            exit(UnitOfMeasure.Description);
        exit(UOMCode);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer)
    begin
        NoOfCopies := NewNoOfCopies;
    end;

    procedure SetSalesHeader(var p_SalesHeader: Record "Sales Header")
    begin
        SalesHeader.CopyFilters(p_SalesHeader);
    end;
}

