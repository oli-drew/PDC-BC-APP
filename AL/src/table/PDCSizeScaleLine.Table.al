/// <summary>
/// Table PDC Size Scale Line (ID 50032).
/// </summary>
table 50032 "PDC Size Scale Line"
{
    Caption = 'Size Scale Header';

    fields
    {
        field(1; "Size Scale Code"; Code[20])
        {
            Caption = 'Size Scale Code';
            NotBlank = true;
            TableRelation = "PDC Size Scale Header".Code;
        }
        field(2; Size; Code[10])
        {
            Caption = 'Size';
        }
        field(3; "Size Sequence"; Integer)
        {
            Caption = 'Size Sequence';
            MaxValue = 999;
            MinValue = 100;
        }
        field(4; "Size Description"; Text[50])
        {
            Caption = 'Size Description';
        }
        field(5; Fit; Code[10])
        {
        }
        field(6; "Fit Sequence"; Integer)
        {
            Caption = 'Fit Sequence';
            MaxValue = 99;
            MinValue = 10;
        }
        field(7; "Fit Description"; Text[50])
        {
            Caption = 'Fit Description';
        }
        field(8; "Size Label"; Text[20])
        {
        }
        field(9; "Fit Label"; Text[20])
        {
        }
        field(10; "Measure Type Size"; Code[20])
        {
            Caption = 'Measure Type Size';
            TableRelation = "PDC Measurement Type".Code where(Type = const(Size));
        }
        field(11; "Garment Size"; Integer)
        {
            Caption = 'Garment Size';
        }
        field(12; "Size Ease"; Integer)
        {
            Caption = 'Size Ease';
        }
        field(13; "Garment Fit"; Integer)
        {
            Caption = 'Garment Fit';
        }
        field(14; "Garment Ease"; Integer)
        {
            Caption = 'Garment Ease';
        }
        field(15; "Measure Type Fit"; Code[20])
        {
            TableRelation = "PDC Measurement Type".Code where(Type = const(Fit));
        }
        field(100; ECM; Integer)
        {
            Caption = 'ECM';
        }
        field(101; EHM; Integer)
        {
            Caption = 'EHM';
        }
        field(102; "Profile"; Decimal)
        {
            Caption = 'Profile';
            DecimalPlaces = 0 : 6;
        }
    }

    keys
    {
        key(Key1; "Size Scale Code", Size, Fit)
        {
        }
        key(Key2; "Size Sequence", "Fit Sequence")
        {
        }
        key(Key3; "Garment Size", "Garment Fit")
        {
        }
    }

    fieldgroups
    {
    }

}

