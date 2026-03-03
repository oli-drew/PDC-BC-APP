/// <summary>
/// Page PDCAPI - Pstd Sales Inv Lines (ID 50111).
/// </summary>
page 50111 "PDCAPI - Pstd Sales Inv Lines"
{
    DelayedInsert = true;
    APIVersion = 'v2.0';
    EntityCaption = 'Posted Sales Invoice Line';
    EntitySetCaption = 'Posted Sales Invoice Lines';
    PageType = API;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    EntityName = 'pstdSalesInvoiceLine';
    EntitySetName = 'pstdSalesInvoiceLines';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    SourceTable = "Sales Invoice Line";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentId; Rec."PDC Document Id")
                {
                    Caption = 'Document Id';
                    Editable = false;
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No';
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'Sequence';
                }
                field(lineType; Rec.Type)
                {
                    Caption = 'Line Type';
                }
                field(lineObjectNumber; Rec."No.")
                {
                    Caption = 'Line Object No.';
                }
                field(itemSystemId; itemSystemId)
                {
                    Caption = 'Item SystemId';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(discountPercent; Rec."Line Discount %")
                {
                    Caption = 'Discount Percent';
                }
                field(taxPercent; Rec."VAT %")
                {
                    Caption = 'Tax Percent';
                    Editable = false;
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(vat; Rec."Amount Including VAT" - Rec.Amount)
                {
                    Caption = 'VAT';
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(branchNo; Rec."PDC Branch No.")
                {
                    Caption = 'Branch No.';
                }
                field(branchSystemId; branchSystemId)
                {
                    Caption = 'branch SystemId';
                }
                field(commentLines; Rec."PDC Comment Lines")
                {
                    Caption = 'Comment Lines';
                }
                field(consignmentNo; Rec."PDC Consignment No.")
                {
                    Caption = 'Consignment No.';
                }
                field(contractCode; Rec."PDC Contract Code")
                {
                    Caption = 'Contract Code';
                }
                field(contractNo; Rec."PDC Contract No.")
                {
                    Caption = 'Contract No.';
                }
                field(contractSystemId; contractSystemId)
                {
                    Caption = 'contract SystemId';
                }
                field(createdByID; Rec."PDC Created By ID")
                {
                    Caption = 'Created By ID';
                }
                field(createdBySystemId; createdBySystemId)
                {
                    Caption = 'Created By SystemId';
                }
                field(customerReference; Rec."PDC Customer Reference")
                {
                    Caption = 'Customer Reference';
                }
                field(draftOrderNo; Rec."PDC Draft Order No.")
                {
                    Caption = 'Web Order No.';
                }
                field(draftOrderStaffLineNo; Rec."PDC Draft Order Staff Line No.")
                {
                    Caption = 'Draft Order Staff Line No.';
                }
                field(draftOrderItemLineNo; Rec."PDC Draft Order Item Line No.")
                {
                    Caption = 'Draft Order Item Line No.';
                }
                field(itemCountryOfOriginCode; Rec."PDC Item Country of OriginCode")
                {
                    Caption = 'Item Country of Origin Code';
                }
                field(itemNetWeight; Rec."PDC Item Net Weight")
                {
                    Caption = 'Item Net Weight';
                }
                field(orderReason; Rec."PDC Order Reason")
                {
                    Caption = 'Order Reason';
                }
                field(orderedByID; Rec."PDC Ordered By ID")
                {
                    Caption = 'Ordered By ID';
                }
                field(orderedBySystemId; orderedBySystemId)
                {
                    Caption = 'Ordered By SystemId';
                }
                field(slaDate; Rec."PDC SLA Date")
                {
                    Caption = 'SLA Date';
                }
                field(staffID; Rec."PDC Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(staffSystemId; staffSystemId)
                {
                    Caption = 'staff SystemId';
                }
                field(wardrobeID; Rec."PDC Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(wardrobeSystemId; wardrobeSystemId)
                {
                    Caption = 'Wardrobe SystemId';
                }
                field(wardrobeLineSystemId; wardrobeLineSystemId)
                {
                    Caption = 'Wardrobe Line SystemId';
                }
                field(wearerID; Rec."PDC Wearer ID")
                {
                    Caption = 'Wearer ID';
                }
                field(wearerName; Rec."PDC Wearer Name")
                {
                    Caption = 'Wearer Name';
                }
                field(webOrderNo; Rec."PDC Web Order No.")
                {
                    Caption = 'Web Order No.';
                }
                field(customerId; customerSystemId)
                {
                    Caption = 'customerId';
                }
                field(carbonEmissionsCO2e; Rec."PDC Carbon Emissions CO2e")
                {
                    Caption = 'Carbon Emissions CO2e';
                }

            }
        }
    }

    actions
    {
    }


    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    var
        customerSystemId: Guid;
        branchSystemId: guid;
        contractSystemId: guid;
        wardrobeSystemId: Guid;
        wardrobeLineSystemId: Guid;
        staffSystemId: Guid;
        createdBySystemId: Guid;
        orderedBySystemId: Guid;
        itemSystemId: Guid;

    local procedure SetCalculatedFields()
    var
        Customer: Record Customer;
        Item: Record Item;
        Branch: Record "PDC Branch";
        Contract: Record "PDC Contract";
        Wardrobe: Record "PDC Wardrobe Header";
        WardrobeLine: Record "PDC Wardrobe Line";
        Staff: Record "PDC Branch Staff";
        PortalUser: Record "PDC Portal User";
    begin
        clear(customerSystemId);
        if Customer.get(Rec."Sell-to Customer No.") then
            customerSystemId := Customer.SystemId;

        clear(branchSystemId);
        if Branch.get(Rec."Sell-to Customer No.", Rec."PDC Branch No.") then
            branchSystemId := Branch.SystemId;

        clear(contractSystemId);
        if Contract.get(Rec."Sell-to Customer No.", Rec."PDC Contract No.") then
            contractSystemId := Contract.SystemId;

        clear(wardrobeSystemId);
        if Wardrobe.get(Rec."PDC Wardrobe ID") then
            wardrobeSystemId := Wardrobe.SystemId;

        clear(itemSystemId);
        clear(wardrobeLineSystemId);
        if Rec.Type = Rec.Type::Item then
            if Item.get(Rec."No.") then begin
                itemSystemId := Item.SystemId;
                if WardrobeLine.get(Rec."PDC Wardrobe ID", Item."PDC Product Code") then
                    wardrobeLineSystemId := WardrobeLine.SystemId;
            end;

        clear(staffSystemId);
        if Staff.get(Rec."PDC Staff ID") then
            staffSystemId := Staff.SystemId;

        PortalUser.SetRange("Contact No.", Rec."PDC Created By ID");
        if PortalUser.FindFirst() then
            createdBySystemId := PortalUser.SystemId;
        PortalUser.SetRange("Contact No.", Rec."PDC Ordered By ID");
        if PortalUser.FindFirst() then
            orderedBySystemId := PortalUser.SystemId;
    end;
}