/// <summary>
/// Page PDCAPI - Draft Order (ID 50102).
/// </summary>
page 50102 "PDCAPI - Draft Order"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Draft Order';
    EntitySetCaption = 'Draft Orders';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'draftorder';
    EntitySetName = 'draftorders';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "PDC Draft Order Header";
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
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(customerId; Rec."Customer Id")
                {
                    Caption = 'Customer Id';
                }
                field(sellToAddress; Rec."Sell-to Address")
                {
                    Caption = 'Sell-to Address';
                }
                field(sellToAddress2; Rec."Sell-to Address 2")
                {
                    Caption = 'Sell-to Address 2';
                }
                field(sellToCity; Rec."Sell-to City")
                {
                    Caption = 'Sell-to City';
                }
                field(sellToContact; Rec."Sell-to Contact")
                {
                    Caption = 'Sell-to Contact';
                }
                field(sellToCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Sell-to Country/Region Code';
                }
                field(sellToCounty; Rec."Sell-to County")
                {
                    Caption = 'Sell-to County';
                }
                field(sellToCustomerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Sell-to Customer Name';
                }
                field(sellToCustomerName2; Rec."Sell-to Customer Name 2")
                {
                    Caption = 'Sell-to Customer Name 2';
                }
                field(shipToCode; Rec."Ship-to Code")
                {
                    Caption = 'Ship-to Code';
                }
                field(shipToId; Rec."Ship-to Id")
                {
                    Caption = 'Ship-to Id';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                }
                field(shipToName2; Rec."Ship-to Name 2")
                {
                    Caption = 'Ship-to Name 2';
                }
                field(shipToAddress; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                }
                field(shipToAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(shipToCounty; Rec."Ship-to County")
                {
                    Caption = 'Ship-to County';
                }
                field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';
                }
                field(sellToPostCode; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }
                field(shipToEMail; Rec."Ship-to E-Mail")
                {
                    Caption = 'Ship-to E-Mail';
                }
                field(shipToMobilePhoneNo; Rec."Ship-to Mobile Phone No.")
                {
                    Caption = 'Ship-to Mobile Phone No.';
                }
                field(requestedShipmentDate; Rec."Requested Shipment Date")
                {
                    Caption = 'Requested Shipment Date';
                }
                field(addressType; Rec."Address Type")
                {
                    Caption = 'Address Type';
                }
                field(approvedOutsideSLA; Rec."Approved Outside SLA")
                {
                    Caption = 'Approved Outside SLA';
                }
                field(awaitingApproval; Rec."Awaiting Approval")
                {
                    Caption = 'Awaiting Approval';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(yourReference; Rec."Your Reference")
                {
                    Caption = 'Your Reference';
                }
                field(poNo; Rec."PO No.")
                {
                    Caption = 'PO No.';
                }
                field(isHomeAddress; Rec."Is Home Ship-To Address")
                {
                    Caption = 'Is Home Ship-To Address';
                }
                field(proceedOrder; Rec."Proceed Order")
                {
                    Caption = 'Proceed Order';
                }
                field(shippingType; Rec."Shipping Type")
                {
                    Caption = 'Shipping Type';
                }
                part(stafflines; "PDCAPI - DraftOrdStaffLine")
                {
                    Caption = 'Lines';
                    EntityName = 'draftorderstaffline';
                    EntitySetName = 'draftorderstafflines';
                    SubPageLink = "Document Id" = field(SystemId);
                }
                part(itemlines; "PDCAPI - DraftOrdItemLine")
                {
                    Caption = 'Lines';
                    EntityName = 'draftorderitemline';
                    EntitySetName = 'draftorderitemlines';
                    SubPageLink = "Document Id" = field(SystemId);
                }
            }
        }
    }

    actions
    {
    }

}

