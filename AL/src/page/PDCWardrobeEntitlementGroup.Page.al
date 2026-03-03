/// <summary>
/// Page PDC Wardrobe Entitlement Group (ID 50001).
/// </summary>
page 50001 "PDC Wardrobe Entitlement Group"
{
    Caption = 'Wardrobe Groups Sub';
    PageType = ListPart;
    SourceTable = "PDC Wardrobe Entitlement Group";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Wardrobe ID"; Rec."Wardrobe ID")
                {
                    ToolTip = 'Wardrobe ID';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                }
                field(Code; Rec."Group Code")
                {
                    ToolTip = 'Group Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field("Entitlement Period"; Rec."Entitlement Period")
                {
                    ToolTip = 'Entitlement Period';
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ToolTip = 'Value';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
            }
        }
    }

}
