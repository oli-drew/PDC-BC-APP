/// <summary>
/// Page PDCAPI - Entitlement (ID 50105).
/// </summary>
page 50105 "PDCAPI - Entitlement"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Entitlement';
    EntitySetCaption = 'Entitlement';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'entitlement';
    EntitySetName = 'entitlement';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Staff Entitlement";
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
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';
                }
                field(branchNo; Rec."Branch No.")
                {
                    Caption = 'Branch No.';
                }
                field(branchSystemId; Rec."Branch SystemId")
                {
                    Caption = 'Branch SystemId';
                }
                field(staffId; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(staffSystemId; Rec."Staff SystemId")
                {
                    Caption = 'Staff SystemId';
                }
                field(wardrobeId; Rec."Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(wardrobeSystemId; Rec."Wardrobe SystemId")
                {
                    Caption = 'Wardrobe SystemId';
                }
                field(productCode; Rec."Product Code")
                {
                    Caption = 'Product Code';
                }
                field(itemType; Rec."Item Type")
                {
                    Caption = 'Item Type';
                }
                field(entitlementPeriod; Rec."Entitlement Period (Days)")
                {
                    Caption = 'Entitlement Period';
                }
                field(entitledInPeriod; Rec."Quantity Entitled in Period")
                {
                    Caption = 'Quantity Entitled in Period';
                }
                field(quantityPosted; Rec."Quantity Posted")
                {
                    Caption = 'Quantity Posted';
                }
                field(quantityOnOrder; Rec."Quantity on Order")
                {
                    Caption = 'Quantity on Order';
                }
                field(quantityOnReturn; Rec."Quantity on Return")
                {
                    Caption = 'Quantity on Return';
                }
                field(quantityOnDraftOrder; Rec."Quantity on Draft Order")
                {
                    Caption = 'Quantity on Draft Order';
                }
                field(quantityIssued; Rec."Calculated Quantity Issued")
                {
                    Caption = 'Calculated Quantity Issued';
                }
                field(quantityRemaining; Rec."Calc. Qty. Remaining in Period")
                {
                    Caption = '"Calc. Qty. Remaining in Period';
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
        Rec.CalcFields("Entitlement Period (Days)", "Quantity Entitled in Period", "Quantity Posted", "Quantity on Order", "Quantity on Return", "Item Type");
    end;

}

