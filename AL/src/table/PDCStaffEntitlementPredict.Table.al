/// <summary>
/// Table PDC Staff Entitlement Predicted (ID 50050).
/// </summary>
table 50050 "PDC Staff Entitlement Predict."
{
    // 09.05.2020 JEMEL J.Jemeljanovs #3257 * new created (copy from T50022)

    Caption = 'Staff Entitlement Predicted';
    DrillDownPageID = "PDC Staff Entitlement List";
    LookupPageID = "PDC Staff Entitlement List";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(2; "Branch No."; Code[20])
        {
            Caption = 'Branch ID';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Customer No."));
        }
        field(3; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";

            trigger OnValidate()
            begin
                CalcFields("Staff Name");
            end;
        }
        field(4; "Staff Name"; Text[70])
        {
            CalcFormula = lookup("PDC Branch Staff".Name where("Staff ID" = field("Staff ID")));
            Caption = 'Staff Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Staff Body Type/Gender"; Code[10])
        {
            CalcFormula = lookup("PDC Branch Staff"."Body Type/Gender" where("Staff ID" = field("Staff ID"),
                                                                          "Sell-to Customer No." = field("Customer No.")));
            Caption = 'Staff Body Type/Gender';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Wardrobe ID"; Code[20])
        {
            Caption = 'Wardrobe ID';
            TableRelation = "PDC Wardrobe Header"."Wardrobe ID";
        }
        field(7; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = "PDC Wardrobe Line"."Product Code" where("Wardrobe ID" = field("Wardrobe ID"));
        }
        field(8; "Entitlement Period (Days)"; Integer)
        {
            CalcFormula = lookup("PDC Wardrobe Line"."Entitlement Period" where("Wardrobe ID" = field("Wardrobe ID"),
                                                                             "Product Code" = field("Product Code")));
            Caption = 'Entitlement Period (Days)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Quantity Entitled in Period"; Integer)
        {
            CalcFormula = lookup("PDC Wardrobe Line"."Quantity Entitled in Period" where("Wardrobe ID" = field("Wardrobe ID"),
                                                                                      "Product Code" = field("Product Code")));
            Caption = 'Quantity Entitled in Period';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Start Date"; Date)
        {
            Editable = false;
        }
        field(11; "End Date"; Date)
        {

            trigger OnValidate()
            var
                NoDaysPast: Integer;
                Lbl: Label '<-%1D>', Comment = '<-%1D>';
            begin
                CalcFields("Entitlement Period (Days)");
                NoDaysPast := "Entitlement Period (Days)" - 1;
                if (NoDaysPast < 0) then NoDaysPast := 0;
                if ("End Date" = 0D)
                  then
                    "Start Date" := 0D
                else
                    Validate("Start Date", CalcDate(StrSubstNo(Lbl, NoDaysPast), "End Date"));
            end;
        }
        field(12; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(13; "Quantity Posted"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry".Quantity where("Posting Date" = field(filter("Date Filter")),
                                                                   "PDC Product Code" = field("Product Code"),
                                                                   "PDC Staff ID" = field("Staff ID"),
                                                                   "Entry Type" = const(Sale)));
            Caption = 'Quantity Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Quantity on Return"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = const("Return Order"),
                                                                         Type = const(Item),
                                                                         "Posting Date" = field(filter("Date Filter")),
                                                                         "PDC Staff ID" = field("Staff ID"),
                                                                         "PDC Product Code" = field("Product Code")));
            Caption = 'Quantity on Return (Unposted)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Quantity on Order"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = const(Order),
                                                                         Type = const(Item),
                                                                         "Posting Date" = field(filter("Date Filter")),
                                                                         "PDC Staff ID" = field("Staff ID"),
                                                                         "PDC Product Code" = field("Product Code")));
            Caption = 'Quantity on Order (Unposted)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Calculated Quantity Issued"; Decimal)
        {
            Caption = 'Calculated Quantity Issued';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(17; "Calc. Qty. Remaining in Period"; Decimal)
        {
            Caption = 'Calculated Qty. Remaining in Period';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(18; "Last DateTime Calculated"; DateTime)
        {
            Caption = 'Last DateTime Calculated';
            Editable = false;
        }
        field(19; Inactive; Boolean)
        {
            Caption = 'Inactive';
        }
        field(20; "Inactivated Datetime"; DateTime)
        {
            Caption = 'Inactivated Datetime';
        }
        field(21; "Wardrobe Filter"; Code[20])
        {
            Caption = 'Wardrobe Filter';
            FieldClass = FlowFilter;
        }
        field(22; "Quantity on Draft Order"; Decimal)
        {
            Caption = 'Quantity on Draft Order';
            Editable = false;
        }
        field(23; "Item Type"; Option)
        {
            CalcFormula = lookup("PDC Wardrobe Line"."Item Type" where("Wardrobe ID" = field("Wardrobe ID"),
                                                                    "Product Code" = field("Product Code")));
            Caption = 'Item Type';
            FieldClass = FlowField;
            OptionCaption = 'Core,Accessory';
            OptionMembers = Core,Accessory;
        }
        field(105; "Wardrobe Discontinued"; Boolean)
        {
            CalcFormula = lookup("PDC Wardrobe Line".Discontinued where("Wardrobe ID" = field("Wardrobe ID"),
                                                                     "Product Code" = field("Product Code")));
            Caption = 'Wardrobe Discontinued';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Staff ID", "Product Code")
        {
        }
        key(Key2; "Start Date", "End Date")
        {
        }
        key(Key3; "Staff ID", "Wardrobe ID", "Product Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CalculateTxt: label 'Calculating @1@@@@@@@@@@@@@';

    /// <summary>
    /// CreateRecords.
    /// </summary>
    /// <param name="StaffIDFilter">Text.</param>
    procedure CreateRecords(StaffIDFilter: Text)
    var
        PDCStaffEntitlement: Record "PDC Staff Entitlement";
        PDCBranchStaff: Record "PDC Branch Staff";
        RecNo: Integer;
        TotalRecNo: Integer;
        Dialog: Dialog;
    begin
        if StaffIDFilter <> '' then
            SetFilter("Staff ID", StaffIDFilter);
        DeleteAll();

        if StaffIDFilter <> '' then
            PDCStaffEntitlement.SetFilter("Staff ID", StaffIDFilter)
        else
            PDCStaffEntitlement.SetFilter("Staff ID", '<>%1', '');
        PDCStaffEntitlement.SetFilter("Product Code", '<>%1', '');
        PDCStaffEntitlement.SetRange(Inactive, false);
        PDCStaffEntitlement.SetRange("Wardrobe Discontinued", false);
        if PDCStaffEntitlement.FindSet() then begin
            if GuiAllowed then
                Dialog.Open(CalculateTxt);
            RecNo := 0;
            TotalRecNo := PDCStaffEntitlement.Count;

            repeat
                RecNo += 1;
                if GuiAllowed then
                    Dialog.Update(1, ROUND(RecNo / TotalRecNo * 10000, 1));
                if PDCBranchStaff.Get(PDCStaffEntitlement."Staff ID") and
                   (PDCStaffEntitlement."Wardrobe ID" = PDCBranchStaff."Wardrobe ID") and
                   (PDCStaffEntitlement."End Date" <> 0D) and
                   (not PDCBranchStaff.Blocked)
                then begin
                    Init();
                    TransferFields(PDCStaffEntitlement);
                    Validate("End Date", CalcDate('<1M>', WorkDate()));
                    Insert(true);
                    CalculateQuantities(Rec, true);
                end;
            until PDCStaffEntitlement.Next() = 0;

            if GuiAllowed then
                Dialog.Close();
        end;
    end;

    /// <summary>
    /// CalculateQuantities.
    /// </summary>
    /// <param name="PDCStaffEntitlementPredict">VAR Record "PDC Staff Entitlement Predict.".</param>
    /// <param name="pModifyRec">Boolean.</param>
    procedure CalculateQuantities(var PDCStaffEntitlementPredict: Record "PDC Staff Entitlement Predict."; pModifyRec: Boolean)
    var
        PDCDraftOrdItemByStaffProd: Query PDCDraftOrdItemByStaffProd;
    begin
        if (PDCStaffEntitlementPredict."Start Date" <> 0D) and (PDCStaffEntitlementPredict."End Date" <> 0D) then
            PDCStaffEntitlementPredict.SetFilter("Date Filter", '%1..%2', PDCStaffEntitlementPredict."Start Date", PDCStaffEntitlementPredict."End Date");
        PDCStaffEntitlementPredict.CalcFields("Quantity Posted");
        PDCStaffEntitlementPredict.CalcFields("Quantity on Return");
        PDCStaffEntitlementPredict.CalcFields("Quantity on Order");
        PDCStaffEntitlementPredict.CalcFields("Quantity Entitled in Period");

        Clear(PDCStaffEntitlementPredict."Quantity on Draft Order");
        Clear(PDCDraftOrdItemByStaffProd);
        PDCDraftOrdItemByStaffProd.SetRange(ProductCodeFilter, PDCStaffEntitlementPredict."Product Code");
        PDCDraftOrdItemByStaffProd.SetRange(StaffIDFilter, PDCStaffEntitlementPredict."Staff ID");
        PDCDraftOrdItemByStaffProd.Open();
        while PDCDraftOrdItemByStaffProd.Read() do
            PDCStaffEntitlementPredict."Quantity on Draft Order" += PDCDraftOrdItemByStaffProd.Quantity;

        PDCStaffEntitlementPredict.Validate("Calculated Quantity Issued", PDCStaffEntitlementPredict."Quantity Posted" + PDCStaffEntitlementPredict."Quantity on Return" + PDCStaffEntitlementPredict."Quantity on Order"
                 + PDCStaffEntitlementPredict."Quantity on Draft Order");
        PDCStaffEntitlementPredict.Validate("Calc. Qty. Remaining in Period", PDCStaffEntitlementPredict."Quantity Entitled in Period" - PDCStaffEntitlementPredict."Calculated Quantity Issued");
        PDCStaffEntitlementPredict.Validate("Last DateTime Calculated", CurrentDatetime);
        if pModifyRec then
            PDCStaffEntitlementPredict.Modify(true);
    end;
}

