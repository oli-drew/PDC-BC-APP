/// <summary>
/// TableExtension PDCWarehouseActivityLine (ID 50040) extends Warehouse Activity Line
/// </summary>
tableextension 50040 PDCWarehouseActivityLine extends "Warehouse Activity Line"
{
    fields
    {
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50001; "PDC Wearer ID"; Code[30])
        {
            Caption = 'Wearer ID';
        }
        field(50002; "PDC Wearer Name"; Text[50])
        {
            Caption = 'Wearer Name';
        }
        field(50003; "PDC Customer Reference"; Text[50])
        {
            Caption = 'Customer Reference';
        }
        field(50004; "PDC Web Order No."; Code[10])
        {
            caption = 'Web Order No.';
        }
        field(50005; "PDC Ordered By ID"; Code[20])
        {
            Caption = 'Ordered By ID';
        }
        field(50006; "PDC Ordered By Name"; Text[100])
        {
            Caption = 'Ordered By Name';
        }
        field(50008; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
            TableRelation = "PDC Branch"."Branch No.";
        }
        field(50009; "PDC Ordered By Phone"; Text[50])
        {
            Caption = 'Ordered By Phone';
        }
        field(50010; "PDC SO Line Amount"; Decimal)
        {
            caption = 'Sales Order Line Amount';
            FieldClass = FlowField;
            CalcFormula = LookUp("Sales Line"."Line Amount" where("Document Type" = const(Order),
                                                            "Document No." = field("Source No."),
                                                            "Line No." = field("Source Line No.")));
        }
        field(50050; "PDC Hide Posting Dialog"; Boolean)
        {
            Caption = 'Hide Posting Dialog';
            Description = 'JML need for posting';
        }
    }
}

