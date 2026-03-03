/// <summary>
/// Page PDCAPI - Wardrobe (ID 50108).
/// </summary>
page 50108 "PDCAPI - Wardrobe"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Wardrobe';
    EntitySetCaption = 'Wardrobes';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'wardrobe';
    EntitySetName = 'wardrobes';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Wardrobe Header";
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
                field(wardrobeId; Rec."Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                part(lines; "PDCAPI - WardrobeLine")
                {
                    Caption = 'Lines';
                    EntityName = 'wardrobeline';
                    EntitySetName = 'wardrobelines';
                    SubPageLink = "Wardrobe SystemId" = field(SystemId);
                }
            }
        }
    }

    actions
    {
    }

}

