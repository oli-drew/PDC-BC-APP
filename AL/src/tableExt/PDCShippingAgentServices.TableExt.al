/// <summary>
/// TableExtension PDCShippingAgentServices (ID 50041) extends Record Shipping Agent Services.
/// </summary>
tableextension 50041 PDCShippingAgentServices extends "Shipping Agent Services"
{
    fields
    {
        field(50000; "PDC Carriage Charge"; Decimal)
        {
            Caption = 'Carriage Charge';
        }
        field(50100; "PDC Carriage Charge Limit"; Decimal)
        {
            Caption = 'Carriage Charge Limit';
        }
        field(50200; "PDC Carriage Charge Type"; Enum "Sales Line Type")
        {
            Caption = 'Carriage Charge Type';
        }
        field(50300; "PDC Carriage Charge No."; Code[20])
        {
            Caption = 'Carriage Charge No.';
            TableRelation = if ("PDC Carriage Charge Type" = const(Item)) Item
            else
            if ("PDC Carriage Charge Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true),
                                                                                                       "Account Type" = const(Posting),
                                                                                                       Blocked = const(false))
            else
            if ("PDC Carriage Charge Type" = const("Charge (Item)")) "Item Charge";
        }
        field(50400; "PDC Show On Portal"; Boolean)
        {
            Caption = 'Show On Portal';
        }
        field(50401; "PDC Check Carriage Limit"; Boolean)
        {
            Caption = 'Check Carriage Limit';
        }
        field(50402; "PDC Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(50403; "PDC Portal Sequence"; Integer)
        {
            Caption = 'Portal Sequence';
        }
        field(50404; "PDC Service Code"; Code[20])
        {
            Caption = 'Service Code';
        }
    }
    keys
    {
        key(Key1; "PDC Country/Region Code", "PDC Portal Sequence")
        {
        }
    }
}

