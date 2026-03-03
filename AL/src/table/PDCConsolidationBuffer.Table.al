/// <summary>
/// Table PDC Consolidation Buffer (ID 50014).
/// </summary>
table 50014 "PDC Consolidation Buffer"
{
    // 13.08.2019 JEMEL J.Jemeljanovs #3003: new fields: Contract No...Created By Name, add "Contract No." to key

    Caption = 'Consolidation Buffer';
    DataClassification = CustomerContent;

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
        field(27; "Contract Item"; Boolean)
        {
            Caption = 'Contract Item';
        }
        field(28; "Contract Colour"; Boolean)
        {
            Caption = 'Contract Colour';
        }
        field(29; "Contract Size"; Boolean)
        {
            Caption = 'Contract Size';
        }
        field(30; "Contract Branding"; Boolean)
        {
            Caption = 'Contract Branding';
        }
        field(31; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
        }
        field(32; "Branch Level 0"; Text[50])
        {
            Caption = 'Branch Level 0';
        }
        field(33; "Branch Level 1"; Text[50])
        {
            Caption = 'Branch Level 1';
        }
        field(34; "Branch Level 2"; Text[50])
        {
            Caption = 'Branch Level 2';
        }
        field(35; "Branch Level 3"; Text[50])
        {
            Caption = 'Branch Level 3';
        }
        field(36; "CF Attr 12"; Decimal)
        {
            Caption = 'Polyester Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(37; "CF Attr 13"; Decimal)
        {
            Caption = 'Polyester Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(38; "CF Attr 14"; Decimal)
        {
            Caption = 'Polyester Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(39; "CF Attr 15"; Decimal)
        {
            Caption = 'Polyester Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(40; "CF Attr 16"; Decimal)
        {
            Caption = 'Cotton Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(41; "CF Attr 17"; Decimal)
        {
            Caption = 'Cotton Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(42; "CF Attr 18"; Decimal)
        {
            Caption = 'Cotton Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(43; "CF Attr 19"; Decimal)
        {
            Caption = 'Cotton Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(44; "CF Attr 20"; Decimal)
        {
            Caption = 'Wool Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(45; "CF Attr 21"; Decimal)
        {
            Caption = 'Wool Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(46; "CF Attr 22"; Decimal)
        {
            Caption = 'Wool Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(47; "CF Attr 23"; Decimal)
        {
            Caption = 'Wool Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(48; "CF Attr 24"; Decimal)
        {
            Caption = 'Nylon Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(49; "CF Attr 25"; Decimal)
        {
            Caption = 'Nylon Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(50; "CF Attr 26"; Decimal)
        {
            Caption = 'Nylon Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(51; "CF Attr 27"; Decimal)
        {
            Caption = 'Nylon Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(52; "CF Attr 28"; Decimal)
        {
            Caption = 'Viscose Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(53; "CF Attr 29"; Decimal)
        {
            Caption = 'Viscose Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(54; "CF Attr 30"; Decimal)
        {
            Caption = 'Viscose Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(55; "CF Attr 31"; Decimal)
        {
            Caption = 'Viscose Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(56; "CF Attr 32"; Decimal)
        {
            Caption = 'Lycra-Spandex Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(57; "CF Attr 33"; Decimal)
        {
            Caption = 'Lycra-Spandex Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(58; "CF Attr 34"; Decimal)
        {
            Caption = 'Lycra-Spandex Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(59; "CF Attr 35"; Decimal)
        {
            Caption = 'Lycra-Spandex Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(60; "CF Attr 36"; Decimal)
        {
            Caption = 'Other Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(61; "CF Attr 37"; Decimal)
        {
            Caption = 'Other Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(62; "CF Attr 38"; Decimal)
        {
            Caption = 'Other Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(63; "CF Attr 39"; Decimal)
        {
            Caption = 'Other Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(64; "CF Attr 40"; Decimal)
        {
            Caption = 'Leather Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(65; "CF Attr 41"; Decimal)
        {
            Caption = 'Leather Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(66; "CF Attr 42"; Decimal)
        {
            Caption = 'Plastic Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(67; "CF Attr 43"; Decimal)
        {
            Caption = 'Plastic Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(68; "CF Attr 44"; Decimal)
        {
            Caption = 'Kevlar Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(69; "CF Attr 45"; Decimal)
        {
            Caption = 'ABS Plastic Moulded Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(70; "CF Attr 46"; Decimal)
        {
            Caption = 'Acrylic Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(71; "CF Attr 47"; Decimal)
        {
            Caption = 'Aramid Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(72; "CF Attr 48"; Decimal)
        {
            Caption = 'Metal Cast Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(73; "CF Attr 49"; Decimal)
        {
            Caption = 'Polyamide Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(74; "CF Attr 50"; Decimal)
        {
            Caption = 'Polycarbonate Moulded Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(75; "CF Attr 51"; Decimal)
        {
            Caption = 'Polyethylene Moulded Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(76; "CF Attr 52"; Decimal)
        {
            Caption = 'Polypropylene Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(77; "CF Attr 53"; Decimal)
        {
            Caption = 'Polyurethane Moulded Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(78; "CF Attr 54"; Decimal)
        {
            Caption = 'PVC Moulded Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(79; "CF Attr 55"; Decimal)
        {
            Caption = 'Rubber Moulded Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(80; "CF Attr 56"; Decimal)
        {
            Caption = 'Carbon Fibre Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(81; "CF Attr 57"; Decimal)
        {
            Caption = 'Cashmere Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(82; "CF Attr 58"; Decimal)
        {
            Caption = 'Cashmere Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(83; "CF Attr 59"; Decimal)
        {
            Caption = 'Acrylic Knitted Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(84; "CF Attr 60"; Decimal)
        {
            Caption = 'Acrylic Knitted Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(85; "CF Attr 61"; Decimal)
        {
            Caption = 'Bamboo Woven Non-Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(86; "CF Attr 62"; Decimal)
        {
            Caption = 'Bamboo Woven Recycled';
            DecimalPlaces = 0 : 5;
        }
        field(87; "CF Attr 63"; Decimal)
        {
            Caption = 'Reserved Carbonfact 63';
            DecimalPlaces = 0 : 5;
        }
        field(88; "CF Attr 64"; Decimal)
        {
            Caption = 'Reserved Carbonfact 64';
            DecimalPlaces = 0 : 5;
        }
        field(89; "CF Attr 65"; Decimal)
        {
            Caption = 'Reserved Carbonfact 65';
            DecimalPlaces = 0 : 5;
        }
        field(90; "CF Attr 66"; Decimal)
        {
            Caption = 'Reserved Carbonfact 66';
            DecimalPlaces = 0 : 5;
        }
        field(91; "CF Attr 67"; Decimal)
        {
            Caption = 'Reserved Carbonfact 67';
            DecimalPlaces = 0 : 5;
        }
        field(92; "CF Attr 68"; Decimal)
        {
            Caption = 'Reserved Carbonfact 68';
            DecimalPlaces = 0 : 5;
        }
        field(93; "CF Attr 69"; Decimal)
        {
            Caption = 'Reserved Carbonfact 69';
            DecimalPlaces = 0 : 5;
        }
        field(94; "CF Attr 70"; Decimal)
        {
            Caption = 'Reserved Carbonfact 70';
            DecimalPlaces = 0 : 5;
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

