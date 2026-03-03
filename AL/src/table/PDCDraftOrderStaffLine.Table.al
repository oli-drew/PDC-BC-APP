/// <summary>
/// Table PDC Draft Order Staff Line (ID 50024).
/// </summary>
table 50024 "PDC Draft Order Staff Line"
{

    Caption = 'Draft Order Staff Line';

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
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";

            trigger OnValidate()
            var
                DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
                Staff: Record "PDC Branch Staff";
            begin
                DraftOrderStaffLine.Reset();
                DraftOrderStaffLine.SetRange("Document No.", "Document No.");
                DraftOrderStaffLine.SetRange("Staff ID", "Staff ID");
                DraftOrderStaffLine.SetFilter("Line No.", '<>%1', "Line No.");
                if not DraftOrderStaffLine.IsEmpty then
                    Error(StaffAlreadyOnOrderLbl, "Staff ID", "Document No.");

                CalcFields("Staff Name", "Body Type/Gender", "Wearer ID", "Branch ID", "Branch Name", "Wardrobe ID", "Wardrobe Name");

                if "Staff ID" = '' then
                    Clear("Staff SystemId")
                else
                    if Staff.get("Staff ID") then
                        "Staff SystemId" := Staff.SystemId;
            end;
        }
        field(4; "Staff Name"; Text[70])
        {
            CalcFormula = lookup("PDC Branch Staff".Name where("Staff ID" = field("Staff ID")));
            Caption = 'Staff Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Body Type/Gender"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Body Type/Gender" where("Staff ID" = field("Staff ID")));
            Caption = 'Body Type/Gender';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Wearer ID"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Wearer ID" where("Staff ID" = field("Staff ID")));
            Caption = 'Your ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Branch ID"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Branch ID" where("Staff ID" = field("Staff ID")));
            Caption = 'Branch ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Branch Name"; Text[50])
        {
            CalcFormula = lookup("PDC Branch".Name where("Branch No." = field("Branch ID"),
                                                    "Customer No." = field("Customer No.")));
            Caption = 'Branch Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Wardrobe ID"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Wardrobe ID" where("Staff ID" = field("Staff ID")));
            Caption = 'Wardrobe ID';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Wardrobe Name"; Text[50])
        {
            CalcFormula = lookup("PDC Wardrobe Header".Description where("Wardrobe ID" = field("Wardrobe ID")));
            Caption = 'Wardrobe Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Contract ID"; Code[20])
        {
            CalcFormula = lookup("PDC Branch Staff"."Contract ID" where("Staff ID" = field("Staff ID")));
            Caption = 'Contract ID';
            FieldClass = FlowField;
        }
        field(12; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code".Code where("PDC Type" = const(Order));
        }
        field(13; "Customer No."; Code[20])
        {
            CalcFormula = lookup("PDC Draft Order Header"."Sell-to Customer No." where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(14; "PO No."; Code[20])
        {
            Caption = 'PO No.';
        }
        field(15; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            trigger OnValidate()
            begin
                UpdateDocumentNo();
            end;
        }
        field(16; "Staff SystemId"; Guid)
        {
            Caption = 'Staff SystemId';
            TableRelation = "PDC Branch Staff".SystemId;

            trigger OnValidate()
            var
                Staff: Record "PDC Branch Staff";
            begin
                if IsNullGuid("Staff SystemId") then
                    "Staff ID" := ''
                else
                    if Staff.GetBySystemId("Staff SystemId") then
                        "Staff ID" := Staff."Staff ID";
            end;
        }
        field(17; "Branch SystemId"; Guid)
        {
            CalcFormula = lookup("PDC Branch Staff"."Branch SystemId" where("Staff ID" = field("Staff ID")));
            Caption = 'Branch SystemId';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Wardrobe SystemId"; Guid)
        {
            CalcFormula = lookup("PDC Branch Staff"."Wardrobe SystemId" where("Staff ID" = field("Staff ID")));
            Caption = 'Wardrobe SystemId';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Contract SystemId"; Guid)
        {
            CalcFormula = lookup("PDC Branch Staff"."SystemId" where("Staff ID" = field("Staff ID")));
            Caption = 'Contract SystemId';
            FieldClass = FlowField;
        }
        field(20; "Customer Id"; Guid)
        {
            Caption = 'Cuctomer Id';
            CalcFormula = lookup("PDC Draft Order Header"."Customer Id" where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Staff ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PDCDraftOrderItemLine: Record "PDC Draft Order Item Line";
    begin
        PDCDraftOrderItemLine.Reset();
        PDCDraftOrderItemLine.SetRange("Document No.", "Document No.");
        PDCDraftOrderItemLine.SetRange("Staff Line No.", "Line No.");
        PDCDraftOrderItemLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if ("Staff ID" <> '') then
            StaffEntitlementFunctions.UpdateDraftOrderItemLines(Rec);

        UpdateDocumentId();
    end;

    trigger OnModify()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if ("Staff ID" <> '') then
            StaffEntitlementFunctions.UpdateDraftOrderItemLines(Rec);
    end;

    var
        StaffAlreadyOnOrderLbl: label 'Staff ID %1 is already part of Draft Order No. %2.', Comment = 'Staff ID %1 is already part of Draft Order No. %2.';

    local procedure UpdateDocumentNo()
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
    begin
        if IsNullGuid(Rec."Document Id") then begin
            Clear(Rec."Document No.");
            exit;
        end;

        if not DraftOrderHeader.GetBySystemId(Rec."Document Id") then
            exit;

        "Document No." := DraftOrderHeader."Document No.";
    end;

    local procedure UpdateDocumentId()
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
    begin
        if "Document No." = '' then begin
            Clear("Document Id");
            exit;
        end;

        if not DraftOrderHeader.Get("Document No.") then
            exit;

        "Document Id" := DraftOrderHeader.SystemId;
    end;
}

