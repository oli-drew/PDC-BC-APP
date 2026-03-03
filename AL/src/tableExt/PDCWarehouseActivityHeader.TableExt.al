/// <summary>
/// TableExtension PDCWarehouseActivityHeader (ID 50039) extends Record Warehouse Activity Header.
/// </summary>
tableextension 50039 PDCWarehouseActivityHeader extends "Warehouse Activity Header"
{
    fields
    {
        field(50000; "PDC Sales Doc. Created At"; DateTime)
        {
            Caption = 'Sales Doc. Created At';
        }
        field(50001; "PDC Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(50002; "PDC Shipping Agent Serv. Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("PDC Shipping Agent Code"));
        }
        field(50003; "PDC Number Of Packages"; Integer)
        {
            Caption = 'Number Of Packages';
        }
        field(50004; "PDC Date of First Printing"; Date)
        {
            Caption = 'Date of First Printing';
        }
        field(50005; "PDC Time of First Printing"; Time)
        {
            Caption = 'Time of First Printing';
        }
        field(50006; "PDC Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
        }
        field(50007; "PDC Ship-to Country/Reg. Code"; code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(50008; "PDC Urgent"; Boolean)
        {
            Caption = 'Urgent';
        }
        field(50059; "PDC Package Type"; Enum PDCPackageType)
        {
            Caption = 'Package Type';
        }
    }
}

