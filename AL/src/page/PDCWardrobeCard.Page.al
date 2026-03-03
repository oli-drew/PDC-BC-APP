/// <summary>
/// Page PDC Wardrobe Card (ID 50025).
/// </summary>
page 50025 "PDC Wardrobe Card"
{
    Caption = 'Wardrobe Card';
    PageType = Card;
    SourceTable = "PDC Wardrobe Header";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit(); //DOC PDCP9 JF 11/07/2017 -+
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description';
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
                field(Disable; Rec.Disable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Disable';
                }
                field("Entitlement By Qty. Group"; Rec."Entitlement By Qty. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement By Qty. Group';
                }
                field("Entitlement By Value Group"; Rec."Entitlement By Value Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement By Value Group';
                }
                field("Entitlement By Points Group"; Rec."Entitlement By Points Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Entitlement By Points Group';
                }
                field("Default Wardrobe"; Rec."Default Wardrobe")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default Wardrobe';
                }
            }
            part(WardrobeLines; "PDC Wardrobe Lines")
            {
                SubPageLink = "Wardrobe ID" = field("Wardrobe ID");
            }
            part(WardrobeGroups; "PDC Wardrobe Entitlement Group")
            {
                SubPageLink = "Wardrobe ID" = field("Wardrobe ID");
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
        area(processing)
        {
            action(CopyWardrobe)
            {
                ApplicationArea = All;
                Caption = '&Copy Wardrobe';
                ToolTip = 'Copy Wardrobe';
                Image = CopyBOMHeader;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
                begin
                    StaffEntitlementFunctions.CopyWardrobe(Rec);
                end;
            }
            action(RefreshEntitlement)
            {
                ApplicationArea = All;
                Caption = 'Update Entitlement';
                ToolTip = 'Update Entitlement';
                Image = ReferenceData;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
                begin
                    StaffEntitlementFunctions.UpdateStaffEntitlementFromWardrobe(Rec);
                end;
            }
        }
        area(navigation)
        {
            action(StaffEntitlement)
            {
                ApplicationArea = All;
                Caption = '&Staff Entitlement';
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
}

