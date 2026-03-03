/// <summary>
/// PageExtension PDCItemCard (ID 50005) extends Record Item Card.
/// </summary>
pageextension 50005 PDCItemCard extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field(PDCProductCode; Rec."PDC Product Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'ProductCode';
            }
        }
        addafter(Inventory)
        {
            field(PDCVendorInventory; Rec."PDC Vendor Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'VendorInventory';
            }
            field(PDCComponentInventory; Rec.CalcComponentInventory())
            {
                Caption = 'Components Inventory';
                ToolTip = 'Components Inventory';
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Rec.ShowComponentInventory();
                end;
            }
        }
        addafter("Qty. on Purch. Order")
        {
            field(PDCQtyOnProdPurchOrder; Rec."PDC Qty. on Prod. Purch. Order")
            {
                ApplicationArea = All;
                ToolTip = 'QtyOnProdPurchOrder';
            }
        }
        addafter("Qty. on Sales Order")
        {
            field(PDCQtytoShip; Rec."PDC Qty. to Ship")
            {
                ApplicationArea = All;
                ToolTip = 'QtytoShip';
            }
        }
        addafter(PreventNegInventoryDefaultNo)
        {
            field(PDCZeroPriceBlock; Rec."PDC Zero Price Block")
            {
                ApplicationArea = All;
                ToolTip = 'ZeroPriceBlock';
            }
            field(PDCFOC; Rec."PDC FOC")
            {
                ApplicationArea = All;
                ToolTip = 'FOC';
            }
            field(PDCVariablePrice; Rec."PDC Variable Price")
            {
                ApplicationArea = All;
                ToolTip = 'VariablePrice';
            }
            field("PDC Contract Item"; Rec."PDC Contract Item")
            {
                ApplicationArea = All;
                ToolTip = 'Contract Item';
            }
            field(PDCSLA; Rec."PDC SLA")
            {
                ApplicationArea = All;
                ToolTip = 'SLA';
            }
            field(PDCReturnPeriod; Rec."PDC Return Period")
            {
                ApplicationArea = All;
                ToolTip = 'ReturnPeriod';
            }
            group(PDCProperties)
            {
                Caption = 'Properties';
                field(PDCStyle; Rec."PDC Style")
                {
                    ApplicationArea = All;
                    ToolTip = 'Style';
                }
                field(PDCColour; Rec."PDC Colour")
                {
                    ApplicationArea = All;
                    ToolTip = 'Colour';
                }
                field(PDCFit; Rec."PDC Fit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Fit';
                }
                field(PDCSize; Rec."PDC Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size';
                }
                field(PDCProduct; Rec."PDC Product")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Product';
                }
                field(PDCProductDescription; Rec."PDC Product Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'ProductDescription';
                }
                field(PDCStyleDescription; Rec."PDC Style Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'StyleDescription';
                }
                field(PDCStyleSequence; Rec."PDC Style Sequence")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'StyleSequence';
                }
                field(PDCColourDescription; Rec."PDC Colour Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'ColourDescription';
                }
                field(PDCColourSequence; Rec."PDC Colour Sequence")
                {
                    ApplicationArea = All;
                    ToolTip = 'ColourSequence';
                }
                field(PDCSizeDescription; Rec."PDC Size Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'SizeDescription';
                }
                field(PDCSizeSequence; Rec."PDC Size Sequence")
                {
                    ApplicationArea = All;
                    ToolTip = 'SizeSequence';
                }
                field(PDCFitDescription; Rec."PDC Fit Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'FitDescription';
                }
                field(PDCFitSequence; Rec."PDC Fit Sequence")
                {
                    ApplicationArea = All;
                    ToolTip = 'FitSequence';
                }
                field(PDCBrandingDescription; Rec."PDC Branding Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'BrandingDescription';
                }
                field(PDCDemandPlanningGroup; Rec."PDC Demand Planning Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'DemandPlanningGroup';
                }
                field(PDCWebPicturePath; Rec."PDC Web Picture Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'WebPicturePath';
                }
                field(PDCSizeScaleCode; Rec."PDC Size Scale Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'SizeScaleCode';
                }
                field(PDCCustomerNo; Rec."PDC Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'CustomerNo';
                }
                field(PDCGender; Rec."PDC Gender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Gender';
                }
                field(PDCSizeGroup; Rec."PDC Size Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'SizeGroup';
                }
                field("PDC Carbon Emissions CO2e"; Rec."PDC Carbon Emissions CO2e")
                {
                    ApplicationArea = All;
                    ToolTip = 'CarbonEmissionsCO2e';
                }
                field("PDC Carbonfact Enabled"; Rec."PDC Carbonfact Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this item is included in Carbonfact exports for CO2 calculation.';
                }
            }
        }
        addafter("Lead Time Calculation")
        {
            field(PDCSource; Rec."PDC Source")
            {
                ApplicationArea = All;
                ToolTip = 'Source';
            }
        }
        addafter("Purch. Unit of Measure")
        {
            field(PDCPrepaid; Rec."PDC Prepaid")
            {
                ApplicationArea = All;
                Caption = 'Prepaid?';
                ToolTip = 'Prepaid?';
            }
        }
    }
    actions
    {
        addafter(Identifiers)
        {
            action("PDC Demand Product")
            {
                ApplicationArea = All;
                Caption = 'Demand Product';
                ToolTip = 'Demand Product';
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.OpenDemandProduct();
                end;
            }
        }
        addlast(Processing)
        {
            action(PDCItemLabel)
            {
                ApplicationArea = All;
                Caption = 'Print Item Label';
                ToolTip = 'Print Item Label';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    Item.get(Rec."No.");
                    Item.SetRecFilter();
                    report.Run(report::"PDC Item Labels", true, false, item);
                end;
            }
        }
    }

}

