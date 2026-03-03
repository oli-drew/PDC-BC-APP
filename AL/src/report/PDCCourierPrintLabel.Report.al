report 50060 "PDC Courier Print Label"
{
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './src/report/Layouts/PDC Courier Print Label.docx';
    //UseRequestPage = false;
    UseSystemPrinter = true;
    //UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(PrinLoop; Integer)
        {
            DataItemTableView = where(Number = const(1));
            column(Number; Number) { }
        }
    }

    // trigger OnPreReport()
    // begin
    //     UploadIntoStream('', InStr);
    //     PDCCourierEvents.SetPDFBlob(InStr);
    //     PDCCourierEvents.SetRepId(Report::"PDC Courier Print Label");
    //     BindSubscription(PDCCourierEvents);
    // end;

    // trigger OnPostReport()
    // begin
    //     PDCCourierEvents.Clean();
    //     UnbindSubscription(PDCCourierEvents);
    // end;

    // var
    //     PDCCourierEvents: Codeunit "PDC Courier Events";
    //     InStr: InStream;
}