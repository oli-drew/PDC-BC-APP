/// <summary>
/// Table PDC Proposal Branding Line (ID 50049).
/// </summary>
table 50049 "PDC Proposal Branding Line"
{
    // 07.02.2020 JEMEL J.Jemeljanovs #3208 * Created

    Caption = 'Proposal Branding Line';

    fields
    {
        field(1; "Proposal No."; Code[20])
        {
            Caption = 'Proposal No.';
            TableRelation = "PDC Proposal Header"."No.";
        }
        field(2; "Proposal Line No."; Integer)
        {
            Caption = 'Proposal Line No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Branding No."; Code[20])
        {
            Caption = 'Branding No.';
            TableRelation = "PDC Branding";

            trigger OnLookup()
            begin
                PDCProposalHeader.Get("Proposal No.");
                PDCBranding.SetFilter("Sell-to Customer No.", '%1|%2', PDCProposalHeader."Customer No.", '');
                if Page.RunModal(0, PDCBranding) = Action::LookupOK then
                    Validate("Branding No.", PDCBranding."No.");
            end;

            trigger OnValidate()
            begin
                if PDCBranding.Get("Branding No.") then begin
                    "Item Component Cost" := PDCBranding."Item Component Cost";
                    "Consuming Component Cost" := PDCBranding."Consuming Component Cost";
                    "Routing Cost" := PDCBranding."Routing Cost Final";
                    "Branding Position Code" := PDCBranding."Branding Position Code";
                end
                else begin
                    "Item Component Cost" := 0;
                    "Consuming Component Cost" := 0;
                    "Routing Cost" := 0;
                    "Branding Position Code" := '';
                end;
            end;
        }
        field(5; "Branding Description"; Text[50])
        {
            CalcFormula = lookup("PDC Branding"."Branding Description" where("No." = field("Branding No.")));
            Caption = 'Branding Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Branding Type Code"; Code[20])
        {
            CalcFormula = lookup("PDC Branding"."Branding Type Code" where("No." = field("Branding No.")));
            Caption = 'Branding Type Code';
            FieldClass = FlowField;
            TableRelation = "PDC Branding Type".Code;
        }
        field(7; "Branding Position Code"; Code[20])
        {
            Caption = 'Branding Position Code';
            TableRelation = "PDC Branding Position".Code;
        }
        field(8; "Branding File"; Text[30])
        {
            CalcFormula = lookup("PDC Branding"."Branding File" where("No." = field("Branding No.")));
            Caption = 'Branding File';
            FieldClass = FlowField;
        }
        field(9; "Consuming Item No."; Code[20])
        {
            CalcFormula = lookup("PDC Branding"."Consuming Item No." where("No." = field("Branding No.")));
            Caption = 'Consuming Item No.';
            FieldClass = FlowField;
            TableRelation = Item."No.";
        }
        field(10; "Consuming Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Consuming Item No.")));
            Caption = 'Consuming Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Consuming Item Qty."; Integer)
        {
            CalcFormula = lookup("PDC Branding Position".Operations where(Code = field("Branding Position Code")));
            Caption = 'Consuming Item Qty.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Item Component Cost"; Decimal)
        {
            Caption = 'Item Component Cost';
        }
        field(14; "Consuming Component Cost"; Decimal)
        {
            Caption = 'Consuming Component Cost';
            FieldClass = Normal;
        }
        field(15; "Routing Cost"; Decimal)
        {
            Caption = 'Routing Cost';
        }
        field(16; "Product Code"; Code[30])
        {
            CalcFormula = lookup("PDC Proposal Product Line"."Product Code" where("Proposal No." = field("Proposal No."),
                                                                               "Line No." = field("Proposal Line No.")));
            Caption = 'Product Code';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
            begin
            end;
        }
        field(17; "Prod.Line Active"; Boolean)
        {
            CalcFormula = Lookup("PDC Proposal Product Line".Active where("Proposal No." = FIELD("Proposal No."), "Line No." = FIELD("Proposal Line No.")));
            Caption = 'Prod.Line Active';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Proposal No.", "Proposal Line No.", "Line No.")
        {
            SumIndexFields = "Routing Cost";
        }
    }

    fieldgroups
    {
    }

    var
        PDCProposalHeader: Record "PDC Proposal Header";
        PDCBranding: Record "PDC Branding";

    /// <summary>
    /// Update.
    /// </summary>
    procedure UpdateValues()
    begin
        Validate("Branding No.");
    end;
}

