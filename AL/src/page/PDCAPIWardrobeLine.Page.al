/// <summary>
/// Page PDCAPI - WardrobeLine (ID 50109).
/// </summary>
page 50109 "PDCAPI - WardrobeLine"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Wardrobe Line';
    EntitySetCaption = 'Wardrobe Lines';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'wardrobeline';
    EntitySetName = 'wardrobelines';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Wardrobe Line";
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
                field(wardrobeSystemId; Rec."Wardrobe SystemId")
                {
                    Caption = 'Wardrobe SystemId';
                }
                field(wardrobeId; Rec."Wardrobe ID")
                {
                    Caption = 'Wardrobe ID';
                }
                field(itemType; Rec."Item Type")
                {
                    Caption = 'Item Type';
                }
                field(productCode; Rec."Product Code")
                {
                    Caption = 'Product Code';
                }
                field(itemGender; Rec."Item Gender")
                {
                    Caption = 'Item Gender';
                }
                field(entitlementPeriod; Rec."Entitlement Period")
                {
                    Caption = 'Entitlement Period';
                }
                field(entitledInPeriod; Rec."Quantity Entitled in Period")
                {
                    Caption = 'Quantity Entitled in Period';
                }
            }
        }
    }

    actions
    {
    }

}

