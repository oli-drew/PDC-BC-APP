/// <summary>
/// PageExtension PDCOrderProcessorRoleCenter (ID 50068) extends Record Order Processor Role Center.
/// </summary>
pageextension 50068 PDCOrderProcessorRoleCenter extends "Order Processor Role Center"
{
    layout
    {
        modify("Intercompany Activities")
        {
            Visible = false;
        }
        modify(ApprovalsActivities)
        {
            Visible = false;
        }
        modify(Control14)
        {
            Visible = false;
        }
    }
    actions
    {
        addlast(Reporting)
        {
            group("PDC")
            {
                action("PDC Period Consolidated Invoice")
                {
                    Caption = 'Period Consolidated Invoice';
                    ToolTip = 'Period Consolidated Invoice';
                    Image = Invoice;
                    RunObject = report "PDC Period Consolid. Invoice";
                    ApplicationArea = All;
                }
            }
        }

        addlast(Sections)
        {
            group("PDC Portal")
            {
                action("PDC Branches")
                {
                    Caption = 'Branches';
                    ToolTip = 'Branches';
                    RunObject = page "PDC Branches";
                    ApplicationArea = All;
                }
                action("PDC Staff")
                {
                    Caption = 'Staff';
                    ToolTip = 'Staff';
                    RunObject = page "PDC Branch Staff List";
                    ApplicationArea = All;
                }
                action("PDC Staff Entitlement")
                {
                    Caption = 'Staff Entitlement';
                    ToolTip = 'Staff Entitlement';
                    RunObject = page "PDC Staff Entitlement List";
                    ApplicationArea = All;
                }
                action("PDC Wardrobes")
                {
                    Caption = 'Wardrobes';
                    ToolTip = 'Wardrobes';
                    RunObject = page "PDC Wardrobe List";
                    ApplicationArea = All;
                }
                action("PDC Wardrobes Lines List")
                {
                    Caption = 'Wardrobes Lines List';
                    ToolTip = 'Wardrobes Lines List';
                    RunObject = page "PDC Wardrobe Line List";
                    ApplicationArea = All;
                }
                action("PDC Draft Orders")
                {
                    Caption = 'Draft Orders';
                    ToolTip = 'Draft Orders';
                    RunObject = page "PDC Draft Orders";
                    ApplicationArea = All;
                }
                action("PDC Contracts")
                {
                    Caption = 'Contracts';
                    ToolTip = 'Contracts';
                    ApplicationArea = All;
                    RunObject = page "PDC Contracts";
                }
                group("PDC Administration")
                {
                    action("PDC NAV Portals")
                    {
                        Caption = 'NAV Portals';
                        ToolTip = 'NAV Portals';
                        ApplicationArea = All;
                        RunObject = page "PDC Nav Portal List";
                    }
                    action("PDC Portal Users")
                    {
                        Caption = 'Portal Users';
                        ToolTip = 'Portal Users';
                        ApplicationArea = All;
                        RunObject = page "PDC Portal User List";
                    }
                    action("PDC Portal Roles")
                    {
                        Caption = 'Portal Roles';
                        ToolTip = 'Portal Roles';
                        ApplicationArea = All;
                        RunObject = page "PDC Nav Portal Roles";
                    }
                    action("PDC Customer Staff Sync")
                    {
                        Caption = 'Customer Staff Sync';
                        ToolTip = 'Configure and monitor staff imports from Azure Blob Storage';
                        ApplicationArea = All;
                        RunObject = page "PDC Blob Staff Imp. Setup List";
                    }
                }
            }
            group("PDC Carbonfact")
            {
                Caption = 'Carbonfact';
                action("PDC CF Export Product Data")
                {
                    Caption = 'Export Product Data';
                    ToolTip = 'Export Carbonfact product data (Products, Packaging, BOM) as a 3-sheet Excel file.';
                    Image = ExportFile;
                    ApplicationArea = All;
                    RunObject = report "PDC CF Product Data Export";
                }
                action("PDC CF Export Purchase Orders")
                {
                    Caption = 'Export Purchase Orders';
                    ToolTip = 'Export Carbonfact purchase order data as an Excel file.';
                    Image = ExportFile;
                    ApplicationArea = All;
                    RunObject = report "PDC CF Purchase Export";
                }
                action("PDC CF Import CO2e")
                {
                    Caption = 'Import CO2e';
                    ToolTip = 'Import Carbonfact CO2e values from CSV and optionally propagate to production items.';
                    Image = ImportExcel;
                    ApplicationArea = All;
                    RunObject = report "PDC CF Import CO2e";
                }
            }
        }
        addlast(Processing)
        {
            group("PDC Portal Tasks")
            {
                action("PDC Wardrobe Worksheet")
                {
                    Caption = 'Wardrobe Worksheet';
                    ToolTip = 'Wardrobe Worksheet';
                    Image = Task;
                    ApplicationArea = All;
                    RunObject = page "PDC Wardrobe Worksheet";
                }
                action("PDC Update Staff Entitlement")
                {
                    Caption = 'Update Staff Entitlement';
                    ToolTip = 'Update Staff Entitlement';
                    Image = Task;
                    ApplicationArea = All;
                    RunObject = report "PDC Update Staff Entitlement";
                }
            }
        }
    }
}
