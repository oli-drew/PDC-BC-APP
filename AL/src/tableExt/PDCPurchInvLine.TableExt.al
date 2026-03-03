/// <summary>
/// TableExtension PDCPurchInvLine (ID 50023) extends Record Purch. Inv. Line.
/// </summary>
tableextension 50023 PDCPurchInvLine extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50001; "PDC Special Order"; Boolean)
        {
            Caption = 'Special Order';
        }
        field(50002; "PDC Special Order Sales No."; Code[20])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order Sales No.';
            TableRelation = if ("PDC Special Order" = const(true)) "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50003; "PDC Spec. Order Sales Line No."; Integer)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order Sales Line No.';
            TableRelation = if ("PDC Special Order" = const(true)) "Sales Line"."Line No." where("Document Type" = const(Order),
                                                                                            "Document No." = field("PDC Special Order Sales No."));
        }
        field(50004; "PDC Skip Pmt. Discount"; Boolean)
        {
            Caption = 'Skip Pmt. Discount';
        }
    }
}

