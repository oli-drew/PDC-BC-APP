/// <summary>
/// Report PDC Contact - Labels DN (ID 50008).
/// </summary>
Report 50008 "PDC Contact - Labels DN"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/ContactLabelsDN.rdlc';
    Caption = 'Contact - Labels';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Contact; Contact)
        {
            RequestFilterFields = "No.", Name, Type, "Salesperson Code", "Post Code", "Territory Code", "Country/Region Code";
            column(ContAddr_1__1_; ContAddr[1] [1])
            {
            }
            column(ContAddr_1__2_; ContAddr[1] [2])
            {
            }
            column(ContAddr_1__3_; ContAddr[1] [3])
            {
            }
            column(ContAddr_1__4_; ContAddr[1] [4])
            {
            }
            column(ContAddr_1__5_; ContAddr[1] [5])
            {
            }
            column(ContAddr_1__6_; ContAddr[1] [6])
            {
            }
            column(ContAddr_2__1_; ContAddr[2] [1])
            {
            }
            column(ContAddr_2__2_; ContAddr[2] [2])
            {
            }
            column(ContAddr_2__3_; ContAddr[2] [3])
            {
            }
            column(ContAddr_2__4_; ContAddr[2] [4])
            {
            }
            column(ContAddr_2__5_; ContAddr[2] [5])
            {
            }
            column(ContAddr_2__6_; ContAddr[2] [6])
            {
            }
            column(ContAddr_3__1_; ContAddr[3] [1])
            {
            }
            column(ContAddr_3__2_; ContAddr[3] [2])
            {
            }
            column(ContAddr_3__3_; ContAddr[3] [3])
            {
            }
            column(ContAddr_3__4_; ContAddr[3] [4])
            {
            }
            column(ContAddr_3__5_; ContAddr[3] [5])
            {
            }
            column(ContAddr_3__6_; ContAddr[3] [6])
            {
            }
            column(ContAddr_1__7_; ContAddr[1] [7])
            {
            }
            column(ContAddr_1__8_; ContAddr[1] [8])
            {
            }
            column(ContAddr_2__7_; ContAddr[2] [7])
            {
            }
            column(ContAddr_2__8_; ContAddr[2] [8])
            {
            }
            column(ContAddr_3__7_; ContAddr[3] [7])
            {
            }
            column(ContAddr_3__8_; ContAddr[3] [8])
            {
            }
            column(ShowBody1; (ColumnNo = 0) and (LabelFormat = Labelformat::"36 x 1265 mm (1 column)"))
            {
            }
            column(GroupNo1; GroupNo)
            {
            }
            column(ShowBody2; (ColumnNo = 0) and (LabelFormat = Labelformat::"37 x 1265 mm (1 column)"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                ColumnNo := ColumnNo + 1;
                FormatAddr.ContactAddr(ContAddr[ColumnNo], Contact);
                if RecordNo = NoOfRecords then begin
                    for i := ColumnNo + 1 to NoOfColumns do
                        Clear(ContAddr[i]);
                    ColumnNo := 0;
                end else
                    if ColumnNo = NoOfColumns then
                        ColumnNo := 0;

                if ColumnNo = 0 then begin
                    if Counter = RecPerPageNum then begin
                        GroupNo := GroupNo + 1;
                        Counter := 0;
                    end;
                    Counter := Counter + 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                case LabelFormat of
                    Labelformat::"36 x 1265 mm (1 column)", Labelformat::"37 x 1265 mm (1 column)":
                        NoOfColumns := 1;
                end;
                NoOfRecords := Count;
                RecordNo := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LabelFormatFld; LabelFormat)
                    {
                        ApplicationArea = All;
                        Caption = 'Format';
                        ToolTip = 'Format';
                        OptionCaption = '36 x 1265 mm (1 column),37 x 1265 mm (1 column)';
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

    trigger OnPreReport()
    begin
        GroupNo := 1;
        RecPerPageNum := 1;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        LabelFormat: Option "36 x 1265 mm (1 column)","37 x 1265 mm (1 column)";
        ContAddr: array[3, 8] of Text[50];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        GroupNo: Integer;
        Counter: Integer;
        RecPerPageNum: Integer;

    /// <summary>
    /// InitializeRequest.
    /// </summary>
    /// <param name="LabelFormatFrom">Option.</param>
    procedure InitializeRequest(LabelFormatFrom: Option)
    begin
        LabelFormat := LabelFormatFrom;
    end;
}

