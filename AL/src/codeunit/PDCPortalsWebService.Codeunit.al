/// <summary>
/// Codeunit PDC Portals Web Service (ID 50016).
/// </summary>
Codeunit 50016 "PDC Portals Web Service"
{

    trigger OnRun()
    begin
    end;

    var
        NavPortal: Record "PDC Portal";
        PortalUser: Record "PDC Portal User";
        UserRole: Record "PDC Portal Role";
        TempBlob: Codeunit "Temp Blob";
        PortalsMgt: Codeunit "PDC Portals Management";
        CustPortalMgt: Codeunit "PDC Portal Mgt";
        FileManagement: Codeunit "File Management";
        InpStream: InStream;
        OutpStream: OutStream;
        DocumentStatus: Option All,Paid,Unpaid;
        UnkownCommandErr: label 'Unknown command %1', comment = '%1=command';
        UnknownPortalCodeErr: label 'Unknow portal code ''%1''', comment = '%1=portal code';
        NotImplementedErr: label 'Method not implemented';

    /// <summary>
    /// Call2.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="PortalName">Text[250].</param>
    /// <param name="Path">Text[250].</param>
    /// <param name="Command">Text[250].</param>
    /// <param name="InputTxt">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure Call2(UserId: Text[250]; PortalName: Text[250]; Path: Text[250]; Command: Text[250]; InputTxt: Text): Text
    var
        JSONManagement: Codeunit "JSON Management";
        InputData: BigText;
        OutputData: BigText;
        OutputTxt: Text;
        xmlDoc: XmlDocument;
        root: XmlElement;
        Node: XmlNode;
        NodeList: XmlNodeList;
        jsonPrefTxt: label 'json', Locked = true;
        BCArrayAttrTxt: label 'json_Array', Locked = true;
        JsonArrayAttrTxt: label 'Array', Locked = true;
        jsonNSTxt: label 'http://james.newtonking.com/projects/json', locked = true;
        outJsonTxt: label '{"data":{"%1":%2}}', Locked = true;
    begin
        if (not NavPortal.Get(PortalName)) then Error(UnknownPortalCodeErr, PortalName);

        InputTxt := JSONManagement.JSONTextToXMLText(InputTxt, '');

        InputData.AddText(InputTxt);
        Call(UserId, PortalName, Path, Command, InputData, OutputData);
        OutputData.GetSubText(OutputTxt, 1);

        if OutputTxt <> '' then begin
            XmlDocument.ReadFrom(OutputTxt, xmlDoc);
            xmlDoc.GetRoot(root);
            root.Add(XmlAttribute.CreateNamespaceDeclaration(jsonPrefTxt, jsonNSTxt));
            xmlDoc.SelectNodes('//*[@' + BCArrayAttrTxt + ']', NodeList);
            foreach node in nodelist do begin
                Node.AsXmlElement().RemoveAttribute(BCArrayAttrTxt);
                Node.AsXmlElement().SetAttribute(JsonArrayAttrTxt, jsonNSTxt, 'true');
            end;
            xmlDoc.WriteTo(OutputTxt);

            OutputTxt := StrSubstNo(outJsonTxt, root.Name, JSONManagement.XMLTextToJSONText(OutputTxt));
        end;

        exit(OutputTxt);
    end;

    /// <summary>
    /// Download2.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="PortalName">Text[250].</param>
    /// <param name="Path">Text[250].</param>
    /// <param name="Command">Text[250].</param>
    /// <param name="InputTxt">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure Download2(UserId: Text[250]; PortalName: Text[250]; Path: Text[250]; Command: Text[250]; InputTxt: Text): Text
    var
        JSONManagement: Codeunit "JSON Management";
        InputData: BigText;
        OutputData: BigText;
        OutputTxt: Text;
        FileName: Text;
        outJsonTxt: label '{"fileName":"%1","fileContent":"%2"}', Locked = true;
    begin
        if (not NavPortal.Get(PortalName)) then Error(UnknownPortalCodeErr, PortalName);

        if InputTxt <> '' then
            InputTxt := JSONManagement.JSONTextToXMLText(InputTxt, '');

        InputData.AddText(InputTxt);
        Download(UserId, PortalName, Path, Command, InputData, FileName, OutputData);
        OutputData.GetSubText(OutputTxt, 1);

        OutputTxt := StrSubstNo(outJsonTxt, FileName, OutputTxt);

        exit(OutputTxt);
    end;

    /// <summary>
    /// Call.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="PortalName">Text[250].</param>
    /// <param name="Path">Text[250].</param>
    /// <param name="Command">Text[250].</param>
    /// <param name="InputData">BigText.</param>
    /// <param name="OutputData">VAR BigText.</param>
    procedure Call(UserId: Text[250]; PortalName: Text[250]; Path: Text[250]; Command: Text[250]; InputData: BigText; var OutputData: BigText)
    var
        CallProcessed: Boolean;
    begin
        if (not NavPortal.Get(PortalName)) then Error(UnknownPortalCodeErr, PortalName);

        if (NavPortal."Portal Type" <> NavPortal."portal type"::Customer) then
            exit;

        Clear(OutputData);

        PortalsMgt.LoadUser(UserId, NavPortal, PortalUser, UserRole);

        //process call
        CallProcessed := true;
        case (Lowercase(Path)) of
            // Primary
            'dashboard':
                ProcessDashboard(NavPortal, Command, InputData, OutputData);
            'invoicelist':
                ProcessInvoiceList(Command, InputData, OutputData, Documentstatus::All);
            'paidinvoicelist':
                ProcessInvoiceList(Command, InputData, OutputData, Documentstatus::Paid);
            'unpaidinvoicelist':
                ProcessInvoiceList(Command, InputData, OutputData, Documentstatus::Unpaid);
            'invoicecard':
                ProcessInvoiceCard(Command, InputData, OutputData);
            'duedoclist':
                ProcessBalanceDue(Command, InputData, OutputData);
            'filteredorderlist':
                ProcessOrderList(Command, InputData, OutputData, true);
            'orderlist':
                ProcessOrderList(Command, InputData, OutputData, false);
            'ordercard':
                ProcessOrderCard(Command, InputData, OutputData);
            'neworder':
                ProcessNewOrder(Command, InputData, OutputData);
            'editorder':
                ProcessNewOrder(Command, InputData, OutputData); // also used for editing orders - in this case it needs to be passed the Order No.            
            'itemlist':
                ProcessItemList(NavPortal, Command, InputData, OutputData);
            'openledgers':
                ProcessOpenLedgers(Command, InputData, OutputData);
            'completeorderlist':
                ProcessInvoiceListBranchFiltered(Command, InputData, OutputData);
            'crmemolist':
                ProcessCrMemoList(Command, InputData, OutputData, 1);
            'closedcrmemolist':
                ProcessCrMemoList(Command, InputData, OutputData, 2);
            'crmemocard':
                ProcessCrMemoCard(Command, InputData, OutputData);
            'main':
                ProcessMainReq(NavPortal, Command, InputData, OutputData);
            'changepassword':
                ProcessPwdChange(Command, InputData, OutputData, NavPortal);
            'resetpassword':
                ProcessPwdReset(NavPortal, Command, InputData, OutputData);
            'branchlist':
                ProcessBranchList(Command, InputData, OutputData);
            'userbranchlist':
                ProcessUserBranchList(Command, InputData, OutputData);
            'stafflist':
                ProcessStaffList(Command, InputData, OutputData);
            'staffcard':
                ProcessStaffCard(Command, InputData, OutputData);
            'updatestaff':
                ProcessUpdateStaff(Command, InputData, OutputData);
            'addstaff':
                ProcessAddStaff(Command, InputData, OutputData);
            'contractlist':
                ProcessContractList(Command, InputData, OutputData);
            'updatecontract':
                ProcessUpdateContract(Command, InputData, OutputData);
            'addcontract':
                ProcessAddContract(Command, InputData, OutputData);
            'wardrobelist':
                ProcessWardrobeList(Command, InputData, OutputData);
            'staffcarddetail':
                ProcessStaffCardDetail(Command, InputData, OutputData);
            'receivedreturnorderlist':
                ProcessReceivedReturnOrderList(Command, InputData, OutputData);
            'receivedreturnordercard':
                ProcessReceivedReturnOrderCard(Command, InputData, OutputData);
            'completedreturnorderlist':
                ProcessCompletedReturnOrderList(Command, InputData, OutputData);
            'completedreturnordercard':
                ProcessCompletedReturnOrderCard(Command, InputData, OutputData);
            'draftorderlist':
                ProcessDraftOrderList(Command, InputData, OutputData);
            'draftordercard':
                ProcessDraftOrderCard(Command, InputData, OutputData);
            'draftorderstafflines':
                ProcessDraftOrderStaffLines(Command, InputData, OutputData);
            'draftorderstaffcard':
                ProcessDraftOrderStaffCard(Command, InputData, OutputData);
            'draftorderfinalise':
                ProcessDraftOrderFinalise(Command, InputData, OutputData);
            'draftordermerge':
                ProcessDraftOrdersMerge(Command, InputData, OutputData);
            'wardrobecard':
                ProcessWardrobeCard(Command, InputData, OutputData);
            'shipmentaddresslist':
                ProcessShipmentAddressList(Command, InputData, OutputData);
            'shipmentaddresscard':
                ProcessShipmentAddressCard(Command, InputData, OutputData);
            'convertinvoice':
                ProcessConvertInvoice(Command, InputData, OutputData);
            'savereturnorder':
                ProcessSaveReturnOrder(Command, InputData, OutputData);
            'getitemprice':
                ProcessGetItemPrice(Command, InputData, OutputData);
            'getitemstock':
                ProcessGetItemStock(Command, InputData, OutputData);
            'getitemalternstock':
                ProcessGetItemAlternativeStock(Command, InputData, OutputData);
            'entitlementstaff':
                ProcessEntitlementStaff(Command, InputData, OutputData);
            'entitlement':
                ProcessEntitlement(Command, InputData, OutputData);
            'usercard':
                ProcessUserCard(Command, InputData, OutputData);
            'updateuser':
                ProcessUpdateUser(Command, InputData, OutputData);
            'wardrobeitems':
                ProcessWardrobeItemList(Command, InputData, OutputData);
            else
                CallProcessed := false;
        end;

        CallProcessed := false;
    end;

    /// <summary>
    /// Download.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="PortalName">Text[250].</param>
    /// <param name="Path">Text[250].</param>
    /// <param name="Command">Text[250].</param>
    /// <param name="InputData">BigText.</param>
    /// <param name="FileName">VAR Text.</param>
    /// <param name="OutputData">VAR BigText.</param>
    procedure Download(UserId: Text[250]; PortalName: Text[250]; Path: Text[250]; Command: Text[250]; InputData: BigText; var FileName: Text; var OutputData: BigText)
    var
        TempBlob1: Codeunit "Temp Blob";
        CallProcessed: Boolean;
        InputStream: InStream;
    begin
        clear(CallProcessed);

        if not (NavPortal.Get(PortalName)) then
            Error(UnknownPortalCodeErr, PortalName)
        else
            case (Lowercase(Path)) of
                'printpostedinvoice':
                    CallProcessed := DownloadPostedSalesInv(TempBlob1, Command, FileName);
                'printpostedcrmemo':
                    CallProcessed := DownloadPostedSalesCrM(TempBlob1, Command, FileName);
                'downloadattachment':
                    CallProcessed := DownloadFileAttachment(TempBlob1, NavPortal.Code, Command, FileName);
                'report':
                    CallProcessed := DownloadReport(TempBlob1, UserId, Command, InputData, FileName);
                'printdraftorder':
                    CallProcessed := DownloadDraftOrder(TempBlob1, Command, FileName);
                'printpostedshipment':
                    CallProcessed := DownloadPostedShipment(TempBlob1, Command, FileName);
                'printreturnorder':
                    CallProcessed := DownloadReturnOrder(TempBlob1, Command, FileName);
                else
                    CallProcessed := false;
            end;

        if (CallProcessed) then begin
            PortalsMgt.CheckFileName(FileName);
            TempBlob1.CreateInStream(InputStream);
            PortalsMgt.EncodeFileData(InputStream, OutputData);
        end;
    end;

    /// <summary>
    /// FindUser.
    /// </summary>
    /// <param name="User">VAR XmlPort "Portal User".</param>
    /// <param name="UserId">Text[250].</param>
    /// <param name="UserName">Text[250].</param>
    procedure FindUser(var User: XmlPort "PDC Portal User"; UserId: Text[250];
                                     UserName: Text[250])
    var
        PortalUserLoc: Record "PDC Portal User";
    begin
        PortalUserLoc.Reset();
        if (UserId = '') and (UserName = '') then
            PortalUserLoc.SetFilter(Id, '0&1')
        else
            if (UserId <> '') then
                PortalUserLoc.SetFilter(Id, '%1', '@' + '@' + ConvertStr(UserId, '@', '?'))
            else
                PortalUserLoc.SetFilter(Id, '%1', '@' + '@' + ConvertStr(UserName, '@', '?'));

        // This will not work presently because we don't know which portal we're in!!!!
        if (NavPortal."Admin Only Login" = true) and (PortalUserLoc."User Type" <> PortalUserLoc."User Type"::Approver) then
            PortalUserLoc.SetFilter(Id, '0&1');
        User.SetTableview(PortalUserLoc);

        User.Export();
    end;


    /// <summary>
    /// GetPasswordHash.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <returns>Return value of type Text[250].</returns>
    procedure GetPasswordHash(UserId: Text[250]): Text[250]
    begin
        PortalUser.Get(UserId);
        exit(PortalUser."Password Hash");
    end;

    /// <summary>
    /// SetPasswordHash.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="UserHash">Text[250].</param>
    procedure SetPasswordHash(UserId: Text[250]; UserHash: Text[250])
    begin
        PortalUser.Get(UserId);
        PortalUser."Password Hash" := UserHash;
        PortalUser.Modify();
    end;

    /// <summary>
    /// GetUserRoles.
    /// </summary>
    /// <param name="Roles">VAR XmlPort "Portal User Role".</param>
    /// <param name="UserId">Text[250].</param>
    /// <param name="PortalName">Text[250].</param>
    procedure GetUserRoles(var Roles: XmlPort "PDC Portal User Role"; UserId: Text[250];
                                          PortalName: Text[250])
    var
        UserRoleLoc: Record "PDC Portal User Role";
    begin
        UserRoleLoc.Reset();
        UserRoleLoc.SetRange("User Id", UserId);
        UserRoleLoc.SetFilter("Portal Code", '%1|%2', '', PortalName);
        Roles.SetTableview(UserRoleLoc);
        Roles.Export();
    end;

    /// <summary>
    /// SSOSignin.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="PSK">Text[250].</param>
    /// <param name="PortalName">Text[250].</param>
    /// <param name="ErrorText">VAR Text[250].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SSOSignin(UserId: Text[250]; PSK: Text[250]; PortalName: Text[250]; var ErrorText: Text[250]): Boolean
    var
        PortalUserLoc: Record "PDC Portal User";
        UserRoleLoc: Record "PDC Portal User Role";
        PortalRole: Record "PDC Portal Role";
        AllowSSO: Boolean;
        LoginFailedErr: label 'Login failed';
        SSOBadPortalErr: label 'Single sign-on is not allowed for this portal';
    begin
        //DOC CP2.03 20160922 DRW -

        // SSO Sign-in is allowed if the following are all true:
        // 1. A portal with the name specified exists
        // 2. The portal allows SSO

        // Either,LoginFailedErr
        // 3. A Portal user with the given UserId exists
        // 4. The portal user has one or more roles for the given portal
        // 6. At least one of those roles allows SSO
        // OR:
        // 7. The portal has SSOCreatePortalUser set to Yes
        //
        // If it's a case that the portal just hasn't been set up to allow SSO or
        // an incorrect portal is specified then the error message is pretty helpful.
        // If the user has attempted to use an invalid user or their user is not setup
        // correctly for SSO then it's a blanket "login failed" error -- this is to
        // stop enumeration of SSO-enabled users by nerfarious parties.
        //
        // In the case of the user having no portal account and SSOCreatePortalUser is on
        // then a new user account is created and default roles are assigned.

        if not (NavPortal.Get(PortalName)) then begin
            ErrorText := UnknownPortalCodeErr;
            exit(false);
        end;

        if (NavPortal.AllowSSO = false) or (NavPortal.SSOPSK = '') then begin
            ErrorText := SSOBadPortalErr;
            exit(false);
        end;

        if (PSK <> NavPortal.SSOPSK) then begin
            ErrorText := LoginFailedErr;
            exit(false);
        end;

        PortalUserLoc.Reset();
        if not (PortalUserLoc.Get(UserId)) then begin
            PortalUserLoc.SetCurrentKey("Azure User Id");
            PortalUserLoc.SetRange("Azure User Id", UserId);
            if not PortalUserLoc.FindFirst() then
                clear(PortalUserLoc);
        end;

        if PortalUserLoc.Id = '' then
            // There is no matching user. If SSOCreatePortalUser
            // is truthy then create a new user here. If it's not then
            // treat this scenario as a failed login.
            if (NavPortal.SSOCreatePortalUser) then begin
                PortalUserLoc.Reset();
                PortalUserLoc.Id := UserId;
                PortalUserLoc."E-Mail" := UserId;
                PortalUserLoc.Insert();

                PortalRole.Reset();
                PortalRole.SetRange(DefaultRole, true);

                // .. If  there aren't any sso-enabled roles then we could have a
                // situation arise where we let them in this time but not subsequently.
                // The same is true if there are no default roles at all.
                if PortalRole.FindSet() then
                    repeat
                        UserRoleLoc.Reset();
                        UserRoleLoc."Portal Code" := NavPortal.Code;
                        UserRoleLoc."User Id" := UserId;
                        UserRoleLoc."User Role Code" := PortalRole.Code;
                        UserRoleLoc.Insert();
                    until PortalRole.Next() = 0;

                exit(true); // Return a successful login.
            end else begin
                ErrorText := LoginFailedErr;
                exit(false)
            end;

        UserRoleLoc.Reset();
        UserRoleLoc.SetRange("Portal Code", NavPortal.Code);
        UserRoleLoc.SetRange("User Id", PortalUserLoc.Id);

        if UserRoleLoc.IsEmpty() then begin
            ErrorText := LoginFailedErr;
            exit(false);
        end;

        AllowSSO := false;

        repeat
            if (PortalRole.Get(UserRoleLoc."User Role Code")) then
                if (PortalRole.AllowSSO) then AllowSSO := true;
        until UserRoleLoc.Next() = 0;

        if (not AllowSSO) then
            ErrorText := LoginFailedErr;

        exit(AllowSSO);
    end;

    /// <summary>
    /// IsUserInRole.
    /// </summary>
    /// <param name="UserId">Text[250].</param>
    /// <param name="RoleCode">Code[20].</param>
    /// <param name="PortalName">Text[250].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsUserInRole(UserId: Text[250]; RoleCode: Code[20]; PortalName: Text[250]): Boolean
    begin
        exit(true);
    end;

    local procedure ProcessDashboard(var NavPortalLoc: Record "PDC Portal"; Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Dashboard";
    begin
        XmlData.InitData(NavPortalLoc, PortalUser);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessInvoiceList(Command: Text[250]; var InputData: BigText; var OutputData: BigText; DocumentStatusFilter: Option)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        XmlData: XmlPort "PDC Portal Posted Inv. List";
    begin
        //Only continue if user role has finances checked
        if (UserRole.Finances) then begin

            XmlData.InitData();
            if (GetInputStream(InputData, InpStream)) then begin
                XmlData.SetSource(InpStream);
                XmlData.Import();
            end;

            CustLedgerEntry.Reset();
            case (DocumentStatusFilter) of
                Documentstatus::Paid:
                    CustPortalMgt.FIlterClosedCustLedgerEntries(PortalUser, CustLedgerEntry, CustLedgerEntry."document type"::Invoice);
                Documentstatus::Unpaid:
                    CustPortalMgt.FIlterOpenCustLedgerEntries(PortalUser, CustLedgerEntry, CustLedgerEntry."document type"::Invoice);
                else
                    CustPortalMgt.FilterCustLedgerEntries(PortalUser, CustLedgerEntry);
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::Invoice);
            end;
            XmlData.FilterData(CustLedgerEntry, PortalUser);

            GetOutputStream(OutpStream);
            XmlData.SetDestination(OutpStream);
            XmlData.Export();
            GetOutputData(OutputData);

        end;
    end;

    local procedure ProcessInvoiceListBranchFiltered(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        XmlData: XmlPort "PDC Portal Compl. Order List";
        BranchFilter: Text;
    begin
        XmlData.InitData();
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        CustLedgerEntry.Reset();
        BranchFilter := XmlData.GetBranchFilter();
        case BranchFilter of
            'All':
                CustPortalMgt.FilterCustLedgerEntriesForMyBranches(PortalUser, CustLedgerEntry);
            'Mine':
                CustPortalMgt.FilterCustLedgerEntriesForCreatedByMe(PortalUser, CustLedgerEntry);
            'MyApprovals':
                CustPortalMgt.FilterCustLedgerEntriesForApprovedByMe(PortalUser, CustLedgerEntry);
            else
                CustPortalMgt.FilterCustLedgerEntriesForBranchFilter(PortalUser, CustLedgerEntry, BranchFilter);
        end;

        XmlData.FilterData(CustLedgerEntry, PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessInvoiceCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Posted Inv. Card";
    begin
        XmlData.InitData();
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessCrMemoList(Command: Text[250]; var InputData: BigText; var OutputData: BigText; DocumentStatusFilter: Option All,Open,Closed)
    var
        CrMemoHeader: Record "Sales Cr.Memo Header";
        CustLE: Record "Cust. Ledger Entry";
        XmlData: XmlPort "PDC Portal Posted Cr.M. List";
    begin
        XmlData.InitData();
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        CrMemoHeader.Reset();
        CustPortalMgt.FilterCrMemos(PortalUser, CrMemoHeader);
        CrMemoHeader.ClearMarks();
        if DocumentStatusFilter <> Documentstatusfilter::All then
            if CrMemoHeader.Findset() then
                repeat
                    CustLE.Reset();
                    CustLE.SetRange("Document No.", CrMemoHeader."No.");
                    CustLE.SetRange("Posting Date", CrMemoHeader."Posting Date");
                    CustLE.SetRange("Document Type", CustLE."document type"::"Credit Memo");
                    if CustLE.FindLast() then
                        CrMemoHeader.Mark((CustLE.Open and (DocumentStatusFilter = 1)) or (not CustLE.Open and (DocumentStatusFilter = 2)));
                until CrMemoHeader.next() = 0;

        CrMemoHeader.MarkedOnly(true);
        XmlData.FilterData(CrMemoHeader);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessCrMemoCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Posted Cr.M. Card";
    begin
        XmlData.InitData();
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessBalanceDue(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        XmlData: XmlPort "PDC Portal Cust. Ledg. Ent.";
    begin
        //Only continue if user role has incidents checked
        if (UserRole.Finances) then begin

            XmlData.InitData();
            if (GetInputStream(InputData, InpStream)) then begin
                XmlData.SetSource(InpStream);
                XmlData.Import();
            end;

            CustLedgEntry.Reset();
            CustLedgEntry.SetCurrentkey("Customer No.", "Posting Date");
            CustLedgEntry.SetRange("Customer No.", PortalUser."Customer No.");
            CustLedgEntry.SetFilter("Remaining Amount", '<>%1', 0);

            XmlData.FilterData(CustLedgEntry);

            GetOutputStream(OutpStream);
            XmlData.SetDestination(OutpStream);
            XmlData.Export();
            GetOutputData(OutputData);
        end;
    end;

    local procedure ProcessOrderList(Command: Text[250]; var InputData: BigText; var OutputData: BigText; Filtered: Boolean)
    var
        OrderHeader: Record "Sales Header";
        XmlData: XmlPort "PDC Portal Sales Orders List";
        BranchFilter: Text;
    begin
        if (UserRole.Orders or UserRole."Staff Request Create") then begin
            XmlData.InitData();
            if (GetInputStream(InputData, InpStream)) then begin
                XmlData.SetSource(InpStream);
                XmlData.Import();
            end;

            OrderHeader.Reset();
            BranchFilter := XmlData.GetBranchFilter();

            case BranchFilter of
                'All':
                    CustPortalMgt.FilterOrdersForMyBranches(PortalUser, OrderHeader, Filtered);
                'Mine':
                    CustPortalMgt.FilterOrdersForCreatedByMe(PortalUser, OrderHeader, Filtered);
                'MyApprovals':
                    CustPortalMgt.FilterOrdersForApprovedByMe(PortalUser, OrderHeader, Filtered);
                else
                    CustPortalMgt.FilterOrdersForBranchFilter(PortalUser, OrderHeader, Filtered, BranchFilter);
            end;
            XmlData.FilterData(OrderHeader);

            GetOutputStream(OutpStream);
            XmlData.SetDestination(OutpStream);
            XmlData.Export();
            GetOutputData(OutputData);
        end;
    end;

    local procedure ProcessOrderCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Sales Order Card";
    begin
        if (UserRole.Orders or UserRole."Staff Request Create") then begin
            XmlData.InitData();
            if (GetInputStream(InputData, InpStream)) then begin
                XmlData.SetSource(InpStream);
                XmlData.Import();
            end;

            XmlData.FilterData(PortalUser);

            GetOutputStream(OutpStream);
            XmlData.SetDestination(OutpStream);
            XmlData.Export();
            GetOutputData(OutputData);
        end;
    end;

    local procedure ProcessNewOrder(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Sales Order Card";
        LastOrderNo: code[20];
    begin
        LastOrderNo := '';

        if (UserRole.Finances) and (UserRole.Orders) then begin
            if (GetInputStream(InputData, InpStream)) then begin
                XmlData.SetSource(InpStream);
                XmlData.Import();
                XmlData.SaveData(PortalUser);
                LastOrderNo := XmlData.GetOrderNo();
            end;

            XmlData.FilterData2(PortalUser, LastOrderNo);

            GetOutputStream(OutpStream);
            XmlData.SetDestination(OutpStream);
            XmlData.Export();
            GetOutputData(OutputData);
        end;
    end;

    local procedure ProcessItemList(var NavPortalLoc: Record "PDC Portal"; Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        Item: Record Item;
        XmlData: XmlPort "PDC Portal Item List";
    begin
        XmlData.InitData();
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        Item.Reset();
        XmlData.FilterData(NavPortalLoc, PortalUser, Item);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessOpenLedgers(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Open Ledgers";
    begin
        XmlData.InitData();

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure DownloadPostedSalesInv(var TempBlob1: Codeunit "Temp Blob"; InvoiceNo: Code[20]; var FileName: Text): Boolean
    var
        SalesInvHeader: Record "Sales Invoice Header";
        ReportSelection: Record "Report Selections";
        AllObjWithCaption: Record AllObjWithCaption;
        RecRef: RecordRef;
        OutStream: OutStream;
        Saved: boolean;
    begin
        SalesInvHeader.Reset();
        if (SalesInvHeader.Get(InvoiceNo)) then begin
            SalesInvHeader.SetRecfilter();

            ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Invoice");
            ReportSelection.SetFilter("Report ID", '<>0');
            if (ReportSelection.FindFirst()) then begin
                AllObjWithCaption.Get(AllObjWithCaption."object type"::Report, ReportSelection."Report ID");
                FileName := AllObjWithCaption."Object Caption" + '.pdf';

                TempBlob1.CreateOutStream(OutStream);
                RecRef.GetTable(SalesInvHeader);
                Saved := Report.SaveAs(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStream, RecRef);
            end;
        end;

        exit(Saved);
    end;

    local procedure DownloadPostedSalesCrM(var TempBlob1: Codeunit "Temp Blob"; crMemoNo: Code[20]; var FileName: Text): Boolean
    var
        SalesCrMHeader: Record "Sales Cr.Memo Header";
        ReportSelection: Record "Report Selections";
        AllObjWithCaption: Record AllObjWithCaption;
        RecRef: RecordRef;
        OutStream: OutStream;
        Saved: boolean;
    begin
        SalesCrMHeader.Reset();
        if (SalesCrMHeader.Get(crMemoNo)) then begin
            SalesCrMHeader.SetRecfilter();

            ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Cr.Memo");
            ReportSelection.SetFilter("Report ID", '<>0');
            if (ReportSelection.FindFirst()) then begin
                AllObjWithCaption.Get(AllObjWithCaption."object type"::Report, ReportSelection."Report ID");
                FileName := AllObjWithCaption."Object Caption" + '.pdf';

                TempBlob1.CreateOutStream(OutStream);
                RecRef.GetTable(SalesCrMHeader);
                Saved := Report.SaveAs(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStream, RecRef);
            end;
        end;

        exit(Saved);
    end;

    local procedure DownloadFileAttachment(var TempBlob1: Codeunit "Temp Blob"; PortalCode: Code[20]; FileNo: Code[20]; var FileName: Text): Boolean
    var
    // TempFileName: Text;
    // CanDownload: Boolean;
    // CustomerNo: Code[20];
    begin
        Error(NotImplementedErr);
    end;

    local procedure GetInputStream(var InputData: BigText; var InputStream: InStream): Boolean
    var
        OutputStream: OutStream;
    begin
        if (InputData.Length = 0) then
            exit(false);

        Clear(TempBlob);
        TempBlob.CreateOutstream(OutputStream);
        InputData.Write(OutputStream);
        TempBlob.CreateInstream(InputStream);
        exit(true);
    end;

    local procedure GetOutputStream(var OutputStream: OutStream)
    begin
        Clear(TempBlob);
        TempBlob.CreateOutstream(OutputStream);
    end;

    local procedure GetOutputData(var OutputData: BigText)
    var
        InputStream: InStream;
    begin
        TempBlob.CreateInstream(InputStream);
        OutputData.Read(InputStream);
    end;

    local procedure ProcessMainReq(var NavPortal: Record "PDC Portal"; Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        User: Record "PDC Portal User";
        XmlData: XmlPort "PDC Portal Main Data";
    begin
        User.Reset();
        User.SetRange(Id, PortalUser.Id);
        User.SetRange("Portal Code Filter", NavPortal.Code);
        XmlData.FilterData(NavPortal, PortalUser);
        XmlData.SetTableview(User);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessPwdChange(Command: Text[250]; var InputData: BigText; var OutputData: BigText; NavPortalLoc: Record "PDC Portal")
    var
        XmlData: XmlPort "PDC Portal User Pass Change";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
            XmlData.UpdateUserPassword(PortalUser);
        end;

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessPwdReset(var NavPortalLoc: Record "PDC Portal"; Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        UserEmail: Text;
    begin
        if (InputData.Length > 0) then begin
            InputData.GetSubText(UserEmail, 1);
            PortalsMgt.ResetUserPassword(NavPortalLoc, UserEmail);
        end;

        Clear(OutputData);
        OutputData.AddText('OK');
    end;

    local procedure ProcessBranchList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        Branch: Record "PDC Branch";
        XmlData: XmlPort "PDC Portal Branch List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        Branch.Reset();
        Branch.SetRange("Customer No.", PortalUser."Customer No.");

        XmlData.FilterData(Branch);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessUserBranchList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        TempBranch: record "PDC Branch" temporary;
        XmlData: XmlPort "PDC Portal Branch List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        PortalsMgt.GetPortalUserBranchList(TempBranch, PortalUser);

        XmlData.FilterData(TempBranch);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessStaffList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        Branch: Record "PDC Branch";
        XmlData: XmlPort "PDC Portal Staff List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        Branch.Reset();
        Branch.SetRange("Customer No.", PortalUser."Customer No.");

        XmlData.FilterData(Branch, PortalUser, Command);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessStaffCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Staff Card";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessUpdateStaff(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Staff Card";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.UpdateStaff(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessAddStaff(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Staff Card";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.AddStaff(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessContractList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Contract List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessUpdateContract(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Contract List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.UpdateContract(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessAddContract(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Contract List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.AddContract(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessWardrobeList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Wardrobe List";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessReceivedReturnOrderList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        OrderHeader: Record "Sales Header";
        XmlData: XmlPort "PDC Portal Recvd Return List";
        BranchFilter: Text;
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        OrderHeader.Reset();

        BranchFilter := XmlData.GetBranchFilter();
        case BranchFilter of
            'All':
                CustPortalMgt.FilterReceivedReturnOrders(PortalUser, OrderHeader);
            'Mine':
                CustPortalMgt.FilterReceivedReturnOrdersForCreatedByMe(PortalUser, OrderHeader);
            else
                CustPortalMgt.FilterReceivedReturnOrdersForBranchFilter(PortalUser, OrderHeader, BranchFilter);
        end;

        XmlData.FilterData(OrderHeader);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessReceivedReturnOrderCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        OrderHeader: Record "Sales Header";
        OrderLine: Record "Sales Line";
        XmlData: XmlPort "PDC Portal Recvd Return Card";
        OrderNo: Code[20];
        OrderNotFoundErr: label 'Open Return Order No. %1 was not found', Comment = '%1=order no.';
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        OrderNo := XmlData.GetNoFilter();

        OrderHeader.Reset();
        CustPortalMgt.FilterReceivedReturnOrders(PortalUser, OrderHeader);

        case Command of
            'get':
                ;
            'delete':
                begin
                    OrderHeader.SetRange("No.", OrderNo);
                    OrderHeader.SetRange(Status, OrderHeader.Status::Open);

                    if not OrderHeader.FindFirst() then Error(OrderNotFoundErr);

                    OrderLine.Reset();
                    OrderLine.SetRange("Document Type", OrderHeader."Document Type");
                    OrderLine.SetRange("Document No.", OrderHeader."No.");

                    if OrderLine.FindSet() then OrderLine.DeleteAll(true);
                    OrderHeader.DeleteAll(true);
                    exit;
                end;
            else
                Error(UnkownCommandErr, Command);
        end;

        XmlData.FilterData(OrderHeader, OrderNo);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessDraftOrderList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        XmlData: XmlPort "PDC Portal Draft Order List";
        branchFilter: Text;
    begin
        if not (UserRole.Orders or UserRole."Staff Request Create") then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        DraftOrderHeader.Reset();

        branchFilter := XmlData.GetBranchFilter();

        case branchFilter of
            'All':
                CustPortalMgt.FilterDraftOrdersForMyBranches(PortalUser, DraftOrderHeader);
            'Mine':
                CustPortalMgt.FilterDraftOrdersForCreatedByMe(PortalUser, DraftOrderHeader);
            'MyApprovals':
                CustPortalMgt.FilterDraftOrdersForMyApprovals(PortalUser, DraftOrderHeader)
            else
                CustPortalMgt.FilterDraftOrdersForBranchFilter(PortalUser, DraftOrderHeader, branchFilter);
        end;

        XmlData.FilterData(DraftOrderHeader);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessDraftOrderCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        XmlData: XmlPort "PDC Portal Draft Order Card";
    begin
        if not (UserRole.Orders or UserRole."Staff Request Create") then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        case Command of
            'get':
                begin
                    DraftOrderHeader.Reset();
                    CustPortalMgt.FilterDraftOrders(PortalUser, DraftOrderHeader);
                    XmlData.FilterData(PortalUser);
                end;
            'save':
                XmlData.SaveData(PortalUser."Customer No.", PortalUser);
            'deletestaff':
                XmlData.DeleteStaffMember();
            'delete':
                XmlData.DeleteData();
            'sendapproval':
                XmlData.SendApproval();
            else
                Error(UnkownCommandErr, Command);
        end;


        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessDraftOrderStaffLines(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        XmlData: XmlPort "PDC Portal Draft Order Staff";
    begin
        if not (UserRole.Orders or UserRole."Staff Request Create") then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        DraftOrderHeader.Reset();
        CustPortalMgt.FilterDraftOrders(PortalUser, DraftOrderHeader);
        XmlData.FilterData(PortalUser, DraftOrderHeader);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessDraftOrderStaffCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        XmlData: XmlPort "PDC Portal Draft Items Card";
    begin
        if not (UserRole.Orders or UserRole."Staff Request Create") then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        case Command of
            'get':
                begin
                    DraftOrderHeader.Reset();
                    CustPortalMgt.FilterDraftOrders(PortalUser, DraftOrderHeader);
                    XmlData.FilterData(PortalUser, DraftOrderHeader);
                end;
            'save':
                XmlData.SaveData(PortalUser);
            else
                Error(UnkownCommandErr, Command);
        end;

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessDraftOrderFinalise(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        SalesSetup: Record "Sales & Receivables Setup";
        XmlData: XmlPort "PDC Portal Draft Order Final";
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        DraftOrderHeader.Reset();
        CustPortalMgt.FilterDraftOrders(PortalUser, DraftOrderHeader);

        case Command of
            'get':
                XmlData.FilterData(PortalUser, DraftOrderHeader);
            'save':
                XmlData.SaveData(PortalUser, DraftOrderHeader);
            else
                Error(UnkownCommandErr, Command);
        end;

        SalesSetup.Get();
        XmlData.SetCutOffTime(SalesSetup."PDC Order Cut Off Time");
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessDraftOrdersMerge(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        XmlData: XmlPort "PDC Portal Draft Order Card";
    begin
        if not (UserRole.Orders or UserRole."Staff Request Create") then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        DraftOrderHeader.Reset();
        DraftOrderHeader.setfilter("Document No.", Command);
        if DraftOrderHeader.IsEmpty then
            exit;

        XmlData.DraftOrdersMerge(DraftOrderHeader, PortalUser."Customer No.", PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessWardrobeCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Wardrobe Card";
    begin
        if not (UserRole.Orders or UserRole."Staff Request Create") then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData();

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessCompletedReturnOrderList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        CompletedReturnOrderHeader: Record "Return Receipt Header";
        XmlData: XmlPort "PDC Portal Comp Return List";
        BranchFilter: Text;
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        CompletedReturnOrderHeader.Reset();
        BranchFilter := XmlData.GetBranchFilter();

        case BranchFilter of
            'All':
                CustPortalMgt.FilterCompletedReturnOrders(PortalUser, CompletedReturnOrderHeader);
            'Mine':
                CustPortalMgt.FilterCompletedReturnOrdersForCreatedByMe(PortalUser, CompletedReturnOrderHeader);
            else
                CustPortalMgt.FilterCompletedReturnOrdersForBranchFilter(PortalUser, CompletedReturnOrderHeader, BranchFilter);
        end;

        XmlData.FilterData(CompletedReturnOrderHeader);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessCompletedReturnOrderCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        XmlData: XmlPort "PDC Portal Comp Return Card";
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        ReturnReceiptHeader.Reset();
        CustPortalMgt.FilterCompletedReturnOrders(PortalUser, ReturnReceiptHeader);


        XmlData.FilterData(ReturnReceiptHeader);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessShipmentAddressList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Ship Address List";
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        case Command of
            'user':
                XmlData.SetFilterPerUser();
            'BranchAddresses':
                XmlData.SetFilterPerBranch();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessShipmentAddressCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Shipping Address";
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        case
            Command of
            'get':
                ;
            'save':
                XmlData.SaveData(PortalUser);
            'edit':
                XmlData.EditData(PortalUser);
            else
                Error(UnkownCommandErr, Command);
        end;

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    // local procedure ProcessCompletedOrderList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    // var
    //     CompletedOrderHeader: Record "Sales Invoice Header";
    //     XmlData: XmlPort "PDC Portal Sales Inv Head L";
    // begin
    // end;

    // local procedure ProcessCompletedOrderCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    // var
    //     CompletedOrderHeader: Record "Sales Invoice Header";
    //     XmlData: XmlPort "PDC Portal Sales Inv Card";
    // begin
    //     if not UserRole.Orders then exit;

    //     if (GetInputStream(InputData, InpStream)) then begin
    //         XmlData.SetSource(InpStream);
    //         XmlData.Import();
    //     end;

    //     CompletedOrderHeader.Reset();
    //     CustPortalMgt.FilterCompletedOrders(PortalUser, CompletedOrderHeader);

    //     GetOutputStream(OutpStream);
    //     XmlData.SetDestination(OutpStream);
    //     XmlData.Export();
    //     GetOutputData(OutputData);
    // end;

    local procedure ProcessConvertInvoice(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        ReturnOrderHeader: Record "Sales Header";
        SalesInvoiceHeaderDb: Record "Sales Invoice Header";
        XmlData: XmlPort "PDC Portal Recvd Return Card";
        InvoiceNo: Code[20];
        InvoiceNotFoundErr: label 'Invoice %1 was not found', Comment = '%1=invoice no.';
        AlreadyReturnedErr: label 'A return order (%1) has already been created for invoice %2.', Comment = '%1=return no, %2=invoice no.';
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        InvoiceNo := XmlData.GetNoFilter();

        ReturnOrderHeader.Reset();
        ReturnOrderHeader.SetRange("Document Type", ReturnOrderHeader."document type"::"Return Order");
        ReturnOrderHeader.SetRange("PDC Return From Invoice No.", InvoiceNo);
        ReturnOrderHeader.SetRange(Status, ReturnOrderHeader.Status::Open);
        if ReturnOrderHeader.FindFirst() then Error(AlreadyReturnedErr, ReturnOrderHeader."No.", InvoiceNo);

        SalesInvoiceHeaderDb.SetRange("No.", InvoiceNo);
        SalesInvoiceHeaderDb.SetRange("Sell-to Customer No.", PortalUser."Customer No.");

        if SalesInvoiceHeaderDb.IsEmpty then
            Error(InvoiceNotFoundErr, InvoiceNo);

        ReturnOrderHeader.Reset();
        CustPortalMgt.CopyDocument(InvoiceNo, ReturnOrderHeader);
        if NavPortal."Apply Return To Invoice" then begin
            ReturnOrderHeader.Validate("Applies-to Doc. Type", ReturnOrderHeader."applies-to doc. type"::Invoice);
            ReturnOrderHeader.Validate("Applies-to Doc. No.", InvoiceNo);
        end
        else begin
            ReturnOrderHeader.Validate("Applies-to Doc. No.", '');
            ReturnOrderHeader.Validate("Applies-to Doc. Type", ReturnOrderHeader."applies-to doc. type"::" ");
        end;
        ReturnOrderHeader.Validate("PDC Return From Invoice No.", InvoiceNo);
        ReturnOrderHeader.SetHideValidationDialog(true);
        ReturnOrderHeader.Validate("Posting Date", WorkDate());
        SalesInvoiceHeaderDb.get(InvoiceNo);
        ReturnOrderHeader."Ship-to Name" := SalesInvoiceHeaderDb."Ship-to Name";
        ReturnOrderHeader."Ship-to Name 2" := SalesInvoiceHeaderDb."Ship-to Name 2";
        ReturnOrderHeader."Ship-to Address" := SalesInvoiceHeaderDb."Ship-to Address";
        ReturnOrderHeader."Ship-to Address 2" := SalesInvoiceHeaderDb."Ship-to Address 2";
        ReturnOrderHeader."Ship-to City" := SalesInvoiceHeaderDb."Ship-to City";
        ReturnOrderHeader."Ship-to Post Code" := SalesInvoiceHeaderDb."Ship-to Post Code";
        ReturnOrderHeader."Ship-to Contact" := SalesInvoiceHeaderDb."Ship-to Contact";
        ReturnOrderHeader."Ship-to Country/Region Code" := SalesInvoiceHeaderDb."Ship-to Country/Region Code";
        ReturnOrderHeader."Ship-to County" := SalesInvoiceHeaderDb."Ship-to County";
        ReturnOrderHeader.Modify(true);


        XmlData.SetOnConvertFromInvoice();
        XmlData.FilterData(ReturnOrderHeader, ReturnOrderHeader."No.");
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessSaveReturnOrder(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        ReturnOrderHeader: Record "Sales Header";
        XmlData: XmlPort "PDC Portal Recvd Return Card";
        LastOrderNo: Code[20];
        OrderHeader: Record "Sales Header";
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
            XmlData.SaveData(PortalUser);
            LastOrderNo := XmlData.GetNoFilter();
        end;

        OrderHeader.Reset();
        CustPortalMgt.FilterReceivedReturnOrders(PortalUser, OrderHeader);


        XmlData.FilterData(OrderHeader, LastOrderNo);
        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessGetItemPrice(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Get Item Price";
        ItemNo: Code[20];
        ItemPrice: Decimal;
        CustomerNo: Code[20];
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        ItemNo := XmlData.GetItemNo();

        CustPortalMgt.GetCustomerNumber(PortalUser, CustomerNo);

        if CustPortalMgt.GetItemPrice(CustomerNo, ItemNo, ItemPrice) then XmlData.SetItemPrice(ItemPrice);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessStaffCardDetail(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Staff Card Detail";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessEntitlementStaff(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        Branch: Record "PDC Branch";
        XmlData: XmlPort "PDC Portal Entitlement Staff";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        case Command of
            'save':
                XmlData.SaveData(PortalUser);
            'predictedcalc':
                begin
                    XmlData.PredictedCalc(PortalUser);
                    Command := 'predicted';
                end;
        end;

        Branch.Reset();
        Branch.SetRange("Customer No.", PortalUser."Customer No.");

        XmlData.FilterData(Branch, PortalUser, Lowercase(Command));

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessEntitlement(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal Entitlement";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(Lowercase(Command));

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessUserCard(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal User Card";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.FilterData(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessUpdateUser(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        XmlData: XmlPort "PDC Portal User Card";
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.UpdateUser(PortalUser);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessGetItemStock(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrder: Record "PDC Draft Order Header";
        Customer: Record Customer;
        STA: Record "Ship-to Address";
        Item: Record Item;
        XmlData: XmlPort "PDC Portal Get Item Stock";
        ItemNo: Code[20];
        OrderNo: Code[20];
        CustomerNo: Code[20];
        FreeStock: Decimal;
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.GetFilters(OrderNo, ItemNo);

        clear(FreeStock);
        if DraftOrder.get(OrderNo) then begin
            if Customer.Get(DraftOrder."Sell-to Customer No.") then
                if STA.get(Customer."No.", DraftOrder."Ship-to Code") and
                  (STA."Location Code" <> '') then
                    Customer."Location Code" := sta."Location Code";
        end
        else begin
            CustPortalMgt.GetCustomerNumber(PortalUser, CustomerNo);
            if Customer.get(CustomerNo) then;
        end;
        if Customer."No." <> '' then
            FreeStock := PortalsMgt.CalcItemFreeStock(ItemNo, '', Customer."Location Code", WorkDate());

        XmlData.SetFreeStockQty(format(FreeStock, 0, 9));
        if Item.Get(ItemNo) then begin
            XmlData.SetLeadTimeCalculation(Format(Item."Lead Time Calculation"));
            XmlData.SetReplenishmentSystem(Format(Item."Replenishment System"));
        end else begin
            XmlData.SetLeadTimeCalculation('');
            XmlData.SetReplenishmentSystem('');
        end;

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessGetItemAlternativeStock(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        DraftOrder: Record "PDC Draft Order Header";
        Customer: Record Customer;
        STA: Record "Ship-to Address";
        TempBuffer: Record Item temporary;
        XmlData: XmlPort "PDC Portal Get Altern Stock";
        ItemNo: Code[20];
        OrderNo: Code[20];
        CustomerNo: Code[20];
    begin
        if not UserRole.Orders then exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.GetFilters(OrderNo, ItemNo);

        if DraftOrder.get(OrderNo) then begin
            if Customer.Get(DraftOrder."Sell-to Customer No.") then
                if STA.get(Customer."No.", DraftOrder."Ship-to Code") and
                  (STA."Location Code" <> '') then
                    Customer."Location Code" := sta."Location Code";
        end
        else begin
            CustPortalMgt.GetCustomerNumber(PortalUser, CustomerNo);
            if Customer.get(CustomerNo) then;
        end;
        if Customer."No." <> '' then
            PortalsMgt.CalcItemAlternativeStock(ItemNo, '', Customer."Location Code", WorkDate(), TempBuffer);

        XmlData.SetBuffer(TempBuffer);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure ProcessWardrobeItemList(Command: Text[250]; var InputData: BigText; var OutputData: BigText)
    var
        Item: Record Item;
        XmlData: XmlPort "PDC Portal Wardrobe Item List";
        WardrobeID: Code[20];
    begin
        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;

        XmlData.GetFilters(WardrobeID);

        CustPortalMgt.FilterWardrobeItems(PortalUser, Item, WardrobeID);

        XmlData.FilterData(PortalUser, Item);

        GetOutputStream(OutpStream);
        XmlData.SetDestination(OutpStream);
        XmlData.Export();
        GetOutputData(OutputData);
    end;

    local procedure DownloadReport(var TempBlob1: Codeunit "Temp Blob"; UserId: Text[250]; Command: Text[250]; var InputData: BigText; var FileName: Text): Boolean
    var
        Customer: Record Customer;
        StatementRep: Report "PDC Statement";
        InvLinesRep: Report "PDC Consolidate Invoices";
        ContractsRep: Report "PDC Portal - Contracts";
        ItemStockRep: Report "PDC Portal - Item Stock";
        StaffSizesRep: Report "PDC Portal - Staff Sizes";
        StaffHistoryRep: Report "PDC Portal - Staff History";
        PriceListRep: Report "PDC Portal - Price List";
        EntitlementRep: Report "PDC Portal - Staff Entitlement";
        StaffListRep: Report "PDC Portal - Staff List";
        ItemReturnRep: Report "PDC Portal - Item Returns";
        OutstandOrdersRep: Report "PDC Portal - Outstanding Ord.";
        XmlData: XmlPort "PDC Portal Report Request";
        RecRef: RecordRef;
        OutStream: OutStream;
        fileFormat: Text;
        CustomerNo: Code[20];
        startDateTxt: Text;
        endDateTxt: Text;
        StartDate: Date;
        EndDate: Date;
        GroupType: Integer;
        branchFilter: Text;
        typeFilter: Text;
        perUserId: Text[250];
        ReportFormat: ReportFormat;
        Saved: Boolean;
    begin
        PortalsMgt.LoadUser(UserId, NavPortal, PortalUser, UserRole);
        CustPortalMgt.GetCustomerNumber(PortalUser, CustomerNo);
        if not Customer.Get(CustomerNo) then
            exit;

        if (GetInputStream(InputData, InpStream)) then begin
            XmlData.SetSource(InpStream);
            XmlData.Import();
        end;
        fileFormat := Lowercase(XmlData.GetFormatFilter());
        if not (fileFormat in ['pdf', 'xls', 'xlsx']) then
            fileFormat := 'pdf';
        if fileFormat = 'xls' then
            fileFormat := 'xlsx';

        case fileFormat of
            'pdf':
                ReportFormat := ReportFormat::PDF;
            'xlsx':
                ReportFormat := ReportFormat::Excel;
        end;

        startDateTxt := XmlData.GetStartDateFilter();
        if Evaluate(StartDate, startDateTxt) then;
        endDateTxt := XmlData.GetEndDateFilter();
        if Evaluate(EndDate, endDateTxt) then;
        branchFilter := XmlData.GetBranchFilter();
        typeFilter := XmlData.GetTypeFilter();

        if (StartDate = 0D) or (EndDate = 0D) then begin
            StartDate := CalcDate('<-CY>', WorkDate());
            EndDate := CalcDate('<CY>', WorkDate());
        end;

        TempBlob1.CreateOutStream(OutStream);

        case Command of
            'statement':
                begin
                    Customer.SetRecfilter();
                    StatementRep.SetTableview(Customer);
                    StatementRep.InitializeRequest(
                             false, //NewPrintEntriesDue
                             true, //NewPrintAllHavingEntry,
                             true, //NewPrintAllHavingBal,
                             false, //NewPrintReversedEntries,
                             false, //NewPrintUnappliedEntries,
                             true, //NewIncludeAgingBand,
                             '1M+CM', //NewPeriodLength,
                             0, //NewDateChoice,
                             false, //NewLogInteraction,
                             StartDate, //NewStartDate,
                             EndDate //NewEndDate
                             );
                    StatementRep.UseRequestPage(false);

                    FileName := 'Statement_' + CustomerNo + '.' + fileFormat;
                    Saved := StatementRep.SaveAs('', ReportFormat, OutStream);
                end; //statement
            'invoicelines',
            'invoicelinesbybranch',
            'invoicelinesbycontract',
            'invoicelinesbyref':
                begin
                    case Command of
                        'invoicelinesbybranch':
                            begin
                                GroupType := 0; //group by branch
                                FileName := 'InvLines_Branches_' + CustomerNo + '.' + fileFormat;
                            end;
                        'invoicelinesbycontract':
                            begin
                                GroupType := 2; //group by contract
                                FileName := 'InvLines_Contracts_' + CustomerNo + '.' + fileFormat;
                            end;
                        'invoicelinesbyref':
                            begin
                                GroupType := 3; //group by reference
                                FileName := 'InvLines_Ref_' + CustomerNo + '.' + fileFormat;
                            end;
                        else begin
                            GroupType := 5; //no grouping
                            FileName := 'InvLines_' + CustomerNo + '.' + fileFormat;
                        end;
                    end;

                    InvLinesRep.InitializeRequest(
                                CustomerNo,
                                GroupType,
                                StartDate,
                                EndDate
                                );
                    InvLinesRep.UseRequestPage(false);

                    Saved := InvLinesRep.SaveAs('', ReportFormat, OutStream);
                end; //invoicelines
            'contracts':
                begin
                    ContractsRep.InitializeRequest(
                                 CustomerNo
                                 );
                    ContractsRep.UseRequestPage(false);

                    FileName := 'Contracts_' + CustomerNo + '.' + fileFormat;
                    Saved := ContractsRep.SaveAs('', ReportFormat, OutStream);
                end; //contracts
            'itemstock':
                begin
                    ItemStockRep.InitializeRequest(
                                 CustomerNo
                                 );
                    ItemStockRep.UseRequestPage(false);

                    FileName := 'ItemStock_' + CustomerNo + '.' + fileFormat;
                    Saved := ItemStockRep.SaveAs('', ReportFormat, OutStream);
                end; //itemstock
            'staffsizes':
                begin
                    StaffSizesRep.InitializeRequest(
                                 CustomerNo
                                 , UserId
                                 );
                    StaffSizesRep.UseRequestPage(false);

                    FileName := 'StaffSizes_' + CustomerNo + '.' + fileFormat;
                    Saved := StaffSizesRep.SaveAs('', ReportFormat, OutStream);
                end; //staffsizes
            'myhistory',
            'staffhistory':
                begin
                    if Command = 'myhistory' then
                        perUserId := UserId;
                    StaffHistoryRep.InitializeRequest(
                                 CustomerNo
                                 , perUserId
                                 , StartDate //NewStartDate,
                                 , EndDate //NewEndDate
                                 , branchFilter //newbranchFilter
                                 , typeFilter //NewtypeFilter
                                 );
                    StaffHistoryRep.UseRequestPage(false);

                    if Command = 'myhistory' then
                        FileName := 'MyHistory_' + CustomerNo + '.' + fileFormat
                    else
                        FileName := 'StaffHistory_' + CustomerNo + '.' + fileFormat;
                    Saved := StaffHistoryRep.SaveAs('', ReportFormat, OutStream);
                end; //staffhistory
            'pricelist':
                begin
                    PriceListRep.InitializeRequest(
                                 CustomerNo
                                 );
                    PriceListRep.UseRequestPage(false);


                    FileName := 'PriceList_' + CustomerNo + '.' + fileFormat;
                    Saved := PriceListRep.SaveAs('', ReportFormat, OutStream);
                end; //pricelist
            'entitlement',
            'overentitlement',
            'underentitlement':
                begin
                    case Command of
                        'entitlement':
                            typeFilter := '';
                        'overentitlement':
                            typeFilter := 'Over_';
                        'underentitlement':
                            typeFilter := 'Under_';
                    end;

                    EntitlementRep.InitializeRequest(
                                 CustomerNo
                                 , UserId
                                 , branchFilter //newbranchFilter
                                 , typeFilter //NewtypeFilter
                                 );
                    EntitlementRep.UseRequestPage(false);

                    FileName := typeFilter + 'Entitlement_' + CustomerNo + '.' + fileFormat;
                    Saved := EntitlementRep.SaveAs('', ReportFormat, OutStream);
                end; //entitlement
            'stafflist':
                begin
                    StaffListRep.InitializeRequest(
                                 CustomerNo
                                 , UserId
                                 , branchFilter //newbranchFilter
                                 );
                    StaffListRep.UseRequestPage(false);

                    FileName := 'StaffList_' + CustomerNo + '.' + fileFormat;
                    Saved := StaffListRep.SaveAs('', ReportFormat, OutStream);
                end; //stafflist
            'itemreturn':
                begin
                    ItemReturnRep.InitializeRequest(
                                 CustomerNo
                                 );
                    ItemReturnRep.UseRequestPage(false);


                    FileName := 'ItemReturn_' + CustomerNo + '.' + fileFormat;
                    Saved := ItemReturnRep.SaveAs('', ReportFormat, OutStream);
                end; //itemreturn
            'outstandingorders':
                begin
                    OutstandOrdersRep.InitializeRequest(
                                        CustomerNo
                                        , UserId
                                        );
                    OutstandOrdersRep.UseRequestPage(false);

                    FileName := 'OutstandOrders' + '.' + fileFormat;
                    Saved := OutstandOrdersRep.SaveAs('', ReportFormat, OutStream);
                end; //contracts
        end; //case


        exit(Saved);
    end;

    local procedure DownloadDraftOrder(var TempBlob1: Codeunit "Temp Blob"; OrderNo: Code[20]; var FileName: Text): Boolean
    var
        DraftOrderHeader: Record "PDC Draft Order Header";
        RecRef: RecordRef;
        OutStream: OutStream;
        Saved: Boolean;
    begin
        DraftOrderHeader.Reset();
        if (DraftOrderHeader.Get(OrderNo)) then begin
            DraftOrderHeader.SetRecfilter();

            FileName := 'Draft_Order_' + DraftOrderHeader."Document No." + '_' + CopyStr(Format(DraftOrderHeader."Created Date", 0, 9), 1, 10) + '.pdf';

            TempBlob1.CreateOutStream(OutStream);
            RecRef.GetTable(DraftOrderHeader);
            Saved := Report.SaveAs(Report::"PDC Portal - Draft Order", '', ReportFormat::Pdf, OutStream, RecRef);
        end;

        exit(Saved);
    end;

    local procedure DownloadPostedShipment(var TempBlob1: Codeunit "Temp Blob"; ShipNo: Code[20]; var FileName: Text): Boolean
    var
        SalesShipHeader: Record "Sales Shipment Header";
        ReportSelection: Record "Report Selections";
        AllObjWithCaption: Record AllObjWithCaption;
        RecRef: RecordRef;
        OutStream: OutStream;
        Saved: Boolean;
    begin
        SalesShipHeader.Reset();
        if (SalesShipHeader.Get(ShipNo)) then begin
            SalesShipHeader.SetRecfilter();

            ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Shipment");
            ReportSelection.SetFilter("Report ID", '<>0');
            if (ReportSelection.FindFirst()) then begin
                AllObjWithCaption.Get(AllObjWithCaption."object type"::Report, ReportSelection."Report ID");
                FileName := AllObjWithCaption."Object Caption" + '.pdf';

                TempBlob1.CreateOutStream(OutStream);
                RecRef.GetTable(SalesShipHeader);
                Saved := Report.SaveAs(ReportSelection."Report ID", '', ReportFormat::Pdf, OutStream, RecRef);
            end;
        end;

        exit(Saved);
    end;

    local procedure DownloadReturnOrder(var TempBlob1: Codeunit "Temp Blob"; OrderNo: Code[20]; var FileName: Text): Boolean
    var
        ReturnOrderHeader: Record "Sales Header";
        RecRef: RecordRef;
        OutStream: OutStream;
        Saved: Boolean;
    begin
        ReturnOrderHeader.Reset();
        if (ReturnOrderHeader.Get(ReturnOrderHeader."document type"::"Return Order", OrderNo)) then begin
            ReturnOrderHeader.SetRecfilter();

            FileName := 'Return_Order_' + ReturnOrderHeader."No." + '_' + CopyStr(Format(ReturnOrderHeader."Posting Date", 0, 9), 1, 10) + '.pdf';

            TempBlob1.CreateOutStream(OutStream);
            RecRef.GetTable(ReturnOrderHeader);
            Saved := Report.SaveAs(Report::"Return Order Confirmation", '', ReportFormat::Pdf, OutStream, RecRef);
        end;

        exit(Saved);
    end;
}

