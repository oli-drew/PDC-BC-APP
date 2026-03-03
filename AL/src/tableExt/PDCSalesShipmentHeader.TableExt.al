/// <summary>
/// TableExtension PDCSalesShipmentHeader (ID 50017) extends Record Sales Shipment Header.
/// </summary>
tableextension 50017 PDCSalesShipmentHeader extends "Sales Shipment Header"
{

    fields
    {
        field(50000; "PDC Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
        }
        field(50001; "PDC Customer Reference"; Code[30])
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
        field(50006; "PDC PLSNO"; Text[30])
        {
            Caption = 'PLSNO';
        }
        field(50007; "PDC Consignment No."; Code[20])
        {
            Caption = 'Consignment No.';
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
        field(50022; "PDC Memo"; Text[250])
        {
            Caption = 'Memo';
        }
        field(50028; "PDC Roll-Out No."; Code[20])
        {
            Caption = 'Roll-Out Number';
            TableRelation = "PDC Roll-out".Code;
        }
        field(50032; "PDC Ship-to E-Mail"; Text[80])
        {
            Caption = 'Ship-to E-Mail';
        }
        field(50033; "PDC Home Address"; Boolean)
        {
            Caption = 'Home Address';
        }
        field(50034; "PDC Ship-to Mobile Phone No."; Text[30])
        {
            Caption = 'Ship-to Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(50050; "PDC Sent to Courier"; Boolean)
        {
            Caption = 'Sent to Courier';
            Editable = false;
        }
        field(50051; "PDC Sent to Courier Date Time"; DateTime)
        {
            Caption = 'Sent to Courier Date Time';
            Editable = false;
        }
        field(50052; "PDC Released"; Boolean)
        {
            Caption = 'Released';
        }
        field(50053; "PDC Number Of Packages"; Integer)
        {
            Caption = 'Number Of Packages';
        }
        field(50054; "PDC Phone"; Code[30])
        {
            Caption = 'Phone';
        }
        field(50055; "PDC Description"; Text[30])
        {
            Caption = 'Description';
        }
        field(50056; "PDC Bill"; Text[10])
        {
            Caption = 'Bill';
        }
        field(50057; "PDC Shipment Error"; Boolean)
        {
            CalcFormula = exist(PDCCourierShipmentHeader where(SalesShipmentHeaderNo = field("No."),
                                                             Deleted = const(false),
                                                             errorCode = filter(<> '')));
            Caption = 'Shipment Error';
            FieldClass = FlowField;
        }
        field(50058; "PDC Delivery Instruction"; Text[200])
        {
            Caption = 'Delivery Instruction';
        }
        field(50059; "PDC Package Type"; Enum PDCPackageType)
        {
            Caption = 'Package Type';
        }
    }

    /// <summary>
    /// SendToUPSTable.
    /// </summary>
    procedure SendToUPSTable()
    var
        PDCFunctions: Codeunit "PDC Functions";
    begin
        PDCFunctions.SalesShipmentSendToUPSTable(Rec);
    end;

}

