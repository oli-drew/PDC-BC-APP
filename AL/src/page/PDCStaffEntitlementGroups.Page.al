/// <summary>
/// Page PDC Staff Entitlement Groups (ID 50000).
/// </summary>
page 50000 "PDC Staff Entitlement Groups"
{
    ApplicationArea = All;
    Caption = 'Staff Entitlement Groups';
    PageType = List;
    SourceTable = "PDC Staff Entitlement Group";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field("Default Value"; Rec."Default Value")
                {
                    ToolTip = 'Default Value';
                    ApplicationArea = All;
                }
            }
        }
    }

}
