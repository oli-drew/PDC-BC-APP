/// <summary>
/// Page PDC Draft Order Staff Lines (ID 50033).
/// </summary>
page 50033 "PDC Draft Order Staff Lines"
{
    Caption = 'Draft Order Staff Lines';
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "PDC Draft Order Staff Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ToolTip = 'Document No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ToolTip = 'Line No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;
                }
                field(StaffName; Rec."Staff Name")
                {
                    ToolTip = 'Staff Name';
                    ApplicationArea = All;
                }
                field(BodyTypeGender; Rec."Body Type/Gender")
                {
                    ToolTip = 'Body Type/Gender';
                    ApplicationArea = All;
                }
                field(WearerID; Rec."Wearer ID")
                {
                    ToolTip = 'Wearer ID';
                    ApplicationArea = All;
                }
                field(BranchID; Rec."Branch ID")
                {
                    ToolTip = 'Branch ID';
                    ApplicationArea = All;
                }
                field(BranchName; Rec."Branch Name")
                {
                    ToolTip = 'Branch Name';
                    ApplicationArea = All;
                }
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                }
                field(WardrobeName; Rec."Wardrobe Name")
                {
                    ToolTip = 'Wardrobe Name';
                    ApplicationArea = All;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ToolTip = 'Reason Code';
                    ApplicationArea = All;
                }
                field(PONo; Rec."PO No.")
                {
                    ToolTip = 'PO No.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Items)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    ToolTip = 'Items';
                    Image = List;
                    RunObject = Page "PDC Draft Order Item Line";
                    RunPageLink = "Document No." = field("Document No."),
                              "Staff Line No." = field("Line No.");
                }
            }
        }
    }
}

