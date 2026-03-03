/// <summary>
/// Page PDC Staff Uniform History (ID 50061).
/// </summary>
page 50061 "PDC Staff Uniform History"
{
    Caption = 'Staff Uniform History';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "PDC Branch Staff";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(BranchID; Rec."Branch ID")
                {
                    ToolTip = 'Branch ID';
                    ApplicationArea = All;
                }
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Name';
                    ApplicationArea = All;
                }
            }
            part(Invoices; "PDC Staff Uniform Hist. Inv.")
            {
                Editable = false;
                SubPageLink = "PDC Staff ID" = field("Staff ID");
            }
            part(Credit; "PDC Staff Uniform Hist. Credit")
            {
                SubPageLink = "PDC Staff ID" = field("Staff ID");
            }
            part(Orders; "PDC Staff Uniform Hist. Orders")
            {
                SubPageLink = "PDC Staff ID" = field("Staff ID");
            }
            part(Draft; "PDC Staff Uniform Hist. Draft")
            {
                SubPageLink = "Staff ID" = field("Staff ID");
            }
        }
    }

    actions
    {
    }
}

