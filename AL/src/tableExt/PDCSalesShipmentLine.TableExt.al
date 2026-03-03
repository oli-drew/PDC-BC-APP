/// <summary>
/// TableExtension PDCSalesShipmentLine (ID 50018) extends Record Sales Shipment Line.
/// </summary>
tableextension 50018 PDCSalesShipmentLine extends "Sales Shipment Line"
{
    fields
    {
        field(50000; "PDC Protex SKU"; Code[30])
        {
            Caption = 'Protex SKU';
            Editable = false;
            TableRelation = Item."PDC Product Code";
        }
        field(50001; "PDC Wearer ID"; Code[30])
        {
            Caption = 'Wearer ID';
            Editable = false;
        }
        field(50002; "PDC Wearer Name"; Text[50])
        {
            Caption = 'Wearer Name';
            Editable = false;
        }
        field(50003; "PDC Customer Reference"; Text[50])
        {
            Caption = 'Customer Reference';
            Editable = false;
        }
        field(50004; "PDC Web Order No."; Code[10])
        {
            Caption = 'Web Order No.';
            Editable = false;
        }
        field(50005; "PDC Ordered By ID"; Code[20])
        {
            Caption = 'Ordered By ID';
            Editable = false;
        }
        field(50006; "PDC Ordered By Name"; Text[100])
        {
            Caption = 'Ordered By Name';
            Editable = false;
        }
        field(50007; "PDC Consignment No."; Code[20])
        {
            Caption = 'Consignment No.';
        }
        field(50008; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Sell-to Customer No."));
        }
        field(50009; "PDC Ordered By Phone"; Text[50])
        {
            Caption = 'Ordered By Phone';
        }
        field(50010; "PDC Comment Lines"; Boolean)
        {
            CalcFormula = exist("Sales Comment Line" where("Document Type" = const(Shipment),
                                                            "No." = field("Document No."),
                                                            "Document Line No." = field("Line No.")));
            Caption = 'Comment Lines';
            FieldClass = FlowField;
        }
        field(50011; "PDC Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";
        }
        field(50012; "PDC Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";
        }
        field(50013; "PDC SLA Date"; Date)
        {
            Caption = 'SLA Date';
        }
        field(50014; "PDC Draft Order No."; Code[20])
        {
            Caption = 'Draft Order No.';
        }
        field(50015; "PDC Draft Order Staff Line No."; Integer)
        {
            Caption = 'Draft Order Staff Line No.';
        }
        field(50016; "PDC Draft Order Item Line No."; Integer)
        {
            Caption = 'Draft Order Item Line No.';
        }
        field(50017; "PDC Order Reason Code"; Code[10])
        {
            Caption = 'Order Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(50018; "PDC Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "PDC Contract"."No.";
        }
        field(50019; "PDC Order Reason"; Text[50])
        {
            Caption = 'Order Reason';
        }
        field(50020; "PDC Created By ID"; Code[20])
        {
            Caption = 'Created By ID';
        }
        field(50021; "PDC Created By Name"; Text[100])
        {
            Caption = 'Created By Name';
        }
        field(50022; "PDC Contract Code"; Code[20])
        {
            Caption = 'Contract Code';
            FieldClass = FlowField;
            CalcFormula = lookup("PDC Contract"."Contract Code" where("Customer No." = field("Sell-to Customer No."), "No." = field("PDC Contract No.")));
        }
        field(50027; "PDC Carbon Emissions CO2e"; Decimal)
        {
            Caption = 'Carbon Emissions CO2e';
            DecimalPlaces = 0 : 5;
        }
    }
}

