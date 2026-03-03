/// <summary>
/// XmlPort PDC Portal Dashboard (ID 50055).
/// </summary>
XmlPort 50055 "PDC Portal Dashboard"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(dashboard)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            textelement(data)
            {
                // textelement(generaldocuments)
                // {
                //     MaxOccurs = Once;
                //     MinOccurs = Once;
                //     XmlName = 'generalDocuments';
                // }
                // textelement(customerdocuments)
                // {
                //     MaxOccurs = Once;
                //     MinOccurs = Once;
                //     XmlName = 'customerDocuments';
                // }
                // textelement(inprogressincidents)
                // {
                //     MaxOccurs = Once;
                //     MinOccurs = Once;
                //     XmlName = 'inprogressIncidents';
                // }
                // textelement(awaitingresponseincidents)
                // {
                //     MaxOccurs = Once;
                //     MinOccurs = Once;
                //     XmlName = 'awaitingresponseIncidents';
                // }
                // textelement(resolvedincidents)
                // {
                //     MaxOccurs = Once;
                //     MinOccurs = Once;
                //     XmlName = 'resolvedIncidents';
                // }
                // textelement(closedincidents)
                // {
                //     XmlName = 'closedIncidents';
                // }
                textelement(openinvoices)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'invoices';
                }
                textelement(orders)
                {
                    XmlName = 'orders';
                }
                textelement(balance)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'balance';
                }
                textelement(balancedue)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'balanceDue';
                }
                textelement(invoicecount)
                {
                    XmlName = 'invoiceCount';
                }
                textelement(dueinvoicecount)
                {
                    XmlName = 'dueInvoiceCount';
                }
                textelement(paidinvoicecount)
                {
                    XmlName = 'paidInvoiceCount';
                }
                textelement(crmemocount)
                {
                    XmlName = 'crMemoCount';
                }
                textelement(closedcrmemocount)
                {
                    XmlName = 'closedCrMemoCount';
                }
                textelement(receivedReturnOrderCount)
                {
                }
                textelement(completedReturnOrderCount)
                {
                }
                // textelement(assistancetext)
                // {
                //     XmlName = 'assistanceText';
                // }
                textelement(draftOrdersCount)
                {
                }
                textelement(staffCount)
                {
                }
                textelement(activeStaffCount)
                {
                }
                textelement(inactiveStaffCount)
                {
                }
                textelement(entitlementRemainingCount)
                {
                    MinOccurs = Zero;
                }
                textelement(entitlementCompletedCount)
                {
                    MinOccurs = Zero;
                }
                textelement(entitlementExceededCount)
                {
                    MinOccurs = Zero;
                }
                textelement(entitlementPredictedCount)
                {
                    MinOccurs = Zero;
                }
                textelement(wardrobeAllItemsCount)
                {
                    MinOccurs = Zero;
                }
                textelement(wardrobeCount)
                {
                    MinOccurs = Zero;
                }
                textelement(contractsCount)
                {
                    MinOccurs = Zero;
                }
                // textelement(messages)
                // {
                //     MinOccurs = Zero;
                // }
                textelement(myRequestsAwaitingApproval)
                {
                }
                textelement(requestsAwaitingApproval)
                {
                }
                textelement(myApprovedOrdersCount)
                {
                }
                textelement(myApprovedInvoiceCount)
                {
                }
            }
        }
    }

    var
        CustPortalMgt: Codeunit "PDC Portal Mgt";

    /// <summary>
    /// InitData.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    procedure InitData(var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User")
    var
        PortalRole: Record "PDC Portal Role";
        NavPortalMgt: Codeunit "PDC Portals Management";
    begin
        NavPortalMgt.GetUserMergedRole(PortalUser, PortalRole);

        //assistanceText := NavPortal.GetAssistanceText();

        if PortalRole.Orders then begin
            draftOrdersCount := Format(CustPortalMgt.CountDraftOrdersForCreatedByMe(PortalUser));
            Orders := Format(CustPortalMgt.CountOrdersForCreatedByMe(NavPortal, PortalUser));
            invoiceCount := Format(CustPortalMgt.GetInvCount(PortalUser));
        end;

        if PortalRole.Finances then begin
            OpenInvoices := Format(CustPortalMgt.GetInvoiceAmount(PortalUser), 0, 9);
            BalanceDue := Format(CustPortalMgt.GetDueAmount(PortalUser), 0, 9);
            dueInvoiceCount := Format(CustPortalMgt.GetOpenInvCount(PortalUser));
            paidInvoiceCount := Format(CustPortalMgt.GetClosedInvCount(PortalUser));
            crMemoCount := Format(CustPortalMgt.CountOpenCrMemos(PortalUser));
            closedCrMemoCount := Format(CustPortalMgt.CountClosedCrMemos(PortalUser));
        end;

        if PortalRole.Returns then begin
            receivedReturnOrderCount := Format(CustPortalMgt.CountReceivedReturnOrdersForMyBranches(PortalUser));
            completedReturnOrderCount := Format(CustPortalMgt.CountCompletedReturnOrdersForMyBranches(PortalUser));
        end;


        if PortalRole."Staff Request Create" then begin
            if not PortalRole.Orders then //previously calculated
                draftOrdersCount := Format(CustPortalMgt.CountDraftOrdersForCreatedByMe(PortalUser));
            myRequestsAwaitingApproval := Format(CustPortalMgt.CountDraftOrdersForCreatedByMeWaitingApproval(PortalUser));
        end;

        if PortalRole."Staff Request Approve" then begin
            requestsAwaitingApproval := Format(CustPortalMgt.CountDraftOrdersForMyApprovals(PortalUser));
            myApprovedOrdersCount := format(CustPortalMgt.CountOrdersForApprovedByMe(NavPortal, PortalUser));
            myApprovedInvoiceCount := format(CustPortalMgt.CountCustLedgerEntriesForApprovedByMe(NavPortal, PortalUser));
        end;


        if PortalRole.Entitlement then begin
            entitlementRemainingCount := Format(CustPortalMgt.CountEntitlement(PortalUser, 0), 9);
            entitlementCompletedCount := Format(CustPortalMgt.CountEntitlement(PortalUser, 1), 9);
            entitlementExceededCount := Format(CustPortalMgt.CountEntitlement(PortalUser, 2), 9);
            entitlementPredictedCount := Format(CustPortalMgt.CountEntitlement(PortalUser, 3), 9);
        end;

        if PortalRole.Wardrobe then begin
            wardrobeAllItemsCount := Format(CustPortalMgt.CountWardrobeItems(PortalUser), 9);
            wardrobeCount := Format(CustPortalMgt.CountWardrobes(PortalUser), 9);
        end;

        if PortalRole.Contracts then
            contractsCount := Format(CustPortalMgt.CountCountracts(PortalUser), 9);

        if PortalRole.Staff then begin
            staffCount := Format(CustPortalMgt.CountStaffForMyBranches(PortalUser));
            activeStaffCount := Format(CustPortalMgt.CountActiveStaff(PortalUser));
            inactiveStaffCount := Format(CustPortalMgt.CountInactiveStaff(PortalUser));
        end;
    end;
}

