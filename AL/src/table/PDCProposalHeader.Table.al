/// <summary>
/// Table PDC Proposal Header (ID 50046).
/// </summary>
table 50046 "PDC Proposal Header"
{
    // 07.02.2020 JEMEL J.Jemeljanovs #3208 * Created

    Caption = 'Proposal Header';
    DrillDownPageID = "PDC Proposal List";
    LookupPageID = "PDC Proposal List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesReceivablesSetup.Get();
                    NoSeries.TestManual(SalesReceivablesSetup."PDC Proposal Nos.");
                end;
            end;
        }
        field(2; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact where(Type = const(Company));

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if ("Contact No." <> xRec."Contact No.") and ("Customer No." = '') then begin
                    Cont.Get("Contact No.");
                    Name := Cont.Name;
                    "Name 2" := Cont."Name 2";
                    Address := Cont.Address;
                    "Address 2" := Cont."Address 2";
                    City := Cont.City;
                    "Post Code" := Cont."Post Code";
                    County := Cont.County;
                    "Country/Region Code" := Cont."Country/Region Code";
                end;

                if ("Customer No." <> '') and ("Contact No." <> '') then begin
                    Cont.Get("Contact No.");
                    ContBusinessRelation.Reset();
                    ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Customer No.");
                    if ContBusinessRelation.FindFirst() then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            Error(errContCustLbl, Cont."No.", Cont.Name, "Customer No.");
                end;
            end;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record Customer;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Customer No." <> xRec."Customer No." then begin
                    Cust.Get("Customer No.");
                    Name := Cust.Name;
                    "Name 2" := Cust."Name 2";
                    Address := Cust.Address;
                    "Address 2" := Cust."Address 2";
                    City := Cust.City;
                    "Post Code" := Cust."Post Code";
                    County := Cust.County;
                    "Country/Region Code" := Cust."Country/Region Code";
                    "Contact Name" := Cust.Contact;

                    ContBusinessRelation.Reset();
                    ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Customer No.");
                    if ContBusinessRelation.FindFirst() then
                        "Contact No." := ContBusinessRelation."Contact No.";
                end;
            end;
        }
        field(4; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(5; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(9; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
        field(10; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(11; County; Text[30])
        {
            Caption = 'County';
        }
        field(12; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(15; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(16; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(17; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(18; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;

            trigger OnValidate()
            begin
                if not Active then
                    "Inactive Date" := WorkDate()
                else
                    "Inactive Date" := 0D;
            end;
        }
        field(19; "Inactive Date"; Date)
        {
            Caption = 'Inactive Date';
            Editable = false;
        }
        field(100; "Total Sales"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Costing Line"."Total Sales" where("Proposal No." = field("No."), "Prod.Line Active" = CONST(true)));
            Caption = 'Total Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Total Cost"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Costing Line"."Total Cost" where("Proposal No." = field("No."), "Prod.Line Active" = CONST(true)));
            Caption = 'Total Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Gross Profit Total"; Decimal)
        {
            CalcFormula = sum("PDC Proposal Costing Line"."Gross Profit Total" where("Proposal No." = field("No."), "Prod.Line Active" = CONST(true)));
            Caption = 'Gross Profit Total';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.TestField("PDC Proposal Nos.");
            "No." := NoSeries.GetNextNo(SalesReceivablesSetup."PDC Proposal Nos.", WorkDate());
        end;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
        errContCustLbl: label 'Contact %1 %2 is related to a different company than customer %3.', Comment = 'Contact %1 %2 is related to a different company than customer %3.';

    /// <summary>
    /// UpdateLines.
    /// </summary>
    procedure UpdateLines()
    var
        PDCProposalProductLine: Record "PDC Proposal Product Line";
    begin
        PDCProposalProductLine.SetRange("Proposal No.", "No.");
        if PDCProposalProductLine.FindSet(true) then
            repeat
                PDCProposalProductLine.UpdateLines();
            until PDCProposalProductLine.Next() = 0;
    end;
}

