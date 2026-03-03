/// <summary>
/// Report PDC Calc. Plan - Plan. Wksh. (ID 50053).
/// </summary>
Report 50053 "PDC Calc. Plan - Plan. Wksh."
{
    Caption = 'Calculate Plan - Plan. Wksh.';
    ProcessingOnly = true;

    //copy of report 99001017 to run from Job Queue.

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("Low-Level Code") where(Type = const(Inventory));
            RequestFilterFields = "No.", "Search Description", "Location Filter";

            trigger OnAfterGetRecord()
            var
                ErrorText: Text[1000];
            begin
                if not SetAtStartPosition then begin
                    SetAtStartPosition := true;
                    Get(PlanningErrorLog."Item No.");
                    Find('=<>');
                end;

                if NoPlanningResiliency then
                    CalcItemPlan.Run(Item)
                else begin
                    CalcItemPlan.ClearInvtProfileOffsetting();
                    CalcItemPlan.SetResiliencyOn();
                    if not CalcItemPlan.Run(Item) then
                        if not CalcItemPlan.GetResiliencyError(PlanningErrorLog) then begin
                            ErrorText := CopyStr(GetLastErrorText, 1, MaxStrLen(ErrorText));
                            if ErrorText = '' then
                                ErrorText := CalcErr
                            else
                                ClearLastError();
                            PlanningErrorLog.SetJnlBatch(CurrTemplateName, CurrWorksheetName, "No.");
                            PlanningErrorLog.SetError(
                              CopyStr(StrSubstNo(ErrorText, TableCaption, "No."), 1, 250), 0, copystr(GetPosition(), 1, 250));
                        end;
                end;

                Commit();
            end;

            trigger OnPostDataItem()
            begin
                CalcItemPlan.Finalize();
            end;

            trigger OnPreDataItem()
            begin
                Clear(CalcItemPlan);
                CalcItemPlan.SetTemplAndWorksheet(CurrTemplateName, CurrWorksheetName, NetChange);
                CalcItemPlan.SetParm(UseForecast, ExcludeForecastBefore, Item);
                CalcItemPlan.Initialize(FromDate, ToDate, MPS, MRP, RespectPlanningParm);

                SetAtStartPosition := true;

                ReqLine.SetRange("Worksheet Template Name", CurrTemplateName);
                ReqLine.SetRange("Journal Batch Name", CurrWorksheetName);
                PlanningErrorLog.SetRange("Worksheet Template Name", CurrTemplateName);
                PlanningErrorLog.SetRange("Journal Batch Name", CurrWorksheetName);
                if PlanningErrorLog.FindFirst() and ReqLine.FindFirst() then
                    CurrReport.Break();

                PlanningErrorLog.DeleteAll();
                ClearLastError();

                Commit();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group(Calculate)
                    {
                        Caption = 'Calculate';
                        field(MPSFld; MPS)
                        {
                            ApplicationArea = Planning;
                            Caption = 'MPS';
                            ToolTip = 'Specifies whether to calculate a master production schedule (MPS) based on independent demand. ';

                            trigger OnValidate()
                            begin
                                if not MfgSetup."Combined MPS/MRP Calculation" then
                                    MRP := not MPS
                                else
                                    if not MPS then
                                        MRP := true;
                            end;
                        }
                        field(MRPFld; MRP)
                        {
                            ApplicationArea = Planning;
                            Caption = 'MRP';
                            ToolTip = 'Specifies whether to calculate an MRP, which will calculate dependent demand that is based on the MPS.';

                            trigger OnValidate()
                            begin
                                if not MfgSetup."Combined MPS/MRP Calculation" then
                                    MPS := not MRP
                                else
                                    if not MRP then
                                        MPS := true;
                            end;
                        }
                    }
                    field(StartingDateFld; FromDate)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date to use for new orders. This date is used to evaluate the inventory.';
                    }
                    field(EndingDateFld; ToDate)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date where the planning period ends. Demand is not included beyond this date.';
                    }
                    field(NoPlanningResiliencyFld; NoPlanningResiliency)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Stop and Show First Error';
                        ToolTip = 'Specifies whether to stop the planning run when it encounters an error. If the planning run stops, then a message is displayed with information about the first error.';
                    }
                    field(UseForecastFld; UseForecast)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Use Forecast';
                        TableRelation = "Production Forecast Name".Name;
                        ToolTip = 'Specifies a forecast that should be included as demand when running the planning batch job.';
                    }
                    field(ExcludeForecastBeforeFld; ExcludeForecastBefore)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Exclude Forecast Before';
                        ToolTip = 'Specifies how much of the selected forecast to include in the planning run, by entering a date before which forecast demand is not included.';
                    }
                    field(RespectPlanningParmFld; RespectPlanningParm)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Respect Planning Parameters for Exception Warnings';
                        ToolTip = 'Specifies whether planning lines with Exception warnings will respect the planning parameters on the item or SKU card.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MfgSetup.Get();
            UseForecast := MfgSetup."Current Production Forecast";
            if MfgSetup."Combined MPS/MRP Calculation" then begin
                MPS := true;
                MRP := true;
            end else
                MRP := not MPS;
        end;
    }

    labels
    {
    }

    var
        MfgSetup: Record "Manufacturing Setup";
        PlanningErrorLog: Record "Planning Error Log";
        ReqLine: Record "Requisition Line";
        CalcItemPlan: Codeunit "Calc. Item Plan - Plan Wksh.";
        NetChange: Boolean;
        MPS: Boolean;
        MRP: Boolean;
        NoPlanningResiliency: Boolean;
        SetAtStartPosition: Boolean;
        FromDate: Date;
        ToDate: Date;
        ExcludeForecastBefore: Date;
        CurrTemplateName: Code[10];
        CurrWorksheetName: Code[10];
        UseForecast: Code[10];
        RespectPlanningParm: Boolean;
        CalcErr: label 'An unidentified error occurred while planning. Recalculate the plan with the option "Stop and Show Error".';


    /// <summary>
    /// SetTemplAndWorksheet.
    /// </summary>
    /// <param name="TemplateName">Code[10].</param>
    /// <param name="WorksheetName">Code[10].</param>
    /// <param name="Regenerative">Boolean.</param>
    procedure SetTemplAndWorksheet(TemplateName: Code[10]; WorksheetName: Code[10]; Regenerative: Boolean)
    begin
        CurrTemplateName := TemplateName;
        CurrWorksheetName := WorksheetName;
        NetChange := not Regenerative;
    end;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="NewFromDate">Date.</param>
    /// <param name="NewToDate">Date.</param>
    /// <param name="NewRespectPlanningParm">Boolean.</param>
    procedure InitializeRequest(NewFromDate: Date; NewToDate: Date; NewRespectPlanningParm: Boolean)
    begin
        FromDate := NewFromDate;
        ToDate := NewToDate;
        RespectPlanningParm := NewRespectPlanningParm;

        MfgSetup.Get();
        if MfgSetup."Combined MPS/MRP Calculation" then begin
            MPS := true;
            MRP := true;
        end else
            MRP := not MPS;
        UseForecast := MfgSetup."Current Production Forecast";
    end;


}

