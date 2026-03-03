/// <summary>
/// Page PDCProposal (ID 50078).
/// </summary>
page 50078 PDCProposal
{
    Caption = 'Proposal';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "PDC Proposal Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ToolTip = 'Contact No.';
                    ApplicationArea = All;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ToolTip = 'Customer No.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Name';
                    ApplicationArea = All;
                }
                field(Name2; Rec."Name 2")
                {
                    ToolTip = 'Name 2';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Address';
                    ApplicationArea = All;
                }
                field(Address2; Rec."Address 2")
                {
                    ToolTip = 'Address 2';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'City';
                    ApplicationArea = All;
                }
                field(ContactName; Rec."Contact Name")
                {
                    ToolTip = 'Contact Name';
                    ApplicationArea = All;
                }
                field(PostCode; Rec."Post Code")
                {
                    ToolTip = 'Post Code';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'County';
                    ApplicationArea = All;
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ToolTip = 'Country/Region Code';
                    ApplicationArea = All;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ToolTip = 'Phone No.';
                    ApplicationArea = All;
                }
                field(EMail; Rec."E-Mail")
                {
                    ToolTip = 'E-Mail';
                    ApplicationArea = All;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ToolTip = 'Salesperson Code';
                    ApplicationArea = All;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ToolTip = 'Document Date';
                    ApplicationArea = All;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ToolTip = 'External Document No.';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Active';
                    ApplicationArea = All;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ToolTip = 'Inactive Date';
                    ApplicationArea = All;
                }
                field(TotalSales; Rec."Total Sales")
                {
                    ToolTip = 'Total Sales';
                    ApplicationArea = All;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ToolTip = 'Total Cost';
                    ApplicationArea = All;
                }
                field(GrossProfitTotal; Rec."Gross Profit Total")
                {
                    ToolTip = 'Gross Profit Total';
                    ApplicationArea = All;
                }
                field(TotGrProfitPct; TotGrProfitPct)
                {
                    Caption = 'Total Gross profit percentage';
                    ToolTip = 'Total Gross profit percentage';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(ProductLines; "PDC Proposal Product Line")
            {
                SubPageLink = "Proposal No." = field("No.");
            }
            part(CostingLines; "PDC Proposal Costing Line")
            {
                Editable = false;
                SubPageLink = "Proposal No." = field("No.");
            }
            part(BrandingLines; "PDC Proposal Branding Line")
            {
                Editable = false;
                SubPageLink = "Proposal No." = field("No.");
            }
        }
        area(factboxes)
        {
            part(ProposalFactBox; "PDC Proposal FactBox")
            {
                SubPageLink = "No." = field("No.");
            }
            part(SalesHistSelltoFactBox; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = field("Customer No.");
            }
            systempart(RecordLinks; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
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
                ToolTip = 'Functions';
                Image = "Action";
                action(UpdateLine)
                {
                    ApplicationArea = All;
                    Caption = 'Update Data';
                    ToolTip = 'Update Data';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.UpdateLines();
                    end;
                }
                action(Print)
                {
                    ApplicationArea = All;
                    Caption = '&Print';
                    ToolTip = 'Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ProposalHdr: Record "PDC Proposal Header";
                    begin
                        CurrPage.SetSelectionFilter(ProposalHdr);
                        Report.Run(Report::"PDC Proposal Print", true, false, ProposalHdr);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Date" := WorkDate();
    end;

    trigger OnAfterGetRecord()
    begin
        //03.12.2020 JEMEL J.Jemeljanovs #3517 >>
        clear(TotGrProfitPct);
        if (Rec."Total Sales" <> 0) then
            TotGrProfitPct := round(Rec."Gross Profit Total" / Rec."Total Sales" * 100, 0.01);
        //03.12.2020 JEMEL J.Jemeljanovs #3517 <<
    end;

    var
        TotGrProfitPct: Decimal;
}

