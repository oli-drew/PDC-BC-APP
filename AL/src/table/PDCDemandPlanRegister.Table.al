/// <summary>
/// Table PDC Demand Plan Register (ID 50039).
/// </summary>
Table 50039 "PDC Demand Plan Register"
{
    // 01.09.2017 JEMEL J.Jemeljanovs #2296
    //   * Created

    Caption = 'Demand Plan Register';
    LookupPageID = "PDC Demand Plan Register";

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
        field(3; Year; Integer)
        {
            Caption = 'Year';
            MinValue = 2017;
        }
        field(4; Month; Integer)
        {
            Caption = 'Month';
            MaxValue = 12;
            MinValue = 1;
        }
        field(5; Demand; Decimal)
        {
            Caption = 'Demand';
            DecimalPlaces = 0 : 5;
        }
        field(6; Notes; Text[100])
        {
            Caption = 'Notes';
        }
    }

    keys
    {
        key(Key1; "Product Code", "Colour Code", Year, Month)
        {
        }
    }

    fieldgroups
    {
    }

    /// <summary>
    /// CalcLastYearStats.
    /// </summary>
    /// <param name="currProduct">Code[10].</param>
    /// <param name="currColour">Code[10].</param>
    /// <param name="currYear">Integer.</param>
    /// <param name="currMonth">Integer.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcLastYearStats(currProduct: Code[10]; currColour: Code[10]; currYear: Integer; currMonth: Integer): Decimal
    var
        PDCDemandProduct: Record "PDC Demand Product";
    begin
        if (currYear = 0) or (currMonth = 0) then
            exit(0);

        if not PDCDemandProduct.Get(currProduct, currColour) then
            exit(0);

        PDCDemandProduct.SetFilter("Date Filter", '%1..%2',
                                Dmy2date(1, currMonth, currYear - 1),
                                CalcDate('<CM>', Dmy2date(1, currMonth, currYear - 1))
                                );
        PDCDemandProduct.CalcFields("Sales (Qty.)", "Consumption (Qty.)");
        exit(PDCDemandProduct."Sales (Qty.)" + PDCDemandProduct."Consumption (Qty.)");
    end;

    /// <summary>
    /// LookupLastYearStats.
    /// </summary>
    /// <param name="currProduct">Code[10].</param>
    /// <param name="currColour">Code[10].</param>
    /// <param name="currYear">Integer.</param>
    /// <param name="currMonth">Integer.</param>
    procedure LookupLastYearStats(currProduct: Code[10]; currColour: Code[10]; currYear: Integer; currMonth: Integer)
    var
        PDCDemandProduct: Record "PDC Demand Product";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if (currYear = 0) or (currMonth = 0) then
            exit;

        if not PDCDemandProduct.Get(currProduct, currColour) then
            exit;

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentkey("Entry Type", "PDC Product Code", "PDC Colour Code", "Posting Date");
        ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."entry type"::Sale, ItemLedgerEntry."entry type"::Consumption);
        ItemLedgerEntry.SetRange("PDC Product Code", PDCDemandProduct."Product Code");
        ItemLedgerEntry.SetRange("PDC Colour Code", PDCDemandProduct."Colour Code");
        ItemLedgerEntry.SetFilter("Posting Date", '%1..%2',
                         Dmy2date(1, currMonth, currYear - 1),
                         CalcDate('<CM>', Dmy2date(1, currMonth, currYear - 1)));
        Page.RunModal(0, ItemLedgerEntry);
    end;
}

