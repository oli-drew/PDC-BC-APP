/// <summary>
/// Table PDCContract (ID 50026).
/// </summary>
table 50026 "PDC Contract"
{

    DrillDownPageID = "PDC Contracts";
    LookupPageID = "PDC Contracts";

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Customer No."; Code[20])
        {
            NotBlank = true;
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
        field(4; "Contract Code"; Code[20])
        {
            Caption = 'Contract Code';
            NotBlank = true;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(6; "Default Contract"; Boolean)
        {
            Caption = 'Default Contract';
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; "Customer Id"; Guid)
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
    }

    keys
    {
        key(Key1; "Customer No.", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        NavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";
    begin
        NavPortal.Get('CUSTP');
        NavPortal.testfield("Contract Series Nos.");
        if ("No." = '') then begin
            "No. Series" := NavPortal."Contract Series Nos.";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
    end;
}

