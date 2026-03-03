/// <summary>
/// Report PDC Segment - Labels DN (ID 50007).
/// </summary>
Report 50007 "PDC Segment - Labels DN"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/SegmentLabelsDN.rdlc';

    Caption = 'Segment - Labels';

    dataset
    {
        dataitem(Header; "Segment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            dataitem(Line; "Segment Line")
            {
                DataItemLink = "Segment No." = field("No.");
                DataItemTableView = sorting("Segment No.", "Line No.");

                column(Cntr; Cntr)
                {
                }
                column(LabelText1; LabelText[1])
                {
                }
                column(LabelText2; LabelText[2])
                {
                }
                column(LabelText3; LabelText[3])
                {
                }
                column(LabelText4; LabelText[4])
                {
                }
                column(LabelText5; LabelText[5])
                {
                }
                column(LabelText6; LabelText[6])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Contact.Get(Line."Contact No.");

                    Clear(LabelText);
                    i := 0;
                    if (Contact."Company Name") <> '' then begin
                        i += 1;
                        LabelText[i] := Contact."Company Name";
                        ToPrint := true;
                    end;
                    if (Contact.Name + Contact."Name 2") <> '' then begin
                        i += 1;
                        LabelText[i] := Contact.Name + Contact."Name 2";
                        ToPrint := true;

                        if OrgLevel.Get(Contact."Organizational Level Code") then
                            LabelText[i] += ', ' + OrgLevel.Description;
                    end;
                    if (Contact.Address) <> '' then begin
                        i += 1;
                        LabelText[i] := Contact.Address;
                        ToPrint := true;
                    end;
                    if (Contact."Address 2") <> '' then begin
                        i += 1;
                        LabelText[i] := Contact."Address 2";
                        ToPrint := true;
                    end;
                    if (Contact.City <> '') or (Contact.County <> '') then begin
                        i += 1;
                        if (Contact.City <> '') then
                            LabelText[i] := Contact.City;
                        if (Contact.County <> '') then begin
                            if LabelText[i] <> '' then LabelText[i] += ', ';
                            LabelText[i] += Contact.County;
                        end;
                        ToPrint := true;
                    end;
                    if (Contact."Post Code") <> '' then begin
                        i += 1;
                        LabelText[i] := Contact."Post Code";
                        ToPrint := true;
                    end;

                    if not ToPrint then
                        CurrReport.Skip();

                    Cntr += 1;
                end;
            }
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
        Contact: Record Contact;
        OrgLevel: Record "Organizational Level";
        LabelText: array[6] of Text;
        i: Integer;
        ToPrint: Boolean;
        Cntr: Integer;
}

