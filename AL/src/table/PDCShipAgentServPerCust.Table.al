/// <summary>
/// Table PDC Ship.Agent Serv. Per Cust. (ID 50042).
/// </summary>
table 50042 "PDC Ship.Agent Serv. Per Cust."
{
    // 15.01.2020 JEMEL J.Jemeljanovs #3193 * Created

    Caption = 'Shipping Agent Services Per Customer';
    DrillDownPageID = "PDC Ship.Agent Serv. Per Cust.";
    LookupPageID = "PDC Ship.Agent Serv. Per Cust.";

    fields
    {
        field(1; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            NotBlank = true;
            TableRelation = "Shipping Agent";
        }
        field(2; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Carriage Charge"; Decimal)
        {
            Caption = 'Carriage Charge';
        }
    }

    keys
    {
        key(Key1; "Shipping Agent Code", "Shipping Agent Service Code", "Customer No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Shipping Agent Service Code", "Customer No.", Description)
        {
        }
    }

}

