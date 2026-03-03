/// <summary>
/// Page PDC Wardrobe Worksheet (ID 50039).
/// </summary>
page 50039 "PDC Wardrobe Worksheet"
{
    AutoSplitKey = true;
    Caption = 'Wardrobe Worksheet';
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "PDC Wardrobe Worksheet";
    UsageCategory = Tasks;
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
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                }
                field(WardrobeDescription; Rec."Wardrobe Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Wardrobe Description';
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
                field(SortOrder; Rec."Sort Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sort Order';
                }
                field(BodyTypeGender; Rec."Body Type/Gender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Body Type/Gender';
                }
                field(QuantityEntitledinPeriod; Rec."Quantity Entitled in Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Quantity Entitled in Period';
                }
                field(EntitlementPeriod; Rec."Entitlement Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement Period';
                }
                field(ColourCode; Rec."Colour Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Colour Code';
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
            action(Post)
            {
                ApplicationArea = All;
                Caption = '&Post';
                ToolTip = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
                begin
                    StaffEntitlementFunctions.PostWardrobeWorksheetToWardrobe(Rec);
                end;
            }
        }
        area(navigation)
        {
            action(Wardrobe)
            {
                ApplicationArea = All;
                Caption = '&Wardrobe';
                ToolTip = 'Wardrobe';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    WardrobeHeader: Record "PDC Wardrobe Header";
                begin
                    WardrobeHeader.Reset();
                    WardrobeHeader.SetRange("Wardrobe ID", Rec."Wardrobe ID");
                    if not WardrobeHeader.IsEmpty then
                        Page.Run(Page::"PDC Wardrobe Card", WardrobeHeader);
                end;
            }
        }
    }
}

