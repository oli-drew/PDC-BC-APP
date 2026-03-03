/// <summary>
/// Table PDC Demand Product (ID 50038).
/// </summary>
table 50038 "PDC Demand Product"
{
    Caption = 'Demand Product';
    DrillDownPageID = "PDC Demand Products";
    LookupPageID = "PDC Demand Products";

    fields
    {
        field(1; "Product Code"; Code[10])
        {
            Caption = 'Product Code';
        }
        field(2; "Colour Code"; Code[6])
        {
            Caption = 'Colour Code';
            TableRelation = "PDC Product colour";
        }
        field(3; "Sales (Qty.)"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry".Quantity where("Entry Type" = const(Sale),
                                                                   "PDC Product Code" = field("Product Code"),
                                                                   "PDC Colour Code" = field("Colour Code"),
                                                                   "Posting Date" = field("Date Filter")));
            Caption = 'Sales (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Consumption (Qty.)"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry".Quantity where("Entry Type" = const(Consumption),
                                                                   "PDC Product Code" = field("Product Code"),
                                                                   "PDC Colour Code" = field("Colour Code"),
                                                                   "Posting Date" = field("Date Filter")));
            Caption = 'Consumption (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(6; "Import Vendor"; Code[20])
        {
            Caption = 'Import Vendor';
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Product Code", "Colour Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PDCDemandPlanRegister.SetRange("Product Code", "Product Code");
        PDCDemandPlanRegister.DeleteAll(true);
    end;

    var
        PDCDemandPlanRegister: Record "PDC Demand Plan Register";

    /// <summary>
    /// OpenDemandPlanRegister.
    /// </summary>
    procedure OpenDemandPlanRegister()
    var
        currYear: Integer;
        currMonth: Integer;
        i: Integer;
    begin
        TestField("Product Code");
        TestField("Colour Code");

        TestField("Import Vendor");

        currYear := Date2dmy(WorkDate(), 3);
        currMonth := Date2dmy(WorkDate(), 2);

        PDCDemandPlanRegister.ClearMarks();

        for i := 0 to 18 do begin
            if i > 0 then begin
                currMonth += 1;
                if currMonth > 12 then begin
                    currMonth := 1;
                    currYear += 1;
                end;
            end;
            if not PDCDemandPlanRegister.Get("Product Code", "Colour Code", currYear, currMonth) then begin
                PDCDemandPlanRegister.Init();
                PDCDemandPlanRegister."Product Code" := "Product Code";
                PDCDemandPlanRegister."Colour Code" := "Colour Code";
                PDCDemandPlanRegister.Year := currYear;
                PDCDemandPlanRegister.Month := currMonth;
                PDCDemandPlanRegister.Insert(true);
            end;
            PDCDemandPlanRegister.Mark(true);
        end; //for

        PDCDemandPlanRegister.MarkedOnly(true);
        if PDCDemandPlanRegister.FindFirst() then
            Page.Run(0, PDCDemandPlanRegister);
    end;
}

