
/// <summary>
/// XmlPort PDC Portal Sales Inv Head L (ID 50025).
/// </summary>
XmlPort 50025 "PDC Portal Sales Inv Head L"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(noFilter)
                {
                    MinOccurs = Zero;
                }
                textelement(branchFilter)
                {
                }
            }
            tableelement(paging; "PDC Portal List Paging")
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                XmlName = 'paging';
                UseTemporary = true;
                fieldelement(pageIndex; Paging."Page Index")
                {
                }
                fieldelement(noOfPages; Paging."No of Pages")
                {
                }
                fieldelement(noOfRecords; Paging."No of Records")
                {
                }
            }
            tableelement(salesinvoiceheader; "Sales Invoice Header")
            {
                MinOccurs = Zero;
                XmlName = 'salesInvoiceHeader';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; SalesInvoiceHeader."No.")
                {
                }
            }
        }
    }

}

