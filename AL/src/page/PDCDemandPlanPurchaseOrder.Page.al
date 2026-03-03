/// <summary>
/// Page PDC Demand Plan Purchase Order (ID 50056).
/// </summary>
page 50056 "PDC Demand Plan Purchase Order"
{
    Caption = 'Demand Plan Purchase Orders';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = Item;
    SourceTableView = sorting("PDC Product Code", "PDC Colour Sequence", "PDC Fit Sequence", "PDC Size Sequence")
                      order(ascending);
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(ShowData; ShowData)
            {
                ApplicationArea = All;
                Caption = 'Show Data';
                ToolTip = 'Show Data';
                Lookup = true;
                OptionCaption = 'All,Purchase Orders,Planning Worksheet';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ToolTip = 'No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ProductCode; Rec."PDC Product Code")
                {
                    ToolTip = 'Product Code';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Colour; Rec."PDC Colour")
                {
                    ToolTip = 'Colour';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Fit; Rec."PDC Fit")
                {
                    ToolTip = 'Fit';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Size; Rec."PDC Size")
                {
                    ToolTip = 'Size';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Col1; MatrixCellData[1])
                {
                    ToolTip = 'Col1';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[1];
                    DrillDown = true;
                    StyleExpr = Col1Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(1);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(1);
                    end;
                }
                field(Col2; MatrixCellData[2])
                {
                    ToolTip = 'Col2';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[2];
                    DrillDown = true;
                    StyleExpr = Col2Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(2);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(2)
                    end;
                }
                field(Col3; MatrixCellData[3])
                {
                    ToolTip = 'Col3';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[3];
                    DrillDown = true;
                    StyleExpr = Col3Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(3);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(3)
                    end;
                }
                field(Col4; MatrixCellData[4])
                {
                    ToolTip = 'Col4';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[4];
                    DrillDown = true;
                    StyleExpr = Col4Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(4);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(4)
                    end;
                }
                field(Col5; MatrixCellData[5])
                {
                    ToolTip = 'Col5';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[5];
                    DrillDown = true;
                    StyleExpr = Col5Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(5);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(5)
                    end;
                }
                field(Col6; MatrixCellData[6])
                {
                    ToolTip = 'Col6';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[6];
                    DrillDown = true;
                    StyleExpr = Col6Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(6);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(6);
                    end;
                }
                field(Col7; MatrixCellData[7])
                {
                    ToolTip = 'Col7';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[7];
                    DrillDown = true;
                    StyleExpr = Col7Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(7);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(7);
                    end;
                }
                field(Col8; MatrixCellData[8])
                {
                    ToolTip = 'Col8';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[8];
                    DrillDown = true;
                    StyleExpr = Col8Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(8);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(8);
                    end;
                }
                field(Col9; MatrixCellData[9])
                {
                    ToolTip = 'Col9';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[9];
                    DrillDown = true;
                    StyleExpr = Col9Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(9);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(9);
                    end;
                }
                field(Col10; MatrixCellData[10])
                {
                    ToolTip = 'Col10';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[10];
                    DrillDown = true;
                    StyleExpr = Col10Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(10);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(10);
                    end;
                }
                field(Col11; MatrixCellData[11])
                {
                    ToolTip = 'Col11';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[11];
                    DrillDown = true;
                    StyleExpr = Col11Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(11);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(11);
                    end;
                }
                field(Col12; MatrixCellData[12])
                {
                    ToolTip = 'Col12';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[12];
                    DrillDown = true;
                    StyleExpr = Col12Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(12);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(12);
                    end;
                }
                field(Col13; MatrixCellData[13])
                {
                    ToolTip = 'Col13';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[13];
                    DrillDown = true;
                    StyleExpr = Col13Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(13);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(13);
                    end;
                }
                field(Col14; MatrixCellData[14])
                {
                    ToolTip = 'Col14';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[14];
                    DrillDown = true;
                    StyleExpr = Col14Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(14);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(14);
                    end;
                }
                field(Col15; MatrixCellData[15])
                {
                    ToolTip = 'Col15';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[15];
                    DrillDown = true;
                    StyleExpr = Col15Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(15);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(15);
                    end;
                }
                field(Col16; MatrixCellData[16])
                {
                    ToolTip = 'Col16';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[16];
                    DrillDown = true;
                    StyleExpr = Col16Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(16);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(16);
                    end;
                }
                field(Col17; MatrixCellData[17])
                {
                    ToolTip = 'Col17';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[17];
                    DrillDown = true;
                    StyleExpr = Col17Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(17);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(17);
                    end;
                }
                field(Col18; MatrixCellData[18])
                {
                    ToolTip = 'Col18';
                    ApplicationArea = All;
                    CaptionClass = '3,' + MatrixColumnCaptions[18];
                    DrillDown = true;
                    StyleExpr = Col18Style;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(18);
                    end;

                    trigger OnValidate()
                    begin
                        MatrixOnValidate(18);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Card)
            {
                ApplicationArea = All;
                Caption = 'Card';
                ToolTip = 'Card';
                Image = Item;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "Item Card";
                RunPageLink = "No." = field("No.");
                ShortCutKey = 'Shift+F7';
            }
        }
        area(processing)
        {
            action("Remove Worksheet Data")
            {
                ApplicationArea = All;
                Caption = 'Remove Worksheet Data';
                ToolTip = 'Remove Worksheet Data';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PDCDemandItemReqLine: Record "PDC Demand Item Req. Line";
                    conf_txtLbl: label 'Do you want to delete Demand Item Requisition Lines?', Comment = 'Do you want to delete Demand Item Requisition Lines?';
                begin
                    if Confirm(conf_txtLbl, false) then begin
                        PDCDemandItemReqLine.Reset();
                        PDCDemandItemReqLine.SetRange("Requester ID", UserId);
                        PDCDemandItemReqLine.SetRange("Product Code", Rec."PDC Product Code");
                        PDCDemandItemReqLine.SetRange("Colour Code", Rec."PDC Colour");
                        PDCDemandItemReqLine.DeleteAll(true);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        for i := 1 to 18 do
            MatrixOnAfterGetRecord(i);

        FormatLine();
    end;

    trigger OnOpenPage()
    begin
        DatePeriod.Reset();
        DatePeriod."Period Type" := DatePeriod."period type"::Month;
        DatePeriod."Period Start" := CalcDate('<-CM>', WorkDate());
        DatePeriod.SetRange("Period Type", DatePeriod."period type"::Month);
        for i := 1 to 18 do begin
            if i = 1 then
                DatePeriod.Find('=')
            else
                DatePeriod.Next();
            TempDateMatrixPeriod[i] := DatePeriod;
            MatrixColumnCaptions[i] := DatePeriod."Period Name" + ' ' + Format(Date2dmy(DatePeriod."Period Start", 3));
        end;
    end;

    var
        DatePeriod: Record Date;
        TempDateMatrixPeriod: array[18] of Record Date temporary;
        MatrixColumnCaptions: array[18] of Text[80];
        MatrixCellData: array[18] of Text[100];
        i: Integer;
        Col1Style: Text[20];
        Col2Style: Text[20];
        Col3Style: Text[20];
        Col4Style: Text[20];
        Col5Style: Text[20];
        Col6Style: Text[20];
        Col7Style: Text[20];
        Col8Style: Text[20];
        Col9Style: Text[20];
        Col10Style: Text[20];
        Col11Style: Text[20];
        Col12Style: Text[20];
        Col13Style: Text[20];
        Col14Style: Text[20];
        Col15Style: Text[20];
        Col16Style: Text[20];
        Col17Style: Text[20];
        Col18Style: Text[20];
        ShowData: Option;

    /// <summary>
    /// CalcMatrixResult.
    /// </summary>
    /// <param name="ColumnID">Integer.</param>
    /// <param name="Result">VAR Decimal.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CalcMatrixResult(ColumnID: Integer; var Result: Decimal): Boolean
    var
        Item1: Record Item;
        PDCDemandItemReqLine: Record "PDC Demand Item Req. Line";
    begin
        if ShowData in [0, 1] then begin //All, Purchase //09.09.2017 JEMEL J.Jemeljanovs #2296
            Item1.Get(Rec."No.");
            if ColumnID = 1 then
                //Item1.SETFILTER("Date Filter", '%1..%2', WORKDATE, NORMALDATE(MatrixPeriod[ColumnID]."Period End")) //27.06.2018 JEMEL J.Jemeljanovs #2674 Closed
                Item1.SetFilter("Date Filter", '..%1', NormalDate(TempDateMatrixPeriod[ColumnID]."Period End")) //27.06.2018 JEMEL J.Jemeljanovs #2674
            else
                Item1.SetFilter("Date Filter", '%1..%2', TempDateMatrixPeriod[ColumnID]."Period Start", NormalDate(TempDateMatrixPeriod[ColumnID]."Period End"));
            Item1.CalcFields("Qty. on Purch. Order");
            Result += Item1."Qty. on Purch. Order";
        end; //Purchase //09.09.2017 JEMEL J.Jemeljanovs #2296

        //09.09.2017 JEMEL J.Jemeljanovs #2296 >>
        if ShowData in [0, 2] then begin //All, Requisition
            PDCDemandItemReqLine.Reset();
            PDCDemandItemReqLine.SetRange("Item No.", Rec."No.");
            PDCDemandItemReqLine.SetFilter("Due Date", '%1..%2', TempDateMatrixPeriod[ColumnID]."Period Start", NormalDate(TempDateMatrixPeriod[ColumnID]."Period End"));
            PDCDemandItemReqLine.CalcSums("Quantity (Base)");
            Result += PDCDemandItemReqLine."Quantity (Base)";
        end;
        //09.09.2017 JEMEL J.Jemeljanovs #2296 <<

        exit(true);
    end;

    /// <summary>
    /// MatrixOnAfterGetRecord.
    /// </summary>
    /// <param name="ColumnID">Integer.</param>
    procedure MatrixOnAfterGetRecord(ColumnID: Integer)
    var
        Result: Decimal;
    begin
        Clear(Result);
        if CalcMatrixResult(ColumnID, Result) then
            MatrixCellData[ColumnID] := Format(Result, 0, '<Precision,0:5><Standard Format,0>')
        else
            MatrixCellData[ColumnID] := 'NaN';
    end;

    /// <summary>
    /// MatrixOnValidate.
    /// </summary>
    /// <param name="ColumnID">Integer.</param>
    procedure MatrixOnValidate(ColumnID: Integer)
    var
        PDCDemandItemReqLine: Record "PDC Demand Item Req. Line";
        PDCDemandProduct: Record "PDC Demand Product";
        NewValue: Decimal;
        PrevResult: Decimal;
        LastLineNo: Integer;
    begin
        if ShowData in [0, 2] then  //All, Requisition
            if Evaluate(NewValue, MatrixCellData[ColumnID]) then
                if CalcMatrixResult(ColumnID, PrevResult) then
                    if NewValue <> PrevResult then begin
                        PDCDemandItemReqLine.Reset();
                        PDCDemandItemReqLine.SetRange("Requester ID", UserId);
                        if PDCDemandItemReqLine.FindLast() then
                            LastLineNo := PDCDemandItemReqLine."Line No.";

                        PDCDemandItemReqLine.Init();
                        PDCDemandItemReqLine."Requester ID" := CopyStr(UserId, 1, 50);
                        PDCDemandItemReqLine."Line No." := LastLineNo + 10000;
                        PDCDemandItemReqLine.Insert(true);
                        PDCDemandItemReqLine.Validate("Item No.", Rec."No.");
                        PDCDemandItemReqLine.Validate(Quantity, NewValue - PrevResult);
                        PDCDemandItemReqLine."Due Date" := TempDateMatrixPeriod[ColumnID]."Period Start";
                        PDCDemandItemReqLine."Order Date" := WorkDate();
                        if not PDCDemandProduct.Get(Rec."PDC Product Code", Rec."PDC Colour") then
                            Clear(PDCDemandProduct);
                        PDCDemandItemReqLine."Vendor No." := PDCDemandProduct."Import Vendor";
                        PDCDemandItemReqLine.Modify(true);
                    end;
        CurrPage.Update(false);
    end;

    /// <summary>
    /// MatrixOnDrillDown.
    /// </summary>
    /// <param name="ColumnID">Integer.</param>
    procedure MatrixOnDrillDown(ColumnID: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        PDCDemandItemReqLine: Record "PDC Demand Item Req. Line";
    begin
        if ShowData in [1] then begin //All, Purchase
            PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
            PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
            PurchaseLine.SetRange("No.", Rec."No.");
            if ColumnID = 1 then
                PurchaseLine.SetFilter("Expected Receipt Date", '..%1', NormalDate(TempDateMatrixPeriod[ColumnID]."Period End"))
            else
                PurchaseLine.SetFilter("Expected Receipt Date", '%1..%2', TempDateMatrixPeriod[ColumnID]."Period Start", NormalDate(TempDateMatrixPeriod[ColumnID]."Period End"));
            Page.Run(0, PurchaseLine);
        end;

        if ShowData in [2] then begin //Requisition
            PDCDemandItemReqLine.Reset();
            PDCDemandItemReqLine.SetRange("Item No.", Rec."No.");
            PDCDemandItemReqLine.SetFilter("Due Date", '%1..%2', TempDateMatrixPeriod[ColumnID]."Period Start", NormalDate(TempDateMatrixPeriod[ColumnID]."Period End"));
            Page.Run(0, PDCDemandItemReqLine);
        end;
    end;

    /// <summary>
    /// FormatLine.
    /// </summary>
    procedure FormatLine()
    begin
        GetLineStyle(Col1Style, 1);
        GetLineStyle(Col2Style, 2);
        GetLineStyle(Col3Style, 3);
        GetLineStyle(Col4Style, 4);
        GetLineStyle(Col5Style, 5);
        GetLineStyle(Col6Style, 6);
        GetLineStyle(Col7Style, 7);
        GetLineStyle(Col8Style, 8);
        GetLineStyle(Col9Style, 9);
        GetLineStyle(Col10Style, 10);
        GetLineStyle(Col11Style, 11);
        GetLineStyle(Col12Style, 12);
        GetLineStyle(Col13Style, 13);
        GetLineStyle(Col14Style, 14);
        GetLineStyle(Col15Style, 15);
        GetLineStyle(Col16Style, 16);
        GetLineStyle(Col17Style, 17);
        GetLineStyle(Col18Style, 18);
    end;

    /// <summary>
    /// GetLineStyle.
    /// </summary>
    /// <param name="ColStyle">VAR Text[20].</param>
    /// <param name="ColumnID">Integer.</param>
    procedure GetLineStyle(var ColStyle: Text[20]; ColumnID: Integer)
    var
        Result: Decimal;
    begin
        if ColumnID <> 0 then begin
            ColStyle := 'Standard';
            if Evaluate(Result, MatrixCellData[ColumnID]) then
                if Result < 0 then
                    ColStyle := 'Attention';
        end
        else
            ColStyle := 'Standard';
    end;
}

