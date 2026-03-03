/// <summary>
/// Report PDC Item Labels (ID 50055).
/// </summary>
report 50055 "PDC Item Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/ItemLabels.rdlc';
    Caption = 'Item Labels';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(DayPrinted; Format(WorkDate(), 0))
            {
            }
            column(Vendor_Item_No_; "Vendor Item No.")
            {
            }
            column(Vendor_Name; this.Vendor.Name)
            {
            }
            column(Vendor_No; this.Vendor."No.")
            {
            }
            column(ProductCode; "PDC Product Code")
            {
            }
            column(Colour; "PDC Colour")
            {
            }
            column(Size; "PDC Size")
            {
            }
            column(Fit; "PDC Fit")
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

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, this.CopyCnt);
                end;
            }

            trigger OnAfterGetRecord()
            var
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
            begin
                if not this.Vendor.get(Item."Vendor No.") then
                    clear(this.Vendor);

                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                this.QRCode := BarcodeFontProvider2D.EncodeFont("No.", BarcodeSymbology2D);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CopyCntFld; CopyCnt)
                {
                    ApplicationArea = All;
                    Caption = 'Copies';
                    ToolTip = 'Copies';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if this.CopyCnt = 0 then
            this.CopyCnt := 1;
    end;


    var

        Vendor: Record Vendor;
        CopyCnt: Integer;
        QRCode: Text;
}

