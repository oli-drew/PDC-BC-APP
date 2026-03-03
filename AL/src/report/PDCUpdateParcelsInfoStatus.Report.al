/// <summary>
/// Report PDC Update Parcels Info Status (ID 50016).
/// </summary>
Report 50016 "PDC Update Parcels Info Status"
{
    Caption = 'Update Parcels Info Status';
    ProcessingOnly = true;
    dataset
    {
        dataitem("Parcels Info"; "PDC Parcels Info")
        {
            DataItemTableView = sorting(Status, "Delivered Date", "Stop Tracking", Deleted) where("Stop Tracking" = const(false), Status = filter(New | "In transit" | Exception), Deleted = const(false));
            RequestFilterFields = ConsignmentNumber, ParcelNumber;
            CalcFields = "Shipment Date";

            trigger OnPreDataItem()
            begin
                if format(FromDateForm) <> '' then
                    setfilter("Shipment Date", '%1..', CalcDate(FromDateForm, WorkDate()));
            end;

            trigger OnAfterGetRecord()
            var
                CustomizedCalendarChange: Record "Customized Calendar Change";
                CalendarManagement: Codeunit "Calendar Management";
                checkDate: Date;
                i: Integer;
                NonWorking: Boolean;
            begin
                ParcelsInfo2.Get(ConsignmentNumber, ParcelNumber);
                ParcelsInfo2.SetRange(ConsignmentNumber, ParcelsInfo2.ConsignmentNumber);
                ParcelsInfo2.SetRange("Stop Tracking", false);
                ParcelsInfo2.SetRange(Deleted, false);
                ParcelsInfo2.SetFilter(Status, '%1|%2|%3', ParcelsInfo2.Status::New, ParcelsInfo2.Status::"In transit", ParcelsInfo2.Status::Exception);
                ParcelsInfo2.FindFirst();
                if ParcelsInfo2.ParcelNumber = "Parcels Info".ParcelNumber then //first open record in ConsignmentNumber
                    ParcelsInfo2.TrackingRequest(ParcelsInfo2.ConsignmentNumber);

                ParcelsInfo2.Get(ConsignmentNumber, ParcelNumber); //reload
                if (ParcelsInfo2.Status in [ParcelsInfo2.Status::New, ParcelsInfo2.Status::"In transit"]) and
                  (not ParcelsInfo2."Stop Tracking") and
                  (not ParcelsInfo2.Deleted) and
                  (ParcelsInfo2."Shipment Date" <> 0D) then begin
                    checkDate := ParcelsInfo2."Shipment Date";
                    i := 0;
                    repeat
                        checkDate := checkDate + 1;
                        NonWorking := CalendarManagement.IsNonworkingDay(checkDate, CustomizedCalendarChange);
                        if NonWorking then
                            i += 1;
                    until i = 3;

                    if checkDate < WorkDate() then begin
                        ParcelsInfo2.Status := ParcelsInfo2.Status::Exception;
                        ParcelsInfo2.Modify();
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromDateFormFld; FromDateForm)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date Calculation';
                        ToolTip = 'From Date Calculation';
                    }
                }
            }
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
        FromDateForm: dateformula;
}

