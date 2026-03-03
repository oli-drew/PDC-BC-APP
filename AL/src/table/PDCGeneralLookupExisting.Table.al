/// <summary>
/// Table PDC General Lookup_existing (ID 50013).
/// </summary>
table 50013 "PDC General Lookup_existing"
{
    Caption = 'General Lookup';
    DrillDownPageID = "PDC General Lookup_Existing";
    LookupPageID = "PDC General Lookup_Existing";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Source,Status';
            OptionMembers = Source,Status;
        }
        field(2; "Code"; Code[20])
        {
        }
        field(3; Description; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

