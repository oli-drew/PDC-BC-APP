/// <summary>
/// Page PDC Staff Uniform Hist. Credit (ID 50063).
/// </summary>
page 50063 "PDC Staff Uniform Hist. Credit"
{
    Caption = 'Credit';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Cr.Memo Line";
    SourceTableView = where(Type = const(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CustomerNo; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Sell-to Customer No.';
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                }
                field("Branch No."; Rec."PDC Branch No.")
                {
                    ToolTip = 'Branch No.';
                    ApplicationArea = All;
                    Caption = 'Branch No.';
                }
                field("Customer Reference"; Rec."PDC Customer Reference")
                {
                    ToolTip = 'Customer Reference';
                    ApplicationArea = All;
                    Caption = 'Customer Reference';
                }
                field(Type; DocTypeCptLbl)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                    Caption = 'Type';
                }
                field("Invoice No."; Rec."Document No.")
                {
                    ToolTip = 'Invoice No.';
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                }
                field("Shipment No."; SalesShipNo)
                {
                    ToolTip = 'Shipment No.';
                    ApplicationArea = All;
                    Caption = 'Shipment No.';
                }
                field(Date; Rec."Posting Date")
                {
                    ToolTip = 'Posting Date';
                    ApplicationArea = All;
                    Caption = 'Date';
                }
                field("Item No."; Rec."No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field("<Description"; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Colour; Item."PDC Colour")
                {
                    ToolTip = 'Colour';
                    ApplicationArea = All;
                    Caption = 'Colour';
                }
                field(Fit; Item."PDC Fit")
                {
                    ToolTip = 'Fit';
                    ApplicationArea = All;
                    Caption = 'Fit';
                }
                field(Size; Item."PDC Size")
                {
                    ToolTip = 'Size';
                    ApplicationArea = All;
                    Caption = 'Size';
                }
                field(Quantity; -Rec.Quantity)
                {
                    ToolTip = 'Quantity';
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Quantity';
                }
                field("Web Order No."; Rec."PDC Draft Order No.")
                {
                    ToolTip = 'Web Order No.';
                    ApplicationArea = All;
                    Caption = 'Web Order No.';
                }
                field("Wearer ID"; Rec."PDC Wearer ID")
                {
                    ToolTip = 'Wearer ID';
                    ApplicationArea = All;
                    Caption = 'Wearer ID';
                }
                field("Wearer Name"; Rec."PDC Wearer Name")
                {
                    ToolTip = 'Wearer Name';
                    ApplicationArea = All;
                    Caption = 'Wearer Name';
                }
                field("Ordered By ID"; Rec."PDC Ordered By ID")
                {
                    ToolTip = 'Ordered By ID';
                    ApplicationArea = All;
                    Caption = 'Ordered By ID';
                }
                field("Ordered By Name"; Rec."PDC Ordered By Name")
                {
                    ToolTip = 'Ordered By Name';
                    ApplicationArea = All;
                    Caption = 'Ordered By Name';
                }
                field(Total; -Rec.Amount)
                {
                    ToolTip = 'Total';
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Total';
                }
                field(VAT; Rec.Amount - Rec."Amount Including VAT")
                {
                    ToolTip = 'VAT';
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'VAT';
                }
                field("Order Date"; SalesCrMemoHeader."Document Date")
                {
                    ToolTip = 'Order Date';
                    ApplicationArea = All;
                    Caption = 'Order Date';
                }
                field("Delivery Date"; Rec."Posting Date")
                {
                    ToolTip = 'Delivery Date';
                    ApplicationArea = All;
                    Caption = 'Delivery Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if not Item.Get(Rec."No.") then Clear(Item);
        if not SalesCrMemoHeader.Get(Rec."Document No.") then Clear(SalesCrMemoHeader);

        Clear(SalesShipNo);
    end;

    var
        Item: Record Item;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesShipNo: Code[20];
        DocTypeCptLbl: label 'Credit', Comment = 'Credit';
}

