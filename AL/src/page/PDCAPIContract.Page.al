/// <summary>
/// Page PDCAPI - Contract (ID 50101).
/// </summary>
page 50101 "PDCAPI - Contract"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Contract';
    EntitySetCaption = 'Contracts';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'contract';
    EntitySetName = 'contracts';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Contract";
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
                field(contractNo; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';
                }
                field(contractCode; Rec."Contract Code")
                {
                    Caption = 'Contract Code';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(defaultContract; Rec."Default Contract")
                {
                    Caption = 'Default Contract';
                }
            }
        }
    }

    actions
    {
    }

}

