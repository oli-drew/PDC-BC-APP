/// <summary>
/// Table PDC Blob Staff Import Log (ID 50060).
/// Logs each row processed during staff import.
/// </summary>
table 50060 "PDC Blob Staff Import Log"
{
    Caption = 'PDC Blob Staff Import Log';
    DataClassification = CustomerContent;
    DrillDownPageId = "PDC Blob Staff Import Log";
    LookupPageId = "PDC Blob Staff Import Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Import DateTime"; DateTime)
        {
            Caption = 'Import DateTime';
        }
        field(4; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(5; "Row No."; Integer)
        {
            Caption = 'Row No.';
        }
        field(10; "Wearer ID"; Code[20])
        {
            Caption = 'Wearer ID';
        }
        field(11; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";
        }
        field(12; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(13; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(14; "Branch ID"; Code[20])
        {
            Caption = 'Branch ID';
        }
        field(15; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
        }
        field(16; "Contract ID"; Code[20])
        {
            Caption = 'Contract ID';
        }
        field(17; "Body Type"; Code[10])
        {
            Caption = 'Body Type';
        }
        field(20; Status; Enum "PDC Blob Staff Import Status")
        {
            Caption = 'Status';
        }
        field(21; Message; Text[250])
        {
            Caption = 'Message';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(CustomerImport; "Customer No.", "Import DateTime")
        {
        }
        key(FileImport; "Customer No.", "File Name")
        {
        }
    }
}
