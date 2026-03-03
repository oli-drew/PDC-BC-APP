/// <summary>
/// Codeunit PDCEventsManual (ID 50008).
/// </summary>
codeunit 50008 PDCEventsManual
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePosting', '', true, true)]
    local procedure PurchPostOnAfterFinalizePosting(var PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PDCFunctions: Codeunit "PDC Functions";
    begin
        PDCFunctions.PrintPurchReceiptLabelsBackground(PurchRcptHeader);
    end;



}
