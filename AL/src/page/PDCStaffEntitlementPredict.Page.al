/// <summary>
/// Page PDC Staff Entitlement Predicted (ID 50060).
/// </summary>
page 50060 "PDC Staff Entitlement Predict."
{
    Caption = 'Staff Entitlement Predicted';
    Editable = false;
    PageType = List;
    SourceTable = "PDC Staff Entitlement Predict.";
    UsageCategory = Administration;
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
                field(EntitlementPeriodDays; Rec."Entitlement Period (Days)")
                {
                    ToolTip = 'Entitlement Period (Day';
                    ApplicationArea = All;
                }
                field(QuantityEntitledinPeriod; Rec."Quantity Entitled in Period")
                {
                    ToolTip = 'Quantity Entitled in Period';
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
                    ToolTip = 'Quantity on Return';
                    ApplicationArea = All;
                }
                field(QuantityonOrder; Rec."Quantity on Order")
                {
                    ToolTip = 'Quantity on Order';
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Calculate)
            {
                ApplicationArea = All;
                Caption = 'Calculate';
                ToolTip = 'Calculate';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if (not Confirm(Text001Lbl)) then
                        exit;
                    if Rec.GetFilter("Staff ID") <> '' then
                        Rec.CreateRecords(Rec.GetFilter("Staff ID"))
                    else
                        Rec.CreateRecords('');

                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        Text001Lbl: label 'Do you want to calculate records?', Comment = 'Do you want to calculate records?';
}

