/// <summary>
/// XmlPort PDC Portal Staff Card (ID 50012).
/// </summary>
XmlPort 50012 "PDC Portal Staff Card"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
                textelement(f_staffId)
                {
                }
            }
            tableelement(branchstaff; "PDC Branch Staff")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                fieldelement(staffid; BranchStaff."Staff ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(customerid; BranchStaff."Sell-to Customer No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(name; BranchStaff.Name)
                {
                }
                fieldelement(branch; BranchStaff."Branch ID")
                {
                }
                fieldelement(branchName; BranchStaff."Branch Name")
                {
                    MinOccurs = Zero;
                }
                fieldelement(gender; BranchStaff."Body Type/Gender")
                {
                }
                fieldelement(uniform; BranchStaff."Wardrobe ID")
                {
                }
                fieldelement(uniformName; BranchStaff."Wardrobe Description")
                {
                    MinOccurs = Zero;
                }
                fieldelement(yourid; BranchStaff."Wearer ID")
                {
                }
                fieldelement(contract; BranchStaff."Contract ID")
                {
                }
                fieldelement(email; BranchStaff."Email Address")
                {
                    MinOccurs = Zero;
                }
                fieldelement(blocked; BranchStaff.Blocked)
                {
                    MinOccurs = Zero;
                }
                textelement(contractcode)
                {
                    MinOccurs = Zero;
                }
                textelement(contractname)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                var
                    Contract: Record "PDC Contract";
                begin
                    Contract.Reset();
                    Contract.SetRange("No.", BranchStaff."Contract ID");
                    if not Contract.FindFirst() then clear(Contract);
                    contractName := Contract.Description;
                    contractcode := Contract."Contract Code";
                end;
            }
        }
    }

    var
        NavPortalUserLoc: Record "PDC Portal User";

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure FilterData(var NavPortalUser: Record "PDC Portal User")
    var
        BranchStaffDb: Record "PDC Branch Staff";
    begin

        BranchStaff.Reset();
        BranchStaffDb.Reset();


        BranchStaffDb.SetRange("Sell-to Customer No.", NavPortalUser."Customer No.");
        BranchStaffDb.SetRange("Staff ID", f_staffId);

        if BranchStaffDb.FindFirst() then BranchStaff.TransferFields(BranchStaffDb);
        BranchStaff.Insert();

        NavPortalUserLoc := NavPortalUser;
    end;

    /// <summary>
    /// UpdateStaff.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure UpdateStaff(var NavPortalUser: Record "PDC Portal User")
    var
        BranchStaffDb: Record "PDC Branch Staff";
        StaffEntitlement: Codeunit "PDC Staff Entitlement";
        StaffNotFoundErr: label 'Staff member with id %1 not found', Comment = '%1=staff if';
        FirstName: Text;
        LastName: Text;
    begin
        BranchStaffDb.Reset();
        BranchStaffDb.SetRange("Sell-to Customer No.", NavPortalUser."Customer No.");
        BranchStaffDb.SetRange("Staff ID", f_staffId);

        if not BranchStaff.FindFirst() then
            Error(StaffNotFoundErr, f_staffId);

        if not BranchStaffDb.FindFirst() then
            Error(StaffNotFoundErr, f_staffId);

        LastName := BranchStaff.Name;
        while StrPos(LastName, ' ') <> 0 do begin
            if FirstName = '' then
                FirstName := CopyStr(LastName, 1, StrPos(LastName, ' ') - 1);

            LastName := CopyStr(LastName, StrPos(LastName, ' ') + 1);
        end;

        BranchStaffDb.Validate("First Name", CopyStr(FirstName, 1, 30));
        BranchStaffDb.Validate("Last Name", CopyStr(LastName, 1, 30));
        BranchStaffDb.Validate(Name, CopyStr(BranchStaff.Name, 1, 70));

        BranchStaffDb."Branch ID" := BranchStaff."Branch ID";
        BranchStaffDb."Body Type/Gender" := BranchStaff."Body Type/Gender";
        BranchStaffDb."Wardrobe ID" := BranchStaff."Wardrobe ID";
        BranchStaffDb."Wearer ID" := BranchStaff."Wearer ID";
        BranchStaffDb."Contract ID" := BranchStaff."Contract ID";
        BranchStaffDb."Email Address" := BranchStaff."Email Address";
        BranchStaffDb.Blocked := BranchStaff.Blocked;
        BranchStaffDb.Modify(true);

        StaffEntitlement.UpdateStaffEntitlementFromBranchStaff(BranchStaffDb);
    end;

    /// <summary>
    /// AddStaff.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure AddStaff(var NavPortalUser: Record "PDC Portal User")
    var
        BranchStaffDb: Record "PDC Branch Staff";
        StaffEntitlement: Codeunit "PDC Staff Entitlement";
        StaffNotFoundErr: label 'Staff member with id %1 not found', Comment = '%1=staff if';
        FirstName: Text;
        LastName: Text;
    begin
        if not BranchStaff.FindFirst() then
            Error(StaffNotFoundErr, f_staffId);

        BranchStaffDb.Init();
        BranchStaffDb.Insert(true);

        LastName := BranchStaff.Name;
        while StrPos(LastName, ' ') <> 0 do begin
            if FirstName = '' then
                FirstName := CopyStr(LastName, 1, StrPos(LastName, ' ') - 1);

            LastName := CopyStr(LastName, StrPos(LastName, ' ') + 1);
        end;

        BranchStaffDb.Validate("First Name", CopyStr(FirstName, 1, 30));
        BranchStaffDb.Validate("Last Name", CopyStr(LastName, 1, 30));
        BranchStaffDb.Validate(Name, CopyStr(BranchStaff.Name, 1, 70));

        BranchStaffDb."Branch ID" := BranchStaff."Branch ID";
        BranchStaffDb."Sell-to Customer No." := NavPortalUser."Customer No.";
        BranchStaffDb."Body Type/Gender" := BranchStaff."Body Type/Gender";
        BranchStaffDb."Wardrobe ID" := BranchStaff."Wardrobe ID";
        BranchStaffDb."Wearer ID" := BranchStaff."Wearer ID";
        BranchStaffDb."Contract ID" := BranchStaff."Contract ID";
        BranchStaffDb."Email Address" := BranchStaff."Email Address";
        BranchStaffDb.Blocked := BranchStaff.Blocked;
        BranchStaffDb."Created By" := NavPortalUser.Id;
        BranchStaffDb."Created On" := CurrentDateTime();
        BranchStaffDb.Modify(true);

        StaffEntitlement.UpdateStaffEntitlementFromBranchStaff(BranchStaffDb);
    end;
}

