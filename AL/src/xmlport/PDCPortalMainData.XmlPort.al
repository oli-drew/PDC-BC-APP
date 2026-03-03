/// <summary>
/// XmlPort PDC Nav Portal Main Data (ID 50052).
/// </summary>
xmlport 50052 "PDC Portal Main Data"
{

    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(data)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            tableelement("PDC Portal User"; "PDC Portal User")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'user';
                fieldelement(userName; "PDC Portal User"."User Name")
                {
                }
                fieldelement(name; "PDC Portal User".Name)
                {
                }
                textelement(userposition)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'position';
                }
                textelement(userfirstname)
                {
                    XmlName = 'firstName';
                }
                fieldelement(custName; "PDC Portal User"."Customer Name")
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                }
                textelement(userpicture)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'picture';
                }
                textelement(userincidents)
                {
                    XmlName = 'allowincidents';
                }
                textelement(userfinances)
                {
                    XmlName = 'allowfinances';
                }
                textelement(userorders)
                {
                    XmlName = 'alloworders';
                }
                textelement(userworkflow)
                {
                    XmlName = 'allowworkflow';
                }
                textelement(userreturns)
                {
                    XmlName = 'allowreturns';
                }
                textelement(userstaff)
                {
                    XmlName = 'allowstaff';
                }
                textelement(usercontracts)
                {
                    XmlName = 'allowcontracts';
                }
                textelement(usergeneralreports)
                {
                    XmlName = 'allowgeneralreports';
                }
                textelement(userfinancialreports)
                {
                    XmlName = 'allowfinancialreports';
                }
                textelement(userallowentitlement)
                {
                    XmlName = 'allowentitlement';
                }
                textelement(userallowcheckout)
                {
                    XmlName = 'allowcheckout';
                }
                textelement(userallowwardrobe)
                {
                    XmlName = 'allowwardrobe';
                }
                fieldelement(companyContactNo; "PDC Portal User"."Company Contact No.")
                {
                }
                fieldelement(email; "PDC Portal User"."E-Mail")
                {
                }
                fieldelement(staffID; "PDC Portal User"."Staff ID")
                {
                }
                textelement(poPerWearer)
                {
                }
                textelement(portaltype)
                {
                    XmlName = 'portalType';
                }
                textelement(nepayurl)
                {
                    XmlName = 'nEPayURL';
                }
                textelement(nepayinstallationid)
                {
                    XmlName = 'nePayInstallationId';
                }
                textelement(mybranchid)
                {
                    XmlName = 'myBranchId';
                }
                textelement(theme)
                {
                    XmlName = 'theme';
                }
                textelement(ponumberformat)
                {
                    XmlName = 'poNumberFormat';
                }
                textelement(contractnoformat)
                {
                    XmlName = 'contractNoFormat';
                }
                textelement(shownotificationbar)
                {
                    XmlName = 'showNotificationBar';
                }
                textelement(notificationbarmessage)
                {
                    XmlName = 'notificationBarMessage';
                }
                textelement(notificationbarlink)
                {
                    XmlName = 'notificationBarLink';
                }
                textelement(clearcookie)
                {
                    XmlName = 'clearCookie';
                }
                textelement(notifications)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                textelement(staffAllBranches)
                {
                }
                textelement(staffRequestApprove)
                {
                }
                textelement(staffRequestCreate)
                {
                }
                textelement(addressCreate)
                {
                }
                textelement(addressEdit)
                {
                }
                textelement(addressListCompany)
                {
                }
                textelement(addressListBranch)
                {
                }
                textelement(staffCreate)
                {
                }
                textelement(staffEdit)
                {
                }
                textelement(userType)
                {
                }
                fieldelement(allowApprovalEmail; "PDC Portal User"."Allow Approval Email")
                {
                    MinOccurs = Zero;
                }
                textelement(allowBulkOrder)
                {
                    MinOccurs = Zero;
                }
                textelement(entitlementEnabled)
                {
                    MinOccurs = Zero;
                }
                textelement(overEntitlementAction)
                {
                    MinOccurs = Zero;
                }               


                trigger OnAfterGetRecord()
                begin
                    //GetUserPicture();
                    NavPortalMgt.GetUserMergedRole("PDC Portal User", PortalRole);
                    userIncidents := Format(PortalRole.Incidents, 0, 9);
                    userFinances := Format(PortalRole.Finances, 0, 9);
                    userOrders := Format(PortalRole.Orders, 0, 9);
                    userWorkflow := Format(PortalRole.Workflow, 0, 9);
                    userReturns := Format(PortalRole.Returns, 0, 9);
                    userStaff := Format(PortalRole.Staff, 0, 9);
                    userContracts := Format(PortalRole.Contracts, 0, 9);
                    userGeneralReports := Format(PortalRole."General Reports", 0, 9);
                    userFinancialReports := Format(PortalRole."Financial Reports", 0, 9);
                    "PDC Portal User".Copyfilter("Portal Code Filter", Portal.Code);

                    Portal.FindFirst();
                    showNotificationBar := Format(Portal."Show Message", 0, 9);
                    notificationBarMessage := Portal."Message Text";
                    notificationBarLink := Portal."Link Address";
                    clearCookie := Format(Portal."Override Display Cookie", 0, 9);
                    poPerWearer := Format("PDC Portal User"."PO per Wearer", 0, 9);
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
                    userType := Format("PDC Portal User"."User Type");
                    allowBulkOrder := Format(PortalRole."Bulk Order", 0, 9);

                    Customer.Get("PDC Portal User"."Customer No.");
                    entitlementEnabled := format(Customer."PDC Entitlement Enabled");
                    overEntitlementAction := Format(Customer."PDC Over Entitlement Action");
                end;
            }
            tableelement(portaluserbranch; "PDC Portal User Branch")
            {
                XmlName = 'branches';
                UseTemporary = true;
                textattribute(jsonarray2)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(branchId; PortalUserBranch."Branch ID")
                {
                }
            }
            tableelement(bodytypes; "PDC General Lookup")
            {
                XmlName = 'bodyTypes';
                textattribute(jsonarray3)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(code; BodyTypes.Code)
                {
                }
                fieldelement(description; BodyTypes.Description)
                {
                }
            }
            tableelement(countries; "Country/Region")
            {
                XmlName = 'countries';
                textattribute(jsonarray4)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(code; Countries.Code)
                {
                }
                fieldelement(name; Countries.Name)
                {
                }
            }
        }
    }


    trigger OnPreXmlPort()
    begin
        userPosition := '';
        //jsonArray1 := 'true';
        jsonArray2 := 'true';
        jsonArray3 := 'true';
        jsonArray4 := 'true';
    end;

    var
        PortalRole: Record "PDC Portal Role";
        Portal: Record "PDC Portal";
        Customer: Record Customer;
        NavPortalMgt: Codeunit "PDC Portals Management";

    procedure GetUserRole(Role: Text)
    begin
    end;

    // local procedure GetUserPicture()
    // var
    //     UserContact: Record Contact;
    //     InputStream: InStream;
    //     convert: dotnet Convert;
    //     MemoryStream: dotnet MemoryStream;
    // begin
    //     //!!! TO-DO !!!
    //     //!!! Check Line Below !!!
    //     //EXIT;

    //     userPicture := '';

    //     if (UserContact.Get("PDC Portal User"."Contact No.")) then begin
    //         if (UserContact.Picture.Hasvalue) then begin
    //             UserContact.CalcFields(Picture);
    //             UserContact.Picture.CreateInstream(InputStream);
    //             MemoryStream := MemoryStream.MemoryStream();
    //             CopyStream(MemoryStream, InputStream);
    //             userPicture := 'data:image/jpg;base64,' +
    //               convert.ToBase64String(MemoryStream.ToArray());
    //         end;
    //     end;
    // end;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="NavPortal">Record "PDC Portal".</param>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(NavPortal: Record "PDC Portal"; var NavPortalUser: Record "PDC Portal User")
    var
        PortalUserBranchDb: Record "PDC Portal User Branch";
        Customer: Record Customer;
    begin
        portalType := Format(NavPortal."Portal Type");

        nEPayURL := NavPortal."nEPay URL";
        nEPayInstallationId := NavPortal."nEPay Merchant Id";

        PortalUserBranch.Reset();
        PortalUserBranch.SetRange("Portal User ID", NavPortalUser.Id);

        PortalUserBranchDb.Reset();
        PortalUserBranchDb.SetRange("Portal User ID", NavPortalUser.Id);
        PortalUserBranchDb.SetRange("Sell-To Customer No.", NavPortalUser."Customer No.");
        if PortalUserBranchDb.FindFirst() then myBranchId := PortalUserBranchDb."Branch ID";

        PortalUserBranch.Reset();
        PortalUserBranch.DeleteAll();
        PortalUserBranchDb.Reset();
        PortalUserBranchDb.SetRange("Portal User ID", NavPortalUser.Id);
        PortalUserBranchDb.SetRange("Sell-To Customer No.", NavPortalUser."Customer No.");
        if PortalUserBranchDb.Findset() then
            repeat
                PortalUserBranch.Init();
                PortalUserBranch := PortalUserBranchDb;
                PortalUserBranch.Insert();
            until PortalUserBranchDb.next() = 0;
        if PortalUserBranch.FindFirst() then myBranchId := PortalUserBranchDb."Branch ID";

        if Customer.Get(NavPortalUser."Customer No.") then begin
            theme := Format(Customer."PDC Portal Theme");
            poNumberFormat := Customer."PDC PO Number Format";
            contractnoformat := Customer."PDC Contract No. Format";
        end;

        BodyTypes.Reset();
        BodyTypes.SetRange(Type, 'BODYTYPE');
        if BodyTypes.FindSet() then;

        Countries.Reset();
        Countries.SetRange("PDC Available in Portal", true);
        if Countries.FindSet() then;
    end;
}

