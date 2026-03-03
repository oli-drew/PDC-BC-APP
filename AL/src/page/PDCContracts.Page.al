/// <summary>
/// Page PDCContracts (ID 50037).
/// </summary>
page 50037 "PDC Contracts"
{
    Caption = 'Contracts';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "PDC Contract";
    UsageCategory = Administration;
    ApplicationArea = All;
    CardPageId = "PDC Contract Card";

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
                }
                field(No; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field(ContractCode; Rec."Contract Code")
                {
                    ToolTip = 'Contract Code';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Blocked';
                    ApplicationArea = All;
                }
                field("Default Contract"; Rec."Default Contract")
                {
                    ToolTip = 'Default Contract';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

