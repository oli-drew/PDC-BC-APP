/// <summary>
/// Report CreateBranchStaffFromTG (ID 50056) creates new staff from TimeGate records.
/// </summary>
report 50056 PDCCreateBranchStaffFromTG
{
    Caption = 'CreateBranchStaffFromTG';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Date Filter";

            trigger OnPreDataItem()
            begin
                NAVPortal.Get('CUSTP');
                NAVPortal.TestField("Branch Staff Series Nos.");
            end;

            trigger OnAfterGetRecord()
            begin
                TimegateRecord.setrange("Customer No.", Customer."No.");
                if TimegateRecord.Findset() then begin
                    clear(Branch);
                    Branch.setrange("Customer No.", Customer."No.");
                    Branch.SetRange("Default Branch", true);
                    if Branch.FindFirst() then;

                    clear(Contract);
                    Contract.setrange("Customer No.", Customer."No.");
                    Contract.setrange("Default Contract", true);
                    if Contract.FindFirst() then;

                    clear(Wardrobe);
                    Wardrobe.setrange("Customer No.", Customer."No.");
                    Wardrobe.setrange("Default Wardrobe", true);
                    if Wardrobe.FindFirst() then;

                    repeat
                        Staff.setrange("Sell-to Customer No.", Customer."No.");
                        Staff.setrange("Wearer ID", TimegateRecord."Tg PIN");
                        if (TimegateRecord."Left Date" <> 0D) then begin
                            if Staff.FindFirst() then
                                if not Staff.Blocked then begin
                                    Staff.validate(Blocked, true);
                                    Staff.Modify();
                                end;
                        end
                        else
                            if Staff.IsEmpty then begin
                                clear(Staff);
                                Staff.Init();
                                Staff."No. Series" := NAVPortal."Branch Staff Series Nos.";
                                Staff."Staff ID" := NoSeries.GetNextNo(Staff."No. Series", WorkDate());
                                Staff.validate("Sell-to Customer No.", Customer."No.");
                                Staff."Wearer ID" := TimegateRecord."Tg PIN";
                                Staff.Insert(false);

                                Staff."First Name" := copystr(TimegateRecord."First Name", 1, 30);
                                Staff."Last Name" := copystr(TimegateRecord.Surname, 1, 30);
                                Staff.Name := copystr(TimegateRecord."First Name" + ' ' + TimegateRecord.Surname, 1, 70);
                                Staff."Body Type/Gender" := copystr(TimegateRecord.Gender, 1, 10);

                                if Branch."Branch No." <> '' then
                                    Staff.validate("Branch ID", Branch."Branch No.");
                                if Contract."No." <> '' then
                                    Staff.validate("Contract ID", Contract."No.");
                                if Wardrobe."Wardrobe ID" <> '' then
                                    Staff.validate("Wardrobe ID", Wardrobe."Wardrobe ID");
                                Staff.Modify(true);
                            end;
                    until TimegateRecord.Next() = 0;
                end;


            end;
        }
    }

    var
        TimegateRecord: Record "PDC Timegate Joiners Leavers";
        Staff: Record "PDC Branch Staff";
        Branch: Record "PDC Branch";
        Wardrobe: Record "PDC Wardrobe Header";
        Contract: Record "PDC Contract";
        NavPortal: Record "PDC Portal";
        NoSeries: Codeunit "No. Series";

}
