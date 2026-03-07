page 50122 "PDC Purch Res. Entry FactBox"
{
    ApplicationArea = All;
    Caption = 'Reservation Entries';
    PageType = ListPart;
    SourceTable = "Reservation Entry";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reserved quantity.';
                }
                field(ReservedFor; ReservedForText)
                {
                    ApplicationArea = All;
                    Caption = 'Reserved For';
                    ToolTip = 'Specifies the demand source this entry is reserved for.';

                    trigger OnDrillDown()
                    var
                        OppositeReservEntry: Record "Reservation Entry";
                    begin
                        if OppositeReservEntry.Get(Rec."Entry No.", not Rec.Positive) then
                            ShowSourceDocument(OppositeReservEntry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        OppositeReservEntry: Record "Reservation Entry";
    begin
        Clear(ReservedForText);
        if OppositeReservEntry.Get(Rec."Entry No.", not Rec.Positive) then
            ReservedForText := ReservEngineMgt.CreateForText(OppositeReservEntry);
    end;

    var
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservedForText: Text;

    procedure ShowSourceDocument(ReservEntry: Record "Reservation Entry")
    var
        SalesHeader: Record "Sales Header";
        ProdOrder: Record "Production Order";
        TransferHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
    begin
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                if SalesHeader.Get(ReservEntry."Source Subtype", ReservEntry."Source ID") then
                    Page.Run(Page::"Sales Order", SalesHeader);
            Database::"Prod. Order Component":
                if ProdOrder.Get(ReservEntry."Source Subtype", ReservEntry."Source ID") then
                    Page.Run(Page::"Released Production Order", ProdOrder);
            Database::"Transfer Line":
                if TransferHeader.Get(ReservEntry."Source ID") then
                    Page.Run(Page::"Transfer Order", TransferHeader);
            Database::"Assembly Line":
                if AssemblyHeader.Get(ReservEntry."Source Subtype", ReservEntry."Source ID") then
                    Page.Run(Page::"Assembly Order", AssemblyHeader);
        end;
    end;
}
