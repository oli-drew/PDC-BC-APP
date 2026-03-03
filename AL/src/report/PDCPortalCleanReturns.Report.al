/// <summary>
/// Report PDC Portal - Clean Returns (ID 50033).
/// </summary>
Report 50033 "PDC Portal - Clean Returns"
{
    Caption = 'Portal - Clean Returns';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const("Return Order"), Status = const(Open), "PDC Return From Invoice No." = filter(<> ''), "PDC Return Submitted" = const(false));

            trigger OnPreDataItem()
            begin
                DeleteAll(true);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

