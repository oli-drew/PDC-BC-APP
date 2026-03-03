/// <summary>
/// Codeunit PDC EDI Sales Order Creator (ID 50302).
/// Creates Sales Orders from parsed EDI data.
/// </summary>
codeunit 50302 "PDC EDI Sales Order Creator"
{
    /// <summary>
    /// Creates a Sales Order from parsed EDI data.
    /// </summary>
    procedure CreateSalesOrder(
        var EDocumentService: Record "E-Document Service";
        ExternalDocNo: Code[35];
        YourReference: Text[35];
        CustomerReference: Text[50];
        OrderDate: Date;
        SpecialInstructions: Text[250];
        ShipToCode: Code[10];
        ContactName: Text[100];
        ContactPhone: Text[30];
        ContactEmail: Text[80];
        var TempPDCEDILine: Record "PDC EDI Import Line" temporary;
        var SalesOrderNo: Code[20];
        var ErrorText: Text): Boolean
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        LineCreated: Boolean;
    begin
        // Validate customer
        if EDocumentService."PDC Customer No." = '' then begin
            ErrorText := CustomerNotConfiguredErr;
            exit(false);
        end;

        if not Customer.Get(EDocumentService."PDC Customer No.") then begin
            ErrorText := StrSubstNo(CustomerNotFoundErr, EDocumentService."PDC Customer No.");
            exit(false);
        end;

        // Validate Ship-to Code
        if ShipToCode <> '' then begin
            ShipToAddress.SetRange("Customer No.", EDocumentService."PDC Customer No.");
            ShipToAddress.SetRange("PDC Address 3", ShipToCode);
            if not ShipToAddress.FindFirst() then begin
                ErrorText := StrSubstNo(ShipToNotFoundErr, ShipToCode, EDocumentService."PDC Customer No.");
                exit(false);
            end;
        end;

        // Create Sales Header
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", EDocumentService."PDC Customer No.");
        SalesHeader."External Document No." := ExternalDocNo;
        SalesHeader."Your Reference" := YourReference;
        SalesHeader."Order Date" := OrderDate;
        SalesHeader."Document Date" := OrderDate;

        if ShipToCode <> '' then
            SalesHeader.Validate("Ship-to Code", ShipToAddress.Code);

        // Set PDC custom fields (contact info)
        SalesHeader."PDC Ship-to E-Mail" := ContactEmail;
        SalesHeader."PDC Ship-to Mobile Phone No." := ContactPhone;

        // Set Ship-to Contact name
        if ContactName <> '' then
            SalesHeader."Ship-to Contact" := CopyStr(ContactName, 1, MaxStrLen(SalesHeader."Ship-to Contact"));

        // Set Order Source if configured
        if EDocumentService."PDC Order Source" <> '' then
            SalesHeader."PDC Order Source" := EDocumentService."PDC Order Source";

        SalesHeader.Modify(true);

        // Create Sales Lines
        TempPDCEDILine.Reset();
        if TempPDCEDILine.FindSet() then
            repeat
                LineCreated := CreateSalesLine(SalesHeader, TempPDCEDILine, CustomerReference);
            until TempPDCEDILine.Next() = 0;

        // Create Special Instructions comment
        if SpecialInstructions <> '' then
            CreateSalesComment(SalesHeader, SpecialInstructions);

        SalesOrderNo := SalesHeader."No.";
        exit(true);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; var TempPDCEDILine: Record "PDC EDI Import Line" temporary; CustomerReference: Text[50]): Boolean
    var
        SalesLine: Record "Sales Line";
        FoundItemNo: Code[20];
    begin
        // Find item by Item Reference or direct Item No.
        FoundItemNo := FindItemNo(TempPDCEDILine."Item No.", SalesHeader."Sell-to Customer No.");

        if FoundItemNo = '' then begin
            // Item not found - create line with error
            TempPDCEDILine."Import Error" := true;
            TempPDCEDILine."Import Error Text" := StrSubstNo(ItemNotFoundErr, TempPDCEDILine."Item No.");
            TempPDCEDILine.Modify();
            exit(false);
        end;

        // Create Sales Line
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := GetNextLineNo(SalesHeader);
        SalesLine.Insert(true);

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", FoundItemNo);
        SalesLine.Validate(Quantity, TempPDCEDILine.Quantity);

        // Set PDC Customer Reference from CSV Column A (Order Number)
        if CustomerReference <> '' then
            SalesLine."PDC Customer Reference" := CustomerReference;

        SalesLine.Modify(true);

        exit(true);
    end;

    local procedure FindItemNo(ProductCode: Code[20]; CustomerNo: Code[20]): Code[20]
    var
        Item: Record Item;
        ItemRef: Record "Item Reference";
    begin
        // First try direct Item No.
        if Item.Get(ProductCode) then
            exit(ProductCode);

        // Try Item Reference (Customer specific)
        ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::Customer);
        ItemRef.SetRange("Reference Type No.", CustomerNo);
        ItemRef.SetRange("Reference No.", ProductCode);
        if ItemRef.FindFirst() then
            exit(ItemRef."Item No.");

        // Try Item Reference (Vendor/general)
        ItemRef.Reset();
        ItemRef.SetRange("Reference No.", ProductCode);
        if ItemRef.FindFirst() then
            exit(ItemRef."Item No.");

        // Try by Vendor Item No. (search all items)
        Item.Reset();
        Item.SetRange("Vendor Item No.", ProductCode);
        if Item.FindFirst() then
            exit(Item."No.");

        exit('');
    end;

    local procedure GetNextLineNo(var SalesHeader: Record "Sales Header"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);
        exit(10000);
    end;

    local procedure CreateSalesComment(var SalesHeader: Record "Sales Header"; CommentText: Text[250])
    var
        SalesCommentLine: Record "Sales Comment Line";
        LineNo: Integer;
        RemainingText: Text;
        ChunkSize: Integer;
    begin
        LineNo := 10000;
        RemainingText := CommentText;
        ChunkSize := MaxStrLen(SalesCommentLine.Comment);

        while RemainingText <> '' do begin
            SalesCommentLine.Init();
            SalesCommentLine."Document Type" := SalesCommentLine."Document Type"::Order;
            SalesCommentLine."No." := SalesHeader."No.";
            SalesCommentLine."Document Line No." := 0;
            SalesCommentLine."Line No." := LineNo;
            SalesCommentLine.Date := SalesHeader."Order Date";
            SalesCommentLine.Comment := CopyStr(RemainingText, 1, ChunkSize);
            SalesCommentLine.Insert();

            if StrLen(RemainingText) > ChunkSize then
                RemainingText := CopyStr(RemainingText, ChunkSize + 1)
            else
                RemainingText := '';

            LineNo += 10000;
        end;
    end;

    var
        CustomerNotConfiguredErr: Label 'Customer No. is not configured on the E-Document Service.';
        CustomerNotFoundErr: Label 'Customer %1 not found.', Comment = '%1 = Customer No.';
        ShipToNotFoundErr: Label 'Ship-to Address %1 not found for Customer %2.', Comment = '%1 = Ship-to Code, %2 = Customer No.';
        ItemNotFoundErr: Label 'Item with code %1 not found.', Comment = '%1 = Product code';
}
