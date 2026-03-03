/// <summary>
/// Report PDC CF Purchase Export (ID 50065).
/// Exports Carbonfact purchase order data as an Excel workbook.
/// </summary>
Report 50065 "PDC CF Purchase Export"
{
    Caption = 'Carbonfact Purchase Order Export';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = where("Entry Type" = const(Purchase));
            RequestFilterFields = "Posting Date", "Item No.";

            trigger OnPreDataItem()
            begin
                if ItemLedgerEntry.GetFilter("Posting Date") = '' then
                    Error(PostingDateRequiredErr);

                TempExcelBuffer.NewRow();
                AddTextColumn(TempExcelBuffer, 'product_id', true);
                AddTextColumn(TempExcelBuffer, 'quantity', true);
                AddTextColumn(TempExcelBuffer, 'order_date', true);
                AddTextColumn(TempExcelBuffer, 'receipt_date', true);
                AddTextColumn(TempExcelBuffer, 'factory_id', true);
                AddTextColumn(TempExcelBuffer, 'truck_km', true);
                AddTextColumn(TempExcelBuffer, 'ship_km', true);
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                CountryRegion: Record "Country/Region";
                COO: Code[10];
                OrderDate: Date;
                TruckKm: Integer;
                ShipKm: Integer;
            begin
                if not Item.Get(ItemLedgerEntry."Item No.") then
                    CurrReport.Skip();
                if not Item."PDC Carbonfact Enabled" then
                    CurrReport.Skip();

                COO := Item."Country/Region of Origin Code";
                TruckKm := 0;
                ShipKm := 0;
                if (COO <> '') and CountryRegion.Get(COO) then begin
                    TruckKm := CountryRegion."PDC CF Truck Km";
                    ShipKm := CountryRegion."PDC CF Ship Km";
                end;

                OrderDate := GetOrderDate(ItemLedgerEntry);

                TempExcelBuffer.NewRow();
                AddTextColumn(TempExcelBuffer, ItemLedgerEntry."Item No.", false);
                AddDecimalColumn(TempExcelBuffer, ItemLedgerEntry.Quantity);
                AddDateColumn(TempExcelBuffer, OrderDate);
                AddDateColumn(TempExcelBuffer, ItemLedgerEntry."Posting Date");
                AddTextColumn(TempExcelBuffer, ItemLedgerEntry."Source No.", false);
                AddIntegerColumn(TempExcelBuffer, TruckKm);
                AddIntegerColumn(TempExcelBuffer, ShipKm);

                RowCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                if RowCount = 0 then
                    Error(NoPurchaseEntriesErr);

                TempExcelBuffer.CreateNewBook('PurchaseOrders');
                TempExcelBuffer.WriteSheet('', CompanyName(), UserId());
                TempExcelBuffer.CloseBook();
                TempExcelBuffer.SetFriendlyFilename('CarbonfactPurchaseOrders');
                TempExcelBuffer.OpenExcel();
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
                    label(InfoLabel)
                    {
                        ApplicationArea = All;
                        Caption = 'Set a Posting Date filter to limit which purchase entries are exported.';
                    }
                }
            }
        }
    }

    internal procedure GetOrderDate(CurrItemLedgerEntry: Record "Item Ledger Entry"): Date
    var
        ValueEntry: Record "Value Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Document Type");
        ValueEntry.SetRange("Item Ledger Entry No.", CurrItemLedgerEntry."Entry No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
        if ValueEntry.FindFirst() then
            if PurchInvHeader.Get(ValueEntry."Document No.") then
                if PurchInvHeader."Order Date" <> 0D then
                    exit(PurchInvHeader."Order Date");

        if PurchRcptHeader.Get(CurrItemLedgerEntry."Document No.") then
            if PurchRcptHeader."Order Date" <> 0D then
                exit(PurchRcptHeader."Order Date");

        exit(CurrItemLedgerEntry."Posting Date");
    end;

    local procedure AddTextColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Text; IsBold: Boolean)
    begin
        ExcelBuffer.AddColumn(Value, false, '', IsBold, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddDecimalColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Decimal)
    begin
        ExcelBuffer.AddColumn(Value, false, '', false, false, false, '0.00###', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure AddIntegerColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Integer)
    begin
        ExcelBuffer.AddColumn(Value, false, '', false, false, false, '0', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure AddDateColumn(var ExcelBuffer: Record "Excel Buffer" temporary; Value: Date)
    begin
        ExcelBuffer.AddColumn(Value, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        RowCount: Integer;
        PostingDateRequiredErr: Label 'You must set a Posting Date filter to avoid exporting the entire history.';
        NoPurchaseEntriesErr: Label 'No purchase entries found for Carbonfact-enabled items in the specified date range.';
}
