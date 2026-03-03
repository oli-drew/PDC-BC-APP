/// <summary>
/// Page PDC Draft Orders (ID 50031).
/// </summary>
page 50031 "PDC Draft Orders"
{
    Caption = 'Draft Orders';
    CardPageID = "PDC Draft Order";
    DataCaptionFields = "Document No.";
    Editable = false;
    PageType = List;
    SourceTable = "PDC Draft Order Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document No.';
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
                field(AddressType; Rec."Address Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Address Type';
                }
                field(ShippingType; Rec."Shipping Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipping Type';
                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Your Reference';
                }
                field(ShiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Code';
                }
                field(ShiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Name';
                }
                field(ShiptoName2; Rec."Ship-to Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Name 2';
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Address';
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Address 2';
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to City';
                }
                field(ShiptoContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Contact';
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Post Code';
                }
                field(ShiptoCounty; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to County';
                }
                field(ShiptoCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Ship-to Country/Region Code';
                }
                field(CreatedDate; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Created Date';
                }
                field(ModifiedDate; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Modified Date';
                }
                field(ApprovedOutsideSLA; Rec."Approved Outside SLA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approved Outside SLA';
                }
                field(AwaitingApproval; Rec."Awaiting Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Awaiting Approval';
                }
                field("Proceed Order"; Rec."Proceed Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Proceed Order';
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}
