/// <summary>
/// Page PDCTimegateEmpl.JoinersLeavers (ID 50002).
/// </summary>
page 50002 "PDCTimegateEmpl.JoinersLeavers"
{
    ApplicationArea = All;
    Caption = 'TimegateEmployeeJoinersLeavers';
    PageType = List;
    SourceTable = "PDC Timegate Joiners Leavers";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field("Tg Employee Id"; Rec."Tg Employee Id")
                {
                    ToolTip = 'Specifies the value of the Tg Employee Id field.';
                    ApplicationArea = All;
                }
                field("Tg PIN"; Rec."Tg PIN")
                {
                    ToolTip = 'Specifies the value of the Tg PIN field.';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.';
                    ApplicationArea = All;
                }
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the value of the Surname field.';
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Join Date"; Rec."Join Date")
                {
                    ToolTip = 'Specifies the value of the Join Date field.';
                    ApplicationArea = All;
                }
                field("Left Date"; Rec."Left Date")
                {
                    ToolTip = 'Specifies the value of the Left Date field.';
                    ApplicationArea = All;
                }
                field("Last Update"; Rec."Last Update")
                {
                    ToolTip = 'Specifies the value of the Last Update field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
