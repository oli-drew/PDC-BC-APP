/// <summary>
/// Report PDC Purchase Order Labels (ID 50014).
/// </summary>
report 50014 "PDC Purchase Order Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PurchaseOrderLabels.rdlc';
    Caption = 'Purchase Order Labels';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Order"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            dataitem(Line; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending) where(Type = const(Item), "Qty. to Receive" = filter(<> 0));
                RequestFilterFields = "No.";
                column(OrderNo; Line."Document No.")
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
                column(Quantity; Format(ROUND(Line."Qty. to Receive", 1)))
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
                    column(Cntr; this.Cntr)
                    {
                    }
                    column(CurrTracking; this.CurrTracking)
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
                        SetRange(Number, 1, ROUND(Line."Qty. to Receive", 1, '>'));
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    ReservEntry: Record "Reservation Entry";
                    Item: Record Item;
                    BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                begin
                    this.TempReservEntry.Reset();
                    this.TempReservEntry.DeleteAll();
                    ReservEntry.setrange("Source Type", DATABASE::"Purchase Line");
                    ReservEntry.setrange("Source Subtype", "Document Type");
                    ReservEntry.setrange("Source ID", "Document No.");
                    ReservEntry.setrange("Source Ref. No.", "Line No.");
                    ReservEntry.setrange("Source Batch Name", '');
                    ReservEntry.setrange("Source Prod. Order Line", 0);
                    ReservEntry.setrange("Item No.", "No.");
                    ReservEntry.setrange("Variant Code", "Variant Code");
                    ReservEntry.setrange("Location Code", "Location Code");
                    if ReservEntry.FindSet() then
                        repeat
                            this.TempReservEntry.Init();
                            this.TempReservEntry := ReservEntry;
                            this.TempReservEntry.Insert();
                        until ReservEntry.Next() = 0;

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

