/// <summary>
/// PageExtension PDCContact List (ID 50083) extends Record Contact List.
/// </summary>
pageextension 50083 "PDCContact List" extends "Contact List"
{
    layout
    {
        addafter("E-Mail")
        {
            field("PDC Company No."; Rec."Company No.")
            {
                ApplicationArea = All;
                ToolTip = 'Company No.';
            }
        }
    }
    actions
    {
        addlast(reporting)
        {
            action("PDC ContactLabelsDN")
            {
                ApplicationArea = All;
                Caption = 'Contact Labels DN';
                ToolTip = 'Contact Labels DN';
                Image = "Report";

                trigger OnAction()
                var
                    rContact: Record Contact;
                begin
                    rContact.Reset();
                    rContact.SetRange("No.", Rec."No.");
                    Report.Run(Report::"PDC Contact - Labels DN", true, false, rContact);
                end;
            }
        }
        addlast("F&unctions")
        {
            action(PDCCreateNewCompanyPerson)
            {
                ApplicationArea = All;
                Caption = 'Create New Company Person';
                ToolTip = 'Create New Company Person';
                Image = ContactPerson;

                trigger OnAction()
                begin
                    Rec.CreateNewCompanyPerson();
                end;
            }
            action(PDCCreatePortalUser)
            {
                ApplicationArea = All;
                Caption = 'Create Portal User';
                ToolTip = 'Create Portal User';
                Image = UserCertificate;

                trigger OnAction()
                var
                    PDCPortalsManagement: Codeunit "PDC Portals Management";
                begin
                    PDCPortalsManagement.CreateUserFromContact(Rec, false);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(PDCCreateNewCompanyPerson_Promoted; PDCCreateNewCompanyPerson)
            {
            }
            actionref(PDCCreatePortalUser_Promoted; PDCCreatePortalUser)
            {
            }
        }
    }
}
