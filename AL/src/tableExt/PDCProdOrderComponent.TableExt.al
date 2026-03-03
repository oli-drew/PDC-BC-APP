/// <summary>
/// TableExtension PDCProdOrderComponent (ID 50055) extends Record Prod. Order Component.
/// </summary>
tableextension 50055 PDCProdOrderComponent extends "Prod. Order Component"
{

    fields
    {
        field(50000; "PDC Production Bin"; Text[30])
        {
            Caption = 'Production Bin';
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order"."PDC Production Bin" where(Status = field(Status), "No." = field("Prod. Order No.")));
        }
    }
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
        if "Item No." = '' then
            exit(0);

        ReservationEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
        ReservationEntry.SetRange("Item No.", "Item No.");
        ReservationEntry.SetRange("Location Code", "Location Code");
        ReservationEntry.SetRange("Source Type", DATABASE::"Prod. Order Component");
        ReservationEntry.SetRange("Source Subtype", Status);
        ReservationEntry.SetRange("Source ID", "Prod. Order No.");
        ReservationEntry.SetRange("Source Batch Name", '');
        ReservationEntry.SetRange("Source Prod. Order Line", "Prod. Order Line No.");
        ReservationEntry.SetRange("Source Ref. No.", "Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        if ReservationEntry.FindSet() then
            repeat
                if FromReservationEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then
                    if FromReservationEntry."Source Type" = Database::"Item Ledger Entry" then
                        ReservedQty += ReservationEntry."Quantity";
            until ReservationEntry.Next() = 0;
        exit(-ReservedQty);
    end;
}
