/// <summary>
/// Page PDC Demand Prod. Req. Worksh. (ID 50057).
/// </summary>
page 50057 "PDC Demand Prod. Req. Worksh."
{
    Caption = 'Demand Products Req. Worksheet';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "PDC Demand Item Req. Line";
    UsageCategory = Tasks;
    ApplicationArea = All;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            field(CurrentRequesterID; CurrentRequesterID)
            {
                ApplicationArea = All;
                Caption = 'Name';
                ToolTip = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                var
                    User: Record User;
                    UserSelection: Codeunit "User Selection";
                begin
                    User.Reset();
                    UserSelection.Open(User);
                    CurrentRequesterID := User."User Name";
                end;

                trigger OnValidate()
                var
                    UserSelection: Codeunit "User Selection";
                begin
                    if CurrentRequesterID <> '' then
                        UserSelection.ValidateUserName(CurrentRequesterID);
                    SetFilters();
                    CurrPage.Update(false);
                end;
            }
            repeater(RepeaterControl)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Item No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field(Description2; Rec."Description 2")
                {
                    ToolTip = 'Description 2';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Quantity';
                    ApplicationArea = All;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Unit of Measure Code';
                    ApplicationArea = All;
                }
                field(DueDate; Rec."Due Date")
                {
                    ToolTip = 'Due Date';
                    ApplicationArea = All;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ToolTip = 'Order Date';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ToolTip = 'Vendor No.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    ToolTip = 'Card';
                    Image = Item;
                    Promoted = false;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = field("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
        area(processing)
        {
            group(Posting)
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    ToolTip = 'Post';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        PurchSetup: Record "Purchases & Payables Setup";
                        PurchHeader: Record "Purchase Header";
                        PurchLine: Record "Purchase Line";
                        TempPurchaseHeader: Record "Purchase Header" temporary;
                        DemandReqLines: Record "PDC Demand Item Req. Line";
                        NoSeries: Codeunit "No. Series";
                        conf_txtLbl: label 'Do you want to post Demand Item Requisition Lines?', Comment = 'Do you want to post Demand Item Requisition Lines?';
                        LastLineNo: Integer;
                    begin
                        //09.09.2017 JEMEL J.Jemeljanovs #2296 >>
                        if Confirm(conf_txtLbl, false) then begin
                            DemandReqLines.Reset();
                            DemandReqLines.CopyFilters(Rec);
                            if CurrentRequesterID <> '' then
                                DemandReqLines.SetRange("Requester ID", CurrentRequesterID);
                            if DemandReqLines.FindSet() then begin
                                PurchSetup.Get();
                                PurchSetup.TestField("Order Nos.");

                                repeat
                                    DemandReqLines.TestField("Vendor No.");
                                    DemandReqLines.TestField("Due Date");

                                    TempPurchaseHeader.Reset();
                                    TempPurchaseHeader.SetRange("Buy-from Vendor No.", DemandReqLines."Vendor No.");
                                    TempPurchaseHeader.SetRange("Expected Receipt Date", DemandReqLines."Due Date");
                                    if not TempPurchaseHeader.FindFirst() then begin
                                        Clear(PurchHeader);
                                        PurchHeader.Init();
                                        PurchHeader."Document Type" := PurchHeader."document type"::Order;
                                        PurchHeader."No. Series" := PurchHeader.GetNoSeriesCode();
                                        PurchHeader."No." := NoSeries.GetNextNo(PurchHeader."No. Series", PurchHeader."Posting Date");
                                        PurchHeader."Posting No. Series" := PurchSetup."Posted Invoice Nos.";
                                        PurchHeader."Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                                        PurchHeader.Insert(true);
                                        PurchHeader.Validate("Buy-from Vendor No.", DemandReqLines."Vendor No.");
                                        PurchHeader.Validate("Order Date", DemandReqLines."Order Date");
                                        PurchHeader.Validate("Expected Receipt Date", DemandReqLines."Due Date");
                                        PurchHeader.Modify(true);

                                        TempPurchaseHeader.Init();
                                        TempPurchaseHeader := PurchHeader;
                                        TempPurchaseHeader.Insert();
                                    end
                                    else
                                        PurchHeader.Get(TempPurchaseHeader."Document Type", TempPurchaseHeader."No.");

                                    PurchLine.Reset();
                                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                                    PurchLine.SetRange("Document No.", PurchHeader."No.");
                                    PurchLine.SetRange(Type, PurchLine.Type::Item);
                                    PurchLine.SetRange("No.", DemandReqLines."Item No.");
                                    if not PurchLine.FindFirst() then begin
                                        PurchLine.Reset();
                                        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                                        PurchLine.SetRange("Document No.", PurchHeader."No.");
                                        if PurchLine.FindLast() then
                                            LastLineNo := PurchLine."Line No.";

                                        PurchLine.Init();
                                        PurchLine."Document Type" := PurchHeader."Document Type";
                                        PurchLine."Document No." := PurchHeader."No.";
                                        PurchLine."Line No." := LastLineNo + 10000;
                                        PurchLine.Insert(true);
                                        PurchLine.Type := PurchLine.Type::Item;
                                        PurchLine.Validate("No.", DemandReqLines."Item No.");
                                        PurchLine.Modify(true);
                                    end;
                                    PurchLine.Validate(Quantity, PurchLine.Quantity + ROUND(DemandReqLines."Quantity (Base)" / PurchLine."Qty. per Unit of Measure", 0.00001));
                                    PurchLine.Modify(true);

                                    DemandReqLines.Delete(true);
                                until DemandReqLines.Next() = 0;
                            end;
                        end;
                        //09.09.2017 JEMEL J.Jemeljanovs #2296 <<
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Requester ID" := CurrentRequesterID;
    end;

    trigger OnOpenPage()
    begin
        CurrentRequesterID := CopyStr(UserId, 1, 50);
        SetFilters();
    end;

    var
        CurrentRequesterID: Code[50];

    local procedure SetFilters()
    begin
        Rec.FilterGroup := 2;
        if CurrentRequesterID <> '' then
            Rec.SetRange("Requester ID", CurrentRequesterID)
        else
            Rec.SetRange("Requester ID");
        Rec.FilterGroup := 0;
    end;
}

