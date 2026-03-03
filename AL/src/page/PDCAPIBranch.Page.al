/// <summary>
/// Page PDCAPI - Branch (ID 50100).
/// </summary>
page 50100 "PDCAPI - Branch"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Branch';
    EntitySetCaption = 'Branches';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'branch';
    EntitySetName = 'branches';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Branch";
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
                field(branchNo; Rec."Branch No.")
                {
                    Caption = 'Wardrobe ID';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(city; rec.City)
                {
                    Caption = 'City';
                }
                field(defaultBranch; Rec."Default Branch")
                {
                    Caption = 'Default Branch';
                }
            }
        }
    }

    actions
    {
    }

}

