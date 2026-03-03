/// <summary>
/// Page PDC Wardrobe List (ID 50024).
/// </summary>
page 50024 "PDC Wardrobe List"
{
    Caption = 'Wardrobe List';
    CardPageID = "PDC Wardrobe Card";
    PageType = List;
    SourceTable = "PDC Wardrobe Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ToolTip = 'Customer Name';
                    ApplicationArea = All;
                }
                field(Disable; Rec.Disable)
                {
                    ToolTip = 'Disable';
                    ApplicationArea = All;
                }
                field("Default Wardrobe"; Rec."Default Wardrobe")
                {
                    ToolTip = 'Default Wardrobe';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
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
                              "Customer No." = field("Customer No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Disable, false);
    end;
}

