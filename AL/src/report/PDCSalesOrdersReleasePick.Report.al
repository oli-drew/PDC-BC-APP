/// <summary>
/// Report PDC Sales Orders Release/Pick (ID 50030).
/// </summary>
Report 50030 "PDC Sales Orders Release/Pick"
{

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnPreDataItem()
            begin
                if GuiAllowed then
                    Window.open('Running sales orders mass reelase and Inv.Pick creation\' +
                                'checking document #1############### \' +
                                'releasing document #2############### \' +
                                'pirck for document #3###############');
            end;


            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then
                    Window.Update(1, "No.");

                if not Customer.Get("Sell-to Customer No.") then
                    CurrReport.Skip();
                if not Customer."PDC Allow Auto-Pick" then
                    CurrReport.Skip();
                if Customer.Blocked <> Customer.Blocked::" " then
                    CurrReport.Skip();
                if Customer."PDC Block Release" then
                    CurrReport.Skip();

                WarehouseActivityHeader.SetRange("Source Document", WarehouseActivityHeader."source document"::"Sales Order");
                WarehouseActivityHeader.SetRange("Source No.", "No.");
                if WarehouseActivityHeader.FindFirst() then
                    CurrReport.Skip();

                Clear(IsReady);
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", '<>%1', '');
                SalesLine.SetFilter(Quantity, '<>%1', 0);
                if SalesLine.FindSet() then begin
                    IsReady := true;
                    repeat
                        if not (SalesLine."Outstanding Quantity" = SalesLine.ReservedFromItemLedger()) then
                            IsReady := false;
                    until (SalesLine.Next() = 0) or (not IsReady);
                end;
                if not IsReady then
                    CurrReport.Skip();

                if Status <> Status::Released then begin
                    if GuiAllowed then
                        Window.Update(2, "No.");
                    SalesHeader2.Get("Document Type", "No.");
                    Clear(PDCFunctions);
                    if PDCFunctions.SO_CheckMandatoryFields(SalesHeader2, false) then
                        if Codeunit.Run(Codeunit::"Release Sales Document", SalesHeader2) then
                            Commit();
                end;

                SalesHeader2.Get("Document Type", "No.");
                if SalesHeader2.Status = SalesHeader2.Status::Released then begin
                    if GuiAllowed then
                        Window.Update(3, "No.");
                    SalesHeader2.SetAutoCreatePutAway(true);
                    SalesHeader2.PDCCreateInvtPutAwayPick();
                    Commit();
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Customer: Record Customer;
        SalesHeader2: Record "Sales Header";
        SalesLine: Record "Sales Line";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        PDCFunctions: Codeunit "PDC Functions";
        IsReady: Boolean;
        Window: Dialog;
}

