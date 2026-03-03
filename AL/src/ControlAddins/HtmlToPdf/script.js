var controlAddIn = {
    ConvertHtmlToPdf: function (htmlContent) {
        this.ConvertHtmlToPdfWithOptions(htmlContent, '{}');
    },

    ConvertHtmlToPdfWithOptions: function (htmlContent, optionsJson) {
        // Use iframe for isolated rendering
        var iframe = document.createElement('iframe');
        iframe.style.position = 'fixed';
        iframe.style.left = '0';
        iframe.style.top = '0';
        iframe.style.width = '450px';
        iframe.style.height = '450px';
        iframe.style.border = 'none';
        iframe.style.zIndex = '-1';
        iframe.style.opacity = '0.01';
        document.body.appendChild(iframe);

        var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
        iframeDoc.open();
        iframeDoc.write('<!DOCTYPE html><html><head><style>body{margin:0;padding:0;background:white;}</style></head><body>' + htmlContent + '</body></html>');
        iframeDoc.close();

        // Wait for iframe to fully render
        iframe.onload = function() {
            setTimeout(function() {
                var body = iframeDoc.body;
                var width = Math.max(body.scrollWidth, 400);
                var height = Math.max(body.scrollHeight, 400);

                var options = {
                    margin: 0,
                    filename: 'label.pdf',
                    image: { type: 'jpeg', quality: 0.92 },
                    html2canvas: {
                        scale: 2,  // Higher resolution for print quality
                        useCORS: true,
                        logging: false,
                        allowTaint: true,
                        backgroundColor: '#ffffff',
                        width: width,
                        height: height,
                        imageTimeout: 5000
                    },
                    jsPDF: {
                        unit: 'px',
                        format: [width, height],
                        orientation: 'portrait',
                        hotfixes: ['px_scaling'],
                        compress: true
                    }
                };

                html2pdf()
                    .set(options)
                    .from(body)
                    .outputPdf('datauristring')
                    .then(function (pdfDataUri) {
                        document.body.removeChild(iframe);
                        var base64 = pdfDataUri.split(',')[1];
                        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('PdfReady', [base64]);
                    })
                    .catch(function (error) {
                        document.body.removeChild(iframe);
                        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ConversionFailed', [error.toString()]);
                    });
            }, 300);
        };

        // Trigger load event manually since we used document.write
        setTimeout(function() {
            if (iframe.onload) iframe.onload();
        }, 200);
    }
};

function ConvertHtmlToPdf(htmlContent) {
    controlAddIn.ConvertHtmlToPdf(htmlContent);
}

function ConvertHtmlToPdfWithOptions(htmlContent, optionsJson) {
    controlAddIn.ConvertHtmlToPdfWithOptions(htmlContent, optionsJson);
}