/// <summary>
/// Report PDC Stop Tracking Parcel (ID 50035).
/// </summary>
Report 50035 "PDC Stop Tracking Parcel"
{
    // 25.01.2020 JEMEL J.Jemeljanovs #3206 * Created

    Caption = 'Stop Tracking Parcel';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Parcels Info"; "PDC Parcels Info")
        {

            trigger OnAfterGetRecord()
            begin
                ParcelsInfo2.Get(ConsignmentNumber, ParcelNumber);
                ParcelsInfo2."Stop Tracking" := true;
                ParcelsInfo2.modify();
            end;

            trigger OnPreDataItem()
            begin
                SetRange(ErrorText, 'PARCEL NOT FOUND');
                SetRange("Stop Tracking", false);
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

    var
        ParcelsInfo2: Record "PDC Parcels Info";
}

