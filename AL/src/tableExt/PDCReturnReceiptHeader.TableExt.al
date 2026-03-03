/// <summary>
/// TableExtension PDCReturnReceiptHeader (ID 50043) extends Record Return Receipt Header.
/// </summary>
tableextension 50043 PDCReturnReceiptHeader extends "Return Receipt Header"
{
    fields
    {
        field(50000; "PDC Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
        }
        field(50001; "PDC Customer Reference"; Text[30])
        {
            Caption = 'Customer Reference';
        }
        field(50003; "PDC WebOrder No."; Code[20])
        {
            Caption = 'WebOrder No.';
        }
        field(50004; "PDC Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
        }
        field(50005; "PDC External Name"; Text[50])
        {
            Caption = 'External Name';
        }
        field(50006; PDCPLSNO; Text[30])
        {
            Caption = 'PLSNO';
        }
        field(50007; "PDC Consignment No."; Code[20])
        {
            Caption = 'Consignment No.';
        }
        field(50008; "PDC UPS Service Code"; Code[10])
        {
            Caption = 'UPS Service Code';
        }
        field(50009; "PDC CityLink Code"; Code[10])
        {
            Caption = 'CityLink Code';
        }
        field(50010; PDCSaturday; Boolean)
        {
            Caption = 'Saturday';
        }
        field(50011; "PDC Pick Instruction Print No."; Integer)
        {
            Caption = 'Pick Instruction Print No.';
        }
        field(50012; "PDC Notes"; Text[250])
        {
            Caption = 'Notes';
        }
        field(50013; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
        field(50014; "PDC Order Source"; Code[20])
        {
            Caption = 'Order Source';
            TableRelation = "PDC General Lookup_existing".Code where(Type = const(Source));
        }
        field(50015; "PDC Order Status"; Code[20])
        {
            Caption = 'Order Status';
            TableRelation = "PDC General Lookup_existing".Code where(Type = const(Status));
        }
        field(50016; "PDC Checked By"; Code[50])
        {
            Caption = 'Checked By';
            Editable = false;
            TableRelation = User;
            ValidateTableRelation = false;
        }
        field(50017; "PDC Last Picking No."; Code[10])
        {
            Caption = 'Last Picking No.';
            Editable = false;
            TableRelation = "Warehouse Activity Header"."No." where("Source No." = field("No."));
            ValidateTableRelation = false;
        }
        field(50018; "PDC CCM Notes"; Text[250])
        {
            Caption = 'CCM Notes';
        }
        field(50019; "PDC Warehouse Document No."; Code[20])
        {
            CalcFormula = lookup("Warehouse Activity Header"."No." where("Source Document" = filter("Sales Order"),
                                                                          "Source No." = field("No.")));
            Caption = 'Warehouse Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "PDC E-Mail 1"; Text[50])
        {
            Caption = 'E-Mail 1';
        }
        field(50025; "PDC E-Mail 2"; Text[50])
        {
            Caption = 'E-Mail 2';
        }
        field(50026; "PDC E-Mail 3"; Text[50])
        {
            Caption = 'E-Mail 3';
        }
        field(50027; "PDC E-Mail 4"; Text[50])
        {
            Caption = 'E-Mail 4';
        }
        field(50028; "PDC Roll-Out No."; Code[20])
        {
            Caption = 'Roll-Out Number';
            TableRelation = "PDC Roll-out".Code;
        }
        field(50036; "PDC Return From Invoice No."; Code[20])
        {
            Caption = 'Return From Invoice No.';
        }
        field(50053; "PDC Number Of Packages"; Integer)
        {
            Caption = 'Number Of Packages';
        }
        field(50059; "PDC Package Type"; Enum PDCPackageType)
        {
            Caption = 'Package Type';
        }
        field(50060; "PDC Collection Reference"; text[100])
        {
            Caption = 'Collection Reference';
        }
        field(50061; "PDC Drop-Off"; Boolean)
        {
            Caption = 'Drop-Off';
        }
        field(50062; "PDC Drop-Off Email"; Text[50])
        {
            Caption = 'Drop-Off Email';
        }
        field(50063; "PDC Drop-Off Location"; Text[50])
        {
            Caption = 'Drop-Off Location';
        }
    }
}

