/// <summary>
/// XmlPort PDC Portal Draft Items Card (ID 50019).
/// </summary>
XmlPort 50019 "PDC Portal Draft Items Card"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                textelement(orderNo)
                {
                }
                textelement(staffLineNo)
                {
                }
            }
            tableelement(draftorderheader; "PDC Draft Order Header")
            {
                MinOccurs = Zero;
                XmlName = 'order';
                UseTemporary = true;
                fieldelement(no; DraftOrderHeader."Document No.")
                {
                }
                fieldelement(poNo; DraftOrderHeader."PO No.")
                {
                }
                textelement(deliveryName)
                {
                }
                fieldelement(deliveryAddress; DraftOrderHeader."Ship-to Address")
                {
                }
                fieldelement(deliveryAddress2; DraftOrderHeader."Ship-to Address 2")
                {
                }
                fieldelement(deliveryCity; DraftOrderHeader."Ship-to City")
                {
                }
                fieldelement(deliveryCounty; DraftOrderHeader."Ship-to County")
                {
                }
                fieldelement(deliveryPostCode; DraftOrderHeader."Ship-to Post Code")
                {
                }
                fieldelement(deliveryCountry; DraftOrderHeader."Ship-to Country/Region Code")
                {
                }
            }
            tableelement(branchstaff; "PDC Branch Staff")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                fieldelement(no; BranchStaff."Staff ID")
                {
                }
                fieldelement(name; BranchStaff.Name)
                {
                }
                fieldelement(gender; BranchStaff."Body Type/Gender")
                {
                }
                fieldelement(yourId; BranchStaff."Wearer ID")
                {
                }
                fieldelement(branch; BranchStaff."Branch Name")
                {
                }
                fieldelement(uniform; BranchStaff."Wardrobe Description")
                {
                }
                fieldelement(uniformId; BranchStaff."Wardrobe ID")
                {
                }
                textelement(contract)
                {
                }
                textelement(contractname)
                {
                    MinOccurs = Zero;
                    XmlName = 'contractName';
                }

                trigger OnAfterGetRecord()
                var
                    ContractDB: Record "PDC Contract";
                begin
                    ContractDB.Get(
                                 BranchStaff."Sell-to Customer No.",
                                 BranchStaff."Contract ID");
                    contract := ContractDB."Contract Code";
                    contractName := ContractDB.Description;
                end;
            }
            tableelement(draftorderitemline; "PDC Draft Order Item Line")
            {
                MinOccurs = Zero;
                XmlName = 'lines';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    Occurrence = Optional;
                    XmlName = 'json_Array';
                }
                fieldelement(itemNo; DraftOrderItemLine."Item No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(lineNo; DraftOrderItemLine."Line No.")
                {
                }
                fieldelement(productCode; DraftOrderItemLine."Product Code")
                {
                }
                textelement(productName)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item: Record Item;
                    begin
                        Item.Reset();
                        Item.SetRange("PDC Product Code", DraftOrderItemLine."Product Code");
                        Item.SetFilter(Blocked, '%1', false);
                        if not Item.FindFirst() then exit;

                        productName := Item.Description;
                    end;
                }
                fieldelement(colour; DraftOrderItemLine."Colour Code")
                {
                }
                fieldelement(size; DraftOrderItemLine."Size Code")
                {
                }
                fieldelement(fit; DraftOrderItemLine."Fit Code")
                {
                    MinOccurs = Zero;
                }
                textelement(entitlement)
                {
                    MinOccurs = Zero;
                }
                textelement(qtyIssued)
                {
                    MinOccurs = Zero;
                }
                textelement(cost)
                {
                    MinOccurs = Zero;
                    XmlName = 'cost';
                }
                fieldelement(quantity; DraftOrderItemLine.Quantity)
                {
                }
                textelement(type)
                {
                    MinOccurs = Zero;
                    XmlName = 'type';

                    trigger OnBeforePassVariable()
                    var
                        WardrobeLine: Record "PDC Wardrobe Line";
                    begin
                        DraftOrderItemLine.CalcFields("Wardrobe ID");

                        if not WardrobeLine.Get(DraftOrderItemLine."Wardrobe ID", DraftOrderItemLine."Product Code") then begin
                            type := '';
                            exit;
                        end;

                        type := Format(WardrobeLine."Item Type");
                    end;
                }
                fieldelement(totalcost; DraftOrderItemLine."Line Amount")
                {
                    MinOccurs = Zero;
                }
                textelement(colourDescription)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item1: Record Item;
                    begin
                        colourDescription := DraftOrderItemLine."Colour Code";
                        if Item1.Get(DraftOrderItemLine."Item No.") then
                            if Item1."PDC Colour Description" <> '' then
                                colourDescription := Item1."PDC Colour Description";
                    end;
                }
                textelement(sizeDescription)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item1: Record Item;
                    begin
                        sizeDescription := DraftOrderItemLine."Size Code";
                        if Item1.Get(DraftOrderItemLine."Item No.") then
                            if Item1."PDC Size Description" <> '' then
                                sizeDescription := Item1."PDC Size Description";
                    end;
                }
                textelement(fitDescription)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    var
                        Item1: Record Item;
                    begin
                        fitDescription := DraftOrderItemLine."Fit Code";
                        if Item1.Get(DraftOrderItemLine."Item No.") then
                            if Item1."PDC Fit Description" <> '' then
                                fitDescription := Item1."PDC Fit Description";
                    end;
                }
                textelement(freeStockQty)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        FreeStockQty := format(FreeStock, 0, 9);
                    end;
                }
                textelement(QtyOtherStaff)
                {
                    MinOccurs = Zero;
                }
                fieldelement(overEntitlementReason; DraftOrderItemLine."Over Entitlement Reason")
                {
                    MinOccurs = Zero;
                    XmlName = 'overEntitlementReason';
                }

                trigger OnAfterGetRecord()
                var
                    StaffEntitlement: Record "PDC Staff Entitlement";
                    DraftOrderStaffLine: Record "PDC Draft Order Staff Line";
                    DraftOrderItemLine1: Record "PDC Draft Order Item Line";
                    Customer: Record Customer;
                    STA: Record "Ship-to Address";
                    CustPortalsMgt: Codeunit "PDC Portal Mgt";
                    NavPortalsMgt: Codeunit "PDC Portals Management";
                    StaffEntitlementMgt: Codeunit "PDC Staff Entitlement";
                begin
                    cost := Format(CustPortalsMgt.GetDrafrOrderItemUnitPrices(DraftOrderHeader, DraftOrderItemLine), 0, 9);

                    if DraftOrderStaffLine.Get(DraftOrderItemLine."Document No.", DraftOrderItemLine."Staff Line No.") then
                        DraftOrderStaffLine.CalcFields("Wardrobe ID");

                    if StaffEntitlement.Get(DraftOrderStaffLine."Staff ID", DraftOrderItemLine."Product Code") then
                        if Customer.get(StaffEntitlement."Customer No.") and Customer."PDC Entitlement Enabled" then begin
                            StaffEntitlement.CalculateQuantities(StaffEntitlement, true);
                            DraftOrderItemLine.CalcFields(Entitlement);
                        end;

                    clear(FreeStock);
                    if DraftOrderItemLine."Item No." <> '' then begin
                        if Customer.Get(DraftOrderHeader."Sell-to Customer No.") then
                            if STA.get(DraftOrderHeader."Sell-to Customer No.", DraftOrderHeader."Ship-to Code") and
                              (sta."Location Code" <> '') then
                                Customer."Location Code" := sta."Location Code";
                        FreeStock := NavPortalsMgt.CalcItemFreeStock(DraftOrderItemLine."Item No.", '', Customer."Location Code", WorkDate());
                    end;

                    clear(FreeStock);
                    if DraftOrderItemLine."Item No." <> '' then begin
                        if Customer.Get(DraftOrderHeader."Sell-to Customer No.") then
                            if STA.get(DraftOrderHeader."Sell-to Customer No.", DraftOrderHeader."Ship-to Code") and
                              (sta."Location Code" <> '') then
                                Customer."Location Code" := sta."Location Code";
                        FreeStock := NavPortalsMgt.CalcItemFreeStock(DraftOrderItemLine."Item No.", '', Customer."Location Code", WorkDate());
                    end;

                    DraftOrderItemLine1.setrange("Document No.", DraftOrderItemLine."Document No.");
                    DraftOrderItemLine1.setfilter("Staff Line No.", '<>%1', DraftOrderItemLine."Staff Line No.");
                    DraftOrderItemLine1.setrange("Item No.", DraftOrderItemLine."Item No.");
                    DraftOrderItemLine1.calcsums(Quantity);
                    QtyOtherStaff := format(DraftOrderItemLine1.Quantity);
                    entitlement := Format(StaffEntitlementMgt.GetQtyEntitled(DraftOrderStaffLine."Staff ID", DraftOrderItemLine."Product Code"));
                    qtyIssued := Format(StaffEntitlementMgt.GetQtyIssued(DraftOrderStaffLine."Staff ID", DraftOrderItemLine."Product Code", false));
                end;

                trigger OnPreXmlItem()
                begin
                    DraftOrderItemLine.SetCurrentkey("Product Code", "Colour Sequence", "Fit Sequence", "Size Sequence");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    if Evaluate(DraftOrderItemLine."Unit Price", cost) then;
                end;
            }
            tableelement(reasoncode; "Reason Code")
            {
                MinOccurs = Zero;
                XmlName = 'reasons';
                fieldelement(code; ReasonCode.Code)
                {
                }
                fieldelement(desc; ReasonCode.Description)
                {
                }
            }
            textelement(reason)
            {
                MinOccurs = Zero;
                XmlName = 'reason';
            }
            textelement(staffpoNo)
            {
                MinOccurs = Zero;

                trigger OnBeforePassVariable()
                var
                    DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
                begin
                    if DraftOrderStaffLineDb.Get(orderNo, staffLineNo) then
                        staffpoNo := DraftOrderStaffLineDb."PO No.";
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        FreeStock: Decimal;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeaderDb">VAR Record "PDC Draft Order Header".</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User"; var DraftOrderHeaderDb: Record "PDC Draft Order Header")
    var
        DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
        BranchStaffDb: Record "PDC Branch Staff";
        ItemDb: Record Item;
    begin
        DraftOrderHeader.Reset();
        DraftOrderHeader.DeleteAll();

        BranchStaff.Reset();
        BranchStaff.DeleteAll();

        ReasonCode.SetRange("PDC Type", ReasonCode."PDC Type"::Order);
        ReasonCode.SetFilter("PDC Customer No.", '=%1|=%2', '', PortalUser."Customer No.");

        DraftOrderItemLine.Reset();
        DraftOrderItemLine.DeleteAll();

        DraftOrderHeaderDb.SetRange("Document No.", orderNo);

        if not DraftOrderHeaderDb.FindFirst() then exit;
        if not DraftOrderStaffLineDb.Get(orderNo, staffLineNo) then exit;

        reason := DraftOrderStaffLineDb."Reason Code";

        if not BranchStaffDb.Get(DraftOrderStaffLineDb."Staff ID") then exit;

        deliveryName := DraftOrderHeaderDb."Ship-to Name" + ' ' + DraftOrderHeaderDb."Ship-to Name 2";

        DraftOrderHeader.TransferFields(DraftOrderHeaderDb);
        DraftOrderHeader.Insert();

        BranchStaff.TransferFields(BranchStaffDb);
        BranchStaff.Insert();

        DraftOrderItemLineDb.Reset();
        DraftOrderItemLineDb.SetRange("Document No.", orderNo);
        DraftOrderItemLineDb.SetRange("Staff Line No.", DraftOrderStaffLineDb."Line No.");

        if not DraftOrderItemLineDb.FindSet() then exit;

        repeat
            DraftOrderItemLineDb.CalcFields("Quantity Remaining");
            DraftOrderItemLineDb.CalcFields("Quantity Issued");
            DraftOrderItemLine.TransferFields(DraftOrderItemLineDb);

            if ItemDb.Get(DraftOrderItemLineDb."Item No.") then begin
                if not ItemDb.Blocked then DraftOrderItemLine.Insert();
            end else
                DraftOrderItemLine.Insert();

        until DraftOrderItemLineDb.Next() = 0;
    end;

    /// <summary>
    /// SaveData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure SaveData(var PortalUser: Record "PDC Portal User")
    var
        DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
        PortalsMgt: Codeunit "PDC Portal Mgt";
        iStaffLineNo: Integer;
    begin
        Evaluate(iStaffLineNo, staffLineNo);

        DraftOrderStaffLineDb.Get(orderNo, staffLineNo);
        DraftOrderStaffLineDb.Validate("Reason Code", reason);
        DraftOrderStaffLineDb.Validate("PO No.", staffpoNo);
        DraftOrderStaffLineDb.Modify(true);


        PortalsMgt.AddOrUpdateDraftOrderItemLines(PortalUser."Customer No.", orderNo, DraftOrderItemLine, iStaffLineNo, true);
    end;
}

