/// <summary>
/// Codeunit PDC Shopify Events (ID 50400).
/// Sets PDC-specific fields on Sales Header when Shopify orders are imported.
/// </summary>
codeunit 50400 "PDC Shopify Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnAfterCreateSalesHeader', '', true, true)]
    local procedure ShpfyOrderEventsOnAfterCreateSalesHeader(ShopifyOrderHeader: Record "Shpfy Order Header"; var SalesHeader: Record "Sales Header")
    var
        GeneralLookupExisting: Record "PDC General Lookup_existing";
    begin
        if not GeneralLookupExisting.Get(GeneralLookupExisting.Type::Source, 'SHOPIFY') then begin
            GeneralLookupExisting.Type := GeneralLookupExisting.Type::Source;
            GeneralLookupExisting.Code := 'SHOPIFY';
            GeneralLookupExisting.Insert();
        end;
        SalesHeader."PDC Order Source" := GeneralLookupExisting.Code;

        SalesHeader."External Document No." := CopyStr(ShopifyOrderHeader."Shopify Order No.", 1, MaxStrLen(SalesHeader."External Document No."));
        SalesHeader."PDC Ship-to E-Mail" := SalesHeader."Sell-to E-Mail";
        SalesHeader."PDC Ship-to Mobile Phone No." := SalesHeader."Sell-to Phone No.";
        SalesHeader."PDC Customer Reference" := CopyStr(ShopifyOrderHeader."Shopify Order No.", 1, MaxStrLen(SalesHeader."PDC Customer Reference"));

        SalesHeader.Modify(true);
    end;
}
