/// <summary>
/// TableExtension PDCPurchaseHeader (ID 50009) extends Record Purchase Header.
/// </summary>
tableextension 50009 PDCPurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(50000; "PDC Total Amount"; Decimal)
        {
            CalcFormula = sum("Purchase Line".Amount where("Document No." = field("No.")));
            Caption = 'Total Amount';
            FieldClass = FlowField;
        }
        field(50002; "PDC Roll-Out No."; Code[20])
        {
            Caption = 'Roll-Out Number';
            TableRelation = "PDC Roll-out".Code;
        }
        field(50003; "PDC Prod. Order No."; Code[20])
        {
            CalcFormula = lookup("Purchase Line"."Prod. Order No." where("Document Type" = field("Document Type"),
                                                                          "Document No." = field("No.")));
            Caption = 'Prod. Order No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "PDC Estimated Receipt Date"; Date)
        {
            Caption = 'Estimated Receipt Date';
        }
    }

    /// <summary>
    /// ExportPO.
    /// </summary>
    procedure ExportPO()
    var
        Vendor1: Record Vendor;
        PurchaseLine1: Record "Purchase Line";
    begin
        //22.11.2019 JEMEL J.Jemeljanovs #3152
        if Vendor1.Get("Buy-from Vendor No.") and (Vendor1."PDC Export PO Xmlport" <> 0) then begin
            PurchaseLine1.SetRange("Document Type", "Document Type");
            PurchaseLine1.SetRange("Document No.", "No.");
            PurchaseLine1.SetRange(Type, PurchaseLine1.Type::Item);
            Xmlport.Run(Vendor1."PDC Export PO Xmlport", false, false, PurchaseLine1);
        end;
    end;
}

