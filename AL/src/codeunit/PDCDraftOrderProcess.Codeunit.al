/// <summary>
/// Codeunit PDCDraftOrderProcess (ID 50004) proceed Draft Order to Sales Order.
/// </summary>
codeunit 50004 "PDC Draft Order Process"
{
    TableNo = "PDC Draft Order Header";

    trigger OnRun()
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
        DraftOrderItemLine: Record "PDC Draft Order Item Line";
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        NavPortalUser: Record "PDC Portal User";
        NavPortalUser2: Record "PDC Portal User";
        GeneralLookupExisting: Record "PDC General Lookup_existing";
        ShippingAgentServices: Record "Shipping Agent Services";
        ShippingAgentServices2: Record "Shipping Agent Services";
        ShipAgentServPerCustomer: Record "PDC Ship.Agent Serv. Per Cust.";
        Customer: Record Customer;
        NoSeries: Codeunit "No. Series";
        PDCSalesOrderConfirmJQ: Codeunit "PDC Sales Order Confirm JQ";
        i: Integer;
        MaxOrderNo: Integer;
        LastLineNo: Integer;
        ConfirmQst: Label 'Do you want to proceed Draft Order %1', Comment = '%1=document no.';
    begin
        Rec.CalcFields("Proceed Order");
        Rec.TestField("Proceed Order", true);

        if GuiAllowed then
            if not Confirm(ConfirmQst, false, Rec."Document No.") then
                exit;

        DraftOrderItemLine.SetCurrentKey("Create Order No.");
        DraftOrderItemLine.setrange("Document No.", Rec."Document No.");
        if DraftOrderItemLine.FindLast() then
            MaxOrderNo := DraftOrderItemLine."Create Order No.";

        for i := 1 to MaxOrderNo do begin
            DraftOrderItemLine.setrange("Create Order No.", i);
            DraftOrderItemLine.SetFilter(Quantity, '>%1', 0);
            if DraftOrderItemLine.findset() then begin
                if not NavPortalUser.get(DraftOrderItemLine."Portal User Id") then
                    clear(NavPortalUser);

                if not ShippingAgentServices.get(DraftOrderItemLine."Shipping Agent Code", DraftOrderItemLine."Shipping Agent Service Code") then
                    clear(ShippingAgentServices);

                clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader.SetHideValidationDialog(true);
                SalesHeader.Validate("Document Type", SalesHeader."document type"::Order);
                SalesHeader.InitRecord();
                SalesHeader."No. Series" := SalesHeader.GetNoSeriesCode();
                SalesHeader."No." := NoSeries.GetNextNo(SalesHeader."No. Series", SalesHeader."Posting Date");
                SalesHeader2.ReadIsolation(IsolationLevel::ReadUncommitted);
                SalesHeader2.SetLoadFields("No.");
                while SalesHeader2.Get(SalesHeader."Document Type", SalesHeader."No.") do
                    SalesHeader."No." := NoSeries.GetNextNo(SalesHeader."No. Series", SalesHeader."Posting Date");
                SalesHeader.insert(true);
                SalesHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                SalesHeader.Validate("PDC WebOrder No.", Rec."Document No.");
                SalesHeader.Validate("External Document No.", Rec."Document No.");
                SalesHeader.Validate("Ship-to Code", Rec."Ship-to Code");
                SalesHeader.Validate("Shipping Agent Code", ShippingAgentServices."Shipping Agent Code");
                SalesHeader.Validate("Shipping Agent Service Code", ShippingAgentServices.Code);
                if NavPortalUser."Contact No." <> '' then
                    SalesHeader.Validate("Sell-to Contact No.", NavPortalUser."Contact No.");
                SalesHeader."Requested Delivery Date" := DraftOrderItemLine."Requested Shipment Date";
                SalesHeader."Your Reference" := Rec."PO No.";

                if DraftOrderItemLine."Out Of SLA" then begin
                    SalesHeader.Validate(SalesHeader."PDC Out of SLA Approved", true);
                    SalesHeader.Validate(SalesHeader."PDC Out of SLA Approved By", NavPortalUser."Contact No.");
                end;


                SalesHeader."PDC Ship-to E-Mail" := Rec."Ship-to E-Mail";
                SalesHeader."PDC Ship-to Mobile Phone No." := Rec."Ship-to Mobile Phone No.";

                if not GeneralLookupExisting.Get(GeneralLookupExisting.Type::Source, 'PORTAL') then begin
                    GeneralLookupExisting.Type := GeneralLookupExisting.Type::Source;
                    GeneralLookupExisting.Code := 'PORTAL';
                    GeneralLookupExisting.Insert();
                end;
                SalesHeader."PDC Order Source" := GeneralLookupExisting.Code;

                if SalesHeader."Ship-to Contact" = '' then
                    SalesHeader."Ship-to Contact" := NavPortalUser.Name;
                SalesHeader.Modify();

                clear(LastLineNo);

                repeat
                    DraftOrderStaffLine.Get(DraftOrderItemLine."Document No.", DraftOrderItemLine."Staff Line No.");

                    LastLineNo += 10000;

                    SalesLine.Init();
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", LastLineNo);
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", DraftOrderItemLine."Item No.");
                    SalesLine.Validate(Quantity, DraftOrderItemLine.Quantity);
                    SalesLine.Validate("Unit Price", DraftOrderItemLine."Unit Price");

                    DraftOrderStaffLine.CalcFields("Wearer ID", "Staff Name", "Contract ID", "Wardrobe ID", "Branch ID");

                    SalesLine.Validate("PDC Staff ID", DraftOrderStaffLine."Staff ID");
                    SalesLine.Validate("PDC Wearer ID", DraftOrderStaffLine."Wearer ID");
                    SalesLine.Validate("PDC Wearer Name", DraftOrderStaffLine."Staff Name");
                    SalesLine.Validate("PDC Wardrobe ID", DraftOrderStaffLine."Wardrobe ID");
                    SalesLine.Validate("PDC Order Reason Code", DraftOrderStaffLine."Reason Code");
                    SalesLine.Validate("PDC Web Order No.", DraftOrderStaffLine."Document No.");
                    SalesLine.Validate("PDC Ordered By ID", NavPortalUser."Contact No.");
                    SalesLine.Validate("PDC Ordered By Name", NavPortalUser.Name);
                    SalesLine."PDC Branch No." := DraftOrderStaffLine."Branch ID";
                    SalesLine.Validate("PDC SLA Date", DraftOrderItemLine."SLA Date");
                    SalesLine.Validate("PDC Draft Order No.", DraftOrderStaffLine."Document No.");
                    SalesLine.Validate("PDC Draft Order Staff Line No.", DraftOrderStaffLine."Line No.");
                    SalesLine.Validate("PDC Draft Order Item Line No.", DraftOrderItemLine."Line No.");
                    SalesLine.Validate("PDC Contract No.", DraftOrderStaffLine."Contract ID");
                    SalesLine.Validate("PDC Over Entitlement Reason", DraftOrderItemLine."Over Entitlement Reason");

                    if DraftOrderStaffLine."PO No." <> '' then
                        SalesLine.Validate("PDC Customer Reference", DraftOrderStaffLine."PO No.")
                    else
                        SalesLine.Validate("PDC Customer Reference", Rec."PO No.");


                    SalesLine."PDC Created By ID" := Rec."Created By ID";
                    NavPortalUser2.SetRange("Contact No.", SalesLine."PDC Created By ID");
                    if NavPortalUser2.FindFirst() then
                        SalesLine."PDC Created By Name" := copystr(NavPortalUser2.Name, 1, MaxStrLen(SalesLine."PDC Created By Name"));

                    SalesLine.Insert(true);
                    DraftOrderItemLine.Delete();
                until DraftOrderItemLine.Next() = 0;

                if ShippingAgentServices."PDC Carriage Charge No." <> '' then begin
                    LastLineNo += 10000;

                    SalesLine.Init();
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", LastLineNo);
                    SalesLine.Validate(Type, ShippingAgentServices."PDC Carriage Charge Type");
                    SalesLine.Validate("No.", ShippingAgentServices."PDC Carriage Charge No.");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Description := ShippingAgentServices.Description;
                    SalesHeader.CalcFields(Amount);

                    if SalesHeader."Sell-to Customer No." <> '' then begin
                        ShippingAgentServices2.Reset();
                        ShippingAgentServices2.SetRange("Shipping Agent Code", ShippingAgentServices."Shipping Agent Code");
                        ShippingAgentServices2.SetRange("PDC Check Carriage Limit", true);
                        if ShippingAgentServices2.FindFirst() then
                            if ShippingAgentServices2.Code = ShippingAgentServices.Code then begin
                                Customer.Get(SalesHeader."Sell-to Customer No.");
                                if Customer."PDC Carriage Charge Limit" > 0 then
                                    ShippingAgentServices."PDC Carriage Charge Limit" := Customer."PDC Carriage Charge Limit";
                            end;
                    end;

                    ShipAgentServPerCustomer.Reset();
                    ShipAgentServPerCustomer.SetRange("Shipping Agent Code", ShippingAgentServices."Shipping Agent Code");
                    ShipAgentServPerCustomer.SetRange("Shipping Agent Service Code", ShippingAgentServices.Code);
                    ShipAgentServPerCustomer.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                    if ShipAgentServPerCustomer.FindFirst() then
                        ShippingAgentServices."PDC Carriage Charge" := ShipAgentServPerCustomer."Carriage Charge";


                    if SalesHeader.Amount > ShippingAgentServices."PDC Carriage Charge Limit" then
                        SalesLine.Validate("Unit Price", 0)
                    else
                        SalesLine.Validate("Unit Price", ShippingAgentServices."PDC Carriage Charge");


                    SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine2.SetRange("Document No.", SalesHeader."No.");
                    SalesLine2.SetRange(Type, SalesLine2.Type::Item);
                    if SalesLine2.FindFirst() then begin
                        SalesLine.Validate("PDC Wearer ID", SalesLine2."PDC Wearer ID");
                        SalesLine."PDC Wearer Name" := SalesLine2."PDC Wearer Name";
                        SalesLine.Validate("PDC Web Order No.", SalesLine2."PDC Web Order No.");
                        SalesLine.Validate("PDC Ordered By ID", SalesLine2."PDC Ordered By ID");
                        SalesLine.Validate("PDC Ordered By Name", SalesLine2."PDC Ordered By Name");
                        SalesLine."PDC Branch No." := SalesLine2."PDC Branch No.";
                        SalesLine.Validate("PDC Contract No.", SalesLine2."PDC Contract No.");
                        SalesLine.Validate("PDC Customer Reference", SalesLine2."PDC Customer Reference");

                        SalesLine."PDC Created By ID" := SalesLine2."PDC Created By ID";
                        SalesLine."PDC Created By Name" := SalesLine2."PDC Created By Name";
                    end;

                    SalesLine.Insert(true);
                end;

                PDCSalesOrderConfirmJQ.EnqueueSendOrderConfirmEmail(SalesHeader);
            end;
        end;

        DraftOrderItemLine.Reset();
        DraftOrderItemLine.SetRange("Document No.", Rec."Document No.");
        DraftOrderItemLine.SetFilter(Quantity, '>%1', 0);
        if DraftOrderItemLine.FindFirst() then exit;


        DraftOrderItemLine.Setrange(Quantity);
        DraftOrderItemLine.DeleteAll();

        DraftOrderStaffLine.Reset();
        DraftOrderStaffLine.SetRange("Document No.", Rec."Document No.");
        DraftOrderStaffLine.DeleteAll();

        if DraftOrderHeader.get(Rec."Document No.") then
            DraftOrderHeader.Delete(true);
    end;

}