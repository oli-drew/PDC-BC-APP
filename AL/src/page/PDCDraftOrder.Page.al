/// <summary>
/// Page PDC Draft Order (ID 50032).
/// </summary>
page 50032 "PDC Draft Order"
{
    Caption = 'Draft Order';
    DataCaptionFields = "Document No.";
    PageType = Card;
    SourceTable = "PDC Draft Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ToolTip = 'Document No.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit(); //DOC PDCP16 JF 11/07/2017 -+
                    end;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Customer No.';
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Customer Name';
                }
                field(SelltoCustomerName2; Rec."Sell-to Customer Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Customer Name 2';
                }
                field(SelltoAddress; Rec."Sell-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Address';
                }
                field(SelltoAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Address 2';
                }
                field(SelltoCity; Rec."Sell-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to City';
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Contact';
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Post Code';
                }
                field(SelltoCounty; Rec."Sell-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to County';
                }
                field(SelltoCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sell-to Country/Region Code';
                }
                field(ShippingType; Rec."Shipping Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipping Type';
                }
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'PO No.';
                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Your Reference';
                    Importance = Additional;
                }
                field(ApprovedOutsideSLA; Rec."Approved Outside SLA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approved Outside SLA';
                }
                field(ShiptoEMail; Rec."Ship-to E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to E-Mail';
                }
                field(ShiptoMobilePhoneNo; Rec."Ship-to Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Mobile Phone No.';
                }
                field(AwaitingApproval; Rec."Awaiting Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Awaiting Approval';
                }
                field("Awaiting Approval DT"; Rec."Awaiting Approval DT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Awaiting Approval DT';
                }
            }
            part(DraftOrderStaffLines; "PDC Draft Order Staff Lines")
            {
                SubPageLink = "Document No." = field("Document No.");
                ApplicationArea = All;
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field(AddressType; Rec."Address Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Address Type';

                    trigger OnValidate()
                    begin
                        SetEditability(); //DOC PDCP16 JF 11/07/2017 -+
                    end;
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Code';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Name';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoName2; Rec."Ship-to Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Name 2';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Address';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Address 2';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to City';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Contact';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Post Code';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoCounty; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to County';
                    Editable = ShippingAddressEditable;
                }
                field(ShiptoCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Country/Region Code';
                    Editable = ShippingAddressEditable;
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Process)
            {
                Caption = 'Process';
                ToolTip = 'Process';
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CODEUNIT.RUN(CODEUNIT::"PDC Draft Order Process", Rec);
                end;
            }
            action(Print)
            {
                ApplicationArea = All;
                Caption = '&Print';
                ToolTip = 'Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DraftHeader: Record "PDC Draft Order Header";
                begin
                    CurrPage.SetSelectionFilter(DraftHeader);
                    Report.Run(Report::"PDC Portal - Draft Order", true, false, DraftHeader);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetEditability();
    end;

    var
        ShippingAddressEditable: Boolean;

    local procedure SetEditability()
    begin
        ShippingAddressEditable := Rec."Address Type" = Rec."Address Type"::"Saved Address";
    end;
}
