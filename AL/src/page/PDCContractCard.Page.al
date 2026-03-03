/// <summary>
/// Page PDC Contract Card (ID 50038).
/// </summary>
page 50038 "PDC Contract Card"
{
    caption = 'Contract Card';
    PageType = Card;
    SourceTable = "PDC Contract";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = false;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                    ShowMandatory = true;
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
                    ShowMandatory = true;
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

