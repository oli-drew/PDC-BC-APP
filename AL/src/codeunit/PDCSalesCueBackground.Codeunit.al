codeunit 50011 "PDC Sales Cue Background"
{

    trigger OnRun()
    var
        SalesCue: Record "Sales Cue";
        Customer: Record Customer;
        Results: Dictionary of [Text, Text];
    begin
        if not SalesCue.get() then
            SalesCue.Init();

        SalesCue."PDC Customers-Over Cred. Limit" := 0;
        Customer.RESET();
        if Customer.FINDSET() then
            repeat
                if Customer.CalcAvailableCredit() < 0 then
                    SalesCue."PDC Customers-Over Cred. Limit" += 1;
            until Customer.next() = 0;
        Results.Add(SalesCue.fieldname("PDC Customers-Over Cred. Limit"), format(SalesCue."PDC Customers-Over Cred. Limit"));

        Results.Add(SalesCue.fieldname("PDC Sales Orders-Ready to Rel."), format(SalesCue.CalcSOReadyToReleasePick(0)));
        Results.Add(SalesCue.fieldname("PDC Sales Orders-Ready to Pick"), format(SalesCue.CalcSOReadyToReleasePick(1)));
        Results.Add(SalesCue.fieldname("PDC Sales Orders - Not Ready"), format(SalesCue.CalcSOReadyToReleasePick(2)));


        Results.Add(SalesCue.fieldname("PDC SLA Today"), format(SalesCue.CalcSLA(1)));
        Results.Add(SalesCue.fieldname("PDC SLA Missed Released"), format(SalesCue.CalcSLA(2)));
        Results.Add(SalesCue.fieldname("PDC SLA Missed Open"), format(SalesCue.CalcSLA(3)));
        Results.Add(SalesCue.fieldname("PDC SLA Tomorrow"), format(SalesCue.CalcSLA(4)));

        Results.Add(SalesCue.fieldname("PDC Firm Pl.Prod.Ord.-NotReady"), format(SalesCue.CalcFirmPlannedProdOrder(false)));

        Page.SetBackgroundTaskResult(Results);
    end;
}
