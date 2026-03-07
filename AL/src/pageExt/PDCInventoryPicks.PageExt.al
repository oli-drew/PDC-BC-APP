/// <summary>
/// PageExtension PDCInventoryPicks (ID 50037) extends Record Inventory Picks.
/// </summary>
pageextension 50037 PDCInventoryPicks extends "Inventory Picks"
{
    layout
    {
        addafter("Sorting Method")
        {
            field(PDCPickStatus; Rec."PDC Pick Status")
            {
                ApplicationArea = All;
                ToolTip = 'Pick Status';
                StyleExpr = PickStatusStyle;
            }
            field(PDCTrolleyCode; Rec."PDC Trolley Code")
            {
                ApplicationArea = All;
                ToolTip = 'Trolley Code';
            }
            field(PDCPickedBy; Rec."PDC Picked By")
            {
                ApplicationArea = All;
                ToolTip = 'Picked By';
            }
            field(PDCPickStartedAt; Rec."PDC Pick Started At")
            {
                ApplicationArea = All;
                ToolTip = 'Pick Started At';
            }
            field(PDCPickCompletedAt; Rec."PDC Pick Completed At")
            {
                ApplicationArea = All;
                ToolTip = 'Pick Completed At';
            }
            field(PDCTotalQuantity; Rec."PDC Total Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Total Quantity across all pick lines.';
            }
            field(PDCUniqueWearers; Rec."PDC Unique Wearers")
            {
                ApplicationArea = All;
                ToolTip = 'Number of unique wearers on this pick.';
            }
            field(PDCTotalLines; Rec."PDC Total Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Total number of pick lines.';
            }
            field(PDCDateofFirstPrinting; Rec."PDC Date of First Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Date of First Printing';
            }
            field(PDCTimeofFirstPrinting; Rec."PDC Time of First Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Time of First Printing';
            }
            field(PDCDateofLastPrinting; Rec."Date of Last Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Date of Last Printing';
            }
            field(PDCTimeofLastPrinting; Rec."Time of Last Printing")
            {
                ApplicationArea = All;
                ToolTip = 'Time of Last Printing';
            }
            field(PDCSalesDocCreatedAt; Rec."PDC Sales Doc. Created At")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Doc. Created At';
            }
            field(PDCShiptoPostCode; Rec."PDC Ship-to Post Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Post Code';
            }
            field(PDCShipToCountryRegionCode; Rec."PDC Ship-to Country/Reg. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Ship-to Country/Region Code';
            }
            field("PDC Urgent"; Rec."PDC Urgent")
            {
                ToolTip = 'Urgent';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(PDCAssignTrolley)
            {
                ApplicationArea = All;
                Caption = 'Assign Trolley';
                ToolTip = 'Assign a trolley to the selected inventory picks.';
                Image = Allocate;

                trigger OnAction()
                var
                    WhseActivityHeader: Record "Warehouse Activity Header";
                    Trolley: Record "PDC Trolley";
                    TrolleyList: Page "PDC Trolley List";
                begin
                    Trolley.SetRange(Blocked, false);
                    TrolleyList.SetTableView(Trolley);
                    TrolleyList.LookupMode(true);
                    if TrolleyList.RunModal() = Action::LookupOK then begin
                        TrolleyList.GetRecord(Trolley);
                        CurrPage.SetSelectionFilter(WhseActivityHeader);
                        if WhseActivityHeader.FindSet() then
                            repeat
                                WhseActivityHeader.Validate("PDC Trolley Code", Trolley.Code);
                                WhseActivityHeader.Modify(true);
                            until WhseActivityHeader.Next() = 0;
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PDCPickStatusMgt: Codeunit "PDC Pick Status Mgt";
    begin
        if Rec."PDC Unique Wearers" = 0 then begin
            PDCPickStatusMgt.RecalcUniqueWearers(Rec."No.");
            Rec.Find();
        end;
        SetPickStatusStyle();
    end;

    var
        PickStatusStyle: Text;

    local procedure SetPickStatusStyle()
    begin
        case Rec."PDC Pick Status" of
            Rec."PDC Pick Status"::Complete:
                PickStatusStyle := 'Favorable';
            Rec."PDC Pick Status"::"In Progress":
                PickStatusStyle := 'Ambiguous';
            else
                PickStatusStyle := 'Standard';
        end;
    end;
}

