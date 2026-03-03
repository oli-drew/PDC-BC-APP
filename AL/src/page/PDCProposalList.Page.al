/// <summary>
/// Page PDC Proposal List (ID 50077).
/// </summary>
page 50077 "PDC Proposal List"
{
    Caption = 'Proposal List';
    CardPageID = PDCProposal;
    Editable = false;
    PageType = List;
    SourceTable = "PDC Proposal Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'No.';
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contact No.';
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name';
                }
                field(Name2; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name 2';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Address';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Address 2';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'City';
                }
                field(ContactName; Rec."Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contact Name';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Post Code';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Country';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Country/Region Code';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Phone No.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'E-Mail';
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Salesperson Code';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document Date';
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'External Document No.';
                }
                field(TotalSales; Rec."Total Sales")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Sales';
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Cost';
                }
                field(GrossProfitTotal; Rec."Gross Profit Total")
                {
                    ApplicationArea = All;
                    ToolTip = 'Gross Profit Total';
                }
                field(Active; Rec.Active) //03.12.2020 JEMEL J.Jemeljanovs #3517
                {
                    ApplicationArea = All;
                    ToolTip = 'Active';
                }
            }
        }
        area(factboxes)
        {
            systempart(RecordLinks; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Print)
                {
                    ApplicationArea = All;
                    Caption = '&Print';
                    ToolTip = 'Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ProposalHdr: Record "PDC Proposal Header";
                    begin
                        CurrPage.SetSelectionFilter(ProposalHdr);
                        Report.RunModal(Report::"PDC Proposal Print", true, false, ProposalHdr);
                    end;
                }
            }
        }
    }
}

