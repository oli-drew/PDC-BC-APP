controladdin "HTML to PDF Converter"
{
    RequestedHeight = 1;
    RequestedWidth = 1;
    HorizontalStretch = false;
    VerticalStretch = false;

    Scripts =
        'https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js',
        'src/ControlAddins/HtmlToPdf/script.js';

    StartupScript = 'src/ControlAddins/HtmlToPdf/startup.js';

    event ControlReady();
    event PdfReady(Base64Pdf: Text);
    event ConversionFailed(ErrorMessage: Text);

    procedure ConvertHtmlToPdf(HtmlContent: Text);
    procedure ConvertHtmlToPdfWithOptions(HtmlContent: Text; OptionsJson: Text);
}