/// <summary>
/// Query PDC Portal Info PickNotes (ID 50002) calculate Inventory Picks
/// </summary>
query 50002 "PDC Portal Info PickNotes"
{
    Caption = 'Count Inventory Picks';

    elements
    {
        dataitem(Header; "Warehouse Activity Header")
        {
            DataItemTableFilter = Type = const("Invt. Pick"), "Source Document" = const("Sales Order");
            filter(PostingDateFilter; "Posting Date")
            {
            }
            filter(SalesDocCreatedAt; "PDC Sales Doc. Created At")
            {
            }
            filter(DateOfLastPrinting; "Date of Last Printing")
            {
            }
            filter(TimeOfLastPrinting; "Time of Last Printing")
            {
            }
            filter(DateOfFirstPrinting; "PDC Date of First Printing")
            {
            }
            filter(TimeOfFirstPrinting; "PDC Time of First Printing")
            {
            }
            column(DocNo; "No.")
            {
            }
            dataitem(Warehouse_Activity_Line; "Warehouse Activity Line")
            {
                DataItemLink = "Activity Type" = Header.Type, "No." = Header."No.";
                column(QuantitySum; Quantity)
                {
                    Method = Sum;
                }
                column(AmtSum; "PDC SO Line Amount")
                {
                    Method = Sum;
                }
            }
        }
    }
}

