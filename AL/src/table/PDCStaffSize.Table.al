/// <summary>
/// Table PDC Staff Size (ID 50029).
/// </summary>
table 50029 "PDC Staff Size"
{
    // 13.08.2018 JEMEL J.Jemeljanovs #2727 - Created

    Caption = 'Staff Size';
    DrillDownPageID = "PDC Staff Sizes";
    LookupPageID = "PDC Staff Sizes";

    fields
    {
        field(1; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";
        }
        field(2; "Size Scale Code"; Code[20])
        {
            Caption = 'Size Scale Code';
            TableRelation = "PDC Size Scale Header".Code;
        }
        field(3; Fit; Code[10])
        {
            Caption = 'Fit';
        }
        field(4; Size; Code[10])
        {
            Caption = 'Size';
        }
        field(5; "Created By Item No."; Code[20])
        {
            Caption = 'Created By Item No.';
            TableRelation = Item;
        }
        field(6; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(7; "Created At"; Date)
        {
            Caption = 'Created At';
        }
    }

    keys
    {
        key(Key1; "Staff ID", "Size Scale Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := CopyStr(UserId, 1, 20);
        "Created At" := Today;
    end;

    trigger OnModify()
    begin
        "Created By" := CopyStr(UserId, 1, 20);
        "Created At" := Today;
    end;
}

