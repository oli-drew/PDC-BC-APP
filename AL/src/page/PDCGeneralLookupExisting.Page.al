/// <summary>
/// Page PDC General Lookup_Existing (ID 50019).
/// </summary>
page 50019 "PDC General Lookup_Existing"
{
    Caption = 'General Lookup';
    PageType = List;
    SourceTable = "PDC General Lookup_existing";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

