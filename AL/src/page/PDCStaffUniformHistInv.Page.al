/// <summary>
/// Page PDC Staff Uniform Hist. Inv. (ID 50062).
/// </summary>
page 50062 "PDC Staff Uniform Hist. Inv."
{
    Caption = 'Invoices';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";
    SourceTableView = where(Type = const(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    ToolTip = 'Customer No.';
                }
                field("Branch No."; Rec."PDC Branch No.")
                {
                    ApplicationArea = All;
                    Caption = 'Branch No.';
                    ToolTip = 'Branch No.';
                }
                field("Customer Reference"; Rec."PDC Customer Reference")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Reference';
                    ToolTip = 'Customer Reference';
                }
                field(DocTypeCpt; DocTypeCptLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Type';
                }
                field("Invoice No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                    ToolTip = 'Invoice No.';
                }
                field("Shipment No."; SalesShipNo)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment No.';
                    ToolTip = 'Shipment No.';
                }
                field(Date; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    ToolTip = 'Date';
                }
                field("Item No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Description';
                }
                field(Colour; Item."PDC Colour")
                {
                    ApplicationArea = All;
                    Caption = 'Colour';
                    ToolTip = 'Colour';
                }
                field(Fit; Item."PDC Fit")
                {
                    ApplicationArea = All;
                    Caption = 'Fit';
                    ToolTip = 'Fit';
                }
                field(Size; Item."PDC Size")
                {
                    ApplicationArea = All;
                    Caption = 'Size';
                    ToolTip = 'Size';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Quantity';
                    ToolTip = 'Quantity';
                }
                field("Web Order No."; Rec."PDC Draft Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Web Order No.';
                    ToolTip = 'Web Order No.';
                }
                field("Wearer ID"; Rec."PDC Wearer ID")
                {
                    ApplicationArea = All;
                    Caption = 'Wearer ID';
                    ToolTip = 'Wearer ID';
                }
                field("Wearer Name"; Rec."PDC Wearer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Wearer Name';
                    ToolTip = 'Wearer Name';
                }
                field("Ordered By ID"; Rec."PDC Ordered By ID")
                {
                    ApplicationArea = All;
                    Caption = 'Ordered By ID';
                    ToolTip = 'Ordered By ID';
                }
                field("Ordered By Name"; Rec."PDC Ordered By Name")
                {
                    ApplicationArea = All;
                    Caption = 'Ordered By Name';
                    ToolTip = 'Ordered By Name';
                }
                field(Total; Rec.Amount)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Total';
                    ToolTip = 'Total';
                }
                field(VAT; Rec."Amount Including VAT" - Rec.Amount)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'VAT';
                    ToolTip = 'VAT';
                }
                field("Order Date"; SalesInvoiceHeader."Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'Order Date';
                    ToolTip = 'Order Date';
                }
                field("Delivery Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Delivery Date';
                    ToolTip = 'Delivery Date';
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
        if not SalesInvoiceHeader.Get(Rec."Document No.") then Clear(SalesInvoiceHeader);

        Clear(SalesShipNo);
        ValueEntry.Reset();
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", Rec."Document No.");
        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.", Rec."Line No.");
        if ValueEntry.FindSet() then
            repeat
                ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."document type"::"Sales Shipment" then
                    SalesShipNo := ItemLedgerEntry."Document No.";
            until (ValueEntry.Next() = 0) or (SalesShipNo <> '');
    end;

    var
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        SalesShipNo: Code[20];
        DocTypeCptLbl: label 'Invoice', Comment = 'Invoice';

}

