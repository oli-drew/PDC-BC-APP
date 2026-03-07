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
        field(50060; "PDC Pick Status"; Enum "PDC Pick Status")
        {
            Caption = 'Pick Status';
        }
        field(50061; "PDC Trolley Code"; Code[20])
        {
            Caption = 'Trolley Code';
            TableRelation = "PDC Trolley" where(Blocked = const(false));

            trigger OnValidate()
            var
                PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
            begin
                if "PDC Trolley Code" <> xRec."PDC Trolley Code" then begin
                    // Remove old slots if changing trolley
                    if xRec."PDC Trolley Code" <> '' then
                        PDCPickStatusMgt.DeleteSlotsForPick("No.", xRec."PDC Trolley Code");

                    if "PDC Trolley Code" <> '' then begin
                        // Assign new trolley
                        if "PDC Pick Status" = "PDC Pick Status"::Pending then begin
                            "PDC Pick Status" := "PDC Pick Status"::"In Progress";
                            "PDC Picked By" := CopyStr(UserId, 1, MaxStrLen("PDC Picked By"));
                            "PDC Pick Started At" := CurrentDateTime;
                        end;
                        PDCPickStatusMgt.CreateSlotsForPick("No.", "PDC Trolley Code");
                    end else begin
                        // Trolley cleared — reset status
                        "PDC Pick Status" := "PDC Pick Status"::Pending;
                        "PDC Picked By" := '';
                        "PDC Pick Started At" := 0DT;
                        "PDC Pick Completed At" := 0DT;
                    end;
                end;
            end;
        }
        field(50062; "PDC Picked By"; Code[50])
        {
            Caption = 'Picked By';
            Editable = false;
        }
        field(50063; "PDC Pick Started At"; DateTime)
        {
            Caption = 'Pick Started At';
            Editable = false;
        }
        field(50064; "PDC Pick Completed At"; DateTime)
        {
            Caption = 'Pick Completed At';
            Editable = false;
        }
        field(50065; "PDC Total Quantity"; Decimal)
        {
            Caption = 'Total Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line".Quantity where("Activity Type" = field(Type),
                                                                       "No." = field("No.")));
            Editable = false;
        }
        field(50066; "PDC Unique Wearers"; Integer)
        {
            Caption = 'Unique Wearers';
            Editable = false;
        }
        field(50067; "PDC Total Lines"; Integer)
        {
            Caption = 'Total Lines';
            FieldClass = FlowField;
            CalcFormula = count("Warehouse Activity Line" where("Activity Type" = field(Type),
                                                                 "No." = field("No.")));
            Editable = false;
        }
        field(50068; "PDC Trolley Default Slots"; Integer)
        {
            Caption = 'Trolley Default Slots';
            FieldClass = FlowField;
            CalcFormula = lookup("PDC Trolley"."Default Slots" where(Code = field("PDC Trolley Code")));
            Editable = false;
        }
        field(50069; "PDC Trolley Max Slots"; Integer)
        {
            Caption = 'Trolley Max Slots';
            FieldClass = FlowField;
            CalcFormula = lookup("PDC Trolley"."Max Slots" where(Code = field("PDC Trolley Code")));
            Editable = false;
        }
    }
}

