/// <summary>
/// TableExtension PDCSalesLine (ID 50008) extends Record Sales Line.
/// </summary>
tableextension 50008 PDCSalesLine extends "Sales Line"
{
    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item1: Record Item;
            begin
                case Type OF
                    Type::Item:
                        begin
                            Item1.get("No.");
                            "PDC Product Code" := Item1."PDC Product Code";
                        end;
                end;

                if Customer.GET("Sell-to Customer No.") then
                    if "PDC Branch No." = '' then
                        "PDC Branch No." := Customer."PDC Default Branch No.";
            end;
        }
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
        field(50005; "PDC Ordered By ID"; Code[20])
        {
            Caption = 'Ordered By ID';
        }
        field(50006; "PDC Ordered By Name"; Text[100])
        {
            Caption = 'Ordered By Name';
        }
        field(50007; PDCInventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                  "Location Code" = field("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Sell-to Customer No."));
        }
        field(50009; "PDC Ordered By Phone"; Text[50])
        {
            Caption = 'Ordered By Phone';
        }
        field(50010; "PDC Comment Lines"; Boolean)
        {
            CalcFormula = exist("Sales Comment Line" where("Document Type" = field("Document Type"),
                                                            "No." = field("Document No."),
                                                            "Document Line No." = field("Line No.")));
            Caption = 'Comment Lines';
            FieldClass = FlowField;
        }
        field(50011; "PDC Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";
        }
        field(50012; "PDC Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";
        }
        field(50013; "PDC SLA Date"; Date)
        {
            Caption = 'SLA Date';
        }
        field(50014; "PDC Draft Order No."; Code[20])
        {
            Caption = 'Draft Order No.';
        }
        field(50015; "PDC Draft Order Staff Line No."; Integer)
        {
            Caption = 'Draft Order Staff Line No.';
        }
        field(50016; "PDC Draft Order Item Line No."; Integer)
        {
            Caption = 'Draft Order Item Line No.';
        }
        field(50017; "PDC Order Reason Code"; Code[10])
        {
            Caption = 'Order Reason Code';
            TableRelation = "Reason Code".Code;

            trigger OnValidate()
            var
                ReasonCode: Record "Reason Code";
            begin
                Clear("PDC Order Reason");
                if ReasonCode.Get("PDC Order Reason Code") then
                    "PDC Order Reason" := ReasonCode.Description;
            end;
        }
        field(50018; "PDC Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "PDC Contract"."No." where("Customer No." = field("Sell-to Customer No."));
        }
        field(50019; "PDC Order Reason"; Text[100])
        {
            Caption = 'Order Reason';
        }
        field(50020; "PDC Created By ID"; Code[20])
        {
            Caption = 'Created By ID';
        }
        field(50021; "PDC Created By Name"; Text[100])
        {
            Caption = 'Created By Name';
        }
        field(50022; "PDC Contract Code"; Code[20])
        {
            Caption = 'Contract Code';
            FieldClass = FlowField;
            CalcFormula = lookup("PDC Contract"."Contract Code" where("Customer No." = field("Sell-to Customer No."), "No." = field("PDC Contract No.")));
        }
        field(50027; "PDC Carbon Emissions CO2e"; Decimal)
        {
            Caption = 'Carbon Emissions CO2e';
            DecimalPlaces = 0 : 5;
        }
        field(50028; "PDC Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Ship-to Post Code" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50029; "PDC Over Entitlement Reason"; Text[100])
        {
            Caption = 'Over Entitlement Reason';
        }
    }
    keys
    {
        key(Key1; "PDC Wearer ID")
        {
        }
    }

    var
        Customer: Record Customer;

    /// <summary>
    /// procedure ReservedFromItemLedgerBase return quantity reserved from Item Ledger Entry.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure ReservedFromItemLedger(): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
        FromReservationEntry: Record "Reservation Entry";
        ReservedQty: Decimal;
    begin
        if not (type = Type::Item) then
            exit(0);
        if "No." = '' then
            exit(0);

        ReservationEntry.setcurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntry.SETRANGE("Item No.", "No.");
        ReservationEntry.SETRANGE("Location Code", "Location Code");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source Subtype", "Document Type");
        ReservationEntry.SETRANGE("Source ID", "Document No.");
        ReservationEntry.SETRANGE("Source Prod. Order Line", 0);
        ReservationEntry.SETRANGE("Source Ref. No.", "Line No.");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        if ReservationEntry.FindSet() then
            repeat
                if FromReservationEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then
                    if FromReservationEntry."Source Type" = Database::"Item Ledger Entry" then
                        ReservedQty += ReservationEntry."Quantity";
            until ReservationEntry.Next() = 0;
        exit(-ReservedQty);
    end;
}

