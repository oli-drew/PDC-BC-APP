/// <summary>
/// Codeunit PDC Portal Sales Price (ID 50019).
/// </summary>
codeunit 50019 "PDC Portal Sales Price"
{
    var
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        Currency: Record Currency;
        PricesInclVAT: Boolean;
        Qty: Decimal;
        VATPerCent: Decimal;
        VATCalcType: Enum "Tax Calculation Type";
        VATBusPostingGr: Code[20];
        QtyPerUOM: Decimal;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        FoundSalesPrice: Boolean;
        LineDiscPerCent: Decimal;

    procedure calcUnitPrice(p_codeCustomerNo: Code[20]; p_codeItemNo: Code[20]; p_codeVariant: Code[10]; p_decQuantity: Decimal; p_codeUnitOfMeasure: Code[20]; p_codeCurrency: Code[10]): Decimal
    var
        Customer: Record Customer;
        ItemUoM: Record "Item Unit of Measure";
        VATSetup: Record "VAT Posting Setup";
        SalesPrice: Codeunit "Sales Price Calc. Mgt.";
        TempSalesPrice: Record "Sales Price" temporary;
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        LineDiscountAmount: Decimal;
        LineAmount: Decimal;
    begin
        if p_decQuantity = 0 then
            p_decQuantity := 1;

        if not Customer.get(p_codeCustomerNo) then
            exit;
        if not Item.get(p_codeItemNo) then
            exit;
        if p_codeUnitOfMeasure = '' then
            if Item."Sales Unit of Measure" <> '' then
                p_codeUnitOfMeasure := item."Sales Unit of Measure"
            else
                p_codeUnitOfMeasure := Item."Base Unit of Measure";
        ItemUoM.get(Item."No.", p_codeUnitOfMeasure);
        if VATSetup.get(Customer."VAT Bus. Posting Group", Item."VAT Prod. Posting Group") then;

        SetCurrency(p_codeCurrency, WorkDate());
        SetVAT(Customer."Prices Including VAT", VATSetup."VAT %", VATSetup."VAT Calculation Type", VATSetup."VAT Bus. Posting Group");
        SetUoM(ABS(p_decQuantity), ItemUoM."Qty. per Unit of Measure");

        clear(LineDiscPerCent);
        if Customer."Allow Line Disc." then begin
            SalesPrice.FindSalesLineDisc(
                TempSalesLineDisc, Customer."No.", '', Customer."Customer Disc. Group", '', p_codeItemNo, Item."Item Disc. Group", p_codeVariant, p_codeUnitOfMeasure,
                p_codeCurrency, WorkDate(), false);
            CalcBestLineDisc(TempSalesLineDisc);
            LineDiscPerCent := TempSalesLineDisc."Line Discount %";
        end;
        SalesPrice.FindSalesPrice(
            TempSalesPrice, Customer."No.", '', Customer."Customer Price Group", '', p_codeItemNo, p_codeVariant, p_codeUnitOfMeasure,
            p_codeCurrency, WorkDate(), false);
        CalcBestUnitPrice(TempSalesPrice);

        if TempSalesPrice."Allow Line Disc." then
            LineDiscountAmount := ROUND(
                    ROUND(p_decQuantity * TempSalesPrice."Unit Price", Currency."Amount Rounding Precision") *
                    TempSalesLineDisc."Line Discount %" / 100, Currency."Amount Rounding Precision");
        LineAmount := ROUND(p_decQuantity * TempSalesPrice."Unit Price", Currency."Amount Rounding Precision") - LineDiscountAmount;
        exit(Round(LineAmount / p_decQuantity, 0.01, '='));
    end;

    local procedure SetCurrency(CurrencyCode2: Code[10]; ExchRateDate2: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        if PricesInCurrency then begin
            Currency.GET(CurrencyCode2);
            Currency.TESTFIELD("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrExchRate.ExchangeRate(ExchRateDate2, Currency.Code);
            ExchRateDate := ExchRateDate2;
        END else
            GLSetup.GET();
    end;

    procedure CalcBestUnitPrice(VAR SalesPrice: Record "Sales Price")
    var
        BestSalesPrice: Record "Sales Price";
        BestSalesPriceFound: Boolean;
    begin
        FoundSalesPrice := SalesPrice.FINDSET();
        if FoundSalesPrice then
            repeat
                if IsInMinQty(SalesPrice."Unit of Measure Code", SalesPrice."Minimum Quantity") then begin
                    ConvertPriceToVAT(
                      SalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                      SalesPrice."VAT Bus. Posting Gr. (Price)", SalesPrice."Unit Price");
                    ConvertPriceToUoM(SalesPrice."Unit of Measure Code", SalesPrice."Unit Price");
                    ConvertPriceLCYToFCY(SalesPrice."Currency Code", SalesPrice."Unit Price");

                    case true of
                        ((BestSalesPrice."Currency Code" = '') AND (SalesPrice."Currency Code" <> '')) OR
                        ((BestSalesPrice."Variant Code" = '') AND (SalesPrice."Variant Code" <> '')):
                            begin
                                BestSalesPrice := SalesPrice;
                                BestSalesPriceFound := TRUE;
                            end;
                        ((BestSalesPrice."Currency Code" = '') OR (SalesPrice."Currency Code" <> '')) AND
                      ((BestSalesPrice."Variant Code" = '') OR (SalesPrice."Variant Code" <> '')):
                            if (BestSalesPrice."Unit Price" = 0) OR
                               (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                            then begin
                                BestSalesPrice := SalesPrice;
                                BestSalesPriceFound := TRUE;
                            end;
                    end;
                end;
            until SalesPrice.next() = 0;

        // No price found in agreement
        if NOT BestSalesPriceFound then begin
            ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            ConvertPriceToUoM('', Item."Unit Price");
            ConvertPriceLCYToFCY('', Item."Unit Price");

            CLEAR(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
        end;

        SalesPrice := BestSalesPrice;
    end;

    local procedure CalcBestLineDisc(var SalesLineDisc: Record "Sales Line Discount")
    var
        BestSalesLineDisc: Record "Sales Line Discount";
    begin
        if SalesLineDisc.Findset() then
            repeat
                if IsInMinQty(SalesLineDisc."Unit of Measure Code", SalesLineDisc."Minimum Quantity") then
                    case true of
                        ((BestSalesLineDisc."Currency Code" = '') and (SalesLineDisc."Currency Code" <> '')) or
                      ((BestSalesLineDisc."Variant Code" = '') and (SalesLineDisc."Variant Code" <> '')):
                            BestSalesLineDisc := SalesLineDisc;
                        ((BestSalesLineDisc."Currency Code" = '') or (SalesLineDisc."Currency Code" <> '')) and
                      ((BestSalesLineDisc."Variant Code" = '') or (SalesLineDisc."Variant Code" <> '')):
                            if BestSalesLineDisc."Line Discount %" < SalesLineDisc."Line Discount %" then
                                BestSalesLineDisc := SalesLineDisc;
                    end;
            until SalesLineDisc.Next() = 0;

        SalesLineDisc := BestSalesLineDisc;
    end;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            EXIT(MinQty <= QtyPerUOM * Qty);
        EXIT(MinQty <= Qty);
    end;

    local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Enum "Tax Calculation Type"; VATBusPostingGr2: Code[20])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;

    end;

    local procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[20]; FromVATBusPostingGr: Code[20]; VAR UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.GET(FromVATBusPostingGr, FromVATProdPostingGr);

            case VATPostingSetup."VAT Calculation Type" OF
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
            end;

            case VATCalcType OF
                VATCalcType::"Normal VAT",
                VATCalcType::"Full VAT",
                VATCalcType::"Sales Tax":
                    if PricesInclVAT then begin
                        if VATBusPostingGr <> FromVATBusPostingGr then
                            UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                    END else
                        UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                VATCalcType::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        END else
            if PricesInclVAT then
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; VAR UnitPrice: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * QtyPerUOM;
    end;

    local procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; VAR UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := ROUND(UnitPrice, Currency."Unit-Amount Rounding Precision");
        END else
            UnitPrice := ROUND(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure CalcLineAmount(SalesPrice: Record "Sales Price"): Decimal
    begin
        if SalesPrice."Allow Line Disc." then
            EXIT(SalesPrice."Unit Price" * (1 - LineDiscPerCent / 100));
        EXIT(SalesPrice."Unit Price");
    end;

}
