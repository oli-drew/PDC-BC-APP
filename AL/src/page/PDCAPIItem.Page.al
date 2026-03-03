/// <summary>
/// Page PDCAPI - Item (ID 50114).
/// </summary>
page 50114 "PDCAPI - Item"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Item';
    EntitySetCaption = 'Items';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'item';
    EntitySetName = 'items';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Item";
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
                field(itemNo; Rec."No.")
                {
                    Caption = 'Item No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure';
                }
                field(productCode; Rec."PDC Product Code")
                {
                    Caption = 'Product Code';
                }
                field(productGroupCode; Rec."Item Category Code")
                {
                    Caption = 'Product Group Code';
                }
                field(colourCode; Rec."PDC Colour")
                {
                    Caption = 'Colour';
                }
                field(colour; Rec."PDC Colour Description")
                {
                    Caption = 'Colour';
                }
                field(sizeCode; Rec."PDC Size")
                {
                    Caption = 'Size';
                }
                field(size; Rec."PDC Size Description")
                {
                    Caption = 'Size';
                }
                field(fitCode; Rec."PDC Fit")
                {
                    Caption = 'Fit';
                }
                field(fit; Rec."PDC Fit Description")
                {
                    Caption = 'Fit';
                }
                field(styleCode; Rec."PDC Style")
                {
                    Caption = 'Style';
                }
                field(style; Rec."PDC Style Description")
                {
                    Caption = 'Style';
                }
            }
        }
    }

    actions
    {
    }

}

