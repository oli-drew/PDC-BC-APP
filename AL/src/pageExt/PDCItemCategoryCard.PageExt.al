/// <summary>
/// PageExtension PDCItemCategoryCard (ID 50042) extends Record Item Category Card.
/// </summary>
pageextension 50042 PDCItemCategoryCard extends "Item Category Card"
{
    layout
    {
        addafter(Attributes)
        {
            part(PDCLines; "PDC Item Category Lines")
            {
                SubPageLink = "Item Category Code" = field("Code");
                ApplicationArea = All;
            }
            group(PDCCarbonfact)
            {
                Caption = 'Carbonfact';
                group(PDCCFLifecycle)
                {
                    Caption = 'Lifecycle';
                    field("PDC CF Category"; Rec."PDC CF Category")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the Carbonfact product category (e.g. Vest, Waistcoat).';
                    }
                    field("PDC CF Lifecycle Weeks"; Rec."PDC CF Lifecycle Weeks")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the expected product lifecycle in weeks.';
                    }
                    field("PDC CF No. of Wears"; Rec."PDC CF No. of Wears")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the expected number of wears.';
                    }
                    field("PDC CF Uses per Wash"; Rec."PDC CF Uses per Wash")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of uses between washes.';
                    }
                    field("PDC CF Tumble Dried %"; Rec."PDC CF Tumble Dried %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the fraction of garments tumble dried (e.g. 0.3 = 30%).';
                    }
                    field("PDC CF End Life Recycled %"; Rec."PDC CF End Life Recycled %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the end-of-life recycled fraction.';
                    }
                    field("PDC CF End Life Waste %"; Rec."PDC CF End Life Waste %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the end-of-life waste fraction.';
                    }
                }
                group(PDCCFPkgBag)
                {
                    Caption = 'Packaging - Bag';
                    field("PDC CF Pkg Bag Material"; Rec."PDC CF Pkg Bag Material")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the bag packaging material (e.g. Recycled polyethylene).';
                    }
                    field("PDC CF Pkg Bag Type"; Rec."PDC CF Pkg Bag Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the bag packaging type (e.g. Polybag).';
                    }
                    field("PDC CF Pkg Bag Mass Kg"; Rec."PDC CF Pkg Bag Mass Kg")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the bag packaging mass in kilograms.';
                    }
                }
                group(PDCCFPkgCarton)
                {
                    Caption = 'Packaging - Carton';
                    field("PDC CF Pkg Carton Material"; Rec."PDC CF Pkg Carton Material")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the carton packaging material (e.g. Recycled Cardboard).';
                    }
                    field("PDC CF Pkg Carton Type"; Rec."PDC CF Pkg Carton Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the carton packaging type (e.g. Outer Carton).';
                    }
                    field("PDC CF Pkg Carton Mass Kg"; Rec."PDC CF Pkg Carton Mass Kg")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the carton packaging mass in kilograms.';
                    }
                }
                group(PDCCFBOM)
                {
                    Caption = 'BOM';
                    field("PDC CF BOM Loss Rate %"; Rec."PDC CF BOM Loss Rate %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the manufacturing loss rate percentage.';
                    }
                }
                group(PDCCFDefaults)
                {
                    Caption = 'Defaults';
                    field("PDC CF Default Care Label"; Rec."PDC CF Default Care Label")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the default care label composition for this category.';
                    }
                    field("PDC CF Default Mass"; Rec."PDC CF Default Mass")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the default net weight in kilograms.';
                    }
                    field("PDC CF Default COO"; Rec."PDC CF Default COO")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the default Country of Origin code.';
                    }
                    field("PDC CF Default Tariff Code"; Rec."PDC CF Default Tariff Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the default commodity/tariff code.';
                    }
                }
            }
        }
    }
    actions
    {
    }
}

