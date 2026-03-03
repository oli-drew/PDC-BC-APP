XmlPort 50034 "PDC Portal Entitlement"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                textelement(staffId)
                {
                }
            }
            tableelement(branchstaff; "PDC Branch Staff")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                fieldelement(no; BranchStaff."Staff ID")
                {
                }
                fieldelement(name; BranchStaff.Name)
                {
                }

            }
            tableelement(entitlement; "PDC Staff Entitlement")
            {
                CalcFields = "Staff Name", "Quantity Entitled in Period", "Group Value Entitled";
                MinOccurs = Zero;
                XmlName = 'entitlement';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(staffid; Entitlement."Staff ID")
                {
                }
                fieldelement(branchid; Entitlement."Branch No.")
                {
                }
                fieldelement(staffName; Entitlement."Staff Name")
                {
                }
                textelement(productCode)
                {
                }
                fieldelement(wardrobe; Entitlement."Wardrobe ID")
                {
                }
                textelement(entitledQty)
                {
                }
                fieldelement(remainingQTY; Entitlement."Calc. Qty. Remaining in Period")
                {
                }
                textelement(branchname)
                {
                    XmlName = 'branchname';

                    trigger OnBeforePassVariable()
                    var
                        Branch: Record "PDC Branch";
                    begin
                        Branch.Reset();
                        Branch.SetRange("Branch No.", Entitlement."Branch No.");
                        Branch.SetRange("Customer No.", Entitlement."Customer No.");
                        if not Branch.FindFirst() then exit;

                        branchName := Branch.Name;
                    end;
                }
                textelement(wardrobename)
                {
                    XmlName = 'wardrobename';

                    trigger OnBeforePassVariable()
                    var
                        WardrobeHeader: Record "PDC Wardrobe Header";
                    begin
                        WardrobeHeader.Reset();
                        WardrobeHeader.SetRange("Wardrobe ID", Entitlement."Wardrobe ID");
                        if not WardrobeHeader.FindFirst() then exit;

                        wardrobeName := WardrobeHeader.Description;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    WardrobeGroup: Record "PDC Wardrobe Entitlement Group";
                begin
                    if entitlement."Group Type" = entitlement."Group Type"::" " then
                        productCode := Entitlement."Product Code"
                    else begin
                        if WardrobeGroup.get(entitlement."Wardrobe ID", entitlement."Group Type", entitlement."Group Code") then
                            productCode := entitlement."Group Code";
                        entitlement."Quantity Entitled in Period" := entitlement."Group Value Entitled";
                    end;
                    entitledQty := Format(Entitlement."Quantity Entitled in Period", 0, '<Sign><Integer>');
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    procedure FilterData(Command: Text)
    var
        BranchStaffDB: Record "PDC Branch Staff";
        EntitlementDb: Record "PDC Staff Entitlement";
        EntitlementPredictedDb: Record "PDC Staff Entitlement Predict.";
    begin
        BranchStaff.DeleteAll();
        Entitlement.Reset();
        Entitlement.DeleteAll();

        if not BranchStaffDB.Get(staffId) then
            exit;
        BranchStaff.TransferFields(BranchStaffDB);
        BranchStaff.Insert();

        if Command in ['remaining', 'complete', 'exceeded'] then begin
            EntitlementDb.SetRange("Staff ID", BranchStaff."Staff ID");
            EntitlementDb.SetRange("Wardrobe ID", BranchStaff."Wardrobe ID");
            EntitlementDb.SetRange("Item Type", EntitlementDb."item type"::Core);
            EntitlementDb.SetRange(Inactive, false);
            EntitlementDb.SetRange("Wardrobe Discontinued", false);
            if Command = 'remaining' then EntitlementDb.SetFilter("Calc. Qty. Remaining in Period", '>0');
            if Command = 'complete' then EntitlementDb.SetFilter("Calc. Qty. Remaining in Period", '0');
            if Command = 'exceeded' then EntitlementDb.SetFilter("Calc. Qty. Remaining in Period", '<0');
            if EntitlementDb.FindSet() then
                repeat
                    if not (Entitlement.Get(EntitlementDb."Staff ID", EntitlementDb."Product Code")) then begin
                        Entitlement.TransferFields(EntitlementDb);
                        Entitlement.Insert();
                    end;
                until EntitlementDb.Next() = 0;
        end
        else
            if Command in ['predicted'] then begin
                EntitlementPredictedDb.SetRange("Staff ID", BranchStaff."Staff ID");
                EntitlementPredictedDb.SetRange("Wardrobe ID", BranchStaff."Wardrobe ID");
                EntitlementPredictedDb.SetRange("Item Type", EntitlementPredictedDb."item type"::Core);
                EntitlementPredictedDb.SetFilter("Calc. Qty. Remaining in Period", '>0');
                if not EntitlementDb.IsEmpty then
                    repeat
                        if not (Entitlement.Get(EntitlementPredictedDb."Staff ID", EntitlementPredictedDb."Product Code")) then begin
                            Entitlement.TransferFields(EntitlementPredictedDb);
                            Entitlement.Insert();
                        end;
                    until EntitlementPredictedDb.Next() = 0;
            end;
    end;
}

