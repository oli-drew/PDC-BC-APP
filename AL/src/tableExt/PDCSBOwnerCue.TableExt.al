/// <summary>
/// TableExtension PDCSBOwnerCue (ID 50051) extends Record SB Owner Cue.
/// </summary>
tableextension 50051 PDCSBOwnerCue extends "SB Owner Cue"
{
    fields
    {
        field(50000; "PDC Customers-Over Cred. Limit"; Integer)
        {
            Caption = 'Customers - Over Credit Limit';
        }
    }

    /// <summary>
    /// ShowCustomers.
    /// </summary>
    procedure ShowCustomers()
    var
        Customer: Record Customer;
    begin
        //++DN1.00
        Customer.Reset();
        Customer.ClearMarks();
        if Customer.FindSet() then
            repeat
                if Customer.CalcAvailableCredit() < 0 then
                    Customer.Mark(true);
            until Customer.Next() = 0;
        Customer.MarkedOnly(true);
        Page.Run(Page::"Customer List", Customer);
        //--DN1.00
    end;
}

