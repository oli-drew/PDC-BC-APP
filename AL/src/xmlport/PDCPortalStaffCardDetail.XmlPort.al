/// <summary>
/// XmlPort PDC Portal Staff Card Detail (ID 50031).
/// </summary>
XmlPort 50031 "PDC Portal Staff Card Detail"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
                textelement(f_staffId)
                {
                }
            }
            tableelement(branchstaff; "PDC Branch Staff")
            {
                MinOccurs = Zero;
                XmlName = 'staffdetail';
                UseTemporary = true;
                tableelement(completedorders; "Sales Invoice Line")
                {
                    AutoSave = false;
                    LinkFields = "PDC Staff ID" = field("Staff ID");
                    LinkTable = BranchStaff;
                    MinOccurs = Zero;
                    XmlName = 'completedOrders';
                    SourceTableView = where(Quantity = filter(<> 0));
                    textattribute(jsonarray)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(docno; CompletedOrders."Document No.")
                    {
                        FieldValidate = no;
                    }
                    textelement(shipmentNo)
                    {
                    }
                    textelement(shipmentDate)
                    {
                    }
                    fieldelement(no; CompletedOrders."No.")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(description; CompletedOrders.Description)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(quantity; CompletedOrders.Quantity)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(custReference; CompletedOrders."PDC Customer Reference")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(orderedId; CompletedOrders."PDC Ordered By ID")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(orderedName; CompletedOrders."PDC Ordered By Name")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(branch; CompletedOrders."PDC Branch No.")
                    {
                        FieldValidate = no;
                    }
                    textelement(colour_completedorders)
                    {
                        XmlName = 'colour';
                    }
                    textelement(size_completedorders)
                    {
                        XmlName = 'size';
                    }
                    textelement(fit_completedorders)
                    {
                        XmlName = 'fit';
                    }
                    textelement(consignmentno)
                    {
                        MinOccurs = Zero;
                        XmlName = 'consignmentNo';
                    }

                    trigger OnAfterGetRecord()
                    var
                        TempSalesShptLine: Record "Sales Shipment Line" temporary;
                        CourierShipmentHeader: Record PDCCourierShipmentHeader;
                    begin
                        Clear(colour_completedOrders);
                        Clear(size_completedOrders);
                        Clear(fit_completedOrders);
                        if CompletedOrders.Type = CompletedOrders.Type::Item then
                            if ItemRec.Get(CompletedOrders."No.") then begin
                                colour_completedOrders := ItemRec."PDC Colour";
                                size_completedOrders := ItemRec."PDC Size";
                                fit_completedOrders := ItemRec."PDC Fit";
                            end;

                        Clear(TempSalesShptLine);
                        CompletedOrders.GetSalesShptLines(TempSalesShptLine);
                        if TempSalesShptLine.FindFirst() then begin
                            shipmentNo := TempSalesShptLine."Document No.";
                            shipmentDate := PortalsMgt.FormatDate(TempSalesShptLine."Shipment Date");

                            CourierShipmentHeader.SetRange(SalesShipmentHeaderNo, TempSalesShptLine."Document No.");
                            if CourierShipmentHeader.FindFirst() then
                                consignmentNo := CourierShipmentHeader.consignmentNumber
                            else
                                consignmentNo := '0';
                        end;
                    end;
                }
                tableelement(orders; "Sales Line")
                {
                    AutoSave = false;
                    LinkFields = "PDC Staff ID" = field("Staff ID");
                    LinkTable = BranchStaff;
                    MinOccurs = Zero;
                    XmlName = 'orders';
                    SourceTableView = where(Quantity = filter(<> 0));
                    textattribute(jsonarray2)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(docno; Orders."Document No.")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(no; Orders."No.")
                    {
                        FieldValidate = no;
                    }
                    textelement(orderdate_orders)
                    {
                        XmlName = 'orderDate';
                    }
                    fieldelement(description; Orders.Description)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(quantity; Orders.Quantity)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(custReference; Orders."PDC Customer Reference")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(orderedId; Orders."PDC Ordered By ID")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(orderedName; Orders."PDC Ordered By Name")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(branch; Orders."PDC Branch No.")
                    {
                        FieldValidate = no;
                    }
                    textelement(colour_orders)
                    {
                        XmlName = 'colour';
                    }
                    textelement(size_orders)
                    {
                        XmlName = 'size';
                    }
                    textelement(fit_orders)
                    {
                        XmlName = 'fit';
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(colour_Orders);
                        Clear(size_Orders);
                        Clear(fit_Orders);
                        if Orders.Type = Orders.Type::Item then
                            if ItemRec.Get(Orders."No.") then begin
                                colour_Orders := ItemRec."PDC Colour";
                                size_Orders := ItemRec."PDC Size";
                                fit_Orders := ItemRec."PDC Fit";
                            end;

                        orderDate_Orders := PortalsMgt.FormatDate(Orders."Shipment Date");
                    end;
                }
                tableelement(draftorders; "PDC Draft Order Item Line")
                {
                    AutoSave = false;
                    CalcFields = "Staff ID";
                    LinkFields = "Staff ID" = field("Staff ID");
                    LinkTable = BranchStaff;
                    MinOccurs = Zero;
                    XmlName = 'draftOrders';
                    SourceTableView = where(Quantity = filter(<> 0));
                    textattribute(jsonarray3)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(docno; draftOrders."Document No.")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(no; draftOrders."Item No.")
                    {
                        FieldValidate = no;
                    }
                    textelement(orderdate_draftorders)
                    {
                        XmlName = 'orderDate';
                    }
                    fieldelement(description; draftOrders."Item Description")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(quantity; draftOrders.Quantity)
                    {
                        FieldValidate = no;
                    }
                    textelement(custreference_draftorders)
                    {
                        XmlName = 'custReference';
                    }
                    textelement(orderedid_draftorders)
                    {
                        XmlName = 'orderedId';
                    }
                    textelement(orderedname_draftorders)
                    {
                        XmlName = 'orderedName';
                    }
                    textelement(branch_draftorders)
                    {
                        XmlName = 'branch';
                    }
                    textelement(colour_draftorders)
                    {
                        XmlName = 'colour';
                    }
                    textelement(size_draftorders)
                    {
                        XmlName = 'size';
                    }
                    textelement(fit_draftorders)
                    {
                        XmlName = 'fit';
                    }

                    trigger OnAfterGetRecord()
                    var
                        Hdr: Record "PDC Draft Order Header";
                        PortalUser: Record "PDC Portal User";
                    begin
                        Clear(colour_draftOrders);
                        Clear(size_draftOrders);
                        Clear(fit_draftOrders);
                        if ItemRec.Get(draftOrders."Item No.") then begin
                            colour_draftOrders := ItemRec."PDC Colour";
                            size_draftOrders := ItemRec."PDC Size";
                            fit_draftOrders := ItemRec."PDC Fit";
                        end;

                        Clear(custReference_draftOrders);
                        Clear(orderedId_draftOrders);
                        Clear(orderedName_draftOrders);

                        Hdr.Get(draftOrders."Document No.");
                        custReference_draftOrders := Hdr."Your Reference";
                        if Hdr."Created By ID" <> '' then begin
                            PortalUser.SetRange("Contact No.", Hdr."Created By ID");
                            if PortalUser.FindFirst() then begin
                                orderedId_draftOrders := PortalUser."Company Contact No.";
                                orderedName_draftOrders := PortalUser.Name;
                            end;
                        end;

                        branch_draftOrders := BranchStaff."Branch ID";

                        Clear(orderDate_draftOrders);
                        if Hdr."Created Date" <> 0DT then
                            orderDate_draftOrders := PortalsMgt.FormatDate(Dt2Date(Hdr."Created Date"));
                    end;
                }
                tableelement(entitlement; "PDC Staff Entitlement")
                {
                    AutoSave = false;
                    CalcFields = "Quantity Entitled in Period", "Quantity Posted", "Quantity on Return", "Quantity on Order", "Group Entitlement Period", "Group Value Entitled";
                    LinkFields = "Customer No." = field("Sell-to Customer No."), "Branch No." = field("Branch ID"), "Staff ID" = field("Staff ID"), "Wardrobe ID" = field("Wardrobe ID");
                    LinkTable = BranchStaff;
                    MinOccurs = Zero;
                    XmlName = 'entitlement';
                    SourceTableView = where(Inactive = const(false));

                    textattribute(jsonarray4)
                    {
                        XmlName = 'json_Array';
                    }
                    textelement(productCode)
                    {
                        XmlName = 'productCode';
                    }
                    textelement(description_entitlement)
                    {
                        XmlName = 'description';
                    }
                    textelement(entitlement_entitlement)
                    {
                        XmlName = 'entitlement';
                    }
                    textelement(used_entitlement)
                    {
                        XmlName = 'used';
                    }
                    textelement(orders_entitlement)
                    {
                        XmlName = 'orders';
                    }
                    textelement(return_entitlement)
                    {
                        XmlName = 'return';
                    }
                    textelement(draft_entitlement)
                    {
                        XmlName = 'draft';
                    }
                    textelement(remaining_entitlement)
                    {
                        XmlName = 'remaining';
                    }

                    trigger OnAfterGetRecord()
                    var
                        WardrobeLine: Record "PDC Wardrobe Line";
                        WardrobeGroup: Record "PDC Wardrobe Entitlement Group";
                    begin
                        if entitlement."Group Type" = entitlement."Group Type"::" " then begin
                            if (Entitlement."Product Code" = '') or
                               (WardrobeLine.Get(Entitlement."Wardrobe ID", Entitlement."Product Code") and WardrobeLine.Discontinued) then
                                currXMLport.Skip();

                            productCode := Entitlement."Product Code";

                            Clear(description_Entitlement);
                            ItemRec.Reset();
                            ItemRec.SetRange("PDC Product Code", Entitlement."Product Code");
                            ItemRec.SetRange(Blocked, false);
                            if ItemRec.FindFirst() then
                                description_Entitlement := ItemRec.Description;
                        end
                        else
                            if WardrobeGroup.get(entitlement."Wardrobe ID", entitlement."Group Type", entitlement."Group Code") then begin
                                productCode := entitlement."Group Code";
                                description_Entitlement := WardrobeGroup.Description;
                                Entitlement."Quantity Entitled in Period" := entitlement."Group Value Entitled";
                            end;

                        Entitlement.CalculateQuantities(Entitlement, false);
                        entitlement_Entitlement := Format(Entitlement."Quantity Entitled in Period", 0, '<Sign><Integer>');
                        used_Entitlement := Format(Entitlement."Quantity Posted", 0, '<Sign><Integer>');
                        orders_Entitlement := Format(Entitlement."Quantity on Order", 0, '<Sign><Integer>');
                        return_Entitlement := Format(Entitlement."Quantity on Return", 0, '<Sign><Integer>');
                        draft_Entitlement := Format(Entitlement."Quantity on Draft Order", 0, '<Sign><Integer>');
                        remaining_Entitlement := Format(Entitlement."Calc. Qty. Remaining in Period", 0, '<Sign><Integer>');
                    end;

                    trigger OnPreXmlItem()
                    var
                        StaffEntitlement: Record "PDC Staff Entitlement";
                    begin
                        StaffEntitlement.SetRange("Customer No.", BranchStaff."Sell-to Customer No.");
                        StaffEntitlement.SetRange("Branch No.", BranchStaff."Branch ID");
                        StaffEntitlement.SetRange("Staff ID", BranchStaff."Staff ID");
                        if StaffEntitlement.Findset() then
                            repeat
                                StaffEntitlement.Validate("End Date", WorkDate());
                                StaffEntitlement.Modify(true);
                                StaffEntitlement.CalculateQuantities(StaffEntitlement, true);
                            until StaffEntitlement.next() = 0;
                    end;
                }
                tableelement(staffsizes; "PDC Staff Size")
                {
                    AutoSave = false;
                    LinkFields = "Staff ID" = field("Staff ID");
                    LinkTable = BranchStaff;
                    MinOccurs = Zero;
                    XmlName = 'staffsizes';
                    textattribute(jsonarray5)
                    {
                        XmlName = 'json_Array';
                    }
                    textelement(description_staffsizes)
                    {
                        XmlName = 'description';
                    }
                    fieldelement(size; staffsizes.Size)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(fit; staffsizes.Fit)
                    {
                        AutoCalcField = false;
                    }
                    fieldelement(item; staffsizes."Created By Item No.")
                    {
                        AutoCalcField = false;
                    }

                    trigger OnAfterGetRecord()
                    var
                        SizeScaleHeader: Record "PDC Size Scale Header";
                    begin
                        Clear(description_staffsizes);
                        if SizeScaleHeader.Get(staffsizes."Size Scale Code") then
                            description_staffsizes := SizeScaleHeader.Description;
                    end;

                }
            }
        }
    }


    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
        jsonarray2 := 'true';
        jsonarray3 := 'true';
        jsonarray4 := 'true';
        jsonarray5 := 'true';
    end;

    var
        ItemRec: Record Item;
        PortalsMgt: Codeunit "PDC Portals Management";

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var NavPortalUser: Record "PDC Portal User")
    var
        BranchStaffDb: Record "PDC Branch Staff";
    begin
        BranchStaff.Reset();
        BranchStaffDb.Reset();

        BranchStaffDb.SetRange("Sell-to Customer No.", NavPortalUser."Customer No.");
        BranchStaffDb.SetRange("Staff ID", f_staffId);

        if BranchStaffDb.FindFirst() then BranchStaff.TransferFields(BranchStaffDb);
        BranchStaff.Insert();
    end;
}

