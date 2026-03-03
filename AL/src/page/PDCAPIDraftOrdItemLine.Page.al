/// <summary>
/// Page PDCAPI - DraftOrdItemLine (ID 50103).
/// </summary>
page 50103 "PDCAPI - DraftOrdItemLine"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Draft Order Item Line';
    EntitySetCaption = 'Draft Order Item Lines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'draftorderitemline';
    EntitySetName = 'draftorderitemlines';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Draft Order Item Line";
    Extensible = false;
    Editable = false;

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
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';
                }
                field(staffLineNo; Rec."Staff Line No.")
                {
                    Caption = 'Staff Line No.';
                }
                field(staffLineId; Rec."Staff Line Id")
                {
                    Caption = 'Staff Line Id';
                }
                field(staffID; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(staffSystemId; Rec."Staff SystemId")
                {
                    Caption = 'Staff SystemId';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(branchID; Rec."Branch ID")
                {
                    Caption = 'Branch ID';
                }
                field(branchSystemId; Rec."Branch SystemId")
                {
                    Caption = 'Branch SystemId';
                }
                field(wardrobeID; Rec."Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(wardrobeSystemId; Rec."Wardrobe SystemId")
                {
                    Caption = 'Specifies the value of the Wardrobe SystemId field.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(itemId; Rec."Item Id")
                {
                    Caption = 'Specifies the value of the Item Id field.';
                }
                field(itemDescription; Rec."Item Description")
                {
                    Caption = 'Item Description';
                }
                field(productCode; Rec."Product Code")
                {
                    Caption = 'Product Code';
                }
                field(fitCode; Rec."Fit Code")
                {
                    Caption = 'Fit Code';
                }
                field(fitSequence; Rec."Fit Sequence")
                {
                    Caption = 'Specifies the value of the Fit Sequence field.';
                }
                field(sizeCode; Rec."Size Code")
                {
                    Caption = 'Size Code';
                }
                field(sizeSequence; Rec."Size Sequence")
                {
                    Caption = 'Size Sequence';
                }
                field(colourCode; Rec."Colour Code")
                {
                    Caption = 'Colour Code';
                }
                field(colourSequence; Rec."Colour Sequence")
                {
                    Caption = 'Colour Sequence';
                }
                field(outOfSLA; Rec."Out Of SLA")
                {
                    Caption = 'Out Of SLA';
                }
                field(slaDate; Rec."SLA Date")
                {
                    Caption = 'SLA Date';
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                    Caption = 'Shipping Agent Code';
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    Caption = 'Shipping Agent Service Code';
                }
                field(unitOfMeasureCode; Rec."Unit Of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(quantityIssued; Rec."Quantity Issued")
                {
                    Caption = 'Quantity Issued';
                }
                field(quantityRemaining; Rec."Quantity Remaining")
                {
                    Caption = 'Quantity Remaining';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(lineAmount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(entitlement; Rec."Entitlement")
                {
                    Caption = 'Entitlement';
                }

                field(portalUserId; Rec."Portal User Id")
                {
                    Caption = 'Portal User Id';
                }
                field(approvedOutsideSLA; Rec."Approved Outside SLA")
                {
                    Caption = 'Approved Outside SLA';
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

    local procedure SetCalculatedFields()
    begin
        Rec.CalcFields(Entitlement, "Quantity Issued", "Quantity Remaining",
                        "Wardrobe ID", "Wardrobe SystemId",
                        "Staff ID", "Staff SystemId",
                        "Branch ID", "Branch SystemId",
                        "Approved Outside SLA");
    end;

}

