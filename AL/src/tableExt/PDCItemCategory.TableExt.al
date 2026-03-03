/// <summary>
/// TableExtension PDCItemCategoryCF (ID 50058) extends Record Item Category.
/// Adds Carbonfact lifecycle, packaging, BOM, and default fields.
/// </summary>
tableextension 50058 PDCItemCategoryCF extends "Item Category"
{
    fields
    {
        field(50000; "PDC CF Category"; Text[50])
        {
            Caption = 'CF Category';
            ToolTip = 'Specifies the Carbonfact product category (e.g. Vest, Waistcoat). This is NOT the BC Item Category.';
            DataClassification = CustomerContent;
        }
        field(50001; "PDC CF Lifecycle Weeks"; Integer)
        {
            Caption = 'CF Lifecycle Weeks';
            ToolTip = 'Specifies the expected product lifecycle in weeks for Carbonfact.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50002; "PDC CF No. of Wears"; Integer)
        {
            Caption = 'CF No. of Wears';
            ToolTip = 'Specifies the expected number of wears for Carbonfact lifecycle calculation.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50003; "PDC CF Uses per Wash"; Integer)
        {
            Caption = 'CF Uses per Wash';
            ToolTip = 'Specifies the number of uses between washes for Carbonfact lifecycle calculation.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50004; "PDC CF Tumble Dried %"; Decimal)
        {
            Caption = 'CF Tumble Dried %';
            ToolTip = 'Specifies the fraction of garments tumble dried (e.g. 0.3 = 30%).';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 1;
            DecimalPlaces = 0 : 2;
        }
        field(50005; "PDC CF End Life Recycled %"; Decimal)
        {
            Caption = 'CF End of Life Recycled %';
            ToolTip = 'Specifies the end-of-life recycled fraction (e.g. 0.5 = 50%).';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 1;
            DecimalPlaces = 0 : 2;
        }
        field(50006; "PDC CF End Life Waste %"; Decimal)
        {
            Caption = 'CF End of Life Waste %';
            ToolTip = 'Specifies the end-of-life waste fraction (e.g. 0.5 = 50%).';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 1;
            DecimalPlaces = 0 : 2;
        }
        field(50007; "PDC CF Pkg Bag Material"; Text[50])
        {
            Caption = 'CF Pkg Bag Material';
            ToolTip = 'Specifies the bag packaging material for Carbonfact (e.g. Recycled polyethylene).';
            DataClassification = CustomerContent;
        }
        field(50008; "PDC CF Pkg Bag Type"; Text[50])
        {
            Caption = 'CF Pkg Bag Type';
            ToolTip = 'Specifies the bag packaging type for Carbonfact (e.g. Polybag).';
            DataClassification = CustomerContent;
        }
        field(50009; "PDC CF Pkg Bag Mass Kg"; Decimal)
        {
            Caption = 'CF Pkg Bag Mass (Kg)';
            ToolTip = 'Specifies the bag packaging mass in kilograms for Carbonfact.';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }
        field(50010; "PDC CF BOM Loss Rate %"; Decimal)
        {
            Caption = 'CF BOM Loss Rate %';
            ToolTip = 'Specifies the manufacturing loss rate percentage for Carbonfact BOM calculation.';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 2;
        }
        field(50011; "PDC CF Pkg Carton Material"; Text[50])
        {
            Caption = 'CF Pkg Carton Material';
            ToolTip = 'Specifies the carton packaging material for Carbonfact (e.g. Recycled Cardboard).';
            DataClassification = CustomerContent;
        }
        field(50012; "PDC CF Pkg Carton Type"; Text[50])
        {
            Caption = 'CF Pkg Carton Type';
            ToolTip = 'Specifies the carton packaging type for Carbonfact (e.g. Outer Carton).';
            DataClassification = CustomerContent;
        }
        field(50013; "PDC CF Pkg Carton Mass Kg"; Decimal)
        {
            Caption = 'CF Pkg Carton Mass (Kg)';
            ToolTip = 'Specifies the carton packaging mass in kilograms for Carbonfact.';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }
        field(50014; "PDC CF Default Care Label"; Text[250])
        {
            Caption = 'CF Default Care Label';
            ToolTip = 'Specifies the default care label composition for this category. Used as fallback when an item has no fabric attributes.';
            DataClassification = CustomerContent;
        }
        field(50015; "PDC CF Default Mass"; Decimal)
        {
            Caption = 'CF Default Mass (Kg)';
            ToolTip = 'Specifies the default net weight in kilograms. Used as fallback when an item has no mass.';
            DataClassification = CustomerContent;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }
        field(50016; "PDC CF Default COO"; Code[10])
        {
            Caption = 'CF Default Country of Origin';
            ToolTip = 'Specifies the default Country of Origin code. Used as fallback when an item has no COO.';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(50017; "PDC CF Default Tariff Code"; Code[20])
        {
            Caption = 'CF Default Tariff Code';
            ToolTip = 'Specifies the default commodity/tariff code. Used as fallback when an item has no tariff code.';
            DataClassification = CustomerContent;
            TableRelation = "Tariff Number";
        }
    }
}
