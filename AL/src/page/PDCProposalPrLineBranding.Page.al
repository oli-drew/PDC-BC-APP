/// <summary>
/// Page PDC Proposal Product Line Bran (ID 50082).
/// </summary>
page 50082 "PDC Proposal Pr. Line Branding"
{
    Caption = 'Proposal Product Line Branding';
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "PDC Proposal Product Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ProposalNo; Rec."Proposal No.")
                {
                    ToolTip = 'Proposal No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ToolTip = 'Line No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ProductCode; Rec."Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(VendorItem; Rec."Vendor Item")
                {
                    ToolTip = 'Vendor Item';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
            }
            part(BrandingLines; "PDC Proposal Branding Line")
            {
                SubPageLink = "Proposal No." = field("Proposal No."),
                              "Proposal Line No." = field("Line No.");
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(UpdateLine)
                {
                    ApplicationArea = All;
                    Caption = 'Update Cost';
                    ToolTip = 'Update Cost';
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
            }
        }
    }
}

