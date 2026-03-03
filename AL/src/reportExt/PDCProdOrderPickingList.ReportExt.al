reportextension 50000 "PDC Prod. Order - Picking List" extends "Prod. Order - Picking List"
{
    dataset
    {
        modify("Prod. Order Component")
        {
            RequestFilterFields = Status, "Due Date", "PDC Production Bin";
        }
    }
}
