/// <summary>
/// Table PDC Roll-out (ID 50016).
/// </summary>
table 50016 "PDC Roll-out"
{
    LookupPageID = "PDC Roll-Out List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    GeneralLedgerSetup.Get();
                    NoSeries.TestManual(GeneralLedgerSetup."PDC Roll-Out Nos.");
                end;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Customer No."; code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Deadline Date"; Date)
        {
            Caption = 'Deadline Date';
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Customer No.", "Deadline Date")
        {

        }
    }

    trigger OnInsert()
    begin
        if Code = '' then begin
            GeneralLedgerSetup.Get();
            GeneralLedgerSetup.TestField("PDC Roll-Out Nos.");
            Code := NoSeries.GetNextNo(GeneralLedgerSetup."PDC Roll-Out Nos.", WorkDate());
        end;
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        NoSeries: Codeunit "No. Series";
}

