/// <summary>
/// Report PDC Portal - Item Returns (ID 50029).
/// </summary>
Report 50029 "PDC Portal - Item Returns"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalItemReturns.rdlc';
    Caption = 'Portal - Item Returns';

    dataset
    {
        dataitem(ItemTmp; Item)
        {
            DataItemTableView = where(Blocked = const(false));
            UseTemporary = true;

            column(No_Item; "No.")
            {
            }
            column(ProductCode_Item; "PDC Product Code")
            {
                IncludeCaption = true;
            }
            column(Description_Item; Description)
            {
                IncludeCaption = true;
            }
            column(Colour_Item; "PDC Colour")
            {
                IncludeCaption = true;
            }
            column(Fit_Item; "PDC Fit")
            {
                IncludeCaption = true;
            }
            column(Size_Item; "PDC Size")
            {
                IncludeCaption = true;
            }
            column(SalesCode_SalesPrice; TempBestSalesPrice."Sales Code")
            {
                IncludeCaption = true;
            }
            column(UnitPrice_SalesPrice; TempBestSalesPrice."Unit Price")
            {
                IncludeCaption = true;
            }
            column(SLA_Item; "PDC SLA")
            {
            }
            column(ReturnPeriod_Item; "PDC Return Period")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(TempSalesPrice);
                Clear(SalesPriceCalcMgt);
                SalesPriceCalcMgt.FindSalesPrice(
                      TempSalesPrice, Customer."No.", '',
                      Customer."Customer Price Group", '', ItemTmp."No.", '', ItemTmp."Sales Unit of Measure",
                      '', WorkDate(), false);
                Clear(TempBestSalesPrice);
                if TempSalesPrice.Findset() then
                    repeat
                        case true of
                            ((TempBestSalesPrice."Currency Code" = '') and (TempSalesPrice."Currency Code" <> '')) or
                          ((TempBestSalesPrice."Variant Code" = '') and (TempSalesPrice."Variant Code" <> '')):
                                TempBestSalesPrice := TempSalesPrice;
                            ((TempBestSalesPrice."Currency Code" = '') or (TempSalesPrice."Currency Code" <> '')) and
                          ((TempBestSalesPrice."Variant Code" = '') or (TempSalesPrice."Variant Code" <> '')):
                                if (TempBestSalesPrice."Unit Price" = 0) or
                                   (TempBestSalesPrice."Unit Price" > TempSalesPrice."Unit Price")
                                then
                                    TempBestSalesPrice := TempSalesPrice;
                        end;//case
                    until TempSalesPrice.next() = 0;

                LinesInDataset += 1;
            end;

            trigger OnPreDataItem()
            begin
                Customer.Reset();
                if CustNoFilter <> '' then begin
                    Customer.SetFilter("No.", CustNoFilter);
                    Customer.FindFirst();
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Customer Filter"; CustNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Filter';
                        ToolTip = 'Customer Filter';
                        TableRelation = Customer;
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
        SalesCodeLbl = 'Sales Code';
        UnitPricelbl = 'Unit Price';
        MinimumQuantityLbl = 'Minimum Quantity';
        UoMLbl = 'Unit Of Measure';
        SLALbl = 'SLA (working days)';
        ReturnPeriodLbl = 'Return Period (days)';
    }

    trigger OnPreReport()
    begin
        if CustNoFilter <> '' then
            WardrobeHeader.SetFilter("Customer No.", CustNoFilter);
        if WardrobeHeader.Findset() then
            repeat
                WardrobeLine.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
                WardrobeLine.SetRange(Discontinued, false);
                if WardrobeLine.Findset() then
                    repeat
                        WardrobeItemOption.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
                        WardrobeItemOption.SetRange("Product Code", WardrobeLine."Product Code");
                        if WardrobeItemOption.Findset() then
                            repeat
                                Item.Reset();
                                Item.SetRange("PDC Product Code", WardrobeItemOption."Product Code");
                                Item.SetRange("PDC Colour", WardrobeItemOption."Colour Code");
                                if Item.Findset() then
                                    repeat
                                        if not ItemTmp.Get(Item."No.") then begin
                                            ItemTmp.Init();
                                            ItemTmp := Item;
                                            ItemTmp.Insert();
                                        end;
                                    until Item.next() = 0;
                            until WardrobeItemOption.next() = 0;
                    until WardrobeLine.next() = 0;
            until WardrobeHeader.next() = 0;
    end;

    var
        Customer: Record Customer;
        Item: Record Item;
        WardrobeHeader: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
        TempSalesPrice: Record "Sales Price" temporary;
        TempBestSalesPrice: Record "Sales Price" temporary;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        CustNoFilter: Text;
        LinesInDataset: Integer;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewCustNoFilter">Text.</param>
    procedure InitializeRequest(NewCustNoFilter: Text)
    begin
        CustNoFilter := NewCustNoFilter;
    end;
}

