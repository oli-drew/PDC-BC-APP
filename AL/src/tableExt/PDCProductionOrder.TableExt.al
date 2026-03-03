/// <summary>
/// TableExtension PDCProductionOrder (ID 50036) extends Record Production Order.
/// </summary>
TableExtension 50036 PDCProductionOrder extends "Production Order"
{
    fields
    {
        field(50000; "PDC Purchase Document No."; Code[20])
        {
            CalcFormula = lookup("Purchase Line"."Document No." where("Prod. Order No." = field("No.")));
            Caption = 'Purchase Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "PDC Released D/T"; DateTime)
        {
            Caption = 'Released D/T';
        }
        field(50003; "PDC No. Labels Printed"; Integer)
        {
            Caption = 'No. Labels Printed';
            Editable = false;
        }
        field(50004; "PDC Printed D/T"; DateTime)
        {
            Caption = 'Printed D/T';
        }
        field(50005; "PDC Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Routing Line"."Work Center No." where(Status = field(Status), "Prod. Order No." = field("No.")));
            Editable = false;
        }
        field(50006; "PDC Production Bin"; Text[30])
        {
            Caption = 'Production Bin';
            trigger OnValidate()
            begin
                if xRec."PDC Production Bin" <> Rec."PDC Production Bin" then
                    "PDC Production Bin Changed" := CurrentDateTime();
            end;
        }
        field(50007; "PDC Issue"; Text[100])
        {
            Caption = 'Issue';
        }
        field(50008; "PDC Urgent"; Boolean)
        {
            Caption = 'Urgent';
        }
        field(50009; "PDC Production Status"; Text[100])
        {
            Caption = 'Production Status';
            trigger OnValidate()
            begin
                if xRec."PDC Production Status" <> Rec."PDC Production Status" then
                    "PDC Production Status Changed" := CurrentDateTime();
            end;
        }
        field(50010; "PDC Production Status Changed"; DateTime)
        {
            Caption = 'Production Status Changed';
        }
        field(50011; "PDC Production Bin Changed"; DateTime)
        {
            Caption = 'Production Bin Changed';
        }
        field(50012; "PDC Priority"; Integer)
        {
            Caption = 'Priority';
            InitValue = 0;
        }
    }

    /// <summary>
    /// CalcRunTime.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcRunTime(): Decimal;
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RunTime: Decimal;
    begin
        ProdOrderRoutingLine.setrange(Status, Status);
        ProdOrderRoutingLine.setrange("Prod. Order No.", "No.");
        if ProdOrderRoutingLine.FindSet() then
            repeat
                RunTime += ProdOrderRoutingLine."Run Time" * Quantity;
            until ProdOrderRoutingLine.Next() = 0;
        exit(RunTime);
    end;
}


