/// <summary>
/// TableExtension PDCRoutingLine (ID 50053) extends Record Routing Line.
/// </summary>
tableextension 50053 PDCRoutingLine extends "Routing Line"
{
    fields
    {
        field(50000; "PDC Branding No."; Code[20])
        {
            Caption = 'Branding No.';
            TableRelation = "PDC Branding";

            trigger OnLookup()
            var
                RoutingHeader: Record "Routing Header";
                PDCBranding: Record "PDC Branding";
            begin
                RoutingHeader.Get("Routing No.");
                PDCBranding.SetFilter("Sell-to Customer No.", '%1|%2', RoutingHeader."PDC Sell-to Customer No.", '');
                if Page.RunModal(0, PDCBranding) = Action::LookupOK then
                    Validate("PDC Branding No.", PDCBranding."No.");
            end;

            trigger OnValidate()
            var
                PDCBranding: Record "PDC Branding";
            begin
                if PDCBranding.Get("PDC Branding No.") then begin
                    PDCBranding.CalcFields("Routing Type", "Routing No.");
                    Validate(Type, PDCBranding."Routing Type");
                    Validate("No.", PDCBranding."Routing No.");
                    Validate("Run Time", PDCBranding."Routing Run Time Mins");
                    Validate("Unit Cost per", PDCBranding."Routing Cost Final");
                    "PDC Branding Type Code" := PDCBranding."Branding Type Code";
                    "PDC Branding Position Code" := PDCBranding."Branding Position Code";
                    Description := CopyStr(PDCBranding."Branding Description" + ' ' + PDCBranding."Branding File", 1, 50);
                end;
            end;
        }
        field(50001; "PDC Branding Type Code"; Code[20])
        {
            CalcFormula = lookup("PDC Branding"."Branding Type Code" where("No." = field("PDC Branding No.")));
            Caption = 'Branding Type Code';
            FieldClass = FlowField;
            TableRelation = "PDC Branding Type".Code;
        }
        field(50002; "PDC Branding Position Code"; Code[20])
        {
            CalcFormula = lookup("PDC Branding"."Branding Position Code" where("No." = field("PDC Branding No.")));
            Caption = 'Branding Position Code';
            FieldClass = FlowField;
            TableRelation = "PDC Branding Position".Code;
        }
        field(50003; "PDC Branding File"; text[30])
        {
            CalcFormula = lookup("PDC Branding"."Branding File" where("No." = field("PDC Branding No.")));
            Caption = 'Branding File';
            FieldClass = FlowField;
        }
    }
}

