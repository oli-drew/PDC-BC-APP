/// <summary>
/// Table PDC Branch Staff (ID 50020).
/// </summary>
table 50020 "PDC Branch Staff"
{
    DrillDownPageID = "PDC Branch Staff List";
    LookupPageID = "PDC Branch Staff List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';

            trigger OnValidate()
            var
                PDCNavPortal: Record "PDC Portal";
                NoSeries: Codeunit "No. Series";
            begin
                if "Staff ID" <> xRec."Staff ID" then begin
                    PDCNavPortal.Get('CUSTP');
                    NoSeries.TestManual(PDCNavPortal."Branch Staff Series Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Sell-to Customer No." = '' then
                    Clear("Customer Id")
                else
                    if Customer.get("Sell-to Customer No.") then
                        "Customer Id" := Customer.SystemId;
            end;
        }
        field(3; "Branch ID"; Code[20])
        {
            Caption = 'Branch ID';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            var
                Branch: Record "PDC Branch";
            begin
                if "Branch ID" = '' then
                    Clear("Branch SystemId")
                else
                    if Branch.get("Sell-to Customer No.", "Branch ID") then
                        "Branch SystemId" := Branch.SystemId;
            end;
        }
        field(4; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                Name := "First Name" + ' ' + "Last Name";
            end;
        }
        field(5; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                Name := "First Name" + ' ' + "Last Name";
            end;
        }
        field(6; Name; Text[70])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(7; "Body Type/Gender"; Code[10])
        {
            Caption = 'Body Type/Gender';
            TableRelation = "PDC General Lookup".Code where(Type = filter('BODYTYPE'));
        }
        field(8; "Wearer ID"; Code[20])
        {
            Caption = 'Wearer ID';

            trigger OnValidate()
            begin
                CheckYourIDIsUnique();
            end;
        }
        field(9; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header" where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            var
                Wardrobe: Record "PDC Wardrobe Header";
            begin
                if Wardrobe.get("Wardrobe ID") then
                    Wardrobe.TestField(Disable, false);

                if "Wardrobe ID" = '' then
                    Clear("Wardrobe SystemId")
                else
                    if Wardrobe.Get("Wardrobe ID") then
                        "Wardrobe SystemId" := Wardrobe.SystemId;
            end;
        }
        field(10; "Contract ID"; Code[20])
        {
            Caption = 'Contract ID';
            TableRelation = "PDC Contract"."No." where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            var
                Contract: Record "PDC Contract";
            begin
                if "Contract ID" = '' then
                    Clear("Contract SystemId")
                else
                    if Contract.Get("Sell-to Customer No.", "Wardrobe ID") then
                        "Wardrobe SystemId" := Contract.SystemId;
            end;
        }
        field(11; "Email Address"; Text[70])
        {
            Caption = 'Email Address';
        }
        field(12; Blocked; Boolean)
        {
        }
        field(14; "Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            CalcFormula = lookup("PDC Branch".Name where("Branch No." = field("Branch ID"),
                                                    "Customer No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
        field(15; "Wardrobe Description"; Text[50])
        {
            Caption = 'Wardrobe Description';
            CalcFormula = lookup("PDC Wardrobe Header".Description where("Wardrobe ID" = field("Wardrobe ID")));
            FieldClass = FlowField;
        }
        field(16; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(17; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
            TableRelation = Customer.SystemId;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if IsNullGuid("Customer Id") then
                    "Sell-to Customer No." := ''
                else
                    if Customer.GetBySystemId("Customer Id") then
                        "Sell-to Customer No." := Customer."No.";
            end;
        }
        field(18; "Branch SystemId"; Guid)
        {
            Caption = 'Branch SystemId';
            TableRelation = "PDC Branch".SystemId;

            trigger OnValidate()
            var
                Branch: Record "PDC Branch";
            begin
                if IsNullGuid("Branch SystemId") then
                    "Wardrobe ID" := ''
                else
                    if Branch.GetBySystemId("Branch SystemId") then
                        "Branch ID" := Branch."Branch No.";
            end;
        }
        field(19; "Wardrobe SystemId"; Guid)
        {
            Caption = 'Wardrobe SystemId';
            TableRelation = "PDC Wardrobe Header".SystemId;

            trigger OnValidate()
            var
                Wardrobe: Record "PDC Wardrobe Header";
            begin
                if IsNullGuid("Wardrobe SystemId") then
                    "Wardrobe ID" := ''
                else
                    if Wardrobe.GetBySystemId("Wardrobe SystemId") then
                        "Wardrobe ID" := Wardrobe."Wardrobe ID";
            end;
        }
        field(20; "Contract SystemId"; Guid)
        {
            Caption = 'Contract SystemId';
            TableRelation = "PDC Contract".SystemId;

            trigger OnValidate()
            var
                Contract: Record "PDC Contract";
            begin
                if IsNullGuid("Contract SystemId") then
                    "Contract ID" := ''
                else
                    if Contract.GetBySystemId("Contract SystemId") then
                        "Contract ID" := Contract."No.";
            end;
        }
        field(21; "Contract Name"; Text[50])
        {
            Caption = 'Contract Name';
            FieldClass = FlowField;
            CalcFormula = lookup("PDC Contract".Description where("Customer No." = field("Sell-to Customer No."), "No." = field("Contract ID")));
        }
        field(22; "Created By"; Text[80])
        {
            Caption = 'Created By';
            TableRelation = "PDC Portal User".Id;
        }
        field(23; "Created On"; DateTime)
        {
            Caption = 'Created On';
        }
    }

    keys
    {
        key(Key1; "Staff ID")
        {
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if StaffEntitlementFunctions.WardrobeEntitlementExistsForBranchStaff("Staff ID") then
            Error(StaffEntitlementExistsLbl, "Staff ID");
    end;

    trigger OnInsert()
    var
        PDCNavPortal: Record "PDC Portal";
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
        NoSeries: Codeunit "No. Series";
    begin
        if "Staff ID" = '' then begin
            PDCNavPortal.Get('CUSTP');
            PDCNavPortal.TestField("Branch Staff Series Nos.");
            "No. Series" := PDCNavPortal."Branch Staff Series Nos.";
            "Staff ID" := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

        if "Wardrobe ID" <> '' then
            StaffEntitlementFunctions.UpdateStaffEntitlementFromBranchStaff(Rec);

        CheckYourIDIsUnique();
    end;

    trigger OnModify()
    var
        StaffEntitlementFunctions: Codeunit "PDC Staff Entitlement";
    begin
        if "Wardrobe ID" <> '' then
            StaffEntitlementFunctions.UpdateStaffEntitlementFromBranchStaff(Rec);

        CheckYourIDIsUnique();
    end;

    var
        StaffEntitlementExistsLbl: label 'Staff Entitlement Exists for Staff ID %1.', comment = 'Staff Entitlement Exists for Staff ID %1.';
        YourIDAlreadyInUseLbl: label 'Your ID %1 is already being used by Staff ID %2 %3.', comment = 'Your ID %1 is already being used by Staff ID %2 %3.';

    local procedure CheckYourIDIsUnique()
    var
        PDCBranchStaff: Record "PDC Branch Staff";
    begin
        if "Wearer ID" = '' then
            exit;

        PDCBranchStaff.Reset();
        PDCBranchStaff.SetFilter("Staff ID", '<>%1', "Staff ID");
        PDCBranchStaff.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
        PDCBranchStaff.SetRange("Wearer ID", "Wearer ID");
        if not PDCBranchStaff.IsEmpty then begin
            PDCBranchStaff.FindFirst();
            Error(YourIDAlreadyInUseLbl, "Wearer ID", PDCBranchStaff."Staff ID", PDCBranchStaff.Name);
        end;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(): Boolean
    var
        PDCNavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";
    begin
        PDCNavPortal.Get('CUSTP');
        PDCNavPortal.TestField("Branch Staff Series Nos.");
        if NoSeries.LookupRelatedNoSeries(PDCNavPortal."Branch Staff Series Nos.", xRec."No. Series", "No. Series") then begin
            "Staff ID" := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;
}

