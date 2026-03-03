/// <summary>
/// Page PDC APIV2 - Staff (ID 50106).
/// </summary>
page 50106 "PDCAPI - Staff"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Staff';
    EntitySetCaption = 'Staff';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'staff';
    EntitySetName = 'staff';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Branch Staff";
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
                field(stuffId; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(customerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';
                }
                field(branchId; Rec."Branch ID")
                {
                    Caption = 'Branch ID';
                }
                field(branchSystemId; Rec."Branch SystemId")
                {
                    Caption = 'Branch SystemId';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(firstName; Rec."First Name")
                {
                    Caption = 'First Name';
                }
                field(lastName; Rec."Last Name")
                {
                    Caption = 'Last Name';
                }
                field(bodyTypeGender; Rec."Body Type/Gender")
                {
                    Caption = 'Body Type/Gender';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(wearerId; Rec."Wearer ID")
                {
                    Caption = 'Wearer ID';
                }
                field(wardrobeId; Rec."Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(wardrobeSystemId; Rec."Wardrobe SystemId")
                {
                    Caption = 'Wardrobe SystemId';
                }
                field(contractId; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                }
                field(contractSystemId; Rec."Contract SystemId")
                {
                    Caption = 'Contract SystemId';
                }
            }
        }
    }

    actions
    {
    }

}

