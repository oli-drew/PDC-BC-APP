page 50020 "PDC Label Printer Hidden"
{
    PageType = Card;
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            usercontrol(HtmlToPdfConverter; "HTML to PDF Converter")
            {
                ApplicationArea = All;

                trigger ControlReady()
                begin
                    if PendingHtml <> '' then
                        CurrPage.HtmlToPdfConverter.ConvertHtmlToPdf(PendingHtml);
                end;

                trigger PdfReady(Base64Pdf: Text)
                begin
                    PendingBase64Pdf := Base64Pdf;
                    CurrPage.Close();
                end;

                trigger ConversionFailed(ErrorMessage: Text)
                begin
                    Error('PDF conversion failed: %1', ErrorMessage);
                end;
            }
        }
    }

    var
        PendingHtml: Text;
        PendingBase64Pdf: Text;

    procedure SetHtmlContent(Html: Text)
    begin
        PendingHtml := Html;
    end;

    procedure GetPDFContent(var Base64Pdf: Text)
    begin
        Base64Pdf := PendingBase64Pdf;
    end;
}