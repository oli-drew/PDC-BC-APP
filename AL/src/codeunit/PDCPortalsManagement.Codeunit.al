/// <summary>
/// Codeunit PDC Portals Management (ID 50017).
/// </summary>
codeunit 50017 "PDC Portals Management"
{

    trigger OnRun()
    begin
    end;

    var
        TempBranch: Record "PDC Branch" temporary;

    /// <summary>
    /// HashPassword.
    /// </summary>
    /// <param name="password">Text[250].</param>
    /// <returns>Return value of type Text[250].</returns>
    procedure HashPassword(password: Text[250]): Text[250]
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
        TempPassword: Text;
        passwordHash: Text;
    begin
        TempPassword := UserPasswordSalt() + password;
        passwordHash := COPYSTR(CryptographyManagement.GenerateHashAsBase64String(TempPassword, HashAlgorithmType::MD5), 1, 250);
        exit(copystr(passwordHash, 1, 250));
    end;

    local procedure UserPasswordSalt(): Text[250]
    begin
        exit('NAVPortalsSalt');
    end;

    /// <summary>
    /// ResetUserPassword.
    /// </summary>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="UserEmail">Text.</param>
    procedure ResetUserPassword(var NavPortal: Record "PDC Portal"; UserEmail: Text)
    var
        UserToProcess: Record "PDC Portal User";
        NewPassword: Text;
    begin
        UserToProcess.Reset();
        UserToProcess.SetRange("E-Mail", UserEmail);
        if (UserToProcess.FindFirst()) then
            NewPassword := UserToProcess.ResetPasswordWithAutoGen(true);
    end;

    /// <summary>
    /// GetUserMergedRole.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="MergerUserRole">VAR Record "PDC Portal Role".</param>
    procedure GetUserMergedRole(var PortalUser: Record "PDC Portal User"; var MergerUserRole: Record "PDC Portal Role")
    var
        PortalRole: Record "PDC Portal Role";
        UserRole: Record "PDC Portal User Role";
    begin
        Clear(MergerUserRole);
        UserRole.Reset();
        PortalUser.Copyfilter("Portal Code Filter", UserRole."Portal Code");
        UserRole.SetRange("User Id", PortalUser.Id);
        if (UserRole.FindSet()) then
            repeat
                PortalRole.Get(UserRole."User Role Code");

                MergerUserRole.Incidents := MergerUserRole.Incidents or PortalRole.Incidents;
                MergerUserRole.Finances := MergerUserRole.Finances or PortalRole.Finances;
                MergerUserRole.Orders := MergerUserRole.Orders or PortalRole.Orders;
                MergerUserRole.Workflow := MergerUserRole.Workflow or PortalRole.Workflow;
                MergerUserRole.Returns := MergerUserRole.Returns or PortalRole.Returns;
                MergerUserRole.Staff := MergerUserRole.Staff or PortalRole.Staff;
                MergerUserRole.Contracts := MergerUserRole.Contracts or PortalRole.Contracts;
                MergerUserRole."General Reports" := MergerUserRole."General Reports" or PortalRole."General Reports";
                MergerUserRole."Financial Reports" := MergerUserRole."Financial Reports" or PortalRole."Financial Reports";
                MergerUserRole.Entitlement := MergerUserRole.Entitlement or PortalRole.Entitlement;
                MergerUserRole.Checkout := MergerUserRole.Checkout or PortalRole.Checkout;
                MergerUserRole.Description := PortalRole.Description;
                MergerUserRole.Wardrobe := MergerUserRole.Wardrobe or PortalRole.Wardrobe;
                MergerUserRole."All Branches" := MergerUserRole."All Branches" or PortalRole."All Branches";
                MergerUserRole."Staff Request Approve" := MergerUserRole."Staff Request Approve" or PortalRole."Staff Request Approve";
                MergerUserRole."Staff Request Create" := MergerUserRole."Staff Request Create" or PortalRole."Staff Request Create";
                MergerUserRole."Address Create" := MergerUserRole."Address Create" or PortalRole."Address Create";
                MergerUserRole."Address List Company" := MergerUserRole."Address List Company" or PortalRole."Address List Company";
                MergerUserRole."Address List Branch" := MergerUserRole."Address List Branch" or PortalRole."Address List Branch";
                MergerUserRole."Staff Create" := MergerUserRole."Staff Create" or PortalRole."Staff Create";
                MergerUserRole."Staff Edit" := MergerUserRole."Staff Edit" or PortalRole."Staff Edit";
                MergerUserRole."Address Edit" := MergerUserRole."Address Edit" or PortalRole."Address Edit";
                MergerUserRole."Bulk Order" := MergerUserRole."Bulk Order" or PortalRole."Bulk Order";
            until (UserRole.Next() = 0);
    end;

    /// <summary>
    /// ProcessPortalText.
    /// </summary>
    /// <param name="PortalText">Text.</param>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="UserEmail">Text.</param>
    /// <param name="Password">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ProcessPortalText(PortalText: Text; var NavPortal: Record "PDC Portal"; UserEmail: Text; Password: Text): Text
    begin

        PortalText := ReplaceAll(PortalText, '[[Email]]', UserEmail);
        PortalText := ReplaceAll(PortalText, '[[PortalName]]', NavPortal.Description);
        PortalText := ReplaceAll(PortalText, '[[PortalUrl]]', NavPortal.Url);
        PortalText := ReplaceAll(PortalText, '[[Password]]', Password);
        exit(PortalText);
    end;

    /// <summary>
    /// SendEmail.
    /// </summary>
    /// <param name="SenderName">Text.</param>
    /// <param name="SenderEmail">Text.</param>
    /// <param name="UserEmail">Text.</param>
    /// <param name="Subject">Text.</param>
    /// <param name="Body">Text.</param>
    procedure SendEmail(SenderName: Text; SenderEmail: Text; UserEmail: Text; Subject: Text; Body: Text)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        ListTo: list of [Text];
    begin
        ListTo.Add(UserEmail);
        EmailMessage.Create(ListTo, Subject, Body, true);
        Email.Send(EmailMessage, enum::"Email Scenario"::Default);
    end;

    /// <summary>
    /// FormatDate.
    /// </summary>
    /// <param name="DateValue">Date.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FormatDate(DateValue: Date): Text
    begin
        if DateValue = 0D then exit('');
        //exit(Format(Date2dmy(DateValue, 1)) + '/' + Format(Date2dmy(DateValue, 2)) + '/' + Format(Date2dmy(DateValue, 3)));
        exit(format(DateValue, 0, '<Day,2>/<Month,2>/<Year,2>'));
    end;

    /// <summary>
    /// FormatTime.
    /// </summary>
    /// <param name="TimeValue">Time.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FormatTime(TimeValue: Time): Text
    begin
        exit(Format(TimeValue));
    end;

    /// <summary>
    /// FormatDateTime.
    /// </summary>
    /// <param name="DateValue">Date.</param>
    /// <param name="TimeValue">Time.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FormatDateTime(DateValue: Date; TimeValue: Time): Text
    begin
        exit(FormatDate(DateValue) + ' ' + FormatTime(TimeValue));
    end;

    /// <summary>
    /// FormatDT.
    /// </summary>
    /// <param name="DateTimeValue">DateTime.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FormatDT(DateTimeValue: DateTime): Text
    begin
        exit(Format(DateTimeValue));
    end;

    /// <summary>
    /// LoadUser.
    /// </summary>
    /// <param name="PortalUserId">Text[250].</param>
    /// <param name="NavPortal">VAR Record "PDC Portal".</param>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="UserRole">VAR Record "PDC Portal Role".</param>
    procedure LoadUser(PortalUserId: Text[250]; var NavPortal: Record "PDC Portal"; var PortalUser: Record "PDC Portal User"; var UserRole: Record "PDC Portal Role")
    begin
        PortalUser.Reset();

        if not (PortalUser.Get(PortalUserId)) then begin
            PortalUser.SetCurrentKey("Azure User Id");
            PortalUser.SetRange("Azure User Id", PortalUserId);
            if not PortalUser.FindFirst() then begin
                Clear(PortalUser);
                PortalUser.Init();
            end;
        end;

        PortalUser.SetRange("Portal Code Filter", NavPortal.Code);
        GetUserMergedRole(PortalUser, UserRole);
    end;

    /// <summary>
    /// CheckFileName.
    /// </summary>
    /// <param name="FileName">VAR Text.</param>
    procedure CheckFileName(var FileName: Text)
    var
        i: Integer;
    begin
        for i := 1 to StrLen(FileName) do
            if (not (FileName[i] in ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '.', ' ', ','])) then
                FileName[i] := '_';
    end;

    /// <summary>
    /// EncodeFileData.
    /// </summary>
    /// <param name="InputStream">VAR InStream.</param>
    /// <param name="OutputData">VAR BigText.</param>
    procedure EncodeFileData(var InputStream: InStream; var OutputData: BigText)
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        OutputData.AddText(Base64Convert.ToBase64(InputStream, false));
    end;

    local procedure ReplaceAll(pString: Text; pFind: Text; pReplace: Text): Text
    var
        lString: Text;
        lReplacing: Boolean;
        lCurrentPos: Integer;
        lPos: Integer;
        lLen: Integer;
    begin
        // Replacing all parts of a string with another string
        //  -> pString: String to search
        //  -> pFind: String to find
        //  -> pReplace: Replacement
        //  <- Replaced string

        lLen := STRLEN(pString);
        if (lLen > 0) then begin
            lReplacing := TRUE;
            lCurrentPos := 1;
            WHILE (lReplacing) DO begin
                lPos := STRPOS(COPYSTR(pString, lCurrentPos, lLen), pFind);
                if (lPos > 0) then begin
                    lString := lString + COPYSTR(pString, lCurrentPos, lPos - 1) + pReplace;
                    lCurrentPos += lPos + STRLEN(pFind) - 1;
                END
                else
                    lReplacing := FALSE;
            end;
        end;

        if (lCurrentPos < lLen) then
            lString := lString + COPYSTR(pString, lCurrentPos, lLen);

        EXIT(lString);
    end;

    /// <summary>
    /// CalcItemFreeStock.
    /// </summary>
    /// <param name="ItemNo">code[20].</param>
    /// <param name="VariantCode">code[10].</param>
    /// <param name="LocationCode">Code[10].</param>
    /// <param name="OnDate">Date.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcItemFreeStock(ItemNo: code[20]; VariantCode: code[10]; LocationCode: Code[10]; OnDate: Date): Decimal
    var
        // CompanyInfo: Record "Company Information";
        // SalesLineTmp: Record "Sales Line" temporary;
        // SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        Item: Record Item;
        FreeBalQty: Decimal;
    begin
        Item.get(ItemNo);
        Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
        FreeBalQty := Item.Inventory - Item."Reserved Qty. on Inventory";
        exit(FreeBalQty);
    end;

    /// <summary>
    /// CalcDraftOrderItemLineQuantity.
    /// </summary>
    /// <param name="FromDraftItemLine">Record "PDC Draft Order Item Line".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcDraftOrderLineItemQuantity(FromDraftItemLine: Record "PDC Draft Order Item Line"): Decimal
    var
        DraftItemLine: Record "PDC Draft Order Item Line";
    begin
        DraftItemLine.setrange("Document No.", FromDraftItemLine."Document No.");
        DraftItemLine.setfilter("Staff Line No.", '..%1', FromDraftItemLine."Staff Line No.");
        DraftItemLine.setrange("Item No.", FromDraftItemLine."Item No.");
        DraftItemLine.CalcSums(Quantity);
        exit(DraftItemLine.Quantity);
    end;

    /// <summary>
    /// CalcItemAlternativeStock.
    /// </summary>
    /// <param name="ItemNo">code[20].</param>
    /// <param name="VariantCode">code[10].</param>
    /// <param name="LocationCode">Code[10].</param>
    /// <param name="OnDate">Date.</param>
    /// <param name="Buffer">Temporary VAR Record Item.</param>
    procedure CalcItemAlternativeStock(ItemNo: code[20]; VariantCode: code[10]; LocationCode: Code[10]; OnDate: Date; var Buffer: Record Item temporary)
    var
        FromItem: Record Item;
        Item: Record Item;
    begin
        if not FromItem.get(ItemNo) then
            exit;

        Item.ClearMarks();
        Item.SetCurrentKey("PDC Product Code", "PDC Colour Sequence", "PDC Fit Sequence", "PDC Size Sequence");
        Item.setrange("PDC Product Code", FromItem."PDC Product Code");
        Item.setrange("PDC Colour", FromItem."PDC Colour");
        Item.setrange("PDC Fit", FromItem."PDC Fit");
        item.Setfilter("PDC Size Sequence", '<%1', FromItem."PDC Size Sequence"); //prev size same fit        
        if item.findlast() then Item.Mark(true);
        item.Setfilter("PDC Size Sequence", '>%1', FromItem."PDC Size Sequence"); //next size same fit
        if item.findfirst() then Item.Mark(true);
        item.SetRange("PDC Size Sequence");

        item.setrange("PDC Size", FromItem."PDC Size");
        Item.setfilter("PDC Fit", '<>%1', FromItem."PDC Fit");
        if Item.findset() then
            repeat
                Item.Mark(true);
            until Item.next() = 0;

        item.setrange("PDC Size");
        item.SetRange("PDC Fit");

        Item.MarkedOnly(true);
        if Item.findset() then
            repeat
                Buffer.init();
                Buffer := Item;
                Buffer."Unit Price" := 0;
                Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                Buffer."Unit Price" := Item.Inventory - Item."Reserved Qty. on Inventory";
                Buffer.insert();
            until Item.next() = 0;
    end;

    /// <summary>
    /// CreateUserFromContact.
    /// </summary>
    /// <param name="Contact">Record Contact.</param>
    /// <param name="HideDualogue">Boolean.</param>
    procedure CreateUserFromContact(Contact: Record Contact; HideDualogue: Boolean)
    var
        PDCPortalUser: Record "PDC Portal User";
        PDCPortal: record "PDC Portal";
        PDCPortalRole: Record "PDC Portal Role";
        PDCPortalUserRole: Record "PDC Portal User Role";
        CreateUserQst: Label 'Do you want to create Portal User from Contact %1?', Comment = '%1=contact No.';
        UserExistErr: Label 'Portal User %1 exists for Contact %1', Comment = '%1=portal user, %2=contact No.';
    begin
        Contact.testfield(Type, Contact.Type::Person);
        Contact.TestField("E-Mail");
        PDCPortalUser.setrange("Contact No.", Contact."No.");
        if not PDCPortalUser.IsEmpty then
            error(UserExistErr, PDCPortalUser.Id);

        if GuiAllowed and (not HideDualogue) then
            if not confirm(CreateUserQst, true, Contact."No.") then
                exit;

        PDCPortalUser.init();
        PDCPortalUser.validate("Company Contact No.", Contact."Company No.");
        PDCPortalUser.validate("Contact No.", Contact."No.");
        PDCPortalUser.Insert(true);

        PDCPortalRole.setrange(DefaultRole, true);
        if (PDCPortal.FindFirst()) and (PDCPortalRole.FindFirst()) then begin
            clear(PDCPortalUserRole);
            PDCPortalUserRole.Init();
            PDCPortalUserRole."Portal Code" := PDCPortal.Code;
            PDCPortalUserRole."User Id" := PDCPortalUser.Id;
            PDCPortalUserRole."User Role Code" := PDCPortalRole.Code;
            PDCPortalUserRole.insert(true);
        end;

        page.Run(page::"PDC Portal User Card", PDCPortalUser);
    end;

    procedure UpdatePresentationOrder(CustomerNo: Code[20])
    var
        Branch: Record "PDC Branch";
    begin
        TempBranch.Reset();
        TempBranch.DeleteAll();

        // This is to cleanup wrong created blank entries created by an import mistake
        if Branch.Get(CustomerNo, '') then
            Branch.Delete();

        Branch.setrange("Customer No.", CustomerNo);
        if Branch.FindSet(false) then
            repeat
                TempBranch.TransferFields(Branch);
                TempBranch.Insert();
            until Branch.Next() = 0;
        UpdatePresentationOrderIterative();
    end;

    local procedure UpdatePresentationOrderIterative()
    var
        Branch: Record "PDC Branch";
        TempStack: Record TempStack temporary;
        TempCurBranch: Record "PDC Branch" temporary;
        CurBranchID: RecordID;
        PresentationOrder: Integer;
        Indentation: Integer;
        HasChildren: Boolean;
    begin
        PresentationOrder := 0;

        TempCurBranch.Copy(TempBranch, true);

        TempBranch.SetCurrentKey("Parent Branch No.");
        TempBranch.Ascending(false);
        TempBranch.SetRange("Parent Branch No.", '');
        if TempBranch.FindSet(false) then
            repeat
                TempStack.Push(TempBranch.RecordId());
            until TempBranch.Next() = 0;

        while TempStack.Pop(CurBranchID) do begin
            TempCurBranch.Get(CurBranchID);
            HasChildren := false;

            TempBranch.SetRange("Parent Branch No.", TempCurBranch."Branch No.");
            if TempBranch.FindSet(false) then
                repeat
                    TempStack.Push(TempBranch.RecordId());
                    HasChildren := true;
                until TempBranch.Next() = 0;

            if TempCurBranch."Parent Branch No." <> '' then begin
                TempBranch.Get(TempCurBranch."Customer No.", TempCurBranch."Parent Branch No.");
                Indentation := TempBranch.Indentation + 1;
            end else
                Indentation := 0;
            PresentationOrder := PresentationOrder + 10000;

            if (TempCurBranch."Presentation Order" <> PresentationOrder) or
               (TempCurBranch.Indentation <> Indentation) or (TempCurBranch."Has Children" <> HasChildren)
            then begin
                Branch.Get(TempCurBranch."Customer No.", TempCurBranch."Branch No.");
                Branch.Validate("Presentation Order", PresentationOrder);
                Branch.Validate(Indentation, Indentation);
                Branch.Validate("Has Children", HasChildren);
                Branch.Modify();
                TempBranch.Get(TempCurBranch."Customer No.", TempCurBranch."Branch No.");
                TempBranch.Validate("Presentation Order", PresentationOrder);
                TempBranch.Validate(Indentation, Indentation);
                TempBranch.Validate("Has Children", HasChildren);
                TempBranch.Modify();
            end;
        end;
    end;

    procedure CalcPresentationOrder(var Branch: Record "PDC Branch")
    var
        BranchSearch: Record "PDC Branch";
        BranchPrev: Record "PDC Branch";
        BranchNext: Record "PDC Branch";
        BranchPrevExists: Boolean;
        BranchNextExists: Boolean;
    begin
        if Branch.HasChildren() then begin
            Branch."Presentation Order" := 0;
            exit;
        end;

        BranchPrev.setrange("Customer No.", Branch."Customer No.");
        BranchPrev.SetRange("Parent Branch No.", Branch."Parent Branch No.");
        BranchPrev.SetFilter("Branch No.", '<%1', Branch."Branch No.");
        BranchPrevExists := BranchPrev.FindLast();
        if not BranchPrevExists then
            BranchPrevExists := BranchPrev.Get(Branch."Customer No.", Branch."Parent Branch No.")
        else
            BranchPrev.Get(BranchPrev."Customer No.", GetLastChildCode(BranchPrev."Customer No.", BranchPrev."Branch No."));

        BranchNext.setrange("Customer No.", Branch."Customer No.");
        BranchNext.SetRange("Parent Branch No.", Branch."Parent Branch No.");
        BranchNext.SetFilter("Branch No.", '>%1', Branch."Branch No.");
        BranchNextExists := BranchNext.FindFirst();
        if not BranchNextExists and BranchPrevExists then begin
            BranchNext.Reset();
            BranchNext.SetCurrentKey("Presentation Order");
            BranchNext.setrange("Customer No.", Branch."Customer No.");
            BranchNext.SetFilter("Branch No.", '<>%1', Branch."Branch No.");
            BranchNext.SetFilter("Presentation Order", '>%1', BranchPrev."Presentation Order");
            BranchNextExists := BranchNext.FindFirst();
        end;

        case true of
            not BranchPrevExists and not BranchNextExists:
                Branch."Presentation Order" := 10000;
            not BranchPrevExists and BranchNextExists:
                Branch."Presentation Order" := BranchNext."Presentation Order" div 2;
            BranchPrevExists and not BranchNextExists:
                Branch."Presentation Order" := BranchPrev."Presentation Order" + 10000;
            BranchPrevExists and BranchNextExists:
                Branch."Presentation Order" := (BranchPrev."Presentation Order" + BranchNext."Presentation Order") div 2;
        end;

        BranchSearch.SetRange("Presentation Order", Branch."Presentation Order");
        BranchSearch.setrange("Customer No.", Branch."Customer No.");
        BranchSearch.SetFilter("Branch No.", '<>%1', Branch."Branch No.");
        if not BranchSearch.IsEmpty() then
            Branch."Presentation Order" := 0;
    end;

    local procedure GetLastChildCode(CustomerNo: code[20]; ParentCode: Code[20]) ChildCode: Code[20]
    var
        TempStack: Record TempStack temporary;
        Branch: Record "PDC Branch";
        RecId: RecordID;
    begin
        ChildCode := ParentCode;

        Branch.Ascending(false);
        Branch.SetRange("Customer No.", CustomerNo);
        Branch.SetRange("Parent Branch No.", ParentCode);
        if Branch.FindSet() then
            repeat
                TempStack.Push(Branch.RecordId());
            until Branch.Next() = 0;

        while TempStack.Pop(RecId) do begin
            Branch.Get(RecId);
            ChildCode := Branch."Branch No.";

            Branch.SetRange("Parent Branch No.", Branch."Branch No.");
            if Branch.FindSet() then
                repeat
                    TempStack.Push(Branch.RecordId());
                until Branch.Next() = 0;
        end;
    end;

    procedure GetPortalUserBranchList(var TempUserBranch: record "PDC Branch" temporary; PortalUser: Record "PDC Portal User")
    var
        Branch: Record "PDC Branch";
        PortalUserBranch: Record "PDC Portal User Branch";
        BranchStaff: Record "PDC Branch Staff";
    begin
        PortalUserBranch.SetRange("Portal User ID", PortalUser.Id);
        PortalUserBranch.SetRange("Sell-To Customer No.", PortalUser."Customer No.");
        if PortalUserBranch.Findset() then
            repeat
                if Branch.Get(PortalUserBranch."Sell-To Customer No.", PortalUserBranch."Branch ID") then begin
                    TempUserBranch.init();
                    TempUserBranch := Branch;
                    if TempUserBranch.insert() then;
                    SelectChildBranches(TempUserBranch, Branch);
                end;
            until PortalUserBranch.next() = 0
        // else
        //     if BranchStaff.get(PortalUser."Staff ID") then
        //         if Branch.Get(BranchStaff."Sell-To Customer No.", BranchStaff."Branch ID") then begin
        //             TempUserBranch.init();
        //             TempUserBranch := Branch;
        //             if TempUserBranch.insert() then;
        //             SelectChildBranches(TempUserBranch, Branch);
        //         end;
    end;

    procedure SelectChildBranches(var TempUserBranch: record "PDC Branch" temporary; CurrBranch: Record "PDC Branch")
    var
        Branch: Record "PDC Branch";
    begin
        Branch.SetRange("Customer No.", CurrBranch."Customer No.");
        Branch.SetRange("Parent Branch No.", CurrBranch."Branch No.");
        if Branch.FindSet() then
            repeat
                TempUserBranch.init();
                TempUserBranch := Branch;
                if TempUserBranch.insert() then;
                SelectChildBranches(TempUserBranch, Branch);
            until Branch.Next() = 0;
    end;

    procedure SelectParentBranches(var TempUserBranch: record "PDC Branch" temporary; CurrBranch: Record "PDC Branch")
    var
        Branch: Record "PDC Branch";
        ParentBranch: code[20];
    begin
        ParentBranch := CurrBranch."Parent Branch No.";
        while Branch.Get(CurrBranch."Customer No.", ParentBranch) do begin
            TempUserBranch.init();
            TempUserBranch := Branch;
            if TempUserBranch.insert() then;
            ParentBranch := Branch."Parent Branch No.";
        end;
    end;

    procedure GetBranchFilter(var TempUserBranch: record "PDC Branch" temporary): text;
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(TempUserBranch);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, TempUserBranch.FieldNo("Branch No.")));
    end;

    procedure GetStaffApproversList(var TempApproversPortalUser: Record "PDC Portal User" temporary; Staff: Record "PDC Branch Staff")
    var
        ApproversPortalUser: Record "PDC Portal User";
        Branch: Record "PDC Branch";
        TempUserBranch: record "PDC Branch" temporary;
        PortalUserBranch: Record "PDC Portal User Branch";
        TempUserRole: Record "PDC Portal Role" temporary;
    begin
        Branch.get(Staff."Sell-to Customer No.", Staff."Branch ID");
        TempUserBranch.init();
        TempUserBranch := Branch;
        if TempUserBranch.insert() then;
        SelectParentBranches(TempUserBranch, Branch);

        PortalUserBranch.setrange("Sell-To Customer No.", Staff."Sell-to Customer No.");
        PortalUserBranch.setfilter("Branch ID", GetBranchFilter(TempUserBranch));
        if PortalUserBranch.FindSet() then
            repeat
                clear(TempUserRole);
                ApproversPortalUser.get(PortalUserBranch."Portal User ID");
                GetUserMergedRole(ApproversPortalUser, TempUserRole);
                if TempUserRole."Staff Request Approve" then begin
                    TempApproversPortalUser.init();
                    TempApproversPortalUser := ApproversPortalUser;
                    if TempApproversPortalUser.insert() then;
                end;
            until PortalUserBranch.Next() = 0;
    end;

    procedure GetUserApproversList(var TempApproversPortalUser: Record "PDC Portal User" temporary; PortalUser: Record "PDC Portal User")
    var
        ApproversPortalUser: Record "PDC Portal User";
        Branch: Record "PDC Branch";
        PortalUserBranch: Record "PDC Portal User Branch";
        TempUserBranch: record "PDC Branch" temporary;
        TempUserRole: Record "PDC Portal Role" temporary;
    begin
        PortalUserBranch.setrange("Portal User ID", PortalUser.Id);
        PortalUserBranch.setrange("Sell-To Customer No.", PortalUser."Customer No.");
        if PortalUserBranch.FindSet() then
            repeat
                Branch.get(PortalUserBranch."Sell-To Customer No.", PortalUserBranch."Branch ID");
                TempUserBranch.init();
                TempUserBranch := Branch;
                if TempUserBranch.insert() then;
                SelectParentBranches(TempUserBranch, Branch);
            until PortalUserBranch.Next() = 0;

        PortalUserBranch.Reset();
        PortalUserBranch.setrange("Sell-To Customer No.", PortalUser."Customer No.");
        PortalUserBranch.setfilter("Branch ID", GetBranchFilter(TempUserBranch));
        if PortalUserBranch.FindSet() then
            repeat
                clear(TempUserRole);
                ApproversPortalUser.get(PortalUserBranch."Portal User ID");
                GetUserMergedRole(ApproversPortalUser, TempUserRole);
                if TempUserRole."Staff Request Approve" then begin
                    TempApproversPortalUser.init();
                    TempApproversPortalUser := ApproversPortalUser;
                    if TempApproversPortalUser.insert() then;
                end;
            until PortalUserBranch.Next() = 0;
    end;

    procedure GetUserWardrobeFilter(var Wardrobe: Record "PDC Wardrobe Header"): text;
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Wardrobe);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, Wardrobe.FieldNo("Wardrobe ID")));
    end;
}

