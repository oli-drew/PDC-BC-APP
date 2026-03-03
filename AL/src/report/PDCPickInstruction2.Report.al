/// 
/// <summary>
/// Report PDC Pick Instruction2 (ID 50005).
/// </summary>
Report 50038 "PDC Pick Instruction2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PickInstructionPDC.rdlc';
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
            dataitem(Header; "Warehouse Activity Header")
            {
                RequestFilterFields = "No.";
                column(No_Header; "No.")
                {
                    IncludeCaption = true;
                }
                column(SourceNo_Header; Header."Source No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerNo_Header; "Destination No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerName_Header; WMSMgt.GetDestinationEntityName("Destination Type", "Destination No."))
                {
                }
                column(ShipToPostCode; SalesHeader."Ship-to Post Code")
                {
                }
                column(createdAt_SalesHeader; Format(SalesHeader."PDC Created At", 0, '<Day,2>/<Month,2>/<Year,2> <Hours24>:<Minutes,2>'))
                {
                }
                column(BarcodeEncodedText; BarcodeEncodedText)
                {
                }
                column(Shipping_Agent_Code; "PDC Shipping Agent Code")
                {
                }
                dataitem(Line; "Warehouse Activity Line")
                {
                    DataItemLink = "No." = field("No.");
                    DataItemTableView = sorting("Activity Type", "No.", "Line No.") where("Activity Type" = const("Invt. Pick"));
                    column(LineNo_Line; "Line No.")
                    {
                    }
                    column(ItemNo_Line; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_Line; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(VariantCode_Line; "Variant Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_Line; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_Line; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ShipmentDate_SalesLine; Format(SalesLine."Shipment Date"))
                    {
                    }
                    column(Quantity_Line; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitOfMeasure_Line; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityToShip_Line; "Qty. Outstanding")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityShipped_Line; "Qty. Handled")
                    {
                        IncludeCaption = true;
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
                        DecimalPlaces = 0 : 5;
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
                    column(SizeSequence; Item."PDC Size Sequence")
                    {
                    }
                    dataitem("Sales Comment Line"; "Sales Comment Line")
                    {
                        DataItemLink = "Document Type" = field("Source Subtype"), "No." = field("Source No."), "Document Line No." = field("Source Line No.");
                        DataItemTableView = where("PDC Comment Type" = const(Internal));

                        column(SalesCommentLine_Type; WarehouseTxt)
                        {
                        }
                        column(SalesCommentLine_Comment; "Sales Comment Line".Comment)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Sales Comment Line".Comment = '' then
                                CurrReport.Skip();
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not SalesLine.Get(Line."Source Subtype", Line."Source No.", Line."Source Line No.") then Clear(SalesLine);

                        Item.Get("Item No.");
                        Item.SetRange("Location Filter", "Location Code");
                        Item.CalcFields(Inventory);
                        if Item.Inventory = 0 then
                            CurrReport.Skip();

                        ItemVendor.SetRange("Vendor No.", Item."Vendor No.");
                        ItemVendor.SetRange("Item No.", Item."No.");
                        if ItemVendor.FindFirst() and (ItemVendor."Vendor Item No." <> '') then
                            Item."Vendor Item No." := ItemVendor."Vendor Item No.";
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    BarcodeString: Text;
                    BarcodeSymbology: Enum "Barcode Symbology";
                    BarcodeFontProvider: Interface "Barcode Font Provider";
                begin
                    if SalesHeader.Get("Source Subtype", "Source No.") then;

                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbology := Enum::"Barcode Symbology"::"Code39";
                    BarcodeString := Header."No.";
                    BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                    BarcodeEncodedText := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

                    if not CurrReport.Preview then begin
                        if Header."PDC Date of First Printing" = 0D then
                            Header."PDC Date of First Printing" := Today;
                        if Header."PDC Time of First Printing" = 0T then
                            Header."PDC Time of First Printing" := time;

                        Header."Date of Last Printing" := Today;
                        Header."Time of Last Printing" := Time;
                        Header.modify();
                    end;
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
    end;

    var
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ItemVendor: Record "Item Vendor";
        DummyCompanyInfo: Record "Company Information";
        // Barcode128B: Codeunit "PDC Barcode 128B";
        WMSMgt: Codeunit "WMS Management";
        NoOfCopies: Integer;
        DateTxt: Text;
        CompNameText: Text;
        BarcodeEncodedText: Text;
        WarehouseTxt: label 'WAREHOUSE';
    // BarcodeText: Text;


    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewNoOfCopies">Integer.</param>
    procedure InitializeRequest(NewNoOfCopies: Integer)
    begin
        NoOfCopies := NewNoOfCopies;
    end;

    /// <summary>
    /// SetSalesHeader.
    /// </summary>
    /// <param name="p_SalesHeader">VAR Record "Sales Header".</param>
    procedure SetSalesHeader(var p_SalesHeader: Record "Sales Header")
    begin
        SalesHeader.CopyFilters(p_SalesHeader);
    end;
}

