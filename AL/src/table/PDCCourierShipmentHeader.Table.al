/// <summary>
/// Table PDCCourierShipmentHeader (ID 50010).
/// </summary>
table 50010 PDCCourierShipmentHeader
{
    Caption = 'Courier Shipment Header';
    Permissions = TableData "Sales Shipment Header" = rm;

    fields
    {
        field(1; ConsignmentNo; Code[10])
        {
        }
        field(2; SalesShipmentHeaderNo; Code[20])
        {
            Caption = 'Sales Shipment Header No.';
            TableRelation = "Sales Shipment Header"."No.";
        }
        field(3; SellToCustomerNo; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(4; OrderDate; Date)
        {
            Caption = 'Order Date';
        }
        field(5; ShipmentDate; Date)
        {
            Caption = 'Shipment Date';
        }
        field(6; ShipToCode; Code[10])
        {
            Caption = 'Ship-to Code';
        }
        field(7; ShipmentMethodCode; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(8; ShipToName; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(9; ShipToName2; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(10; ShipToAddress; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(11; ShipToAddress2; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(12; ShipToCity; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(13; ShipToContact; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(14; ShipToPostCode; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(15; ShipToCounty; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(16; ShipToCountryRegionCode; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(17; EmployeeName; Text[50])
        {
            Caption = 'Employee Name';
        }
        field(18; CustomerReference; Code[30])
        {
            Caption = 'Customer Reference';
        }
        field(20; WebOrderNo; Code[20])
        {
            Caption = 'WebOrder No.';
        }
        field(21; EmployeeID; Code[20])
        {
            Caption = 'Employee ID';
        }
        field(23; PLSNO; Text[30])
        {
            Caption = 'PLSNO';
        }
        field(25; Notes; Text[250])
        {
        }
        field(26; Phone; Code[50])
        {
        }
        field(27; Description; Text[30])
        {
        }
        field(28; Bill; Text[10])
        {
        }
        field(29; PackageType; Text[10])
        {
        }
        field(30; Weight; Integer)
        {
        }
        field(31; NumberOfPackages; Integer)
        {
        }
        field(35; Memo; Text[250])
        {
        }
        field(38; OrdererName; Text[30])
        {
        }
        field(39; OriginalOrderNo; Code[20])
        {
            Caption = 'Order No.';
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if "Shipping Agent Code" <> xRec."Shipping Agent Code" then
                    Validate("Shipping Agent Service Code", '');
            end;
        }
        field(5794; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(50000; "Sent to Courier"; Boolean)
        {
            Caption = 'Sent to Courier';
        }
        field(50001; shipmentId; Code[20])
        {
            Editable = false;
        }
        field(50002; consignmentNumber; Code[20])
        {
            Editable = false;
        }
        field(50003; errorCode; Code[100])
        {
            Editable = false;
        }
        field(50004; errorMessage; Text[250])
        {
            Editable = false;
        }
        field(50005; errorObject; Text[250])
        {
            Editable = false;
        }
        field(50006; Deleted; Boolean)
        {
            Caption = 'Deleted';

            trigger OnValidate()
            var
                ParcelsInfo: Record "PDC Parcels Info";
            begin
                TestField(Deleted, true);//one way not deleted -> deleted

                ParcelsInfo.SetRange(ConsignmentNumber, ConsignmentNo);
                ParcelsInfo.ModifyAll(Deleted, Deleted);
            end;
        }
        field(50032; "Ship-to E-Mail"; Text[80])
        {
            Caption = 'Ship-to E-Mail';
        }
        field(50034; "Ship-to Mobile Phone No."; Text[30])
        {
            Caption = 'Ship-to Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
    }

    keys
    {
        key(Key1; ConsignmentNo)
        {
        }
        key(Key2; consignmentNumber)
        {
        }
    }

    fieldgroups
    {
    }

    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        ShippingAgent: Record "Shipping Agent";
        DPD: Codeunit PDCCourierDPD;
        DX: Codeunit PDCCourierDX;

    /// <summary>
    /// procedure Send_InsertShipment send shipment info to shipping agent Api.
    /// </summary>
    /// <param name="SalesShipNo">Code[20].</param>
    procedure Send_InsertShipment(SalesShipNo: Code[20])
    begin
        SalesShipmentHeader.get(SalesShipNo);
        ShippingAgent.get(SalesShipmentHeader."Shipping Agent Code");
        case ShippingAgent."PDC Connection Type" of
            ShippingAgent."PDC Connection Type"::DPD:
                DPD.Send_InsertShipment(SalesShipNo);
            ShippingAgent."PDC Connection Type"::DX:
                DX.Send_InsertShipment(SalesShipNo);
        end;
    end;

    /// <summary>
    /// procedure LabelRequest requests labels from DPD API.
    /// </summary>
    /// <param name="SalesShipNo">Code[20].</param>
    procedure LabelRequest(SalesShipNo: Code[20])
    begin
        SalesShipmentHeader.get(SalesShipNo);
        ShippingAgent.get(SalesShipmentHeader."Shipping Agent Code");
        case ShippingAgent."PDC Connection Type" of
            ShippingAgent."PDC Connection Type"::DPD:
                DPD.LabelRequest(SalesShipNo, false);
            ShippingAgent."PDC Connection Type"::DX:
                DX.LabelRequest(SalesShipNo, false);
        end;

    end;

    /// <summary>
    /// procedure LabelRequest requests labels from DPD API.
    /// </summary>
    /// <param name="SalesShipNo">Code[20].</param>
    procedure LabelPreview(SalesShipNo: Code[20])
    begin
        SalesShipmentHeader.get(SalesShipNo);
        ShippingAgent.get(SalesShipmentHeader."Shipping Agent Code");
        case ShippingAgent."PDC Connection Type" of
            ShippingAgent."PDC Connection Type"::DPD:
                DPD.LabelRequest(SalesShipNo, true);
            ShippingAgent."PDC Connection Type"::DX:
                DX.LabelRequest(SalesShipNo, true);
        end;
    end;

}

