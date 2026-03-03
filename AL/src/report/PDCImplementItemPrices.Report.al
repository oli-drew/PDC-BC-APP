/// <summary>
/// Report PDC Implement Item Prices (ID 50018).
/// </summary>
Report 50018 "PDC Implement Item Prices"
{
    Caption = 'Implement Item Prices';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Price Generator"; "PDC Sales Price Generator")
        {
            RequestFilterFields = "Item No.";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Item No.");

                TestField("Item No.");
                if "Sales Type" = "sales type"::Customer then
                    TestField("Sales Code");
                TestField("Unit Price");

                if SalesPrice.Get("Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity") then begin
                    SalesPrice.SetRecfilter();
                    Error(SalesPriceExistErr, SalesPrice.GetFilters);
                end;

                SalesPrice.Reset();
                SalesPrice.Init();
                SalesPrice."Item No." := "Item No.";
                SalesPrice."Sales Type" := "Sales Type";
                SalesPrice."Sales Code" := "Sales Code";
                SalesPrice."Starting Date" := "Starting Date";
                SalesPrice."Currency Code" := "Currency Code";
                SalesPrice."Variant Code" := "Variant Code";
                SalesPrice."Unit of Measure Code" := "Unit of Measure Code";
                SalesPrice."Minimum Quantity" := "Minimum Quantity";
                SalesPrice."Unit Price" := "Unit Price";
                SalesPrice."Price Includes VAT" := "Price Includes VAT";
                SalesPrice."Allow Invoice Disc." := "Allow Invoice Disc.";
                SalesPrice."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                SalesPrice."Ending Date" := "Ending Date";
                SalesPrice."Allow Line Disc." := "Allow Line Disc.";
                SalesPrice.Insert(true);
            end;

            trigger OnPostDataItem()
            begin
                Commit();
                DeleteAll();
                Commit();
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Progress1Lbl +
                  Progress2Lbl);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        SalesPrice: Record "Sales Price";
        Progress1Lbl: label 'Creating Items Prices...\\';
        Progress2Lbl: label 'Item No.               #1##########\', comment = '%1=item no.';
        Window: Dialog;
        SalesPriceExistErr: label 'Sales Prices already exists within filter: %1', comment = '%1=filters';
}

