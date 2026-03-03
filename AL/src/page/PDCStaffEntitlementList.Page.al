/// <summary>
/// Page PDC Staff Entitlement List (ID 50030).
/// </summary>
page 50030 "PDC Staff Entitlement List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "PDC Staff Entitlement";
    Caption = 'Staff Entitlement';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(BranchNo; Rec."Branch No.")
                {
                    ToolTip = 'Branch No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(StaffID; Rec."Staff ID")
                {
                    ToolTip = 'Staff ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(StaffName; Rec."Staff Name")
                {
                    ToolTip = 'Staff Name';
                    ApplicationArea = All;
                }
                field(StaffBodyTypeGender; Rec."Staff Body Type/Gender")
                {
                    ToolTip = 'Staff Body Type/Gender';
                    ApplicationArea = All;
                }
                field(ProductCode; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Group Type"; Rec."Group Type")
                {
                    ToolTip = 'Group Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Group Code"; Rec."Group Code")
                {
                    ToolTip = 'Group Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(EntitlementPeriodDays; Rec."Entitlement Period (Days)")
                {
                    ToolTip = 'Entitlement Period (Days)';
                    ApplicationArea = All;
                }
                field("Group Entitlement Period"; Rec."Group Entitlement Period")
                {
                    ToolTip = 'Group Entitlement Period';
                    ApplicationArea = All;
                }
                field(QuantityEntitledinPeriod; Rec."Quantity Entitled in Period")
                {
                    ToolTip = 'Quantity Entitled in Period';
                    ApplicationArea = All;
                }
                field("Group Value Entitled"; Rec."Group Value Entitled")
                {
                    ToolTip = 'Group Value Entitled';
                    ApplicationArea = All;
                }
                field(StartDate; Rec."Start Date")
                {
                    ToolTip = 'Start Date';
                    ApplicationArea = All;
                }
                field(EndDate; Rec."End Date")
                {
                    ToolTip = 'End Date';
                    ApplicationArea = All;
                }
                field(QuantityPosted; Rec."Quantity Posted")
                {
                    ToolTip = 'Quantity Posted';
                    ApplicationArea = All;
                }
                field(QuantityonReturn; Rec."Quantity on Return")
                {
                    ToolTip = 'Quantityon Return';
                    ApplicationArea = All;
                }
                field(QuantityonOrder; Rec."Quantity on Order")
                {
                    ToolTip = 'Quantityon Order';
                    ApplicationArea = All;
                }
                field(QuantityonDraftOrder; Rec."Quantity on Draft Order")
                {
                    ToolTip = 'Quantity on Draft Order';
                    ApplicationArea = All;
                }
                field(CalculatedQuantityIssued; Rec."Calculated Quantity Issued")
                {
                    ToolTip = 'Calculated Quantity Issued';
                    ApplicationArea = All;
                }
                field(CalcQtyRemaininginPeriod; Rec."Calc. Qty. Remaining in Period")
                {
                    ToolTip = 'Calc. Qty. Remaining in Period';
                    ApplicationArea = All;
                }
                field("Calculated Amount Issued"; Rec."Calculated Amount Issued")
                {
                    ToolTip = 'Calculated Amount Issued';
                    ApplicationArea = All;
                }
                field("Calc. Amt. Remaining in Period"; Rec."Calc. Amt. Remaining in Period")
                {
                    ToolTip = 'Calc. Amt. Remaining in Period';
                    ApplicationArea = All;
                }
                field(LastDateTimeCalculated; Rec."Last DateTime Calculated")
                {
                    ToolTip = 'Last DateTime Calculated';
                    ApplicationArea = All;
                }
                field(WardrobeID; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Inactive; Rec.Inactive)
                {
                    ToolTip = 'Inactive';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InactivatedDatetime; Rec."Inactivated Datetime")
                {
                    ToolTip = 'Inactivated Datetime';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PosponedPeriodDays; Rec."Posponed Period (Days)")
                {
                    ToolTip = 'Posponed Period Days';
                    ApplicationArea = All;
                }
                field(PosponedByUser; Rec."Posponed By User")
                {
                    ToolTip = 'Posponed By User';
                    ApplicationArea = All;
                }
                field(PosponedAt; Rec."Posponed At")
                {
                    ToolTip = 'Posponed At';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calc. Qty for Work Date")
            {
                ApplicationArea = All;
                Caption = 'Calc. Qty for Work Date';
                ToolTip = 'Calc. Qty for Work Date';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    StaffEntitlement: Record "PDC Staff Entitlement";
                begin
                    if (not Confirm(Text001Lbl, false, WorkDate())) then
                        exit;

                    StaffEntitlement.CopyFilters(Rec);
                    StaffEntitlement.SetRange(Inactive, false); //04.09.2019 JEMEL J.Jemeljanovs #3069
                    StaffEntitlement.FindSet();
                    repeat
                        StaffEntitlement.Validate("End Date", WorkDate());
                        StaffEntitlement.Modify(true);
                        Rec.CalculateQuantities(StaffEntitlement, true);
                    until StaffEntitlement.Next() = 0;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalculateQuantities(Rec, false);
    end;

    var
        Text001Lbl: label 'This activity will set the End Date on all records in the list to the Work Date %1, and re-calculate quantities.\\Do you wish to continue?', Comment = 'This activity will set the End Date on all records in the list to the Work Date %1, and re-calculate quantities.\\Do you wish to continue?';
}

