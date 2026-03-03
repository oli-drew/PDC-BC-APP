/// <summary>
/// XmlPort PDC Portal User Card (ID 50035).
/// </summary>
xmlport 50035 "PDC Portal User Card"
{

    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            tableelement(user; "PDC Portal User")
            {
                MinOccurs = Zero;
                XmlName = 'user';
                UseTemporary = true;
                fieldelement(userid; User.Id)
                {
                    MinOccurs = Zero;
                }
                fieldelement(username; User."User Name")
                {
                    MinOccurs = Zero;
                }
                fieldelement(name; User.Name)
                {
                    MinOccurs = Zero;
                }
                fieldelement(phoneno; User."Phone No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(email; User."E-Mail")
                {
                    MinOccurs = Zero;
                }
                fieldelement(defaultshiptocode; User."Default Ship-to Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(poperwearer; User."PO per Wearer")
                {
                    MinOccurs = Zero;
                }
                fieldelement(entitlementreport; User."Entitlement Email Report")
                {
                    MinOccurs = Zero;
                }
                textelement(role)
                {
                    MinOccurs = Zero;
                }
                textelement(userfinances)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowfinances';
                }
                textelement(userorders)
                {
                    MinOccurs = Zero;
                    XmlName = 'alloworders';
                }
                textelement(userreturns)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowreturns';
                }
                textelement(userstaff)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowstaff';
                }
                textelement(usercontracts)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowcontracts';
                }
                textelement(usergeneralreports)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowgeneralreports';
                }
                textelement(userfinancialreports)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowfinancialreports';
                }
                textelement(userallowentitlement)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowentitlement';
                }
                textelement(userallowcheckout)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowcheckout';
                }
                textelement(userallowwardrobe)
                {
                    MinOccurs = Zero;
                    XmlName = 'allowwardrobe';
                }
                textelement(staffAllBranches)
                {
                    MinOccurs = Zero;
                }
                textelement(staffRequestApprove)
                {
                    MinOccurs = Zero;
                }
                textelement(staffRequestCreate)
                {
                    MinOccurs = Zero;
                }
                textelement(addressCreate)
                {
                    MinOccurs = Zero;
                }
                textelement(addressEdit)
                {
                    MinOccurs = Zero;
                }
                textelement(addressListCompany)
                {
                    MinOccurs = Zero;
                }
                textelement(addressListBranch)
                {
                    MinOccurs = Zero;
                }
                textelement(staffCreate)
                {
                    MinOccurs = Zero;
                }
                textelement(staffEdit)
                {
                    MinOccurs = Zero;
                }
                fieldelement(staffID; User."Staff ID")
                {
                    MinOccurs = Zero;
                }
                // fieldelement(adminid; User.AdminID)
                // {
                //     MinOccurs = Zero;
                // }
                fieldelement(userType; User."User Type")
                {
                    MinOccurs = Zero;
                }
                fieldelement(allowApprovalEmail; User."Allow Approval Email")
                {
                    MinOccurs = Zero;
                }
                textelement(allowBulkOrder)
                {
                    MinOccurs = Zero;
                }
                tableelement(adminlist; "PDC Portal User")
                {
                    MinOccurs = Zero;
                    XmlName = 'admins';
                    UseTemporary = true;
                    textattribute(jsonarray)
                    {
                        Occurrence = Optional;
                        XmlName = 'json_Array';

                        trigger OnBeforePassVariable()
                        begin
                            jsonArray := 'true';
                        end;
                    }
                    fieldelement(adminuserid; AdminList.Id)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(adminusername; AdminList.Name)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(adminuseremail; AdminList."E-Mail")
                    {
                        MinOccurs = Zero;
                    }
                }
                tableelement(portaluserbranch; "PDC Branch")
                {
                    MinOccurs = Zero;
                    XmlName = 'branches';
                    UseTemporary = true;
                    SourceTableView = sorting("Presentation Order");

                    textattribute(jsonarray2)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(branchId; portaluserbranch."Branch No.")
                    {
                    }
                    fieldelement(branchName; portaluserbranch.Name)
                    {
                    }
                    fieldelement(indentation; portaluserbranch.Indentation)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PortalRole: Record "PDC Portal Role";
                    NavPortalMgt: Codeunit "PDC Portals Management";
                begin
                    NavPortalMgt.GetUserMergedRole(User, PortalRole);
                    role := PortalRole.Description;
                    userFinances := Format(PortalRole.Finances, 0, 9);
                    userOrders := Format(PortalRole.Orders, 0, 9);
                    userReturns := Format(PortalRole.Returns, 0, 9);
                    userStaff := Format(PortalRole.Staff, 0, 9);
                    userContracts := Format(PortalRole.Contracts, 0, 9);
                    userGeneralReports := Format(PortalRole."General Reports", 0, 9);
                    userFinancialReports := Format(PortalRole."Financial Reports", 0, 9);
                    userAllowEntitlement := Format(PortalRole.Entitlement, 0, 9);
                    userAllowCheckout := Format(PortalRole.Checkout, 0, 9);
                    userAllowWardrobe := Format(PortalRole.Wardrobe, 0, 9);
                    staffAllBranches := Format(PortalRole."All Branches", 0, 9);
                    staffRequestApprove := Format(PortalRole."Staff Request Approve", 0, 9);
                    staffRequestCreate := Format(PortalRole."Staff Request Create", 0, 9);
                    addressCreate := Format(PortalRole."Address Create", 0, 9);
                    addressEdit := Format(PortalRole."Address Edit", 0, 9);
                    addressListCompany := Format(PortalRole."Address List Company", 0, 9);
                    addressListBranch := Format(PortalRole."Address List Branch", 0, 9);
                    staffCreate := Format(PortalRole."Staff Create", 0, 9);
                    staffEdit := Format(PortalRole."Staff Edit", 0, 9);
                    allowBulkOrder := Format(PortalRole."Bulk Order", 0, 9);
                end;
            }
        }
    }

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var NavPortalUser: Record "PDC Portal User")
    var
        NavPortalUser1: Record "PDC Portal User";
        PortalMgt: Codeunit "PDC Portals Management";
    begin
        User.DeleteAll();
        User := NavPortalUser;
        User.Insert();

        AdminList.Reset();
        AdminList.DeleteAll();
        if User."User Type" <> User."User Type"::Approver then begin
            NavPortalUser1.SetRange("Customer No.", User."Customer No.");
            NavPortalUser1.SetRange("User Type", User."User Type"::Approver);
            NavPortalUser1.SetFilter("E-Mail", '<>%1', '');
            if NavPortalUser1.Findset() then
                repeat
                    AdminList.Init();
                    AdminList := NavPortalUser1;
                    AdminList.Insert();
                until NavPortalUser1.next() = 0;
        end;

        PortalMgt.GetPortalUserBranchList(portaluserbranch, NavPortalUser);
    end;

    /// <summary>
    /// UpdateUser.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure UpdateUser(var NavPortalUser: Record "PDC Portal User")
    begin
        if User.FindFirst() then begin
            NavPortalUser.Name := User.Name;
            NavPortalUser."Phone No." := User."Phone No.";
            NavPortalUser."E-Mail" := User."E-Mail";
            NavPortalUser."Default Ship-to Code" := User."Default Ship-to Code";
            NavPortalUser."PO per Wearer" := User."PO per Wearer";
            NavPortalUser."Entitlement Email Report" := User."Entitlement Email Report";
            NavPortalUser."Allow Approval Email" := User."Allow Approval Email";
            NavPortalUser.Modify();
        end;
    end;
}

