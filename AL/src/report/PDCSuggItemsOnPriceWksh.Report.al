/// <summary>
/// Report PDC Sugg. Items On Price Wksh. (ID 50017).
/// </summary>
Report 50017 "PDC Sugg. Items On Price Wksh."
{
    Caption = 'Suggest Items on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "PDC Product Code";


            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "No.");

                Worksheet.Init();
                Worksheet.Validate("Item No.", "No.");
                Worksheet.Validate("Sales Type", SalesTypeFilter);
                if SalesCode <> '' then
                    Worksheet.Validate("Sales Code", SalesCode);
                Worksheet.Validate("Unit of Measure Code", "Base Unit of Measure");
                Worksheet.Validate("Minimum Quantity", MinQty);
                Worksheet.Validate("Currency Code", CurrCode);
                Worksheet.Validate("Unit Price", UnitPrice);
                Worksheet.Insert(true);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(ProgressTxt);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SalesTypeFilterFld; SalesTypeFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Type Filter';
                        ToolTip = 'Sales Type Filter';
                        OptionCaption = 'Customer,,All Customers';

                        trigger OnValidate()
                        begin
                            SalesCode := '';
                        end;
                    }
                    field(SalesCodeFld; SalesCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Code';
                        ToolTip = 'Sales Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Customer: Record Customer;
                        begin
                            if SalesTypeFilter = Salestypefilter::Customer then begin
                                Customer.Reset();
                                if Page.RunModal(0, Customer) = Action::LookupOK then
                                    SalesCode := Customer."No.";
                            end;
                        end;
                    }
                    field(MinQtyFld; MinQty)
                    {
                        ApplicationArea = All;
                        Caption = 'Minimum Quantity';
                        ToolTip = 'Minimum Quantity';
                    }
                    field(CurrCodeFld; CurrCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Currency Code';
                        ToolTip = 'Currency Code';
                        TableRelation = Currency;
                    }
                    field(UnitPriceFld; UnitPrice)
                    {
                        ApplicationArea = All;
                        Caption = 'Initial Unit Price';
                        ToolTip = 'Initial Unit Price';
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
    }

    trigger OnPreReport()
    begin
        if SalesTypeFilter = Salestypefilter::Customer then
            if SalesCode = '' then
                Error(SpecifyTxt, 'Sales Code');
    end;

    var

        Worksheet: Record "PDC Sales Price Generator";
        Window: Dialog;
        SalesTypeFilter: Option Customer,,"All Customers";
        SalesCode: Code[20];
        MinQty: Decimal;
        CurrCode: Code[10];
        UnitPrice: Decimal;
        SpecifyTxt: label '%1 must be specified.', Comment = '%1=required value';
        ProgressTxt: label 'Processing items  #1##########', Comment = '%1=progress';
}

