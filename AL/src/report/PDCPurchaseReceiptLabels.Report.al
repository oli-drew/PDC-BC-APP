/// <summary>
/// Report PDC Purchase Order Labels (ID 50041).
/// </summary>
report 50041 "PDC Purchase Receipt Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PurchaseReceiptLabels.rdlc';
    Caption = 'Purchase Receipt Labels';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Order"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            dataitem(Line; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending) where(Type = const(Item), Quantity = filter(<> 0));
                RequestFilterFields = "No.";
                column(OrderNo; "Order"."Order No.")
                {
                }
                column(ItemNo; Line."No.")
                {
                }
                column(ProductCode; this.ProductCode)
                {
                }
                column(Colour; this.Colour)
                {
                }
                column(Size; this.Size)
                {
                }
                column(Fit; this.Fit)
                {
                }
                column(ReorderingPolicy; this.ReorderingPolicy)
                {
                }
                column(QRCode; this.QRCode)
                {
                }

                column(Description; Line.Description)
                {
                }
                column(Quantity; Format(ROUND(Line.Quantity, 1)))
                {
                }
                column(DayPrinted; Format(Order."Order Date", 0))
                {
                }
                column(Vendor_Item_No_; "Vendor Item No.")
                {
                }
                dataitem(LabelLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) order(ascending);
                    column(CurrNumber; Format(Number))
                    {
                    }
                    column(Cntr; Cntr)
                    {
                    }
                    column(CurrTracking; CurrTracking)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        this.Cntr += 1;

                        clear(this.CurrTracking);
                        if this.TempReservEntry.FindFirst() then begin
                            this.CurrTracking := this.ReservEngineMgt.CreateForText(this.TempReservEntry);
                            this.TempReservEntry.Quantity -= 1;
                            if this.TempReservEntry.Quantity <= 0 then
                                this.TempReservEntry.Delete()
                            else
                                this.TempReservEntry.Modify();
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, ROUND(Line.Quantity, 1, '>'));
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    ReservEntry: Record "Reservation Entry";
                    ItemLedgEntry: Record "Item Ledger Entry";
                    Item: Record Item;
                    BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                begin
                    this.TempReservEntry.reset();
                    this.TempReservEntry.DeleteAll();

                    ItemLedgEntry.Reset();
                    ItemLedgEntry.SetCurrentKey("Document No.");
                    ItemLedgEntry.SetRange("Document No.", "Document No.");
                    ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Purchase Receipt");
                    ItemLedgEntry.SetRange("Document Line No.", "Line No.");
                    if ItemLedgEntry.FindSet() then
                        repeat
                            ReservEntry.SetSourceFilter(DATABASE::"Item Ledger Entry", 0, '', ItemLedgEntry."Entry No.", false);
                            ReservEntry.SetSourceFilter('', 0);
                            if ReservEntry.findset() then
                                repeat
                                    this.TempReservEntry.Init();
                                    this.TempReservEntry := ReservEntry;
                                    this.TempReservEntry.insert();
                                until ReservEntry.Next() = 0;
                        until ItemLedgEntry.Next() = 0;

                    Item.Get("No.");
                    this.ProductCode := Item."PDC Product Code";
                    this.Colour := Item."PDC Colour";
                    this.Size := Item."PDC Size";
                    this.Fit := Item."PDC Fit";
                    this.ReorderingPolicy := Format(Item."Reordering Policy");

                    BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                    BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                    this.QRCode := BarcodeFontProvider2D.EncodeFont("No.", BarcodeSymbology2D);
                end;
            }
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
    }

    var
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        CurrTracking: Text;
        Cntr: Integer;
        ProductCode: Text;
        Colour: Text;
        Size: Text;
        Fit: Text;
        ReorderingPolicy: Text;
        QRCode: Text;

}

