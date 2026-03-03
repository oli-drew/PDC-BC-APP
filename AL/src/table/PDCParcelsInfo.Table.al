/// <summary>
/// Table PDC Parcels Info (ID 50028).
/// </summary>
table 50028 "PDC Parcels Info"
{
    Caption = 'Parcels Info';
    DrillDownPageID = "PDC Parcels Info";
    LookupPageID = "PDC Parcels Info";

    fields
    {
        field(1; ConsignmentNumber; Code[20])
        {
            Editable = false;
        }
        field(2; ParcelNumber; Code[20])
        {
            Editable = false;
        }
        field(3; ParcelCode; Code[20])
        {
        }
        field(4; StatusCode; Code[10])
        {
            trigger OnValidate()
            begin
                SetStatus();
            end;
        }
        field(5; StatusDateTime; DateTime)
        {
        }
        field(6; StatusDescription; Text[250])
        {
        }
        field(7; "Stop Tracking"; Boolean)
        {
        }
        field(8; ErrorText; Text[50])
        {
        }
        field(9; SalesShipmentNo; Code[20])
        {
        }
        field(10; Deleted; Boolean)
        {
            Caption = 'Deleted';
            Editable = false;
        }
        field(11; Status; Option)
        {
            OptionCaption = 'New,In transit,Delivered,Exception,Returned,Cancelled';
            OptionMembers = New,"In transit",Delivered,Exception,Returned,Cancelled;
        }
        field(12; "Delivered Date"; Date)
        {
            Caption = 'Delivered Date';
        }
        field(13; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = lookup("Sales Shipment Header"."Sell-to Customer No." where("No." = field(SalesShipmentNo)));
            Caption = 'Sell-to Customer No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup("Sales Shipment Header"."Sell-to Customer Name" where("No." = field(SalesShipmentNo)));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Shipment Date"; Date)
        {
            CalcFormula = lookup("Sales Shipment Header"."Shipment Date" where("No." = field(SalesShipmentNo)));
            Caption = 'Shipment Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Ship-to Post Code"; Code[20])
        {
            CalcFormula = lookup("Sales Shipment Header"."Ship-to Post Code" where("No." = field(SalesShipmentNo)));
            Caption = 'Ship-to Post Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Last Track DT"; DateTime)
        {
            Caption = 'Last Track DT';
        }
        field(18; "Return Status"; Option)
        {
            OptionMembers = " ","Returned - Credited","Returned - Redespatched";
        }
        field(19; "Shipping Agent Code"; Code[10])
        {
            CalcFormula = lookup("Sales Shipment Header"."Shipping Agent Code" where("No." = field(SalesShipmentNo)));
            Caption = 'Shipping Agent Code';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; ConsignmentNumber, ParcelNumber)
        {
        }
        key(Key2; Status, "Delivered Date", "Stop Tracking", Deleted)
        {
        }
    }

    fieldgroups
    {
    }

    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        PDCCourierShipmentHeader: Record PDCCourierShipmentHeader;
        ShippingAgent: Record "Shipping Agent";
        PDCCourierDPD: Codeunit PDCCourierDPD;
        PDCCourierDX: Codeunit PDCCourierDX;

    /// <summary>
    /// procedure TracckingRequest run tracking request for consignment.
    /// </summary>
    /// <param name="ConsigNumber">Consignment Noo. of type Code[10].</param>
    procedure TrackingRequest(ConsigNumber: Code[10])
    begin
        PDCCourierShipmentHeader.setrange(consignmentNumber, ConsigNumber);
        PDCCourierShipmentHeader.FindFirst();
        SalesShipmentHeader.get(PDCCourierShipmentHeader.SalesShipmentHeaderNo);
        if ShippingAgent.get(SalesShipmentHeader."Shipping Agent Code") then
            case ShippingAgent."PDC Connection Type" of
                ShippingAgent."PDC Connection Type"::DPD:
                    PDCCourierDPD.TrackingRequest(ConsigNumber);
                ShippingAgent."PDC Connection Type"::DX:
                    PDCCourierDX.TrackingRequest(Rec);
            end;
    end;

    local procedure SetStatus()
    begin
        SalesShipmentHeader.get(Rec.SalesShipmentNo);
        ShippingAgent.get(SalesShipmentHeader."Shipping Agent Code");
        case ShippingAgent."PDC Connection Type" of
            ShippingAgent."PDC Connection Type"::DPD:
                PDCCourierDPD.SetStatus(Rec);
            ShippingAgent."PDC Connection Type"::DX:
                PDCCourierDX.SetStatus(Rec);
        end;
    end;
}

