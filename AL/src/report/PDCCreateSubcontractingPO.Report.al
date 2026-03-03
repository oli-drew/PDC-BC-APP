/// <summary>
/// Report PDC Create Subcontracting PO (ID 50049).
/// </summary>
report 50049 "PDC Create Subcontracting PO"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = SORTING(Number) where(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                ReqWkshTmpl: Record "Req. Wksh. Template";
                JrnBatch: Record "Requisition Wksh. Name";
                JrnLine: Record "Requisition Line";
                ProdOrder: Record "Production Order";
                CalculateSubContract: Report "Calculate Subcontracts";
                MakePurchOrder: Report "Carry Out Action Msg. - Req.";
                PDCFunctions: Codeunit "PDC Functions";
            begin
                ReqWkshTmpl.Reset();
                ReqWkshTmpl.SETRANGE("Page ID", page::"Subcontracting Worksheet");
                ReqWkshTmpl.SETRANGE(Recurring, false);
                ReqWkshTmpl.SETRANGE(Type, 1);
                ReqWkshTmpl.FINDFIRST();

                if JrnBatch.get(ReqWkshTmpl.Name, 'PO') then
                    JrnBatch.Delete(true);

                JrnBatch.Init();
                JrnBatch."Worksheet Template Name" := ReqWkshTmpl.Name;
                JrnBatch.Name := 'PO';
                JrnBatch.Description := 'Created by rep. 50049 JQ';
                JrnBatch.Insert();

                COMMIT();

                JrnLine.Init();
                JrnLine."Worksheet Template Name" := JrnBatch."Worksheet Template Name";
                JrnLine."Journal Batch Name" := JrnBatch.Name;

                CalculateSubContract.SetWkShLine(JrnLine);
                CalculateSubContract.UseRequestPage := false;
                CalculateSubContract.RUNMODAL();

                COMMIT();

                JrnLine.Reset();
                JrnLine.setrange("Worksheet Template Name", JrnBatch."Worksheet Template Name");
                JrnLine.setrange("Journal Batch Name", JrnBatch.Name);
                JrnLine.setfilter("Action Message", '<>%1', JrnLine."Action Message"::New);
                JrnLine.DeleteAll(true);
                JrnLine.setrange("Action Message");

                JrnLine.setfilter("Ref. Order Type", '<>%1', JrnLine."Ref. Order Type"::"Prod. Order");
                JrnLine.DeleteAll(true);
                JrnLine.setrange("Ref. Order Type");
                if JrnLine.FindSet() then
                    repeat
                        ProdOrder.get(JrnLine."Ref. Order Status", JrnLine."Ref. Order No.");
                        if PDCFunctions.ProdOrderHasShortage(ProdOrder) then
                            JrnLine.Delete(true);
                    until JrnLine.next() = 0;

                if JrnLine.Findset() then begin
                    MakePurchOrder.SetReqWkshLine(JrnLine);
                    MakePurchOrder.UseRequestPage := false;
                    MakePurchOrder.RUNMODAL();
                end;

                if JrnBatch.get(ReqWkshTmpl.Name, 'PO') then
                    JrnBatch.Delete(true);
            end;
        }
    }

}
