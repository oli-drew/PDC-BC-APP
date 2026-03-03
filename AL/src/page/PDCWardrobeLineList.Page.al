/// <summary>
/// Page PDC Wardrobe Line List (ID 50034).
/// </summary>
page 50034 "PDC Wardrobe Line List"
{
    Caption = 'Wardrobe Line List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "PDC Wardrobe Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Wardrobe ID';
                }
                field(ProductCode; Rec."Product Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Product Code';
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
        area(navigation)
        {
            group(Company)
            {
                Caption = '&Company';
                Image = Company;
                action(Wardrobe)
                {
                    ApplicationArea = All;
                    Caption = 'Wardrobe';
                    ToolTip = 'Wardrobe';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "PDC Wardrobe Card";
                    RunPageLink = "Wardrobe ID" = field("Wardrobe ID");
                }
            }
        }
        area(processing)
        {
            action(StaffEntitlement)
            {
                ApplicationArea = All;
                Caption = 'Staff Entitlement';
                ToolTip = 'Staff Entitlement';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "PDC Staff Entitlement List";
                RunPageLink = "Wardrobe ID" = field("Wardrobe ID"),
                              "Customer No." = field("Customer No."),
                              "Product Code" = field("Product Code");
                RunPageMode = View;
            }
        }
    }
}

