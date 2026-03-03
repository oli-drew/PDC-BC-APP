/// <summary>
/// Page PDCAPI - DraftOrdStaffLine (ID 50104).
/// </summary>
page 50104 "PDCAPI - DraftOrdStaffLine"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Draft Order Staff Line';
    EntitySetCaption = 'Draft Order Staff Lines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'draftorderstaffline';
    EntitySetName = 'draftorderstafflines';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Draft Order Staff Line";
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
                field(staffID; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(staffName; Rec."Staff Name")
                {
                    Caption = 'Staff Name';
                }
                field(staffSystemId; Rec."Staff SystemId")
                {
                    Caption = 'Staff SystemId';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Cuctomer Id';
                }
                field(branchID; Rec."Branch ID")
                {
                    Caption = 'Branch ID';
                }
                field(branchName; Rec."Branch Name")
                {
                    Caption = 'Branch Name';
                }
                field(branchSystemId; Rec."Branch SystemId")
                {
                    Caption = 'Branch SystemId';
                }
                field(contractID; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(contractSystemId; Rec."Contract SystemId")
                {
                    Caption = 'Contract SystemId';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(poNo; Rec."PO No.")
                {
                    Caption = 'PO No.';
                }
                field(reasonCode; Rec."Reason Code")
                {
                    Caption = 'Reason Code';
                }
                field(bodyTypeGender; Rec."Body Type/Gender")
                {
                    Caption = 'Body Type/Gender';
                }
                field(wardrobeID; Rec."Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(wardrobeName; Rec."Wardrobe Name")
                {
                    Caption = 'Wardrobe Name';
                }
                field(wardrobeSystemId; Rec."Wardrobe SystemId")
                {
                    Caption = 'Wardrobe SystemId';
                }
                field(wearerID; Rec."Wearer ID")
                {
                    Caption = 'Wearer ID';
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
        Rec.CalcFields("Customer No.", "Customer Id",
                        "Wardrobe ID", "Wardrobe Name", "Wardrobe SystemId",
                        "Body Type/Gender", "Wearer ID",
                        "Branch ID", "Branch Name", "Branch SystemId",
                        "Contract ID", "Contract SystemId");
    end;

}

