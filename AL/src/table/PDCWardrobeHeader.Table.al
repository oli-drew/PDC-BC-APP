/// <summary>
/// Table PDC Wardrobe Header (ID 50018).
/// </summary>
table 50018 "PDC Wardrobe Header"
{
    // //DOC PDCP9         JF 11/07/2017 - object creation
    // //DOC MA2018-06-26  MA 26/06/2018 - added call to WardrobeEntitlementExistsForWardrobeHeader function from No. OnValidate()
    //       DRW2018-06-28 DRW 28/06/2019 - commented  out the above call for the time being.

    Caption = 'Wardrobe Header';
    DrillDownPageID = "PDC Wardrobe List";
    LookupPageID = "PDC Wardrobe List";

    fields
    {
        field(1; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';

            trigger OnValidate()
            begin
                if "Wardrobe ID" <> xRec."Wardrobe ID" then begin
                    NavPortal.Get('CUSTP');
                    NoSeries.TestManual(NavPortal."Wardrobe Series Nos.");
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
            begin
                CalcFields("Customer Name");
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(6; Disable; Boolean)
        {
            Caption = 'Disable';
            trigger OnValidate()
            var
                Staff: Record "PDC Branch Staff";
            begin
                if Disable then begin
                    Staff.SetRange("Wardrobe ID", "Wardrobe ID");
                    if not Staff.IsEmpty then
                        error(DisableErr);
                end;
            end;
        }
        field(7; "Entitlement By Qty. Group"; Boolean)
        {
            Caption = 'Entitlement By Qty. Group';

        }
        field(8; "Entitlement By Value Group"; Boolean)
        {
            Caption = 'Entitlement By Value Group';
        }
        field(9; "Entitlement By Points Group"; Boolean)
        {
            Caption = 'Entitlement By Points Group';
        }
        field(10; "Default Wardrobe"; Boolean)
        {
            Caption = 'Default Wardrobe';
        }
    }

    keys
    {
        key(Key1; "Wardrobe ID")
        {
        }
        key(Key2; "Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DisableErr: Label 'Wardrobe cannot be disabled when it is applied to Staff';

    trigger OnDelete()
    var
        PDCWardrobeLine: Record "PDC Wardrobe Line";
        PDCBranchStaff: Record "PDC Branch Staff";
        ErrWardrobeAssignedLbl: Label 'Cannot delete wardrobe %1 as it is assigned to one or more staff members', Comment = 'Cannot delete wardrobe %1 as it is assigned to one or more staff members';
    begin
        PDCBranchStaff.Reset();
        PDCBranchStaff.SetRange("Wardrobe ID", "Wardrobe ID");
        if PDCBranchStaff.Get() then Error(ErrWardrobeAssignedLbl, "Wardrobe ID");

        PDCWardrobeLine.Reset();
        PDCWardrobeLine.SetRange("Wardrobe ID", "Wardrobe ID");
        PDCWardrobeLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if "Wardrobe ID" = '' then begin
            NavPortal.Get('CUSTP');
            NavPortal.TestField("Wardrobe Series Nos.");
            "No. Series" := NavPortal."Wardrobe Series Nos.";
            "Wardrobe ID" := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(): Boolean
    begin
        NavPortal.Get('CUSTP');
        NavPortal.TestField("Wardrobe Series Nos.");
        if NoSeries.LookupRelatedNoSeries(NavPortal."Wardrobe Series Nos.", xRec."No. Series", "No. Series") then begin
            "Wardrobe ID" := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    var
        NavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";

}

