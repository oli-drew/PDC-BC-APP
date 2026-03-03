/// <summary>
/// Page PDCAPI - Prod. Order Components (ID 50014).
/// </summary>
page 50014 "PDCAPI - Prod.Order Com. Sheet"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Prod. Order Comment Sheet';
    EntitySetCaption = 'Prod. Order Comments Sheet';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'prodOrderCommentSheet';
    EntitySetName = 'prodOrderCommentsSheet';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Prod. Order Comment Line";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(prodOrderStatus; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(prodOrderNo; Rec."Prod. Order No.")
                {
                    Caption = 'Prod. Order No';
                }
                field(date; Rec.Date)
                {
                    Caption = 'Date';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                }
            }
        }
    }
}