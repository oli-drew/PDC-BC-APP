/// <summary>
/// Codeunit PDC Job Queue (ID 50013) handles procedures run from Job Queue.
/// </summary>
Codeunit 50013 "PDC Job Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Parameters: array[10] of Text;
        ParameterSeparator: Text[1];
        ParameterNumber: Integer;
        intPos: Integer;
        x: Integer;
        Command: Text;
    begin
        if GuiAllowed then
            Window.Open(WindowLbl);

        ParameterSeparator := ';';
        ParameterNumber := 1;
        Parameters[1] := Rec."Parameter String";
        repeat
            intPos := StrPos(Parameters[ParameterNumber], ParameterSeparator);
            if intPos <> 0 then begin
                Parameters[ParameterNumber + 1] := CopyStr(Parameters[ParameterNumber], intPos + StrLen(ParameterSeparator));
                Parameters[ParameterNumber] := DelStr(Parameters[ParameterNumber], intPos);
                ParameterNumber += 1;
            end;
        until (intPos = 0) or (ParameterNumber > 10);

        for x := 1 to 10 do begin
            if StrPos(Parameters[x], ':') <> 0 then begin
                Command := CopyStr(Parameters[x], 1, StrPos(Parameters[x], ':') - 1);
                Parameters[x] := CopyStr(Parameters[x], StrPos(Parameters[x], ':') + 1);
            end
            else begin
                Command := Parameters[x];
                Parameters[x] := '';
            end;

            case Command of
                'SEND_REP_SP':
                    SendReportToSalesperson(Parameters[x]);
                'PRINT_PROD':
                    PrintProdOrders(Parameters[x]);
                'RUN_REP':
                    RunReport(Parameters[x]);
                'PROD_RESERVE':
                    RunProdOrderAutoReserve();
                'PROD_RELEASE':
                    RunProdOrderRelease();
                'SALES_RESERVE':
                    RunSalesOrderAutoReserve();
            end;
        end;
    end;

    var
        Window: Dialog;
        WindowLbl: label 'Task : #1########################', Comment = '%1=task name';

    local procedure SendReportToSalesperson(Parameters: Text)
    var
        CompanyInfo: Record "Company Information";
        Salesperson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        ListTo: list of [Text];
        RepID: Integer;
        SPFilter: Text;
        Subject: Text[100];
        OnDate: Date;
        OutStr: OutStream;
        InStr: InStream;
    begin
        if StrPos(Parameters, '-') <> 0 then begin
            if not Evaluate(RepID, CopyStr(Parameters, 1, StrPos(Parameters, '-') - 1)) then exit;
            SPFilter := CopyStr(Parameters, StrPos(Parameters, '-') + 1);
        end
        else
            if not Evaluate(RepID, Parameters) then exit;

        CompanyInfo.Get();

        if SPFilter <> '' then
            Salesperson.SetRange(Code, SPFilter);
        Salesperson.SetFilter("E-Mail", '<>%1', '');
        if Salesperson.FindSet() then
            repeat
                if RepID in [113] then begin //reports based on Customer table
                    OnDate := WorkDate() - 1;
                    Customer.SetRange("Salesperson Code", Salesperson.Code);
                    Customer.SetRange("Date Filter", OnDate);
                    TempBlob.CreateOutStream(OutStr);
                    if report.SaveAs(RepID, '', ReportFormat::Pdf, OutStr) then begin
                        TempBlob.CreateInStream(InStr);

                        ListTo.Add(Salesperson."E-Mail");
                        EmailMessage.Create(ListTo, Subject, '', true);
                        EmailMessage.AddAttachment('Rep' + Format(RepID) + '_' + Format(OnDate, 0, '<Year4>.<Month,2>.<Day,2>') + '.pdf', 'PDF', InStr);
                        Email.Send(EmailMessage, enum::"Email Scenario"::Default);
                    end;
                end;
            until Salesperson.Next() = 0;
    end;

    local procedure PrintProdOrders(Parameters: Text)
    var
        ManufSetup: Record "Manufacturing Setup";
        ProdOrder: Record "Production Order";
        ProdOrder2: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        PDCFunctions: Codeunit "PDC Functions";
        LabelCnt: Decimal;
        ToPrintLabels: Boolean;
    begin
        ProdOrder.setrange(Status, ProdOrder.Status::Released);
        if ProdOrder.findset() then
            repeat
                if ProdOrder."PDC Printed D/T" = 0DT then
                    if not PDCFunctions.ProdOrderHasShortage(ProdOrder) then begin
                        ProdOrder2.get(ProdOrder.Status, ProdOrder."No.");
                        ProdOrder2.SetRecFilter();
                        Report.Run(report::"PDC Prod. Order PickNote", false, false, ProdOrder2);

                        if ProdOrder."PDC No. Labels Printed" = 0 then begin
                            ToPrintLabels := true;

                            ManufSetup.get();
                            if ManufSetup."PDC Def. Prod. Labels Cnt." > 0 then begin
                                clear(LabelCnt);
                                ProdOrderLine.setrange(Status, ProdOrder.Status);
                                ProdOrderLine.setrange("Prod. Order No.", ProdOrder."No.");
                                if ProdOrderLine.findset() then
                                    repeat
                                        LabelCnt += round(ProdOrderLine."Remaining Quantity", 1, '>');
                                    until ProdOrderLine.next() = 0;
                                if LabelCnt > ManufSetup."PDC Def. Prod. Labels Cnt." then
                                    ToPrintLabels := false;
                            end;
                            if ToPrintLabels then begin
                                ProdOrder2.get(ProdOrder.Status, ProdOrder."No.");
                                ProdOrder2.SetRecFilter();
                                Report.Run(report::"PDC Production Order Labels", false, false, ProdOrder2);
                            end;
                        end;
                    end;
            until ProdOrder.next() = 0;
    end;

    local procedure RunReport(Parameters: Text)
    var
        Item: Record Item;
        ReqWkshTemplate: Record "Req. Wksh. Template";
        WkshName: Record "Requisition Wksh. Name";
        PlanningJournal: Record "Requisition Line";
        PlanningErrorLog: Record "Planning Error Log";
        CalculatePlanPlanWksh: Report "PDC Calc. Plan - Plan. Wksh.";
        ReportID: Integer;
        FromDateFormula: Text;
        ToDateFormula: Text;
        DateFormulaFilterTxt: Label '<%1>', Comment = '%1=dateformula';
    begin
        FromDateFormula := '-1M';
        ToDateFormula := '+2M';

        if STRPOS(Parameters, '|') > 0 then begin
            if not Evaluate(ReportID, copystr(Parameters, 1, STRPOS(Parameters, '|') - 1)) then
                exit;
            Parameters := copystr(Parameters, STRPOS(Parameters, '|') + 1);
            if STRPOS(Parameters, '|') > 0 then begin
                FromDateFormula := copystr(Parameters, 1, STRPOS(Parameters, '|') - 1);
                ToDateFormula := copystr(Parameters, STRPOS(Parameters, '|') + 1);
            end;
        end
        else
            if not Evaluate(ReportID, Parameters) then
                exit;

        case ReportID of
            report::"PDC Calc. Plan - Plan. Wksh.":
                begin
                    ReqWkshTemplate.setrange("Page ID", page::"Planning Worksheet");
                    ReqWkshTemplate.FindFirst();
                    WkshName.setrange("Worksheet Template Name", ReqWkshTemplate.Name);
                    WkshName.setrange(Name, 'JOBQUEUE');
                    if not WkshName.FindFirst() then
                        WkshName.setrange(Name);
                    if not WkshName.FindFirst() then
                        exit;

                    PlanningJournal.setrange("Worksheet Template Name", WkshName."Worksheet Template Name");
                    PlanningJournal.setrange("Journal Batch Name", WkshName.Name);
                    PlanningJournal.DeleteAll(TRUE);

                    PlanningErrorLog.SETRANGE("Worksheet Template Name", WkshName."Worksheet Template Name");
                    PlanningErrorLog.SETRANGE("Journal Batch Name", WkshName.Name);
                    PlanningErrorLog.DeleteAll(TRUE);

                    CalculatePlanPlanWksh.SetTemplAndWorksheet(WkshName."Worksheet Template Name", WkshName.Name, TRUE);
                    CalculatePlanPlanWksh.InitializeRequest(CALCDATE(StrSubstNo(DateFormulaFilterTxt, FromDateFormula), WorkDate()), CALCDATE(StrSubstNo(DateFormulaFilterTxt, ToDateFormula), WorkDate()), false);
                    CalculatePlanPlanWksh.UseRequestPage(false);
                    Item.setrange(Blocked, false);
                    CalculatePlanPlanWksh.SetTableView(Item);
                    CalculatePlanPlanWksh.run();
                end;
        end;
    end;

    local procedure RunProdOrderAutoReserve()
    var
        PDCFunctions: Codeunit "PDC Functions";
    begin
        PDCFunctions.FirmProdOrderAutoReserve();
    end;

    local procedure RunSalesOrderAutoReserve()
    var
        PDCFunctions: Codeunit "PDC Functions";
    begin
        PDCFunctions.SalesOrderAutoReserve();
    end;

    local procedure RunProdOrderRelease()
    var
        PDCFunctions: Codeunit "PDC Functions";
    begin
        PDCFunctions.FirmProdOrderAutoRelease();
    end;
}

