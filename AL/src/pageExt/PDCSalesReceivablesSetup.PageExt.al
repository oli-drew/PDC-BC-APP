/// <summary>
/// PageExtension PDCSalesReceivablesSetup (ID 50051) extends Record Sales &amp; Receivables Setup.
/// </summary>
pageextension 50051 PDCSalesReceivablesSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field(PDCDefaultItemTemplate; Rec."PDC Default Item Template")
            {
                ToolTip = 'Default Item Template';
                ApplicationArea = All;
            }
            field(PDCDefaultCustomerTemplate; Rec."PDC Default Customer Template")
            {
                ToolTip = 'Default Customer Template';
                ApplicationArea = All;
            }
            field(PDCDefaultVendorTemplate; Rec."PDC Default Vendor Template")
            {
                ToolTip = 'Default Vendor Template';
                ApplicationArea = All;
            }
            field("PDC Despatch Date Buffer"; Rec."PDC Despatch Date Buffer")
            {
                ToolTip = 'Despatch Date Buffer';
                ApplicationArea = All;
            }
            field(PDCCarriageChargeGLAccount; Rec."PDC Carriage Charge G/L Acc.")
            {
                ToolTip = 'Carriage Charge G/L Account';
                ApplicationArea = All;
            }
            field(PDCOrderCutOffTime; Rec."PDC Order Cut Off Time")
            {
                ToolTip = 'Order Cut Off Time';
                ApplicationArea = All;
            }
            field("PDC Despatch Cut Off Time"; Rec."PDC Despatch Cut Off Time")
            {
                ToolTip = 'Despatch Cut Off Time';
                ApplicationArea = All;
            }
            field(PDCInvPickPrintLabels; Rec."PDC Inv.Pick Print Labels")
            {
                ToolTip = 'Inv.Pick Print Labels';
                ApplicationArea = All;
            }
        }
        addlast("Number Series")
        {
            field(PDCBarcodeNos; Rec."PDC Barcode Nos.")
            {
                ToolTip = 'Barcode Nos.';
                ApplicationArea = All;
            }
            field(PDCStartInvoiceNo; Rec."PDC Start Invoice No.")
            {
                ToolTip = 'Start Invoice No.';
                ApplicationArea = All;
            }
            field(PDCStartCrMemoNo; Rec."PDC Start Cr.Memo No.")
            {
                ToolTip = 'Start Cr.Memo No.';
                ApplicationArea = All;
            }
            field(PDCConsignmentNos; Rec."PDC Consignment Nos.")
            {
                ToolTip = 'Consignment Nos.';
                ApplicationArea = All;
            }
            field(PDCBrandingNos; Rec."PDC Branding Nos.")
            {
                ToolTip = 'Branding Nos.';
                ApplicationArea = All;
            }
            field(PDCProposalNos; Rec."PDC Proposal Nos.")
            {
                ToolTip = 'Proposal Nos."';
                ApplicationArea = All;
            }
            field("PDC Ship-to Addrs. Nos."; Rec."PDC Ship-to Addrs. Nos.")
            {
                ToolTip = 'Ship-to Addrs. Nos.';
                ApplicationArea = All;
            }
        }
        addlast("Background Posting")
        {
            field(PDCLabelPrinter; Rec."PDC Label Printer")
            {
                ToolTip = 'Label Printer';
                ApplicationArea = All;
                LookupPageID = Printers;
            }
            group(PDCEMailSetup)
            {
                Caption = 'E-Mail Setup';
                field(PDCInvoiceEmailSetup; Rec."PDC Invoice E-mail Setup")
                {
                    ToolTip = 'Invoice E-mail Setup';
                    ApplicationArea = All;
                }
                field(PDCStatementEmailSetup; Rec."PDC Statement E-mail Setup")
                {
                    ToolTip = 'Statement E-mail Setup';
                    ApplicationArea = All;
                }
                field(PDCCreditMemoEmailSetup; Rec."PDC Credit Memo E-mail Setup")
                {
                    ToolTip = 'Credit Memo E-mail Setup';
                    ApplicationArea = All;
                }
                field(PDCTestEMailAddress; Rec."PDC Test E-Mail Address")
                {
                    ToolTip = 'Test E-Mail Address';
                    ApplicationArea = All;
                }
                field(PDCDefCustStatmStartDate; Rec."PDC Def.Cust.Statm. Start Date")
                {
                    ToolTip = 'Def Cust Statm Start Date';
                    ApplicationArea = All;
                }
                field(PDCDefCustStatmEndDate; Rec."PDC Def. Cust. Statm. End Date")
                {
                    ToolTip = 'Def. Cust. Statm. End Date';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {

        addfirst(processing)
        {
            group(PDCOrderConfirmationEmail)
            {
                Caption = 'Order Confirmation E-mail';
                Image = Attachments;
                action(PDCOrderConf_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Order Conf. E-mail Body"));
                    end;
                }
                action(PDCOrderConf_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Order Conf. E-mail Body"));
                    end;
                }
                action(PDCOrderConf_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Order Conf. E-mail Body"), true);
                    end;
                }
            }
            group(PDCOrderRequestApprovedEmail)
            {
                Caption = 'Order Request Approved E-mail';
                Image = Attachments;
                action(PDCOrderReqApproved_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Order Conf2. E-mail Body"));
                    end;
                }
                action(PDCOrderReqApproved_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Order Conf2. E-mail Body"));
                    end;
                }
                action(PDCOrderReqApproved_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Order Conf2. E-mail Body"), true);
                    end;
                }
            }
            group(PDCReturnConfirmationEmail)
            {
                Caption = 'Return Confirmation E-mail';
                Image = Attachments;
                action(PDCReturnConf_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Return Conf. E-mail Body"));
                    end;
                }
                action(PDCReturnConf_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Return Conf. E-mail Body"));
                    end;
                }
                action(PDCReturnConf_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Return Conf. E-mail Body"), true);
                    end;
                }
            }
            group(PDCEntitlementEmail)
            {
                Caption = 'Entitlement E-mail';
                Image = Attachments;
                action(PDCEntitlement_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Entitlement E-mail Body")); //12.05.2020 JEMEL J.Jemeljanovs #3257 
                    end;
                }
                action(PDCEntitlement_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Entitlement E-mail Body")); //12.05.2020 JEMEL J.Jemeljanovs #3257 
                    end;
                }
                action(PDCEntitlement_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Entitlement E-mail Body"), true); //12.05.2020 JEMEL J.Jemeljanovs #3257
                    end;
                }
            }
            group(PDCDraftOrderApproval)
            {
                Caption = 'Draft Order Approval';
                ToolTip = 'Draft Order Approval';
                Image = Attachments;
                action(PDCOrdApprove_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Order Approval E-mail Body")); //15.06.2020 JEMEL J.Jemeljanovs #3294
                    end;
                }
                action(PDCOrdApprove_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Order Approval E-mail Body")); //15.06.2020 JEMEL J.Jemeljanovs #3294
                    end;
                }
                action(PDCOrdApprove_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Order Approval E-mail Body"), true); //15.06.2020 JEMEL J.Jemeljanovs #3294 
                    end;
                }
            }
            group(PDCDraftOrderNotification)
            {
                Caption = 'Draft Order Notification';
                ToolTip = 'Draft Order Notification';
                Image = Attachments;
                action(PDCOrdNotification_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Order Notif. E-mail Body"));
                    end;
                }
                action(PDCOrdNotification_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Order Notif. E-mail Body"));
                    end;
                }
                action(PDCOrdNotification_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Order Notif. E-mail Body"), true);
                    end;
                }
            }
            group(PDCDraftOrderApproveReminder)
            {
                Caption = 'Draft Order Approve Reminder';
                ToolTip = 'Draft Order Approve Reminder';
                Image = Attachments;
                action(PDCOrdApprRem_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC Order Appr.Rem.E-mail Body"));
                    end;
                }
                action(PDCOrdApprRem_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC Order Appr.Rem.E-mail Body"));
                    end;
                }
                action(PDCOrdApprRem_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC Order Appr.Rem.E-mail Body"), true);
                    end;
                }
            }
            group(PDCWelcomeEmail)
            {
                Caption = 'User Welcome E-mail';
                ToolTip = 'USer Welcome E-mail';
                Image = Attachments;
                action(PDCWelcomeEmail_ImportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    ToolTip = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ImportAttachment(Rec.FIELDNO("PDC User Welcome E-mail Body"));
                    end;
                }
                action(PDCWelcomeEmail_ExportAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';
                    ToolTip = 'Export';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_ExportAttachment(Rec.FIELDNO("PDC User Welcome E-mail Body"));
                    end;
                }
                action(PDCWelcomeEmail_RemoveAttachment)
                {
                    ApplicationArea = All;
                    Caption = 'Remove';
                    ToolTip = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.PortalConf_RemoveAttachment(Rec.FIELDNO("PDC User Welcome E-mail Body"), true);
                    end;
                }
            }
        }
    }
}

