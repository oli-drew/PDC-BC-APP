/// <summary>
/// Page PDC Staff Uniform Hist. Draft (ID 50065).
/// </summary>
page 50065 "PDC Staff Uniform Hist. Draft"
{
    Caption = 'Draft';
    Editable = false;
    PageType = ListPart;
    SourceTable = "PDC Draft Order Item Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CustomerNo; PDCDraftOrderHeader."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    ToolTip = 'Customer No.';
                }
                field("Branch No."; Rec."Branch ID")
                {
                    ApplicationArea = All;
                    Caption = 'Branch No.';
                    ToolTip = 'Branch No.';
                }
                field("Customer Reference"; PDCDraftOrderHeader."PO No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Reference';
                    ToolTip = 'Customer Reference';
                }
                field(Type; DocTypeCptLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Type';
                }
                field("Invoice No."; Rec."Sales Order No.")
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
                field(Date; PDCDraftOrderHeader."Requested Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    ToolTip = 'Date';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Item No.';
                }
                field(Description; Rec."Item Description")
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
                field("Web Order No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Web Order No.';
                    ToolTip = 'Web Order No.';
                }
                field("Wearer ID"; Rec."Staff ID")
                {
                    ApplicationArea = All;
                    Caption = 'Wearer ID';
                    ToolTip = 'Wearer ID';
                }
                field("Wearer Name"; PDCBranchStaff.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Wearer Name';
                    ToolTip = 'Wearer Name';
                }
                field("Ordered By ID"; '')
                {
                    ApplicationArea = All;
                    Caption = 'Ordered By ID';
                    ToolTip = 'Ordered By ID';
                }
                field("Ordered By Name"; '')
                {
                    ApplicationArea = All;
                    Caption = 'Ordered By Name';
                    ToolTip = 'Ordered By Name';
                }
                field(Total; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Total';
                    ToolTip = 'Total';
                }
                field(VAT; 0)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'VAT';
                    ToolTip = 'VAT';
                }
                field("Order Date"; PDCDraftOrderHeader."Created Date")
                {
                    ApplicationArea = All;
                    Caption = 'Order Date';
                    ToolTip = 'Order Date';
                }
                field("Delivery Date"; PDCDraftOrderHeader."Requested Shipment Date")
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
        if not Item.Get(Rec."Item No.") then Clear(Item);
        if not PDCDraftOrderHeader.Get(Rec."Document No.") then Clear(PDCDraftOrderHeader);
        if not PDCBranchStaff.Get(Rec."Staff ID") then Clear(PDCBranchStaff);

        Clear(SalesShipNo);
    end;

    var
        Item: Record Item;
        PDCDraftOrderHeader: Record "PDC Draft Order Header";
        PDCBranchStaff: Record "PDC Branch Staff";
        SalesShipNo: Code[20];
        DocTypeCptLbl: label 'Draft', Comment = 'Draft';
}

