/// <summary>
/// Table PDC Branch (ID 50012).
/// </summary>
Table 50012 "PDC Branch"
{
    Caption = 'Branch';
    DrillDownPageID = "PDC Branches";
    LookupPageID = "PDC Branches";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." = '' then
                    Clear("Customer Id")
                else
                    if Customer.get("Customer No.") then
                        "Customer Id" := Customer.SystemId;
            end;
        }
        field(2; "Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            FieldClass = FlowField;
        }
        field(5; Address; Text[30])
        {
        }
        field(6; "Address 2"; Text[30])
        {
        }
        field(7; "Address 3"; Text[30])
        {
        }
        field(8; "Address 4"; Text[30])
        {
        }
        field(9; "Address 5"; Text[30])
        {
        }
        field(10; City; Code[50])
        {
        }
        field(11; "Post Code"; Code[10])
        {
        }
        field(12; Phone; Text[30])
        {
        }
        field(13; "Ship-to Address"; Code[10])
        {
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(14; "Default Branch"; Boolean)
        {
        }
        field(15; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
            TableRelation = Customer.SystemId;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if IsNullGuid("Customer Id") then
                    "Customer No." := ''
                else
                    if Customer.GetBySystemId("Customer Id") then
                        "Customer No." := Customer."No.";
            end;
        }
        field(16; "Parent Branch No."; Code[20])
        {
            Caption = 'Parent Branch No.';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Customer No."));

            trigger OnValidate()
            var
                Branch1: Record "PDC Branch";
                ParentBranch: Code[20];
            begin
                ParentBranch := "Parent Branch No.";
                while Branch1.Get("Customer No.", ParentBranch) do begin
                    if Branch1."Branch No." = "Branch No." then
                        Error(CyclicInheritanceErr);
                    ParentBranch := Branch1."Parent Branch No.";
                end;
            end;
        }
        field(17; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(18; "Presentation Order"; Integer)
        {
            Caption = 'Presentation Order';
        }
        field(19; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
        }
        field(20; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Branch No.")
        {
        }
        key(Key2; "Parent Branch No.")
        {
        }
        key(Key3; "Presentation Order")
        {
        }
        key(Key4; Indentation, "Customer No.", "Branch No.", Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Customer No.");
        TestField("Branch No.");
        UpdateIndentation();
        PortalsManagement.CalcPresentationOrder(Rec);
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        UpdateIndentation();
        PortalsManagement.CalcPresentationOrder(Rec);
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnRename()
    begin
        "Presentation Order" := 0;
        "Last Modified Date Time" := CurrentDateTime;
    end;

    var
        PortalsManagement: Codeunit "PDC Portals Management";
        CyclicInheritanceErr: Label 'An Branch cannot be a parent of itself or any of its children.';


    procedure HasChildren(): Boolean
    var
        Branch: Record "PDC Branch";
    begin
        Branch.setrange("Customer No.", "Customer No.");
        Branch.SetRange("Parent Branch No.", "Branch No.");
        exit(not Branch.IsEmpty)
    end;

    local procedure UpdateIndentation()
    var
        ParentBranch: Record "PDC Branch";
    begin
        if ParentBranch.Get("Customer No.", "Parent Branch No.") then
            UpdateIndentationTree(ParentBranch.Indentation + 1)
        else
            UpdateIndentationTree(0);
    end;

    procedure UpdateIndentationTree(Level: Integer)
    var
        Branch: Record "PDC Branch";
    begin
        Indentation := Level;

        Branch.setrange("Customer No.", "Customer No.");
        Branch.SetRange("Parent Branch No.", "Branch No.");
        if Branch.FindSet() then
            repeat
                Branch.UpdateIndentationTree(Level + 1);
                Branch.Modify();
            until Branch.Next() = 0;
    end;

    procedure GetStyleText(): Text
    begin
        if Indentation = 0 then
            exit('Strong');

        if HasChildren() then
            exit('Strong');

        exit('');
    end;
}

