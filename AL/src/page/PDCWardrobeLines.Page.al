/// <summary>
/// Page PDC Wardrobe Lines (ID 50027).
/// </summary>
page 50027 "PDC Wardrobe Lines"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "PDC Wardrobe Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProductCode; Rec."Product Code")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                    ToolTip = 'Product Code';
                    trigger OnValidate()
                    begin
                        SetItemDescription();
                        SetStyle();
                    end;
                }
                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Description';
                    Editable = false;
                    StyleExpr = LineStyle;
                }
                field(ItemType; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item Type';
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer Name';
                }
                field(SortOrder; Rec."Sort Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sort Order';
                }
                field(ItemGender; Rec."Item Gender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item Gender';
                }
                field(QuantityEntitledinPeriod; Rec."Quantity Entitled in Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Quantity Entitled in Period';
                }
                field(Discontinued; Rec.Discontinued)
                {
                    ApplicationArea = All;
                    ToolTip = 'Discontinued';
                }
                field(EntitlementPeriod; Rec."Entitlement Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Period';
                }
                field("Entitlement Qty. Group"; Rec."Entitlement Qty. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Qty. Group';
                }
                field("Entitlement Value Group"; Rec."Entitlement Value Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Value Group';
                }
                field("Entitlement Points Group"; Rec."Entitlement Points Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Points Group';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ItemOption)
            {
                ApplicationArea = All;
                Caption = 'Item Option';
                ToolTip = 'Item Option';
                Image = CreateLinesFromJob;
                RunObject = Page "PDC Wardrobe Item Option List";
                RunPageLink = "Wardrobe ID" = field("Wardrobe ID"),
                              "Product Code" = field("Product Code");
            }
            action(StaffEntitlement)
            {
                ApplicationArea = All;
                Caption = 'Staff Entitlement';
                ToolTip = 'Staff Entitlement';
                Image = LedgerEntries;
                RunObject = Page "PDC Staff Entitlement List";
                RunPageLink = "Wardrobe ID" = field("Wardrobe ID"),
                              "Customer No." = field("Customer No."),
                              "Product Code" = field("Product Code");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetItemDescription();
        SetStyle();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ItemDescription);
    end;

    var
        ItemDescription: Text[100];
        LineStyle: Text;

    local procedure SetItemDescription()
    var
        Item: Record Item;
    begin
        Clear(ItemDescription);
        if Rec."Product Code" <> '' then begin
            Item.SetRange("PDC Product Code", Rec."Product Code");
            if Item.FindFirst() then
                ItemDescription := Item.Description;
        end;
    end;

    local procedure SetStyle()
    var
        PDCWardrobeItemOption: Record "PDC Wardrobe Item Option";
    begin
        //04.11.2020 JEMEL J.Jemeljanovs #3490
        PDCWardrobeItemOption.SetRange("Wardrobe ID", Rec."Wardrobe ID");
        PDCWardrobeItemOption.SetRange("Product Code", Rec."Product Code");
        PDCWardrobeItemOption.SetFilter("Colour Code", '<>%1', '');
        if PDCWardrobeItemOption.IsEmpty() then
            LineStyle := 'Unfavorable'
        else
            LineStyle := 'Standard';
    end;
}

