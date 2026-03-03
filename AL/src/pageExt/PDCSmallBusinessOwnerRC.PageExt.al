/// <summary>
/// PageExtension PDCSmallBusinessOwnerRC (ID 50071) extends Record Small Business Owner RC.
/// </summary>
pageextension 50071 PDCSmallBusinessOwnerRC extends "Small Business Owner RC"
{
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
            group(PDCPortal)
            {
                Caption = 'Portal';

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
                action("PDC Draft Orders")
                {
                    Caption = 'Draft Orders';
                    ToolTip = 'Draft Orders';
                    RunObject = page "PDC Draft Orders";
                    ApplicationArea = All;
                }
                group("PDC Portal Administration")
                {
                    Caption = 'Portal Administration';

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
                }
            }
            group(PDCProposal)
            {
                Caption = 'Proposals';

                action("PDC Branding")
                {
                    Caption = 'Branding';
                    ToolTip = 'Branding';
                    ApplicationArea = All;
                    RunObject = page "PDC Branding";
                }
                action("PDC Proposal List")
                {
                    Caption = 'Proposals';
                    ToolTip = 'Proposals';
                    ApplicationArea = All;
                    RunObject = page "PDC Proposal List";
                }
                group("PDC Proposal Administration")
                {
                    Caption = 'Proposal Administration';

                    action("PDC Branding Position")
                    {
                        Caption = 'Branding Position';
                        ToolTip = 'Branding Position';
                        ApplicationArea = All;
                        RunObject = page "PDC Branding Position";
                    }
                    action("PDC Branding Type")
                    {
                        Caption = 'Branding Type';
                        ToolTip = 'Branding Type';
                        ApplicationArea = All;
                        RunObject = page "PDC Branding Type";
                    }
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
                    Image = Worksheet;
                    ApplicationArea = All;
                    RunObject = page "PDC Wardrobe Worksheet";
                }
                action("PDC Update Staff Entitlement")
                {
                    Caption = 'Update Staff Entitlement';
                    ToolTip = 'Update Staff Entitlement';
                    Image = Refresh;
                    ApplicationArea = All;
                    RunObject = report "PDC Update Staff Entitlement";
                }
            }
        }
    }
}
