/// <summary>
/// Table PDC Consolidation Buffer (ID 50014).
/// </summary>
table 50014 "PDC Consolidation Buffer"
{
    // 13.08.2019 JEMEL J.Jemeljanovs #3003: new fields: Contract No...Created By Name, add "Contract No." to key

    Caption = 'Consolidation Buffer';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(2; "Branch No."; Code[20])
        {
            Caption = 'Branch No.';
            TableRelation = "PDC Branch"."Branch No.";
        }
        field(3; "Customer Reference"; Text[80])
        {
            Caption = 'Customer Reference';
        }
        field(4; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(5; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
        field(8; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(9; "Delivery Date"; Date)
        {
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,"Credit Memo";
        }
        field(11; "Wearer ID"; Code[30])
        {
            Caption = 'Wearer ID';
            Editable = false;
        }
        field(12; "Wearer Name"; Text[50])
        {
            Caption = 'Wearer Name';
            Editable = false;
        }
        field(13; "Web Order No."; Code[10])
        {
            Editable = false;
        }
        field(14; "Ordered By ID"; Code[20])
        {
            Caption = 'Ordered By ID';
            Editable = false;
        }
        field(15; "Ordered By Name"; Text[100])
        {
            Caption = 'Ordered By Name';
            Editable = false;
        }
        field(16; "Ordered By Phone"; Text[50])
        {
            Caption = 'Ordered By Phone';
        }
        field(17; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(18; "Line Total"; Decimal)
        {
            Caption = 'Line Total';
        }
        field(19; "Line Total Including VAT"; Decimal)
        {
        }
        field(20; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(21; "Order Reason"; Text[50])
        {
            Caption = 'Order Reason';
        }
        field(22; "Created By ID"; Code[20])
        {
            Caption = 'Created By ID';
        }
        field(23; "Created By Name"; Text[100])
        {
            Caption = 'Created By Name';
        }
        field(24; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
        }
        field(25; "Carbon Emissions CO2e"; Decimal)
        {
            Caption = 'Carbon Emissions CO2e';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
        }
    }

    keys
    {
        key(Key1; Type, "Customer No.", "Branch No.", "Customer Reference", "Invoice No.", "Shipment No.", "Item No.", "Wearer ID", "Contract No.", "Wardrobe ID", "Staff ID")
        {
        }
    }

    fieldgroups
    {
    }
}

