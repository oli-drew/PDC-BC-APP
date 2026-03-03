/// <summary>
/// Table PDC Demand Item Req. Line (ID 50040).
/// </summary>
table 50040 "PDC Demand Item Req. Line"
{
    // 09.09.2017 JEMEL J.Jemeljanovs #2296
    //   * Created

    Caption = 'Demand Item Requisition Line';
    DrillDownPageID = "PDC Demand Prod. Req. Lines";
    LookupPageID = "PDC Demand Prod. Req. Lines";

    fields
    {
        field(2; "Requester ID"; Code[50])
        {
            Caption = 'Requester ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("Requester ID");
            end;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("Requester ID");
            end;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                GetItem();
                Item.TestField(Blocked, false);
                UpdateDescription();
                Item.TestField("Base Unit of Measure");
                Validate("Unit of Measure Code", Item."Base Unit of Measure");
                "Product Code" := Item."PDC Product Code";
                "Colour Code" := Item."PDC Colour";
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(8; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                if LookupVendor(Vendor) then
                    Validate("Vendor No.", Vendor."No.");
            end;

            trigger OnValidate()
            begin
                if "Vendor No." <> '' then
                    if Vendor.Get("Vendor No.") then begin
                        if Vendor.Blocked = Vendor.Blocked::All then
                            Vendor.VendBlockedErrorMessage(Vendor, false);

                        if "Order Date" = 0D then
                            Validate("Order Date", WorkDate());

                        Validate(Quantity);
                    end else
                        "Vendor No." := ''
                else
                    UpdateDescription();
            end;
        }
        field(9; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));

            trigger OnValidate()
            begin
                GetItem();

                "Qty. per Unit of Measure" := UnitofMeasureManagement.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                Validate(Quantity);
            end;
        }
        field(11; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
            end;
        }
        field(12; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(13; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(14; "Product Code"; Code[30])
        {
            Caption = 'Product Code';
        }
        field(15; "Colour Code"; Code[10])
        {
            Caption = 'Colour Code';
            TableRelation = "PDC Product colour";
        }
    }

    keys
    {
        key(Key1; "Requester ID", "Line No.")
        {
        }
        key(Key2; "Item No.", "Due Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        PDCDemandItemReqLine: Record "PDC Demand Item Req. Line";
    begin
        if CurrentKey <> PDCDemandItemReqLine.CurrentKey then begin
            PDCDemandItemReqLine := Rec;
            PDCDemandItemReqLine.SetRecfilter();
            PDCDemandItemReqLine.SetRange("Line No.");
            if PDCDemandItemReqLine.FindLast() then
                "Line No." := PDCDemandItemReqLine."Line No." + 10000;
        end;
    end;

    trigger OnRename()
    begin
        Error(Text004Lbl, TableCaption);
    end;

    var
        Item: Record Item;
        Vendor: Record Vendor;
        ItemVendor: Record "Item Vendor";
        UnitofMeasureManagement: Codeunit "Unit of Measure Management";
        Text004Lbl: label 'You cannot rename a %1.', Comment = 'You cannot rename a %1.';

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure GetItem()
    begin
        TestField("Item No.");
        if "Item No." <> Item."No." then
            Item.Get("Item No.");
    end;

    /// <summary>
    /// LookupVendor.
    /// </summary>
    /// <param name="VendorRec">VAR Record Vendor.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure LookupVendor(var VendorRec: Record Vendor): Boolean
    begin
        if ItemVendor.ReadPermission then begin
            ItemVendor.Init();
            ItemVendor.SetRange("Item No.", "Item No.");
            ItemVendor.SetRange("Vendor No.", "Vendor No.");
            if not ItemVendor.FindLast() then begin
                ItemVendor."Item No." := "Item No.";
                ItemVendor."Vendor No." := "Vendor No.";
            end;
            ItemVendor.SetRange("Vendor No.");
            if Page.RunModal(0, ItemVendor) = Action::LookupOK then begin
                VendorRec.Get(ItemVendor."Vendor No.");
                exit(true);
            end;
            exit(false);
        end;
        VendorRec."No." := "Vendor No.";
        exit(Page.RunModal(0, VendorRec) = Action::LookupOK);
    end;

    local procedure UpdateDescription()
    var
    begin
        GetItem();
        Description := Item.Description;
        "Description 2" := Item."Description 2";
    end;
}

