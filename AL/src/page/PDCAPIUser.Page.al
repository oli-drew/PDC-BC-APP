/// <summary>
/// Page PDCAPI - User (ID 50107).
/// </summary>
page 50107 "PDCAPI - User"
{
    APIVersion = 'v2.0';
    EntityCaption = 'User';
    EntitySetCaption = 'Users';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'user';
    EntitySetName = 'users';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Portal User";
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
                field(userId; Rec."ID")
                {
                    Caption = 'User ID';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
            }
        }
    }

    actions
    {
    }

}

