/// <summary>
/// Report PDC Prod. Order PickNote (ID 50048).
/// </summary>
Report 50048 "PDC Prod. Order PickNote"
{
    Caption = 'Prod. Order Pick Note';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/ProdOrderPickNote.rdlc';


    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.") where(Status = CONST(Released));
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(ProdOrderTableCaptionFilter; TableCaption + ':' + ProdOrderFilter)
            {
            }
            column(No_ProdOrder; "No.")
            {
            }
            column(Desc_ProdOrder; Description)
            {
            }
            column(SourceNo_ProdOrder; "Source No.")
            {
                IncludeCaption = true;
            }
            column(Status_ProdOrder; Status)
            {
            }
            column(Qty_ProdOrder; Quantity)
            {
                IncludeCaption = true;
            }
            column(Filter_ProdOrder; ProdOrderFilter)
            {
            }
            column(ReportCapt; ReportLbl)
            {
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            column(VendorNoCapt; VendorNoCaptLbl)
            {
            }
            column(VendorItemNoCapt; VendorItemNoCaptLbl)
            {
            }
            column(LastPurchDateCaptB; LastPurchDateCaptLbl)
            {
            }
            column(CurrTracking; CurrTracking)
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                column(ItemNo_ProdOrderComp; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_ProdOrderComp; Description)
                {
                    IncludeCaption = true;
                }
                column(Qtyper_ProdOrderComp; "Quantity per")
                {
                    IncludeCaption = true;
                }
                column(UOMCode_ProdOrderComp; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(RemainingQty_ProdOrderComp; "Remaining Quantity")
                {
                    IncludeCaption = true;
                }
                column(LocationCode_ProdOrderComp; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(BinCode_ProdOrderComp; "Bin Code")
                {
                    IncludeCaption = true;
                }
                column(VendorNo; CompItem."Vendor No.")
                {
                }
                column(VendorItemNo; CompItem."Vendor Item No.")
                {
                }
                column(LastPurchDate; format(LastPurchDate, 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(FreeStock; FreeStock)
                {
                    DecimalPlaces = 0 : 5;
                }

                trigger OnAfterGetRecord()
                var
                    ItemLE: Record "Item Ledger Entry";
                    TempSalesLine: Record "Sales Line" temporary;
                    SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
                begin
                    ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");

                    ReservationEntry.SetRange("Source Type", Database::"Prod. Order Component");
                    ReservationEntry.SetRange("Source ID", "Production Order"."No.");
                    ReservationEntry.SetRange("Source Ref. No.", "Line No.");
                    ReservationEntry.SetRange("Source Subtype", Status);
                    ReservationEntry.SetRange("Source Batch Name", '');
                    ReservationEntry.SetRange("Source Prod. Order Line", "Prod. Order Line No.");

                    if ReservationEntry.Findset() then begin
                        RemainingQtyReserved := 0;
                        repeat
                            if ReservationEntry2.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then
                                if (ReservationEntry2."Source Type" = Database::"Prod. Order Line") and
                                   (ReservationEntry2."Source ID" = "Prod. Order Component"."Prod. Order No.")
                                then
                                    RemainingQtyReserved += ReservationEntry2."Quantity (Base)";
                        until ReservationEntry.Next() = 0;
                        if "Prod. Order Component"."Remaining Qty. (Base)" = RemainingQtyReserved then
                            CurrReport.Skip();
                    end;
                    clear(CompItem);
                    clear(LastPurchDate);
                    if CompItem.get("Item No.") then begin
                        ItemLE.SetCurrentKey("Item No.", "Posting Date");
                        ItemLE.setrange("Item No.", CompItem."No.");
                        ItemLE.setrange("Entry Type", ItemLE."Entry Type"::Purchase);
                        if ItemLE.findlast() then
                            LastPurchDate := ItemLE."Posting Date";
                    end;

                    clear(FreeStock);
                    if CompItem.get("Item No.") then begin
                        clear(TempSalesLine);
                        TempSalesLine.Init();
                        TempSalesLine.Type := TempSalesLine.Type::Item;
                        TempSalesLine."No." := "Item No.";
                        TempSalesLine."Location Code" := "Location Code";
                        TempSalesLine."Bin Code" := "Bin Code";
                        FreeStock := SalesInfoPaneMgt.CalcAvailableInventory(TempSalesLine) - SalesInfoPaneMgt.CalcGrossRequirements(TempSalesLine);
                        CompItem.CalcFields("PDC Qty. on Rel. Prod. Order");
                        FreeStock -= CompItem."PDC Qty. on Rel. Prod. Order";
                    end;

                    Printed := true;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Remaining Quantity", '<>0');
                end;

                trigger OnPostDataItem()
                begin
                    if Printed then
                        if not CurrReport.Preview then begin
                            "Production Order"."PDC Printed D/T" := CurrentDateTime;
                            "Production Order".modify();
                        end;
                end;
            }

            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");

                column(Operation_No_; "Operation No.")
                {
                    IncludeCaption = true;
                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Type; Type)
                {
                    IncludeCaption = true;
                }
                column(No_; "No.")
                {
                    IncludeCaption = true;
                }
                column(Run_Time; "Run Time")
                {
                    IncludeCaption = true;
                }
                column(Unit_Cost_per; "Unit Cost per")
                {
                    IncludeCaption = true;
                }
                column(RoutingLineBrandingNo; RoutingLine."PDC Branding No.")
                {
                }
                column(RoutingLineBrandingNoCpt; RoutingLine.fieldcaption("PDC Branding No."))
                {
                }
                column(RoutingLineBrandingTypeCode; RoutingLine."PDC Branding Type Code")
                {
                }
                column(RoutingLineBrandingTypeCodeCpt; RoutingLine.fieldcaption("PDC Branding Type Code"))
                {
                }
                column(RoutingLineBrandingPositionCode; RoutingLine."PDC Branding Position Code")
                {
                }
                column(RoutingLineBrandingPositionCodeCpt; RoutingLine.fieldcaption("PDC Branding Position Code"))
                {
                }
                column(CustomerNo; Customer."No.")
                {
                }
                column(CustomerName; Customer.Name)
                {
                }
                column(BrandingFile; Branding."Branding File")
                {
                }
                column(BrandingFileCpt; Branding.fieldcaption("Branding File"))
                {
                }
                column(BrandingFilePic; BarcodeText)
                {
                }

                trigger OnAfterGetRecord()
                var
                // Barcode: Codeunit "Temp Blob";
                // Base64Convert: Codeunit "Base64 Convert";
                // TempText: Text;
                // InStr: InStream;
                begin
                    clear(RoutingLine);
                    ProdOrderLine.Reset();
                    ProdOrderLine.SETRANGE(Status, Status);
                    ProdOrderLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SETRANGE("Routing No.", "Routing No.");
                    ProdOrderLine.SETRANGE("Routing Reference No.", "Routing Reference No.");
                    if ProdOrderLine.FindFirst() then begin
                        clear(Customer);
                        if ProdItem.get(ProdOrderLine."Item No.") then
                            if Customer.get(ProdItem."PDC Customer No.") then;
                        if RoutingLine.get(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code", "Operation No.") then begin
                            RoutingLine.CalcFields("PDC Branding Type Code", "PDC Branding Position Code");
                            if not Branding.get(RoutingLine."PDC Branding No.") then
                                clear(Branding);


                            // clear(BarcodeText);
                            // if Branding."Branding File" <> '' then begin
                            //     Clear(Barcode);
                            //     Barcode128B.CreateBarcode(Barcode, Branding."Branding File");
                            //     Barcode.CreateInStream(InStr);
                            //     InStr.Read(TempText);
                            //     BarcodeText := Base64Convert.ToBase64(TempText);
                            // end;
                        end;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters;
            end;

            trigger OnAfterGetRecord()
            var
                TempOrderTrackingEntry2: Record "Order Tracking Entry" temporary;
                TrackingMgt: Codeunit "OrderTrackingManagement";
            begin
                clear(Printed);

                TempOrderTrackingEntry.Reset();
                TempOrderTrackingEntry.DeleteAll();
                clear(TrackingMgt);
                ProdOrderLine.Reset();
                ProdOrderLine.SETRANGE(Status, Status);
                ProdOrderLine.SETRANGE("Prod. Order No.", "No.");
                if ProdOrderLine.Findset() then
                    repeat
                        TrackingMgt.SetProdOrderLine(ProdOrderLine);
                        TrackingMgt.FindRecordsWithoutMessage();
                        clear(TempOrderTrackingEntry2);
                        if TrackingMgt.FindRecord('-', TempOrderTrackingEntry2) then begin
                            TempOrderTrackingEntry.Init();
                            TempOrderTrackingEntry := TempOrderTrackingEntry2;
                            TempOrderTrackingEntry.Insert();
                            while TrackingMgt.GetNextRecord(1, TempOrderTrackingEntry2) > 0 do begin
                                TempOrderTrackingEntry.Init();
                                TempOrderTrackingEntry := TempOrderTrackingEntry2;
                                TempOrderTrackingEntry.Insert();
                            end;
                        end;
                    until ProdOrderLine.next() = 0;
                if TempOrderTrackingEntry.FindSet() then
                    repeat
                        if TempOrderTrackingEntry."Demanded by" <> '' then
                            if strpos(CurrTracking, TempOrderTrackingEntry."Demanded by") = 0 then begin
                                if CurrTracking <> '' then CurrTracking += ',';
                                CurrTracking += TempOrderTrackingEntry."Demanded by";
                            end;
                    until TempOrderTrackingEntry.next() = 0;

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
        ProdOrderCompDueDateCapt = 'Due Date';
    }

    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ProdOrderLine: Record "Prod. Order Line";
        RoutingLine: Record "Routing Line";
        ProdItem: Record Item;
        Customer: Record Customer;
        CompItem: Record Item;
        Branding: Record "PDC Branding";
        TempOrderTrackingEntry: Record "Order Tracking Entry" temporary;

        // Barcode128B: Codeunit "PDC Barcode 128B";
        ProdOrderFilter: Text;
        RemainingQtyReserved: Decimal;
        LastPurchDate: Date;
        ReportLbl: label 'Prod. Order - Pick Note';
        CurrReportPageNoCaptLbl: label 'Page';
        VendorNoCaptLbl: Label 'Vendor No.';
        VendorItemNoCaptLbl: Label 'Vendor Item No.';
        LastPurchDateCaptLbl: Label 'Last Purchase Date';
        FreeStock: Decimal;
        Printed: Boolean;
        CurrTracking: Text;
        BarcodeText: Text;

}

