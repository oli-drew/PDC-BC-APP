table 50005 "PDC Item Creation Attribute"
{
    Caption = 'Item Creation Attribute';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "PDC Item Creation Batch".Name;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Item Attribute ID"; Integer)
        {
            Caption = 'Item Attribute ID';
            TableRelation = "Item Attribute".ID;
        }
        field(4; "Item Attribute Value ID"; Integer)
        {
            Caption = 'Item Attribute Value ID';
            TableRelation = "Item Attribute Value".ID where("Attribute ID" = field("Item Attribute ID"));
        }
    }

    keys
    {
        key(PK; "Journal Batch Name", "Item No.", "Item Attribute ID")
        {
            Clustered = true;
        }
    }
}
