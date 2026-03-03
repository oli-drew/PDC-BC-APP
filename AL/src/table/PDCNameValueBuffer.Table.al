/// <summary>
/// Table PDC Name Value Buffer (ID 50056).
/// </summary>
table 50056 "PDC Name Value Buffer"
{
    //Old No. 9062730 

    // //DOC NA2015.1  JH 04/10/2013 - "Selected", "Value Visible", "Selected Visible" added
    // //DOC NA2016.10 JH 26/08/2015 - Cloned to bespoke range, upgraded to 2016
    // //DOC NA2016.12 JH 24/11/2015 - "Name", "Value" keys added
    // //DOC NA2016.14 JH 11/04/2016 - "Page Caption" added
    // //DOC NA2016.15 JH 06/05/2016 - CfMD amendments

    Caption = 'Name Value Buffer';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(4; Selected; Boolean)
        {
            Caption = 'Selected';
        }
        field(5; "Value Visible"; Boolean)
        {
            Caption = 'Value Visible';
            FieldClass = FlowFilter;
        }
        field(6; "Selected Visible"; Boolean)
        {
            Caption = 'Selected Visible';
            FieldClass = FlowFilter;
        }
        field(7; "Integer Value"; Integer)
        {
            Caption = 'Integer Value';
        }
        field(8; "Page Caption"; Text[250])
        {
            Caption = 'Page Caption';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; ID)
        {
        }
        key(Key2; Name)
        {
        }
        key(Key3; Value)
        {
        }
    }

    fieldgroups
    {
    }
}

