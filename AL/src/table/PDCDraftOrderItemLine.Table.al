/// <summary>
/// Table PDC Draft Order Item Line (ID 50025).
/// </summary>
table 50025 "PDC Draft Order Item Line"
{

    Caption = 'Draft Order Item Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "PDC Draft Order Header"."Document No.";

            trigger OnValidate()
            begin
                UpdateDocumentId();
            end;
        }
        field(2; "Staff Line No."; Integer)
        {
            TableRelation = "PDC Draft Order Staff Line"."Line No." where("Document No." = field("Document No."));
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
        }
        field(6; Quantity; Integer)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            var
                PDCFunctions: Codeunit "PDC Functions";
            begin
                if "Item No." <> '' then begin
                    PDCFunctions.FindDraftOrderItemLinePrice(Rec);
                    UpdateLineAmount();
                end;
            end;
        }
        field(7; Entitlement; Integer)
        {
            CalcFormula = lookup("PDC Wardrobe Line"."Quantity Entitled in Period" where("Wardrobe ID" = field("Wardrobe ID"),
                                                                                      "Product Code" = field("Product Code")));
            Caption = 'Entitlement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Quantity Issued"; Decimal)
        {
            CalcFormula = lookup("PDC Staff Entitlement"."Calculated Quantity Issued" where("Staff ID" = field("Staff ID"),
                                                                                         "Branch No." = field("Branch ID"),
                                                                                         "Product Code" = field("Product Code"),
                                                                                         Inactive = const(false)));
            Caption = 'Quantity Issued';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Colour Code"; Code[20])
        {
            Caption = 'Colour Code';
        }
        field(11; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                UpdateLineAmount();
            end;
        }
        field(12; "Unit Of Measure Code"; Code[20])
        {
            Caption = 'Unit Of Measure Code';
            TableRelation = "Unit of Measure".Code;
        }
        field(13; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(14; "SLA Date"; Date)
        {
            Caption = 'SLA Date';
        }
        field(15; "Last DateTime Calculated"; DateTime)
        {
            CalcFormula = lookup("PDC Staff Entitlement"."Last DateTime Calculated" where("Staff ID" = field("Staff ID"),
                                                                                       "Branch No." = field("Branch ID"),
                                                                                       "Product Code" = field("Product Code"),
                                                                                       Inactive = const(false)));
            Caption = 'Last DateTime Calculated';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Quantity Remaining"; Decimal)
        {
            CalcFormula = lookup("PDC Staff Entitlement"."Calc. Qty. Remaining in Period" where("Staff ID" = field("Staff ID"),
                                                                                             "Branch No." = field("Branch ID"),
                                                                                             "Product Code" = field("Product Code"),
                                                                                             Inactive = const(false)));
            Caption = 'Quantity Remaining';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(18; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order),
                                                           "Document No." = field("Sales Order No."));
        }
        field(19; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnLookup()
            var
                Item: Record Item;
                WardrobeLine: Record "PDC Wardrobe Line";
                WardrobeItemOption: Record "PDC Wardrobe Item Option";
                TempWardrobeItemOption: Record "PDC Wardrobe Item Option" temporary;
                ProtexSKUFilter: Text;
                ColourFilter: Text;
            begin
                CalcFields("Wardrobe ID");
                WardrobeLine.Reset();
                WardrobeLine.SetRange("Wardrobe ID", "Wardrobe ID");
                if WardrobeLine.FindSet() then
                    repeat
                        if ProtexSKUFilter <> '' then
                            ProtexSKUFilter := ProtexSKUFilter + '|';

                        ProtexSKUFilter := ProtexSKUFilter + WardrobeLine."Product Code";

                        WardrobeItemOption.Reset();
                        WardrobeItemOption.SetRange("Wardrobe ID", "Wardrobe ID");
                        WardrobeItemOption.SetRange("Product Code", "Product Code");
                        if WardrobeItemOption.FindSet() then
                            repeat
                                if not TempWardrobeItemOption.Get('', '', WardrobeItemOption."Colour Code") then begin
                                    TempWardrobeItemOption.Init();
                                    TempWardrobeItemOption."Colour Code" := WardrobeItemOption."Colour Code";
                                    TempWardrobeItemOption.Insert();

                                    if ColourFilter <> '' then
                                        ColourFilter := ColourFilter + '|';

                                    ColourFilter := ColourFilter + WardrobeItemOption."Colour Code";
                                end;
                            until WardrobeItemOption.Next() = 0;

                    until WardrobeLine.Next() = 0;

                Item.Reset();
                Item.SetFilter("PDC Product Code", ProtexSKUFilter);
                Item.SetFilter("PDC Colour", ColourFilter);
                if Page.RunModal(0, Item) <> Action::LookupOK then
                    Error('');

                Validate("Item No.", Item."No.");
            end;

            trigger OnValidate()
            var
                Item: Record Item;
                PDCFunctions: Codeunit "PDC Functions";
            begin
                if "Item No." <> '' then begin
                    Item.Get("Item No.");
                    Validate("Item Description", Item.Description);
                    "Product Code" := Item."PDC Product Code";
                    "Colour Code" := Item."PDC Colour";
                    "Fit Code" := Item."PDC Fit";
                    "Size Code" := Item."PDC Size";
                    "Colour Sequence" := Item."PDC Colour Sequence";
                    "Size Sequence" := Item."PDC Size Sequence";
                    "Fit Sequence" := Item."PDC Fit Sequence";
                end
                else begin
                    Validate("Item Description", '');
                    "Product Code" := '';
                    "Colour Code" := '';
                    "Fit Code" := '';
                    "Size Code" := '';
                    "Colour Sequence" := '';
                    "Size Sequence" := 0;
                    "Fit Sequence" := 0;
                end;

                if "Item No." <> xRec."Item No." then begin
                    if ("Item No." <> Item."No.") and ("Item No." <> '') then
                        Item.Get("Item No.");

                    Validate("Unit Of Measure Code", Item."Sales Unit of Measure");
                    Validate(Quantity, 0);
                    Validate("Unit Price", 0);
                    if "Item No." <> '' then
                        PDCFunctions.FindDraftOrderItemLinePrice(Rec);

                end;
                if "Item No." = '' then
                    Clear("Item Id")
                else
                    if Item.Get("Item No.") then
                        "Item Id" := Item.SystemId;
            end;
        }
        field(20; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(21; "Fit Code"; Code[10])
        {
            Caption = 'Fit Code';
        }
        field(22; "Size Code"; Code[10])
        {
            Caption = 'Size Code';
        }
        field(23; "Colour Sequence"; Code[10])
        {
            Caption = 'Colour Sequence';
        }
        field(24; "Size Sequence"; Integer)
        {
            Caption = 'Size Sequence';
        }
        field(25; "Fit Sequence"; Integer)
        {
            Caption = 'Fit Sequence';
        }
        field(26; "Over Entitlement Reason"; Text[100])
        {
            Caption = 'Over Entitlement Reason';
        }
        field(100; "Staff ID"; Code[20])
        {
            CalcFormula = lookup("PDC Draft Order Staff Line"."Staff ID" where("Document No." = field("Document No."),
                                                                            "Line No." = field("Staff Line No.")));
            Caption = 'Staff ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Branch ID"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Branch ID" where("Staff ID" = field("Staff ID")));
            Caption = 'Branch ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Wardrobe ID"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Wardrobe ID" where("Staff ID" = field("Staff ID")));
            Caption = 'Wardrobe ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Approved Outside SLA"; Boolean)
        {
            CalcFormula = lookup("PDC Draft Order Header"."Approved Outside SLA" where("Document No." = field("Document No.")));
            Caption = 'Approved Outside SLA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; "Create Order No."; Integer)
        {
        }
        field(201; "Requested Shipment Date"; Date)
        {
        }
        field(202; "Shipping Agent Code"; Code[20])
        {
        }
        field(203; "Shipping Agent Service Code"; Code[20])
        {
        }
        field(205; "Portal User Id"; text[80])
        {
        }
        field(204; "Out Of SLA"; Boolean)
        {
        }
        field(300; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            trigger OnValidate()
            begin
                UpdateDocumentNo();
            end;
        }
        field(301; "Item Id"; Guid)
        {
            Caption = 'Item Id';
            TableRelation = Item.SystemId;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if IsNullGuid("Item Id") then
                    "Item No." := ''
                else
                    if Item.GetBySystemId("Item Id") then
                        "Item No." := Item."No.";
            end;
        }
        field(302; "Staff SystemId"; Guid)
        {
            Caption = 'Staff SystemId';
            CalcFormula = lookup("PDC Draft Order Staff Line"."Staff SystemId" where("Document No." = field("Document No."),
                                                                            "Line No." = field("Staff Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(303; "Branch SystemId"; Guid)
        {
            CalcFormula = lookup("PDC Branch Staff"."Branch SystemId" where("Staff ID" = field("Staff ID")));
            Caption = 'Branch SystemId';
            Editable = false;
            FieldClass = FlowField;
        }
        field(304; "Wardrobe SystemId"; Guid)
        {
            CalcFormula = lookup("PDC Branch Staff"."Wardrobe SystemId" where("Staff ID" = field("Staff ID")));
            Caption = 'Wardrobe SystemId';
            Editable = false;
            FieldClass = FlowField;
        }
        field(305; "Staff Line Id"; Guid)
        {
            Caption = 'Staff Line Id';
            trigger OnValidate()
            begin
                UpdateDocumentNo();
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Staff Line No.", "Line No.")
        {
        }
        key(Key2; "Product Code")
        {
        }
        key(Key3; "Product Code", "Colour Sequence", "Fit Sequence", "Size Sequence")
        {
        }
        key(Key4; "Create Order No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UpdateDocumentId();
    end;

    local procedure UpdateLineAmount()
    begin
        Validate("Line Amount", Quantity * "Unit Price");
    end;

    local procedure UpdateDocumentNo()
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
    begin
        if IsNullGuid(Rec."Document Id") then begin
            Clear(Rec."Document No.");
            clear("Staff Line No.");
            exit;
        end;

        if not DraftOrderHeader.GetBySystemId(Rec."Document Id") then
            exit;
        if not DraftOrderStaffLine.GetBySystemId(Rec."Staff Line Id") then
            exit;

        "Document No." := DraftOrderHeader."Document No.";
        "Staff Line No." := DraftOrderStaffLine."Line No.";
    end;

    local procedure UpdateDocumentId()
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
    begin
        if "Document No." = '' then begin
            Clear("Document Id");
            clear("Staff Line Id");
            exit;
        end;

        if not DraftOrderHeader.Get("Document No.") then
            exit;
        if not DraftOrderStaffLine.get(Rec."Document No.", Rec."Staff Line No.") then
            exit;
        "Document Id" := DraftOrderHeader.SystemId;
        "Staff Line Id" := DraftOrderStaffLine.SystemId;
    end;
}
