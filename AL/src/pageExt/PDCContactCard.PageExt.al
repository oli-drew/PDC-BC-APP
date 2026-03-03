/// <summary>
/// PageExtension PDCContactCard (ID 50054) extends Record Contact Card.
/// </summary>
PageExtension 50054 PDCContactCard extends "Contact Card"
{
    layout
    {
        modify("Phone No.")
        {
            trigger OnAssistEdit()
            begin
                TAPIManagement.Dial(Rec."Phone No.");
            end;
        }

        modify("Mobile Phone No.")
        {
            trigger OnAssistEdit()
            begin
                TAPIManagement.Dial(Rec."Mobile Phone No.");
            end;
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

    var
        TAPIManagement: Codeunit TAPIManagement;
}

