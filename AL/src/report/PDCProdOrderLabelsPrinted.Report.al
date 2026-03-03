/// <summary>
/// Report PDC Prod.Order Labels -Printed (ID 50015).
/// </summary>
Report 50015 "PDC Prod.Order Labels -Printed"
{
    Caption = 'Prod.Order Labels -Printed';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Order"; "Production Order")
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                "PDC No. Labels Printed" := "PDC No. Labels Printed" + 1;
                modify();
                Commit();
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

