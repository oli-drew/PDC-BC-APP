/// <summary>
/// TableExtension PDCSalesCue (ID 50050) extends Record Sales Cue.
/// </summary>
tableextension 50050 PDCSalesCue extends "Sales Cue"
{
    fields
    {
        field(50003; "PDC Customers - Blocked"; Integer)
        {
            Caption = 'Customers - Blocked';
            FieldClass = FlowField;
            CalcFormula = count(Customer where(Blocked = filter(<> ' ')));
        }
        field(50004; "PDC Customers-Over Cred. Limit"; Integer)
        {
            Caption = 'Customers - Over Credit Limit';
        }
        field(50005; "PDC Sales Orders-Ready to Rel."; Integer)
        {
            Caption = 'Sales Orders Open - Ready to Release';
        }
        field(50006; "PDC Sales Orders-Ready to Pick"; Integer)
        {
            Caption = 'Sales Orders Released - Ready to Pick';
        }
        field(50007; "PDC Parcels Deliv. This Month"; Integer)
        {
            CalcFormula = count("PDC Parcels Info" where(Status = const(Delivered),
                                                      "Stop Tracking" = const(false),
                                                      Deleted = const(false),
                                                      "Delivered Date" = field("PDC Date Filter3")));
            Caption = 'Parcels Delivered This Month';
            FieldClass = FlowField;
        }
        field(50008; "PDC Parcels Deliv. Last Month"; Integer)
        {
            CalcFormula = count("PDC Parcels Info" where(Status = const(Delivered),
                                                      "Stop Tracking" = const(false),
                                                      Deleted = const(false),
                                                      "Delivered Date" = field("PDC Date Filter4")));
            Caption = 'Parcels Delivered Last Month';
            FieldClass = FlowField;
        }
        field(50009; "PDC Parcels In Transit"; Integer)
        {
            CalcFormula = count("PDC Parcels Info" where(Status = const("In transit"),
                                                      "Stop Tracking" = const(false),
                                                      Deleted = const(false)));
            Caption = 'Parcels In Transit';
            FieldClass = FlowField;
        }
        field(50010; "PDC Parcels Exception"; Integer)
        {
            CalcFormula = count("PDC Parcels Info" where(Status = const(Exception),
                                                      "Stop Tracking" = const(false),
                                                      Deleted = const(false)));
            Caption = 'Parcels Exception';
            FieldClass = FlowField;
        }
        field(50011; "PDC Date Filter3"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50012; "PDC Date Filter4"; Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50013; "PDC SLA Today"; Integer)
        {
            Caption = 'SLA Today';
            Editable = false;
            FieldClass = Normal;
        }
        field(50014; "PDC SLA Missed Released"; Integer)
        {
            Caption = 'SLA Missed Released';
            Editable = false;
        }
        field(50015; "PDC SLA Missed Open"; Integer)
        {
            Caption = 'SLA Missed Open';
            Editable = false;
        }
        field(50016; "PDC SLA Tomorrow"; Integer)
        {
            Caption = 'SLA Tomorrow';
            Editable = false;
        }
        field(50017; "PDC Sales Return Orders-Releas"; Integer)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter("Return Order"),
                                                      Status = filter(Released),
                                                      "Responsibility Center" = field("Responsibility Center Filter"),
                                                      "PDC Return Submitted" = const(true)));
            Caption = 'Sales Return Orders - Released';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "PDC Customers - On Stop"; Integer)
        {
            Editable = false;
            Caption = 'Customers - On Stop';
            FieldClass = FlowField;
            CalcFormula = count(Customer where("PDC Block Release" = filter(true)));
        }
        field(50019; "PDC Sales Orders - Not Ready"; Integer)
        {
            Caption = 'Sales Orders - Not Ready';
        }
        field(50020; "PDC Firm Pl.Prod.Ord.-NotReady"; Integer)
        {
            Caption = 'Firm Planned Production Order - Not Ready';
        }
    }

    /// <summary>
    /// procedure ShowCustomers open customer list with available credit less then 0.
    /// </summary>
    procedure ShowCustomers()
    var
        Customer: Record Customer;
    begin
        Customer.Reset();
        Customer.ClearMarks();
        if Customer.FindSet() then
            repeat
                if Customer.CalcAvailableCredit() < 0 then
                    Customer.Mark(true);
            until Customer.Next() = 0;
        Customer.MarkedOnly(true);
        Page.Run(Page::"Customer List", Customer);
    end;

    /// <summary>
    /// procedure CalcSOReadyToReleasePick calculate sales orders by Type.
    /// </summary>
    /// <param name="Type">Option Release, Pick, NOtReady.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CalcSOReadyToReleasePick(Type: Option Release,Pick,NotReady): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SelectSOReadyToReleasePick(SalesHeader, Type);
        exit(SalesHeader.Count());
    end;

    /// <summary>
    /// procedure ShowSOReadyToReleasePick shows list of sales orders by Type.
    /// </summary>
    /// <param name="Type">Option Release, Pick, NOtReady.</param>
    procedure ShowSOReadyToReleasePick(Type: Option Release,Pick,NotReady)
    var
        SalesHeader: Record "Sales Header";
    begin
        SelectSOReadyToReleasePick(SalesHeader, Type);
        if SalesHeader.Count > 0 then
            Page.RunModal(Page::"Sales Order List", SalesHeader);
    end;

    local procedure SelectSOReadyToReleasePick(var SalesHeader: Record "Sales Header"; Type: Option Release,Pick,NotReady)
    var
        SalesLine: Record "Sales Line";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        IsCorrectDoc: Boolean;
        FinishSearch: Boolean;
    begin
        SalesHeader.Reset();
        SalesHeader.ClearMarks();

        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        if Type = Type::Pick then
            SalesHeader.SetRange(Status, SalesHeader.Status::Released)
        else
            SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", '<>%1', '');
                SalesLine.SetFilter(Quantity, '<>%1', 0);
                SalesLine.setfilter("Outstanding Quantity", '<>%1', 0);
                if SalesLine.FindSet() then begin
                    FinishSearch := false;
                    if Type <> Type::NotReady then
                        IsCorrectDoc := true
                    else
                        IsCorrectDoc := false;
                    repeat
                        case Type of
                            Type::Release:
                                begin
                                    SalesLine.CalcFields("Reserved Quantity");
                                    if SalesLine."Outstanding Quantity" < SalesLine.ReservedFromItemLedger() then begin
                                        IsCorrectDoc := false;
                                        FinishSearch := true;
                                    end;
                                end;
                            Type::Pick:
                                if SalesLine."Outstanding Quantity" < SalesLine.ReservedFromItemLedger() then begin
                                    IsCorrectDoc := false;
                                    FinishSearch := true;
                                end
                                else begin
                                    WarehouseActivityLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.");
                                    WarehouseActivityLine.setrange("Source Type", DATABASE::"Sales Line");
                                    WarehouseActivityLine.setrange("Source Subtype", SalesLine."Document Type");
                                    WarehouseActivityLine.setrange("Source No.", SalesLine."Document No.");
                                    WarehouseActivityLine.SetRange("Source Line No.", SalesLine."Line No.");
                                    if not WarehouseActivityLine.IsEmpty then begin
                                        IsCorrectDoc := false;
                                        FinishSearch := true;
                                    end;
                                end;
                            Type::NotReady:
                                begin
                                    SalesLine.CalcFields("Reserved Quantity");
                                    if SalesLine."Outstanding Quantity" > SalesLine."Reserved Quantity" then begin
                                        IsCorrectDoc := true;
                                        FinishSearch := true;
                                    end;
                                end;
                        end;
                    until (SalesLine.Next() = 0) or (FinishSearch);
                    if IsCorrectDoc then
                        SalesHeader.Mark(true);
                end;
            until SalesHeader.Next() = 0;

        SalesHeader.SetRange("Document Type");
        SalesHeader.SetRange(Status);
        SalesHeader.MarkedOnly(true);
    end;

    /// <summary>
    /// procedure CalcSLA filter and count sales orders by SLA.
    /// </summary>
    /// <param name="SLA_Num">Integer.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CalcSLA(SLA_Num: Integer): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterSLAOrders(SalesHeader, SLA_Num);
        exit(SalesHeader.Count());
    end;

    /// <summary>
    /// procedure ShowSLAOrders filter and show sales orders by SLA.
    /// </summary>
    /// <param name="SLA_Num">Integer.</param>
    procedure ShowSLAOrders(SLA_Num: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterSLAOrders(SalesHeader, SLA_Num);
        if SalesHeader.Count() > 0 then
            Page.RunModal(Page::"Sales Order List", SalesHeader);
    end;

    local procedure FilterSLAOrders(var SalesHeader: Record "Sales Header"; SLA_Num: Integer)
    begin
        SalesHeader.Reset();

        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        case SLA_Num of
            1:
                begin //SLA Today
                    SalesHeader.SetRange("Requested Delivery Date", WorkDate());
                    SalesHeader.SetRange(Status, SalesHeader.Status::Open);
                end;
            2:
                begin  //SLA Missed Released
                    SalesHeader.SetFilter("Requested Delivery Date", '<%1', WorkDate());
                    SalesHeader.SetRange(Status, SalesHeader.Status::Released);
                end;
            3:
                begin //SLA Missed Open
                    SalesHeader.SetFilter("Requested Delivery Date", '<%1', WorkDate());
                    SalesHeader.SetRange(Status, SalesHeader.Status::Open);
                end;
            4:
                begin //SLA Tomorrow
                    SalesHeader.SetRange("Requested Delivery Date", WorkDate() + 1);
                    SalesHeader.SetRange(Status, SalesHeader.Status::Open);
                end;
        end;//case
    end;

    /// <summary>
    /// procedure CalcFirmPlannedProdOrder filter and calculate Firm Planned Productin orders.
    /// </summary>
    /// <param name="ShowReady">Boolean.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CalcFirmPlannedProdOrder(ShowReady: Boolean): Integer
    var
        ProductionOrder: Record "Production Order";
    begin
        FilterFirmPlannedProdOrder(ProductionOrder, ShowReady);
        exit(ProductionOrder.Count());
    end;

    /// <summary>
    /// procedure ShowFirmPlannedProdOrder filter and show Firm Planned Productin orders.
    /// </summary>
    /// <param name="ShowReady">Boolean.</param>
    procedure ShowFirmPlannedProdOrder(ShowReady: Boolean)
    var
        ProductionOrder: Record "Production Order";
    begin
        FilterFirmPlannedProdOrder(ProductionOrder, ShowReady);
        if ProductionOrder.Count() > 0 then
            Page.Run(Page::"Firm Planned Prod. Orders", ProductionOrder);
    end;

    local procedure FilterFirmPlannedProdOrder(var ProductionOrder: Record "Production Order"; ShowReady: Boolean)
    var
        ProdOrderComponent: Record "Prod. Order Component";
        IsReady: Boolean;
    begin
        ProductionOrder.Reset();
        ProductionOrder.ClearMarks();

        ProductionOrder.setrange(Status, ProductionOrder.Status::"Firm Planned");
        if ProductionOrder.FindSet() then
            repeat
                clear(IsReady);
                ProdOrderComponent.setrange(Status, ProductionOrder.Status);
                ProdOrderComponent.setrange("Prod. Order No.", ProductionOrder."No.");
                ProdOrderComponent.setfilter("Remaining Qty. (Base)", '<>%1', 0);
                if ProdOrderComponent.FindSet(true) then begin
                    IsReady := true;
                    repeat
                        if ProdOrderComponent."Remaining Quantity" > ProdOrderComponent.ReservedFromItemLedger() then
                            IsReady := false;
                    until ProdOrderComponent.Next() = 0;
                    if (ShowReady and IsReady) or (not ShowReady and not IsReady) then
                        ProductionOrder.Mark(true);
                end;
            until ProductionOrder.Next() = 0;
        ProductionOrder.SetRange(Status);
        ProductionOrder.MarkedOnly(true);
    end;
}

