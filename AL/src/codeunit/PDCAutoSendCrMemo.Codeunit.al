codeunit 50021 "PDC Auto Send CrMemo RetOrder"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(
        var SalesHeader: Record "Sales Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SalesShptHdrNo: Code[20];
        RetRcpHdrNo: Code[20];
        SalesInvHdrNo: Code[20];
        SalesCrMemoHdrNo: Code[20];
        CommitIsSuppressed: Boolean)
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        // Only trigger for Return Orders that generated a Credit Memo
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order" then
            exit;

        if SalesCrMemoHdrNo = '' then
            exit;

        if not SalesCrMemoHeader.Get(SalesCrMemoHdrNo) then
            exit;

        SalesCrMemoHeader.SetRecFilter();
        SalesCrMemoHeader.SendRecords();
    end;
}
