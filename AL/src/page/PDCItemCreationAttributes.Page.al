page 50040 "PDC Item Creation Attributes"
{
    Caption = 'Item Creation Attributes';
    PageType = StandardDialog;
    SourceTable = "Item Attribute Value Selection";
    SourceTableTemporary = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item attribute name.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemAttribute: Record "Item Attribute";
                    begin
                        if Page.RunModal(0, ItemAttribute) = Action::LookupOK then begin
                            Rec."Attribute ID" := ItemAttribute.ID;
                            Rec."Attribute Name" := ItemAttribute.Name;
                            Rec."Attribute Type" := ItemAttribute.Type;
                        end;
                    end;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the attribute value.';
                }
            }
        }
    }
}
