/// <summary>
/// TableExtension PDCSalesHeader (ID 50007) extends Record Sales Header.
/// </summary>
tableextension 50007 PDCSalesHeader extends "Sales Header"
{
    fields
    {

        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
                ShipToAddr: Record "Ship-to Address";
            begin
                if "Document Type" = "Document Type"::"Return Order" then
                    if ("Ship-to Code" <> '') then begin
                        ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
                        CopyShipToCustomerAddressFieldsFromShipToAddr1(ShipToAddr);
                    end
                    else begin
                        Cust.get("Sell-to Customer No.");
                        CopyShipToCustomerAddressFieldsFromCustomer1(Cust);
                    end;

            end;
        }

        modify("Shipping Agent Service Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateCarriageLine();
            end;
        }
        field(50000; "PDC Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
        }
        field(50001; "PDC Customer Reference"; Text[30])
        {
            Caption = 'Customer Reference';
        }
        field(50002; "PDC Urgent"; Boolean)
        {
            Caption = 'Urgent';

            trigger OnValidate()
            var
                WarehouseActivityHeader: Record "Warehouse Activity Header";
                WarehouseActivityLine: Record "Warehouse Activity Line";
            begin
                if Rec."PDC Urgent" = xRec."PDC Urgent" then
                    exit;
                WarehouseActivityLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.");
                WarehouseActivityLine.SetRange("Source Type", DATABASE::"Sales Line");
                WarehouseActivityLine.SetRange("Source Subtype", Rec."Document Type");
                WarehouseActivityLine.SetRange("Source No.", Rec."No.");
                if WarehouseActivityLine.IsEmpty() then
                    exit;
                WarehouseActivityLine.FindSet();
                repeat
                    WarehouseActivityHeader.Get(WarehouseActivityLine."Activity Type", WarehouseActivityLine."No.");
                    if WarehouseActivityHeader."PDC Urgent" <> Rec."PDC Urgent" then begin
                        WarehouseActivityHeader."PDC Urgent" := Rec."PDC Urgent";
                        WarehouseActivityHeader.Modify(true);
                    end;
                until WarehouseActivityLine.Next() = 0;
            end;
        }
        field(50003; "PDC WebOrder No."; Code[20])
        {
            Caption = 'WebOrder No.';
        }
        field(50004; "PDC Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
        }
        field(50007; "PDC Consignment No."; Code[20])
        {
            Caption = 'Consignment No.';
        }
        field(50011; "PDC Pick Instruction Print No."; Integer)
        {
            Caption = 'Pick Instruction Print No.';
        }
        field(50012; "PDC Notes"; Text[250])
        {
            Caption = 'Notes';
        }
        field(50013; "PDC Branch No."; Code[20])
        {
            Caption = 'Branch No.';
        }
        field(50014; "PDC Order Source"; Code[20])
        {
            Caption = 'Order Source';
            TableRelation = "PDC General Lookup_existing".Code where(Type = const(Source));
        }
        field(50015; "PDC Order Status"; Code[20])
        {
            Caption = 'Order Status';
            TableRelation = "PDC General Lookup_existing".Code where(Type = const(Status));

            trigger OnValidate()
            begin
                "PDC Checked By" := CopyStr(UserId, 1, 50);
            end;
        }
        field(50016; "PDC Checked By"; Code[50])
        {
            Caption = 'Checked By';
            Editable = false;
            TableRelation = User;
            ValidateTableRelation = false;
        }
        field(50017; "PDC Last Picking No."; Code[20])
        {
            Caption = 'Last Picking No.';
            Editable = false;
            TableRelation = "Warehouse Activity Header"."No." where("Source No." = field("No."));
            ValidateTableRelation = false;
        }
        field(50019; "PDC Warehouse Document No."; Code[20])
        {
            CalcFormula = lookup("Warehouse Activity Header"."No." where("Source Document" = filter("Sales Order"),
                                                                          "Source No." = field("No.")));
            Caption = 'Warehouse Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "PDC Roll-Out No."; Code[20])
        {
            Caption = 'Roll-Out Number';
            TableRelation = "PDC Roll-out".Code;

            trigger OnValidate()
            var
                RollOutRec: Record "PDC Roll-out";
            begin
                if RollOutRec.get("PDC Roll-Out No.") then
                    RollOutRec.TestField(Blocked, false);
            end;
        }
        field(50029; "PDC Out of SLA Approved"; Boolean)
        {
            Caption = 'Approved for Delivery Outside SLA?';
        }
        field(50030; "PDC Out of SLA Approved By"; Code[20])
        {
            Caption = 'Out Of SLA Delivery Approved By';
            TableRelation = "PDC Portal User"."Contact No.";
        }
        field(50031; "PDC Is Home Ship-To Address"; Boolean)
        {
            Caption = 'Is Home Ship-To Address?';
        }
        field(50032; "PDC Ship-to E-Mail"; Text[80])
        {
            Caption = 'Ship-to E-Mail';
        }
        field(50033; "PDC Home Address"; Boolean)
        {
            Caption = 'Home Address';
        }
        field(50034; "PDC Ship-to Mobile Phone No."; Text[30])
        {
            Caption = 'Ship-to Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(50035; "PDC Created At"; DateTime)
        {
            Caption = 'Created At';
        }
        field(50036; "PDC Return From Invoice No."; Code[20])
        {
            Caption = 'Return From Invoice No.';
        }
        field(50037; "PDC Return Submitted"; Boolean)
        {
            Caption = 'Return Submitted';
        }
        field(50053; "PDC Number Of Packages"; Integer)
        {
            Caption = 'Number Of Packages';
        }
        field(50058; "PDC Delivery Instruction"; Text[200])
        {
            Caption = 'Delivery Instruction';
        }
        field(50059; "PDC Package Type"; Enum PDCPackageType)
        {
            Caption = 'Package Type';
        }
        field(50060; "PDC Collection Reference"; text[100])
        {
            Caption = 'Collection Reference';
        }
        field(50061; "PDC Drop-Off"; Boolean)
        {
            Caption = 'Drop-Off';
        }
        field(50062; "PDC Drop-Off Email"; Text[50])
        {
            Caption = 'Drop-Off Email';
        }
        field(50063; "PDC Drop-Off Location"; Text[50])
        {
            Caption = 'Drop-Off Location';
        }
    }

    var
        HideValidationDialog: Boolean;
        PDCHideValidationDialog: Boolean;
        AutoCreatePutAway: Boolean;
        CarriageUpdMsgLbl: label 'Do you want to update carriage line?', Comment = 'Do you want to update carriage line?';


    trigger OnAfterInsert()
    var
        PDCGeneralLookupexisting: Record "PDC General Lookup_existing";
    begin
        "PDC Created At" := CURRENTDATETIME;

        if ("Document Type" = "Document Type"::Order) AND ("PDC Order Source" = '') then begin
            if NOT PDCGeneralLookupexisting.GET(PDCGeneralLookupexisting.Type::Source, 'MANUAL') then begin
                PDCGeneralLookupexisting.Type := PDCGeneralLookupexisting.Type::Source;
                PDCGeneralLookupexisting.Code := 'MANUAL';
                PDCGeneralLookupexisting.INSERT();
            end;
            "PDC Order Source" := PDCGeneralLookupexisting.Code;
        end;
    end;

    /// <summary>
    /// PDCSetHideValidationDialog.
    /// </summary>
    /// <param name="NewHideValidationDialog">Boolean.</param>
    procedure PDCSetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        PDCHideValidationDialog := NewHideValidationDialog;
    end;

    /// <summary>
    /// PDCCreateInvtPutAwayPick.
    /// </summary>
    procedure PDCCreateInvtPutAwayPick()
    var
        WarehouseRequest: Record "Warehouse Request";
        CreateInvtPutawayPickMvmt: Report "Create Invt Put-away/Pick/Mvmt";
    begin
        if "Document Type" = "Document Type"::Order then
            if NOT IsApprovedForPosting() then
                EXIT;
        TESTFIELD(Status, Status::Released);

        WarehouseRequest.RESET();
        WarehouseRequest.SETCURRENTKEY("Source Document", "Source No.");
        case "Document Type" OF
            "Document Type"::Order:
                begin
                    if "Shipping Advice" = "Shipping Advice"::Complete then
                        CheckShippingAdvice();
                    WarehouseRequest.SETRANGE("Source Document", WarehouseRequest."Source Document"::"Sales Order");
                end;
            "Document Type"::"Return Order":
                WarehouseRequest.SETRANGE("Source Document", WarehouseRequest."Source Document"::"Sales Return Order");
        end;
        WarehouseRequest.SETRANGE("Source No.", "No.");
        CreateInvtPutawayPickMvmt.SuppressMessages(AutoCreatePutAway);
        CreateInvtPutawayPickMvmt.InitializeRequest(FALSE, TRUE, FALSE, TRUE, FALSE);
        CreateInvtPutawayPickMvmt.USEREQUESTPAGE(NOT AutoCreatePutAway);
        CreateInvtPutawayPickMvmt.SETTABLEVIEW(WarehouseRequest);
        CreateInvtPutawayPickMvmt.RUNMODAL();
    end;

    /// <summary>
    /// SetAutoCreatePutAway.
    /// </summary>
    /// <param name="pAutoCreatePutAway">Boolean.</param>
    procedure SetAutoCreatePutAway(pAutoCreatePutAway: Boolean)
    begin
        // PDC2 MM ->
        AutoCreatePutAway := pAutoCreatePutAway;
        // PDC2 MM <-
    end;

    /// <summary>
    /// GetLastConsignmentNo.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetLastConsignmentNo(): Code[20]
    var
        l_SalesShipmentHeader: Record "Sales Shipment Header";
        l_PDCCourierShipmentHeader: Record PDCCourierShipmentHeader;
    begin
        // PDC2 MM 10-08-15 ->
        l_SalesShipmentHeader.SetRange("Order No.", "No.");
        if l_SalesShipmentHeader.FindLast() then begin
            l_PDCCourierShipmentHeader.SetRange(SalesShipmentHeaderNo, l_SalesShipmentHeader."No.");
            if l_PDCCourierShipmentHeader.FindLast() then
                exit(l_PDCCourierShipmentHeader.ConsignmentNo);
        end;
        // PDC2 MM 10-08-15 <-
    end;

    /// <summary>
    /// CalcReqDeliveryDate.
    /// </summary>
    procedure CalcReqDeliveryDate()
    var
        SalesLine1: Record "Sales Line";
        Item1: Record Item;
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        NonWorking: Boolean;
        ProposedDate: Date;
        i: Integer;
    begin
        if "Requested Delivery Date" = 0D then begin
            SalesSetup.Get();

            SalesLine1.SetRange("Document Type", "Document Type");
            SalesLine1.SetRange("Document No.", "No.");
            SalesLine1.SetRange(Type, SalesLine1.Type::Item);
            SalesLine1.SetFilter("No.", '<>%1', '');
            SalesLine1.SetFilter("Qty. to Ship", '>%1', 0);
            if SalesLine1.FindSet() then
                repeat
                    Item1.Get(SalesLine1."No.");
                    if SalesSetup."PDC Order Cut Off Time" <> 000000T then
                        if Dt2Time(CurrentDatetime) >= SalesSetup."PDC Order Cut Off Time" then
                            Item1."PDC SLA" += 1;

                    ProposedDate := "Order Date";
                    for i := 1 to Item1."PDC SLA" do begin
                        ProposedDate += 1;
                        NonWorking := CalendarManagement.IsNonworkingDay(ProposedDate, CustomizedCalendarChange);
                        while NonWorking do begin
                            ProposedDate += 1;
                            NonWorking := CalendarManagement.IsNonworkingDay(ProposedDate, CustomizedCalendarChange);
                        end;
                    end;
                    NonWorking := CalendarManagement.IsNonworkingDay(ProposedDate, CustomizedCalendarChange);
                    while NonWorking do begin
                        ProposedDate += 1;
                        NonWorking := CalendarManagement.IsNonworkingDay(ProposedDate, CustomizedCalendarChange);
                    end;

                    if ProposedDate > "Requested Delivery Date" then
                        "Requested Delivery Date" := ProposedDate;
                until SalesLine1.Next() = 0;
        end;
    end;

    local procedure UpdateCarriageLine()
    var
        SalesLine: Record "Sales Line";
        ShippingAgentServices: Record "Shipping Agent Services";
        LastLineNo: Integer;
    begin
        if not GuiAllowed then
            exit;
        if HideValidationDialog then
            exit;
        if PDCHideValidationDialog then
            exit;

        if not ("Document Type" in ["document type"::Quote, "document type"::Order]) then
            exit;

        if not (ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") and (ShippingAgentServices."PDC Carriage Charge No." <> '')) then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        if SalesLine.IsEmpty then
            exit;

        SalesLine.SetRange(Type, ShippingAgentServices."PDC Carriage Charge Type");
        SalesLine.SetRange("No.", ShippingAgentServices."PDC Carriage Charge No.");
        if not SalesLine.FindFirst() then begin
            SalesLine.SetRange(Type);
            SalesLine.SetRange("No.");
            SalesLine.FindLast();
            LastLineNo := SalesLine."Line No.";

            SalesLine.Init();
            SalesLine."Document Type" := "Document Type";
            SalesLine."Document No." := "No.";
            SalesLine."Line No." := LastLineNo + 10000;
            SalesLine.Insert(true);
            SalesLine.Type := ShippingAgentServices."PDC Carriage Charge Type";
            SalesLine.Validate("No.", ShippingAgentServices."PDC Carriage Charge No.");
            SalesLine.Validate(Quantity, 1);
            SalesLine.Modify(true);
        end;
        SalesLine.Description := ShippingAgentServices.Description;
        SalesLine.Validate("Unit Price", ShippingAgentServices."PDC Carriage Charge");
        SalesLine.Modify(true);
    end;


    local procedure CopyShipToCustomerAddressFieldsFromShipToAddr1(ShiptoAddress: Record "Ship-to Address")
    begin
        "Ship-to Name" := ShiptoAddress.Name;
        "Ship-to Name 2" := ShiptoAddress."Name 2";
        "Ship-to Address" := ShiptoAddress.Address;
        "Ship-to Address 2" := ShiptoAddress."Address 2";
        "Ship-to City" := ShiptoAddress.City;
        "Ship-to Post Code" := ShiptoAddress."Post Code";
        "Ship-to County" := ShiptoAddress.County;
        VALIDATE("Ship-to Country/Region Code", ShiptoAddress."Country/Region Code");
        "Ship-to Contact" := ShiptoAddress.Contact;
        if ShiptoAddress."Shipment Method Code" <> '' then
            VALIDATE("Shipment Method Code", ShiptoAddress."Shipment Method Code");
        if ShiptoAddress."Location Code" <> '' then
            VALIDATE("Location Code", ShiptoAddress."Location Code");
        "Shipping Agent Code" := ShiptoAddress."Shipping Agent Code";
        "Shipping Agent Service Code" := ShiptoAddress."Shipping Agent Service Code";
        if ShiptoAddress."Tax Area Code" <> '' then
            "Tax Area Code" := ShiptoAddress."Tax Area Code";
        "Tax Liable" := ShiptoAddress."Tax Liable";
    end;

    local procedure CopyShipToCustomerAddressFieldsFromCustomer1(VAR SellToCustomer: Record Customer)
    begin
        "Ship-to Name" := SellToCustomer.Name;
        "Ship-to Name 2" := SellToCustomer."Name 2";

        "Ship-to Address" := SellToCustomer.Address;
        "Ship-to Address 2" := SellToCustomer."Address 2";
        "Ship-to City" := SellToCustomer.City;
        "Ship-to Post Code" := SellToCustomer."Post Code";
        "Ship-to County" := SellToCustomer.County;
        VALIDATE("Ship-to Country/Region Code", SellToCustomer."Country/Region Code");
        "Ship-to Contact" := SellToCustomer.Contact;
        if SellToCustomer."Shipment Method Code" <> '' then
            VALIDATE("Shipment Method Code", SellToCustomer."Shipment Method Code");
        "Tax Area Code" := SellToCustomer."Tax Area Code";
        "Tax Liable" := SellToCustomer."Tax Liable";
        if SellToCustomer."Location Code" <> '' then
            VALIDATE("Location Code", SellToCustomer."Location Code");
        "Shipping Agent Code" := SellToCustomer."Shipping Agent Code";
        "Shipping Agent Service Code" := SellToCustomer."Shipping Agent Service Code";
    end;

    /// <summary>
    /// CalcOutstandingAmt.
    /// </summary>
    /// <param name="InclVAT">Boolean.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcOutstandingAmt(InclVAT: Boolean): Decimal
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesLine: Record "Sales Line";
        OutstandingAmt: Decimal;
    begin
        GeneralLedgerSetup.get();
        SalesLine.setrange("Document Type", "Document Type");
        SalesLine.setrange("Document No.", "No.");
        SalesLine.setfilter("Outstanding Quantity", '<>%1', 0);
        if SalesLine.findset() then
            repeat
                if InclVAT then
                    OutstandingAmt += SalesLine."Outstanding Amount"
                else
                    if SalesLine."Amount Including VAT" <> 0 then
                        OutstandingAmt += round(SalesLine."Outstanding Amount" / SalesLine."Amount Including VAT" * SalesLine.Amount, GeneralLedgerSetup."Amount Rounding Precision");
            until SalesLine.next() = 0;
        exit(OutstandingAmt);
    end;

    internal procedure PerformReleasePickPrint()
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WhseRequest: Record "Warehouse Request";
        CreateInvPick: Report "Create Invt Put-away/Pick/Mvmt";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        PDCFunctions: Codeunit "PDC Functions";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if Rec.Status <> Rec.Status::Released then begin
            ReleaseSalesDoc.PerformManualRelease(Rec);
            Commit();
        end;

        if Rec.Status = Rec.Status::Released then begin
            WhseRequest.Reset();
            WhseRequest.SetCurrentKey("Source Document", "Source No.");
            WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Sales Order");
            WhseRequest.SetRange("Source No.", "No.");

            clear(CreateInvPick);
            CreateInvPick.InitializeRequest(false, true, false, false, false);
            CreateInvPick.SetTableView(WhseRequest);
            CreateInvPick.UseRequestPage(false);
            CreateInvPick.RunModal();

            WarehouseActivityHeader.SetRange("Source Document", WarehouseActivityHeader."Source Document"::"Sales Order");
            WarehouseActivityHeader.SetRange("Source No.", Rec."No.");
            if WarehouseActivityHeader.FindSet() then
                repeat
                    PDCFunctions.PrintInvPickInstructionBackground(WarehouseActivityHeader);
                    PDCFunctions.PrintInvPickLabelsBackground(WarehouseActivityHeader);
                until WarehouseActivityHeader.Next() = 0;
        end;
    end;
}

