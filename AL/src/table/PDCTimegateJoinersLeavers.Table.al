/// <summary>
/// Table PDCTimegateEmpl.JoinersLeavers (ID 50002).
/// </summary>
table 50002 "PDC Timegate Joiners Leavers"
{
    Caption = 'Timegate Employee Joiners Leavers';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(2; "Tg Employee Id"; Integer)
        {
            Caption = 'Tg Employee Id';
            DataClassification = CustomerContent;
        }
        field(3; "Tg PIN"; text[4])
        {
            Caption = 'Tg PIN';
            DataClassification = CustomerContent;
        }
        field(4; "First Name"; Text[50])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(5; Surname; Text[50])
        {
            Caption = 'Surname';
            DataClassification = CustomerContent;
        }
        field(6; Gender; Text[20])
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(7; "Branch Code"; Text[10])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(8; "Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            DataClassification = CustomerContent;
        }
        field(9; "Join Date"; Date)
        {
            Caption = 'Join Date';
            DataClassification = CustomerContent;
        }
        field(10; "Left Date"; Date)
        {
            Caption = 'Left Date';
            DataClassification = CustomerContent;
        }
        field(11; "Last Update"; DateTime)
        {
            Caption = 'Last Update';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Tg Employee Id")
        {
            Clustered = true;
        }
    }

}
