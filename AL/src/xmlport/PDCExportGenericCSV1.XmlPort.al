/// <summary>
/// XmlPort PDC Export Generic CSV 1 (ID 50007).
/// </summary>
XmlPort 50007 "PDC Export Generic CSV 1"
{

    Caption = 'Export Generic CSV';
    Direction = Export;
    FieldDelimiter = '<None>';
    Format = VariableText;
    TextEncoding = WINDOWS;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            MinOccurs = Zero;
            tableelement("Data Exch. Field"; "Data Exch. Field")
            {
                XmlName = 'PostExchField';
                textelement(ColumnX)
                {
                    MinOccurs = Zero;
                    Unbound = true;

                    trigger OnBeforePassVariable()
                    begin
                        if QuitLoop then
                            currXMLport.BreakUnbound();

                        if "Data Exch. Field"."Line No." <> LastLineNo then begin
                            if "Data Exch. Field"."Line No." <> LastLineNo + 1 then
                                ErrorText += LinesNotSequentialErr
                            else begin
                                LastLineNo := "Data Exch. Field"."Line No.";
                                PrevColumnNo := 0;
                                "Data Exch. Field".Next(-1);
                                Window.Update(1, LastLineNo);
                            end;
                            currXMLport.BreakUnbound();
                        end;

                        CheckColumnSequence();
                        ColumnX := "Data Exch. Field".Value;

                        if "Data Exch. Field".next() = 0 then
                            QuitLoop := true;
                    end;
                }
            }
        }
    }


    trigger OnInitXmlPort()
    begin
        Window.Open(ProgressMsg);
    end;

    trigger OnPostXmlPort()
    begin
        if ErrorText <> '' then
            Error(ErrorText);

        Window.Close();

        if DataExch.GET(DataExchEntryNo) then
            if DataExchDef.GET(DataExch."Data Exch. Def Code") then
                currXMLport.FILENAME := DataExchDef.Name + '.csv';
    end;

    trigger OnPreXmlPort()
    begin
        InitializeGlobals();
    end;

    var
        DataExchDef: Record "Data Exch. Def";
        DataExch: Record "Data Exch.";
        Window: Dialog;
        ErrorText: Text;
        DataExchEntryNo: Integer;
        LastLineNo: Integer;
        PrevColumnNo: Integer;
        QuitLoop: Boolean;
        ColumnsNotSequentialErr: label 'The data to be exported is not structured correctly. The columns in the dataset must be sequential.';
        LinesNotSequentialErr: label 'The data to be exported is not structured correctly. The lines in the dataset must be sequential.';
        ProgressMsg: label 'Exporting line no. #1######', comment = '%1=progress';

    local procedure InitializeGlobals()
    begin
        DataExchEntryNo := "Data Exch. Field".GetRangeMin("Data Exch. No.");
        LastLineNo := 1;
        PrevColumnNo := 0;
        QuitLoop := false;
    end;

    /// <summary>
    /// CheckColumnSequence.
    /// </summary>
    procedure CheckColumnSequence()
    begin
        if "Data Exch. Field"."Column No." <> PrevColumnNo + 1 then begin
            ErrorText += ColumnsNotSequentialErr;
            currXMLport.BreakUnbound();
        end;

        PrevColumnNo := "Data Exch. Field"."Column No.";
    end;
}

