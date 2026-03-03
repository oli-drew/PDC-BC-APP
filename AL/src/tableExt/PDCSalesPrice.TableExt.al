/// <summary>
/// TableExtension PDCSalesPrice (ID 50045) extends Record Sales Price.
/// </summary>
tableextension 50045 PDCSalesPrice extends "Sales Price"
{
    fields
    {
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CalcDirectCostMargin();
            end;
        }
        modify("Starting Date")
        {
            trigger OnAfterValidate()
            begin
                CalcDirectCostMargin();
            end;
        }
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            Editable = false;
        }
        field(50001; "PDC Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "PDC Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Vendor No." where("No." = field("Item No.")));
            Editable = false;
        }
        field(50003; "PDC Vendor Item No."; text[50])
        {
            Caption = 'Vendor Item No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Vendor Item No." where("No." = field("Item No.")));
            Editable = false;
        }
        field(50004; "PDC Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost (LCY)';
            FieldClass = Normal;
            Editable = false;
        }
        field(50005; "PDC Gross"; Decimal)
        {
            Caption = 'Gross (LCY)';
            Editable = false;
        }
        field(50006; PDCMargin; Decimal)
        {
            Caption = 'Margin (%)';
            Editable = false;
        }
        field(50007; "PDC Item Blocked"; Boolean)
        {
            Caption = 'Item Blocked';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
            Editable = false;
        }
        field(50008; "PDC Direct Unit CostStart.Date"; date)
        {
            Caption = 'Direct Unit Cost Starting Date';
            FieldClass = Normal;
            Editable = false;
        }
    }

    trigger OnAfterInsert()
    begin
        Item.GET("Item No.");
        "PDC Product Code" := Item."PDC Product Code";
    end;

    var
        Item: Record Item;

    /// <summary>
    /// procedure CalcDirectCostMargin find purchase price and calculate margin.
    /// </summary>
    procedure CalcDirectCostMargin()
    var
        PurchPrice: Record "Purchase Price";
        TempItem: Record Item temporary;
        ProdBom: Record "Production BOM Header";
        WorksheetName: Record "Standard Cost Worksheet Name";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CalcStdCost: Codeunit "Calculate Standard Cost";
        UnitPriceLCY: Decimal;
    begin
        Item.GET("Item No.");
        if Item."Replenishment System" = Item."Replenishment System"::Purchase then begin
            CalcFields("PDC Vendor No.");
            PurchPrice.setrange("Item No.", "Item No.");
            PurchPrice.setrange("Vendor No.", "PDC Vendor No.");
            if PurchPrice.findlast() then begin
                "PDC Direct Unit Cost" := PurchPrice."Direct Unit Cost";
                if PurchPrice."Currency Code" <> '' then
                    "PDC Direct Unit Cost" := CurrencyExchangeRate.ExchangeAmount("PDC Direct Unit Cost", PurchPrice."Currency Code", '', "Starting Date");
                "PDC Direct Unit CostStart.Date" := PurchPrice."Starting Date";
            end;
        end
        else
            if Item."Replenishment System" = Item."Replenishment System"::"Prod. Order" then
                if ProdBom.get(Item."Production BOM No.") and (ProdBom.Status = ProdBom.Status::Certified) then begin

                    if not WorksheetName.get('SALESPRICE') then begin
                        WorksheetName.init();
                        WorksheetName.Name := 'SALESPRICE';
                        WorksheetName.Description := 'Created by Sales Price calc. Direct Cost';
                        WorksheetName.insert();
                    end;

                    item.SetRecFilter();
                    CLEAR(CalcStdCost);
                    CalcStdCost.SetProperties(WorkDate(), TRUE, FALSE, true, WorksheetName.Name, false);
                    clear(TempItem);
                    CalcStdCost.CalcItems(Item, TempItem);
                    tempItem.setrange("No.", Item."No.");
                    if TempItem.findfirst() then
                        "PDC Direct Unit Cost" := TempItem."Standard Cost";
                end;
        if "Unit Price" <> 0 then begin
            if "Currency Code" <> '' then
                UnitPriceLCY := CurrencyExchangeRate.ExchangeAmount("Unit Price", "Currency Code", '', "Starting Date")
            else
                UnitPriceLCY := "Unit Price";

            if "PDC Direct Unit Cost" <> 0 then
                "PDC Gross" := UnitPriceLCY - "PDC Direct Unit Cost"
            else
                "PDC Gross" := 0;
            if UnitPriceLCY <> 0 then
                PDCMargin := round("PDC Gross" / UnitPriceLCY * 100, 0.0001)
            else
                PDCMargin := 0;
        end
        else begin
            "PDC Gross" := 0;
            PDCMargin := 0;
        end;
        if Modify() then;
    end;
}

