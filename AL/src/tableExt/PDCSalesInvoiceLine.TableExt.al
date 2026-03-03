/// <summary>
/// TableExtension PDCSalesInvoiceLine (ID 50020) extends Record Sales Invoice Line.
/// </summary>
tableextension 50020 PDCSalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                PDCUpdateDocumentId();
            end;
        }
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
            TableRelation = "PDC Branch";
        }
        field(50009; "PDC Ordered By Phone"; Text[50])
        {
            Caption = 'Ordered By Phone';
        }
        field(50010; "PDC Comment Lines"; Boolean)
        {
            CalcFormula = exist("Sales Comment Line" where("Document Type" = const("Posted Invoice"),
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
        field(50023; "PDC Item Net Weight"; Decimal)
        {
            Caption = 'Item Net Weight';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Net Weight" where("No." = field("No.")));
            Editable = false;
        }
        field(50024; "PDC Item Country of OriginCode"; Code[10])
        {
            Caption = 'Item Country of Origin Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("No.")));
            Editable = false;
        }
        field(50025; "PDC Item Commodity Code"; Code[20])
        {
            Caption = 'Item Commodity Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Tariff No." where("No." = field("No.")));
            Editable = false;
        }
        field(50026; "PDC Document Id"; Guid)
        {
            Caption = 'Document Id';
            trigger OnValidate()
            begin
                PDCUpdateDocumentNo();
            end;
        }
        field(50027; "PDC Carbon Emissions CO2e"; Decimal)
        {
            Caption = 'Carbon Emissions CO2e';
            DecimalPlaces = 0 : 5;
        }
        field(50028; "PDC Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Ship-to Post Code" where("No." = field("Document No.")));
        }
        field(50029; "PDC Over Entitlement Reason"; Text[100])
        {
            Caption = 'Over Entitlement Reason';
        }
    }

    keys
    {

        key(PDCDocumentIdKey; "PDC Document Id")
        {
        }
    }

    trigger OnInsert()
    begin
        PDCUpdateDocumentId();
    end;

    local procedure PDCUpdateDocumentId()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if "Document No." = '' then begin
            Clear("PDC Document Id");
            exit;
        end;

        if not SalesInvoiceHeader.Get("Document No.") then
            exit;

        "PDC Document Id" := SalesInvoiceHeader.SystemId;
    end;


    local procedure PDCUpdateDocumentNo()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if IsNullGuid(Rec."PDC Document Id") then begin
            Clear(Rec."Document No.");
            exit;
        end;

        if not SalesInvoiceHeader.GetBySystemId(Rec."PDC Document Id") then
            exit;

        "Document No." := SalesInvoiceHeader."No.";
    end;
}

