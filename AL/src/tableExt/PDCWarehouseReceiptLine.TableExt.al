/// <summary>
/// TableExtension PDCWarehouseReceiptLine (ID 50049) extends Record Warehouse Receipt Line.
/// </summary>
tableextension 50049 PDCWarehouseReceiptLine extends "Warehouse Receipt Line"
{
    fields
    {
        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50001; "PDC Wearer ID"; Code[30])
        {
            Caption = 'Wearer ID';
        }
        field(50002; "PDC Wearer Name"; Text[50])
        {
            Caption = 'Wearer Name';
        }
        field(50003; "PDC Customer Reference"; Text[50])
        {
            Caption = 'Customer Reference';
        }
        field(50004; "PDC Web Order No."; Code[10])
        {
            Caption = 'Web Order No.';
        }
        field(50005; "PDC Ordered By ID"; Code[10])
        {
            Caption = 'Ordered By ID';
        }
        field(50006; "PDC Ordered By Name"; Text[100])
        {
            Caption = 'Ordered By Name';
        }
    }
}

