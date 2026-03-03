/// <summary>
/// Table PDC Proposal Product Line (ID 50047).
/// </summary>
table 50047 "PDC Proposal Product Line"
{
    // 07.02.2020 JEMEL J.Jemeljanovs #3208 * Created

    Caption = 'Proposal Product Line';

    fields
    {
        field(1; "Proposal No."; Code[20])
        {
            Caption = 'Proposal No.';
            TableRelation = "PDC Proposal Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
            NotBlank = true;

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                Item.SetRange(Type, Item.Type::Inventory);
                if Page.RunModal(0, Item) = Action::LookupOK then
                    Validate("Product Code", Item."PDC Product Code");
            end;

            trigger OnValidate()
            var
                ProposalCostingLine: Record "PDC Proposal Costing Line";
            begin
                if "Product Code" <> xRec."Product Code" then begin
                    ProposalCostingLine.SetRange("Proposal No.", "Proposal No.");
                    ProposalCostingLine.SetRange("Proposal Line No.", "Line No.");
                    if ProposalCostingLine.FindSet(true) then
                        repeat
                            ProposalCostingLine.Validate("Product Code", "Product Code");
                            ProposalCostingLine.Modify();
                        until ProposalCostingLine.Next() = 0;
                end;
            end;
        }
        field(4; "Vendor Item"; Text[30])
        {
            Caption = 'Vendor Item';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Branding Routing Cost"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Branding Line"."Routing Cost" where("Proposal No." = field("Proposal No."),
                                                                             "Proposal Line No." = field("Line No.")));
            Caption = 'Branding Routing Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Branding Component Cost"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Branding Line"."Consuming Component Cost" where("Proposal No." = field("Proposal No."),
                                                                                         "Proposal Line No." = field("Line No.")));
            Caption = 'Branding Component Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Size Range"; Text[50])
        {
            Caption = 'Size Range';
        }
        field(9; "STD Sizes"; Text[50])
        {
            Caption = 'STD Sizes';
        }
        field(10; "Skip Print"; Boolean)
        {
            Caption = 'Skip Print';
        }
        field(11; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(12; "Item Code"; text[30])
        {
            Caption = 'Item Code';
        }
        field(13; "Internal Notes"; text[30])
        {
            Caption = 'Internal Notes';
        }
    }

    keys
    {
        key(Key1; "Proposal No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PDCProposalCostingLine.SetRange("Proposal No.", "Proposal No.");
        PDCProposalCostingLine.SetRange("Proposal Line No.", "Line No.");
        PDCProposalCostingLine.DeleteAll();

        PDCProposalBrandingLine.SetRange("Proposal No.", "Proposal No.");
        PDCProposalBrandingLine.SetRange("Proposal Line No.", "Line No.");
        PDCProposalBrandingLine.DeleteAll();
    end;

    var
        PDCProposalCostingLine: Record "PDC Proposal Costing Line";
        PDCProposalBrandingLine: Record "PDC Proposal Branding Line";

    /// <summary>
    /// UpdateLines.
    /// </summary>
    procedure UpdateLines()
    var
        PDCProposalBrandingLine2: Record "PDC Proposal Branding Line";
        PDCProposalCostingLine2: Record "PDC Proposal Costing Line";
    begin
        PDCProposalBrandingLine2.SetRange("Proposal No.", "Proposal No.");
        PDCProposalBrandingLine2.SetRange("Proposal Line No.", "Line No.");
        if PDCProposalBrandingLine2.FindSet(true) then
            repeat
                PDCProposalBrandingLine2.UpdateValues();
                PDCProposalBrandingLine2.Modify(true);
            until PDCProposalBrandingLine2.Next() = 0;

        PDCProposalCostingLine2.SetRange("Proposal No.", "Proposal No.");
        PDCProposalCostingLine2.SetRange("Proposal Line No.", "Line No.");
        if PDCProposalCostingLine2.FindSet(true) then
            repeat
                PDCProposalCostingLine2.UpdateValues();
                PDCProposalCostingLine2.Modify(true);
            until PDCProposalCostingLine2.Next() = 0;
    end;
}

