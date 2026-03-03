/// <summary>
/// Table PDC Staff Entitlement (ID 50022).
/// </summary>
table 50022 "PDC Staff Entitlement"
{
    Caption = 'Staff Entitlement';
    DrillDownPageID = "PDC Staff Entitlement List";
    LookupPageID = "PDC Staff Entitlement List";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." = '' then
                    Clear("Customer Id")
                else
                    if Customer.get("Customer No.") then
                        "Customer Id" := Customer.SystemId;
            end;
        }
        field(2; "Branch No."; Code[20])
        {
            Caption = 'Branch ID';
            TableRelation = "PDC Branch"."Branch No." where("Customer No." = field("Customer No."));

            trigger OnValidate()
            var
                Branch: Record "PDC Branch";
            begin
                if "Branch No." = '' then
                    Clear("Branch SystemId")
                else
                    if Branch.get("Customer No.", "Branch No.") then
                        "Branch SystemId" := Branch.SystemId;
            end;
        }
        field(3; "Staff ID"; Code[20])
        {
            Caption = 'Staff ID';
            TableRelation = "PDC Branch Staff"."Staff ID";

            trigger OnValidate()
            var
                Staff: Record "PDC Branch Staff";
            begin
                CalcFields("Staff Name");

                if "Staff ID" = '' then
                    Clear("Staff SystemId")
                else
                    if Staff.get("Staff ID") then
                        "Staff SystemId" := Staff.SystemId;
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

            trigger OnValidate()
            var
                Wardrobe: Record "PDC Wardrobe Header";
            begin
                if Wardrobe.get("Wardrobe ID") then
                    Wardrobe.TestField(Disable, false);

                if "Wardrobe ID" = '' then
                    Clear("Wardrobe SystemId")
                else
                    if Wardrobe.Get("Wardrobe ID") then
                        "Wardrobe SystemId" := Wardrobe.SystemId;
            end;
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
            Editable = false; //automatically calculated from End Date
        }
        field(11; "End Date"; Date)
        {

            trigger OnValidate()
            var
                NoDaysPast: Integer;
                Lbl: Label '<-%1D>', Comment = '<-%1D>';
            begin
                if "Posponed Period (Days)" > 0 then
                    if Dt2Date("Posponed At") + "Posponed Period (Days)" <= WorkDate() then begin
                        Clear("Posponed Period (Days)");
                        Clear("Posponed By User");
                        Clear("Posponed At");
                    end;

                CalcFields("Entitlement Period (Days)");

                if "Group Code" <> '' then begin
                    CalcFields("Group Entitlement Period");
                    "Entitlement Period (Days)" := "Group Entitlement Period";
                end;

                NoDaysPast := "Entitlement Period (Days)" - 1 + "Posponed Period (Days)";
                if (NoDaysPast < 0) then NoDaysPast := 0;
                if ("End Date" = 0D)
                  then
                    "Start Date" := 0D
                else
                    Validate("Start Date", CalcDate(StrSubstNo(Lbl, NoDaysPast), "End Date"));
                CalculateQuantities(Rec, true);
            end;
        }
        field(12; "Date Filter"; Date)
        {
            FieldClass = FlowFilter; //Used to filter SUM flowfields for ILE/SL
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
        field(24; "Posponed Period (Days)"; Integer)
        {
            Caption = 'Posponed Period (Days)';
        }
        field(25; "Posponed By User"; Code[20])
        {
            Caption = 'Posponed By User';
        }
        field(26; "Posponed At"; DateTime)
        {
            Caption = 'Posponed At';
        }
        field(27; "Group Type"; Enum PDCEntitlementGroupType)
        {
            Caption = 'Group Type';
        }
        field(28; "Group Code"; Code[20])
        {
            Caption = 'Group Code';
            TableRelation = "PDC Staff Entitlement Group".Code where(Type = field("Group Type"));
        }
        field(29; "Calculated Amount Issued"; Decimal)
        {
            Caption = 'Calculated Amount Issued';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(30; "Calc. Amt. Remaining in Period"; Decimal)
        {
            Caption = 'Calculated Amount Remaining in Period';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(31; "Group Entitlement Period"; Integer)
        {
            CalcFormula = lookup("PDC Wardrobe Entitlement Group"."Entitlement Period" where("Wardrobe ID" = field("Wardrobe ID"),
                                Type = field("Group Type"), "Group Code" = field("Group Code")));
            Caption = 'Group Entitlement Period';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Group Value Entitled"; Decimal)
        {
            CalcFormula = lookup("PDC Wardrobe Entitlement Group".Value where("Wardrobe ID" = field("Wardrobe ID"),
                                Type = field("Group Type"), "Group Code" = field("Group Code")));
            Caption = 'Group Value Entitled';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Customer Id"; Guid)
        {
            Caption = 'Customer Id';
            TableRelation = Customer.SystemId;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if IsNullGuid("Customer Id") then
                    "Customer No." := ''
                else
                    if Customer.GetBySystemId("Customer Id") then
                        "Customer No." := Customer."No.";
            end;
        }
        field(34; "Branch SystemId"; Guid)
        {
            Caption = 'Branch SystemId';
            TableRelation = "PDC Branch".SystemId;

            trigger OnValidate()
            var
                Branch: Record "PDC Branch";
            begin
                if IsNullGuid("Branch SystemId") then
                    "Wardrobe ID" := ''
                else
                    if Branch.GetBySystemId("Branch SystemId") then
                        "Branch No." := Branch."Branch No.";
            end;
        }
        field(35; "Staff SystemId"; Guid)
        {
            Caption = 'Staff SystemId';
            TableRelation = "PDC Branch Staff".SystemId;

            trigger OnValidate()
            var
                Staff: Record "PDC Branch Staff";
            begin
                if IsNullGuid("Staff SystemId") then
                    "Staff ID" := ''
                else
                    if Staff.GetBySystemId("Staff SystemId") then
                        "Staff ID" := Staff."Staff ID";
            end;
        }
        field(36; "Wardrobe SystemId"; Guid)
        {
            Caption = 'Wardrobe SystemId';
            TableRelation = "PDC Wardrobe Header".SystemId;

            trigger OnValidate()
            var
                Wardrobe: Record "PDC Wardrobe Header";
            begin
                if IsNullGuid("Wardrobe SystemId") then
                    "Wardrobe ID" := ''
                else
                    if Wardrobe.GetBySystemId("Wardrobe SystemId") then
                        "Wardrobe ID" := Wardrobe."Wardrobe ID";
            end;
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
        key(Key1; "Staff ID", "Product Code", "Group Type", "Group Code")
        {
        }
        key(Key2; "Start Date", "End Date")
        {
        }
        key(Key3; "Staff ID", "Wardrobe ID", "Product Code")
        {
        }
        key(Key4; Inactive)
        {
        }
    }

    fieldgroups
    {
    }


    /// <summary>
    /// CalculateQuantities.
    /// </summary>
    /// <param name="PDCStaffEntitlement">VAR Record "PDC Staff Entitlement".</param>
    /// <param name="pModifyRec">Boolean.</param>
    procedure CalculateQuantities(var PDCStaffEntitlement: Record "PDC Staff Entitlement"; pModifyRec: Boolean)
    var
        PDCWardrobeLine: Record "PDC Wardrobe Line";
        TempPDCStaffEntitlement: Record "PDC Staff Entitlement" temporary;
        TempSalesPrice: Record "Sales Price" temporary;
        Customer: Record Customer;
        Item: Record Item;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        PDCDraftOrdItemByStaffProd: Query PDCDraftOrdItemByStaffProd;
    begin
        if PDCStaffEntitlement."Group Type" = PDCStaffEntitlement."Group Type"::" " then begin
            if (PDCStaffEntitlement."Start Date" <> 0D) and (PDCStaffEntitlement."End Date" <> 0D) then
                PDCStaffEntitlement.SetFilter("Date Filter", '%1..%2', PDCStaffEntitlement."Start Date", PDCStaffEntitlement."End Date"); //MA 2018-02-27
            PDCStaffEntitlement.CalcFields("Quantity Posted");
            PDCStaffEntitlement.CalcFields("Quantity on Return");
            PDCStaffEntitlement.CalcFields("Quantity on Order");
            PDCStaffEntitlement.CalcFields("Quantity Entitled in Period");

            Clear(PDCStaffEntitlement."Quantity on Draft Order");
            Clear(PDCDraftOrdItemByStaffProd);
            PDCDraftOrdItemByStaffProd.SetRange(ProductCodeFilter, PDCStaffEntitlement."Product Code");
            PDCDraftOrdItemByStaffProd.SetRange(StaffIDFilter, PDCStaffEntitlement."Staff ID");
            PDCDraftOrdItemByStaffProd.Open();
            while PDCDraftOrdItemByStaffProd.Read() do
                PDCStaffEntitlement."Quantity on Draft Order" += PDCDraftOrdItemByStaffProd.Quantity;

            PDCStaffEntitlement.Validate("Calculated Quantity Issued", PDCStaffEntitlement."Quantity Posted" - PDCStaffEntitlement."Quantity on Return" + PDCStaffEntitlement."Quantity on Order" + PDCStaffEntitlement."Quantity on Draft Order");
            PDCStaffEntitlement.Validate("Calc. Qty. Remaining in Period", PDCStaffEntitlement."Quantity Entitled in Period" - PDCStaffEntitlement."Calculated Quantity Issued");
        end
        else begin
            clear(PDCStaffEntitlement."Quantity Posted");
            Clear(PDCStaffEntitlement."Quantity on Order");
            Clear(PDCStaffEntitlement."Quantity on Return");
            Clear(PDCStaffEntitlement."Quantity on Draft Order");
            clear(PDCStaffEntitlement."Calculated Quantity Issued");
            clear(PDCStaffEntitlement."Calc. Qty. Remaining in Period");
            clear(PDCStaffEntitlement."Calculated Amount Issued");
            PDCStaffEntitlement.CalcFields("Group Value Entitled");

            PDCWardrobeLine.reset();
            PDCWardrobeLine.setrange("Wardrobe ID", PDCStaffEntitlement."Wardrobe ID");
            case PDCStaffEntitlement."Group Type" of
                PDCStaffEntitlement."Group Type"::"Quantity Group":
                    PDCWardrobeLine.setrange("Entitlement Qty. Group", PDCStaffEntitlement."Group Code");
                PDCStaffEntitlement."Group Type"::"Value Group":
                    PDCWardrobeLine.setrange("Entitlement Value Group", PDCStaffEntitlement."Group Code");
                PDCStaffEntitlement."Group Type"::"Points Group":
                    PDCWardrobeLine.setrange("Entitlement Points Group", PDCStaffEntitlement."Group Code")
            end;
            PDCWardrobeLine.setrange(Discontinued, false);
            if PDCWardrobeLine.FindSet() then
                repeat
                    clear(TempPDCStaffEntitlement);
                    PDCWardrobeLine.CalcFields("Customer No.");
                    TempPDCStaffEntitlement.Init();
                    TempPDCStaffEntitlement.Validate("Staff ID", PDCStaffEntitlement."Staff ID");
                    TempPDCStaffEntitlement.Validate("Wardrobe ID", PDCWardrobeLine."Wardrobe ID");
                    TempPDCStaffEntitlement.Validate("Product Code", PDCWardrobeLine."Product Code");
                    TempPDCStaffEntitlement.Validate("Customer No.", PDCWardrobeLine."Customer No.");
                    TempPDCStaffEntitlement.Validate("Branch No.", PDCStaffEntitlement."Branch No.");
                    TempPDCStaffEntitlement.Validate("Group Type", TempPDCStaffEntitlement."Group Type"::" ");
                    TempPDCStaffEntitlement."Start Date" := PDCStaffEntitlement."Start Date";
                    TempPDCStaffEntitlement."End Date" := PDCStaffEntitlement."End Date";
                    TempPDCStaffEntitlement.Insert();
                    TempPDCStaffEntitlement.CalculateQuantities(TempPDCStaffEntitlement, true);

                    PDCStaffEntitlement."Quantity Posted" += TempPDCStaffEntitlement."Quantity Posted";
                    PDCStaffEntitlement."Quantity on Order" += TempPDCStaffEntitlement."Quantity on Order";
                    PDCStaffEntitlement."Quantity on Return" += TempPDCStaffEntitlement."Quantity on Return";
                    PDCStaffEntitlement."Quantity on Draft Order" += TempPDCStaffEntitlement."Quantity on Draft Order";

                    PDCStaffEntitlement.Validate("Calculated Quantity Issued", PDCStaffEntitlement."Calculated Quantity Issued" + TempPDCStaffEntitlement."Calculated Quantity Issued");
                    if PDCStaffEntitlement."Group Type" in [PDCStaffEntitlement."Group Type"::"Value Group", PDCStaffEntitlement."Group Type"::"Points Group"] then begin
                        clear(SalesPriceCalcMgt);
                        if Customer."No." <> PDCWardrobeLine."Customer No." then
                            Customer.get(PDCWardrobeLine."Customer No.");
                        if Item."PDC Product Code" <> PDCWardrobeLine."Product Code" then begin
                            Item.SetCurrentkey("PDC Product Code");
                            Item.SetRange("PDC Product Code", PDCWardrobeLine."Product Code");
                            Item.SetRange(Blocked, false);
                            Item.FindFirst();
                        end;
                        SalesPriceCalcMgt.FindSalesPrice(TempSalesPrice, PDCWardrobeLine."Customer No.", '', Customer."Customer Price Group", '',
                                                     Item."No.", '', Item."Sales Unit of Measure", '', PDCStaffEntitlement."Start Date", false);
                        SalesPriceCalcMgt.CalcBestUnitPrice(TempSalesPrice);
                        if PDCStaffEntitlement."Group Type" = PDCStaffEntitlement."Group Type"::"Value Group" then
                            PDCStaffEntitlement.Validate("Calculated Amount Issued", PDCStaffEntitlement."Calculated Amount Issued" + TempPDCStaffEntitlement."Calculated Quantity Issued" * TempSalesPrice."Unit Price")
                        else
                            PDCStaffEntitlement.Validate("Calculated Amount Issued", PDCStaffEntitlement."Calculated Amount Issued" + TempPDCStaffEntitlement."Calculated Quantity Issued" * TempSalesPrice."Unit Price"); //to-do replace py Points
                    end;
                until PDCWardrobeLine.next() = 0;

            case PDCStaffEntitlement."Group Type" of
                PDCStaffEntitlement."Group Type"::"Quantity Group":
                    PDCStaffEntitlement.Validate("Calc. Qty. Remaining in Period", PDCStaffEntitlement."Group Value Entitled" - PDCStaffEntitlement."Calculated Quantity Issued");
                PDCStaffEntitlement."Group Type"::"Value Group",
                PDCStaffEntitlement."Group Type"::"Points Group":
                    PDCStaffEntitlement.Validate("Calc. Amt. Remaining in Period", PDCStaffEntitlement."Group Value Entitled" - PDCStaffEntitlement."Calculated Amount Issued");
            end;
            PDCStaffEntitlement.Validate("Last DateTime Calculated", CurrentDatetime);
            if pModifyRec then
                PDCStaffEntitlement.Modify(true);
        end;

        PDCStaffEntitlement.Validate("Last DateTime Calculated", CurrentDatetime);
        if pModifyRec then
            PDCStaffEntitlement.Modify(true);
    end;
}

