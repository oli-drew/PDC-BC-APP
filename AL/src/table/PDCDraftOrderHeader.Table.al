/// <summary>
/// Table PDC Draft Order Header (ID 50023).
/// </summary>
table 50023 "PDC Draft Order Header"
{
    Caption = 'Draft Order Header';
    DrillDownPageID = "PDC Draft Orders";
    LookupPageID = "PDC Draft Orders";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnValidate()
            var
                PDCNavPortal: Record "PDC Portal";
                NoSeries: Codeunit "No. Series";
            begin
                if "Document No." <> xRec."Document No." then begin
                    PDCNavPortal.Get('CUSTP');
                    NoSeries.TestManual(PDCNavPortal."Draft Orders Series Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Sell-to Customer No." <> xRec."Sell-to Customer No." then begin
                    Customer.Get("Sell-to Customer No.");
                    Validate("Sell-to Customer Name", Customer.Name);
                    Validate("Sell-to Customer Name 2", Customer."Name 2");
                    Validate("Sell-to Address", Customer.Address);
                    Validate("Sell-to Address 2", Customer."Address 2");
                    Validate("Sell-to City", Customer.City);
                    Validate("Sell-to Post Code", Customer."Post Code");
                    Validate("Sell-to County", Customer.County);
                    Validate("Sell-to Country/Region Code", Customer."Country/Region Code");

                    Validate("Ship-to Code", '');

                    if "Sell-to Customer No." = '' then
                        Clear("Customer Id")
                    else
                        if Customer.get("Sell-to Customer No.") then
                            "Customer Id" := Customer.SystemId;
                end;
            end;
        }
        field(3; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(4; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(5; "Sell-to Address"; Text[50])
        {
            Caption = 'Sell-to Address';
        }
        field(6; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(7; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", false);
            end;
        }
        field(8; "Sell-to Contact"; Text[50])
        {
            Caption = 'Sell-to Contact';
        }
        field(9; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", false);
            end;
        }
        field(10; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County';
        }
        field(11; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(12; "Address Type"; Option)
        {
            Caption = 'Address Type';
            OptionCaption = 'My Address,Saved Address';
            OptionMembers = "My Address","Saved Address";
        }
        field(20; "Shipping Type"; Option)
        {
            Caption = 'Shipping Type';
            OptionCaption = 'Ship All Available Now,Ship Complete Uniform Set,Ship Complete Order';
            OptionMembers = "Ship All Available Now","Ship Complete Uniform Set","Ship Complete Order";
        }
        field(21; "Your Reference"; Code[20])
        {
            Caption = 'Your Reference';
        }
        field(30; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            var
                Customer: Record Customer;
                ShiptoAddress: Record "Ship-to Address";
            begin
                if "Ship-to Code" <> '' then begin
                    ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code");
                    Validate("Ship-to Name", ShiptoAddress.Name);
                    Validate("Ship-to Name 2", ShiptoAddress."Name 2");
                    Validate("Ship-to Address", ShiptoAddress.Address);
                    Validate("Ship-to Address 2", ShiptoAddress."Address 2");
                    Validate("Ship-to City", ShiptoAddress.City);
                    Validate("Ship-to Post Code", ShiptoAddress."Post Code");
                    Validate("Ship-to County", ShiptoAddress.County);
                    Validate("Ship-to Country/Region Code", ShiptoAddress."Country/Region Code");
                    Validate("Ship-to Contact", ShiptoAddress.Contact);
                    Validate("Is Home Ship-To Address", ShiptoAddress."PDC Is Home Ship-To Address");
                    Validate("Address Type", "address type"::"Saved Address");
                end else
                    if "Sell-to Customer No." <> '' then begin
                        Customer.Get("Sell-to Customer No.");
                        Validate("Ship-to Name", Customer.Name);
                        Validate("Ship-to Name 2", Customer."Name 2");
                        Validate("Ship-to Address", Customer.Address);
                        Validate("Ship-to Address 2", Customer."Address 2");
                        Validate("Ship-to City", Customer.City);
                        Validate("Ship-to Post Code", Customer."Post Code");
                        Validate("Ship-to County", Customer.County);
                        Validate("Ship-to Country/Region Code", Customer."Country/Region Code");
                        Validate("Ship-to Contact", Customer.Contact);
                        Validate("Address Type", "address type"::"My Address");
                    end;

                if "Ship-to Code" = '' then
                    Clear("Ship-to Id")
                else
                    if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then
                        "Ship-to Id" := ShiptoAddress.SystemId;
            end;
        }
        field(31; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(32; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(33; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(34; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(35; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", false);

            end;
        }
        field(36; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(37; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", false);
            end;
        }
        field(38; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(39; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(40; "Approved Outside SLA"; Boolean)
        {
            Caption = 'Approved Outside SLA';
        }
        field(42; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(43; "PO No."; Code[20])
        {
            Caption = 'PO No.';
        }
        field(44; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(46; "Requested Shipment Date"; Date)
        {
        }
        field(47; "Created Date"; DateTime)
        {
        }
        field(48; "Modified Date"; DateTime)
        {
        }
        field(49; "Is Home Ship-To Address"; Boolean)
        {
            Caption = 'Is Home Ship-To Address?';
        }
        field(50; "Created By ID"; Code[20])
        {
            Caption = 'Created By ID';
        }
        field(51; "Modified By ID"; Code[20])
        {
            Caption = 'Modified By ID';
        }
        field(52; "Ship-to E-Mail"; Text[80])
        {
            Caption = 'Ship-to E-Mail';
        }
        field(53; "Ship-to Mobile Phone No."; Text[30])
        {
            Caption = 'Ship-to Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(54; "Awaiting Approval"; Boolean)
        {
            Caption = 'Awaiting Approval';

            trigger OnValidate()
            begin
                if "Awaiting Approval" then
                    "Awaiting Approval DT" := CurrentDateTime;
            end;
        }
        field(57; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
            TableRelation = Customer.SystemId;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if IsNullGuid("Customer Id") then
                    "Sell-to Customer No." := ''
                else
                    if Customer.GetBySystemId("Customer Id") then
                        "Sell-to Customer No." := Customer."No.";
            end;
        }
        field(58; "Ship-to Id"; Guid)
        {
            Caption = 'Ship-to Id';
            TableRelation = "Ship-to Address".SystemId;

            trigger OnValidate()
            var
                ShiptoAddress: Record "Ship-to Address";
            begin
                if IsNullGuid("Ship-to Id") then
                    "Ship-to Code" := ''
                else
                    if ShiptoAddress.GetBySystemId("Ship-to Id") then
                        "Ship-to Code" := ShiptoAddress.Code;
            end;
        }
        field(59; "Awaiting Approval DT"; DateTime)
        {
            Caption = 'Awaiting Approval DT';
        }
        field(200; "Proceed Order"; Boolean)
        {
            Caption = 'Proceed Order';
            FieldClass = FlowField;
            CalcFormula = exist("PDC Draft Order Item Line" where("Document No." = field("Document No."), "Create Order No." = filter(> 0)));
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
        }
        key(Key2; "Sell-to Customer No.")
        {
        }
        key(Key3; "Shipping Type")
        {
        }
        key(Key4; "Approved Outside SLA")
        {
        }
        key(Key5; "Modified Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PDCDraftOrderStaffLine: Record "PDC Draft Order Staff Line";
    begin
        PDCDraftOrderStaffLine.Reset();
        PDCDraftOrderStaffLine.SetRange("Document No.", "Document No.");
        PDCDraftOrderStaffLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        PDCNavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";
    begin
        if "Document No." = '' then begin
            PDCNavPortal.Get('CUSTP');
            PDCNavPortal.TestField("Draft Orders Series Nos.");
            "No. Series" := PDCNavPortal."Draft Orders Series Nos.";
            "Document No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

        "Created Date" := CurrentDatetime;
        "Modified Date" := CurrentDatetime;
    end;

    trigger OnModify()
    begin
        "Modified Date" := CurrentDatetime;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(): Boolean
    var
        PDCNavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";
    begin
        PDCNavPortal.Get('CUSTP');
        PDCNavPortal.TestField("Draft Orders Series Nos.");
        if NoSeries.LookupRelatedNoSeries(PDCNavPortal."Draft Orders Series Nos.", xRec."No. Series", "No. Series") then begin
            "Document No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;
}
