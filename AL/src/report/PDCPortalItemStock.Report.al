/// <summary>
/// Report PDC Portal - Item Stock (ID 50022).
/// </summary>
Report 50022 "PDC Portal - Item Stock"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PortalItemStock.rdlc';
    Caption = 'Portal - Item Stock';

    dataset
    {
        dataitem(Customer; Customer)
        {
            dataitem(ItemTmp; Item)
            {
                CalcFields = Inventory;
                DataItemTableView = sorting("PDC Product Code", "PDC Colour Sequence", "PDC Fit Sequence", "PDC Size Sequence") order(ascending);
                UseTemporary = true;

                column(No_ItemTmp; ItemTmp."No.")
                {
                    IncludeCaption = true;
                }
                column(ProductCode_ItemTmp; ItemTmp."PDC Product Code")
                {
                    IncludeCaption = true;
                }
                column(Colour_ItemTmp; ItemTmp."PDC Colour")
                {
                    IncludeCaption = true;
                }
                column(Size_ItemTmp; ItemTmp."PDC Size")
                {
                    IncludeCaption = true;
                }
                column(Fit_ItemTmp; ItemTmp."PDC Fit")
                {
                    IncludeCaption = true;
                }
                column(Description_ItemTmp; ItemTmp.Description)
                {
                    IncludeCaption = true;
                }
                column(Inventory_ItemTmp; ItemTmp.Inventory)
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    LinesInDataset += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ItemTmp.DeleteAll();

                Wardrobe.SetRange("Customer No.", "No.");
                if Wardrobe.Findset() then
                    repeat
                        WardrobeLine.SetRange("Wardrobe ID", Wardrobe."Wardrobe ID");
                        WardrobeLine.SetRange(Discontinued, false);
                        if WardrobeLine.Findset() then
                            repeat
                                WardrobeItemOption.SetRange("Wardrobe ID", WardrobeLine."Wardrobe ID");
                                WardrobeItemOption.SetRange("Product Code", WardrobeLine."Product Code");
                                if WardrobeItemOption.Findset() then
                                    repeat
                                        ItemDB.Reset();
                                        ItemDB.SetCurrentkey("PDC Product Code", "PDC Colour", "PDC Fit", "PDC Size");
                                        ItemDB.SetRange("PDC Product Code", WardrobeItemOption."Product Code");
                                        ItemDB.SetRange("PDC Colour", WardrobeItemOption."Colour Code");
                                        ItemDB.SetRange(Blocked, false);
                                        if ItemDB.Findset() then
                                            repeat
                                                if not ItemTmp.Get(ItemDB."No.") then begin
                                                    ItemTmp.Init();
                                                    ItemTmp := ItemDB;
                                                    ItemTmp.Insert();
                                                end;
                                            until ItemDB.next() = 0;
                                    until WardrobeItemOption.next() = 0;
                            until WardrobeLine.next() = 0;
                    until Wardrobe.next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                if CustNoFilter <> '' then
                    SetFilter("No.", CustNoFilter);
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
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        WardrobeItemOption: Record "PDC Wardrobe Item Option";
        ItemDB: Record Item;
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

