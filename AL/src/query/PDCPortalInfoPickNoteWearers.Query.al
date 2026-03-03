/// <summary>
/// Query PDC PortalInfo PickNoteWearers (ID 50009).
/// </summary>
query 50009 "PDC PortalInfo PickNoteWearers"
{
    Caption = 'Count Pick Note wearers';

    elements
    {
        dataitem(Header; "Warehouse Activity Header")
        {
            DataItemTableFilter = Type = const("Invt. Pick");
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
                column(Wearer_ID; "PDC Wearer ID")
                {
                }
                column("Count_")
                {
                    Method = Count;
                }
            }
        }
    }
}

