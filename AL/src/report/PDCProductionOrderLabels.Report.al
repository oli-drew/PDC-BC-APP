/// <summary>
/// Report PDC Production Order Labels (ID 50011).
/// </summary>
report 50011 "PDC Production Order Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/ProductionOrderLabels.rdlc';
    Caption = 'Production Order Labels';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Header; "Production Order")
        {
            RequestFilterFields = "No.";
            dataitem(Line; "Prod. Order Line")
            {
                DataItemLink = Status = field(Status), "Prod. Order No." = field("No.");
                DataItemTableView = sorting(Status, "Prod. Order No.", "Line No.") order(ascending);
                RequestFilterFields = "Item No.";
                column(OrderNo; Line."Prod. Order No.")
                {
                }
                column(ItemNo; Line."Item No.")
                {
                }
                column(Description; Line.Description)
                {
                }
                column(Quantity; Format(ROUND(Line.Quantity, 1)))
                {
                }
                column(DayPrinted; Format(Today, 0))
                {
                }
                column(CustomerNo; this.Item."PDC Customer No.")
                {
                }
                column(VendorItemNo; this.Item."Vendor Item No.")
                {
                }
                column(FirmPlannedOrderNo; Header."Firm Planned Order No.")
                {
                }
                column(ProductCode; this.Item."PDC Product Code")
                {
                }
                column(Colour; this.Item."PDC Colour")
                {
                }
                column(Size; this.Item."PDC Size")
                {
                }
                column(Fit; this.Item."PDC Fit")
                {
                }
                column(ReorderingPolicy; this.Item."Reordering Policy")
                {
                }
                column(QRCode; this.QRCode)
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

                    trigger OnPostDataItem()
                    var
                        Order2: Record "Production Order";
                        LabelCountPrinted: Report "PDC Prod.Order Labels -Printed";
                    begin
                        if not CurrReport.Preview() then begin
                            Order2.Get(Header.Status, Header."No.");
                            Order2.SetRecfilter();
                            LabelCountPrinted.SetTableview(Order2);
                            LabelCountPrinted.Run();
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
                    BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                begin
                    this.TempReservEntry.reset();
                    this.TempReservEntry.DeleteAll();
                    ReservEntry.setrange("Source Type", DATABASE::"Prod. Order Line");
                    ReservEntry.setrange("Source Subtype", Status);
                    ReservEntry.setrange("Source ID", "Prod. Order No.");
                    ReservEntry.setrange("Source Ref. No.", 0);
                    ReservEntry.setrange("Source Batch Name", '');
                    ReservEntry.setrange("Source Prod. Order Line", "Line No.");
                    ReservEntry.setrange("Item No.", "Item No.");
                    ReservEntry.setrange("Variant Code", "Variant Code");
                    ReservEntry.setrange("Location Code", "Location Code");
                    if ReservEntry.findset() then
                        repeat
                            this.TempReservEntry.Init();
                            this.TempReservEntry := ReservEntry;
                            this.TempReservEntry.insert();
                        until ReservEntry.Next() = 0;
                    if not this.Item.get(Line."Item No.") then begin
                        clear(this.Item);
                        this.QRCode := '';
                    end else begin
                        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                        this.QRCode := BarcodeFontProvider2D.EncodeFont(this.Item."No.", BarcodeSymbology2D);
                    end;
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
        Item: Record Item;
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        CurrTracking: Text;
        Cntr: Integer;
        QRCode: Text;
}

