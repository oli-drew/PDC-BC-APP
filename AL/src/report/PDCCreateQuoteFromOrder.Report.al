/// <summary>
/// Report PDC Create Quote From Order (ID 50006).
/// </summary>
Report 50006 "PDC Create Quote From Order"
{
    Caption = 'Create Quote From Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") order(ascending) where("Document Type" = const(Order));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                TestField(Status, Status::Open);

                QuoteHeader.Init();
                QuoteHeader."Document Type" := QuoteHeader."document type"::Quote;
                QuoteHeader.Insert(true);
                DocNo := QuoteHeader."No.";

                QuoteHeader.Get(QuoteHeader."document type"::Quote, DocNo);
                QuoteHeader.TransferFields("Sales Header", false);
                QuoteHeader."Document Type" := QuoteHeader."document type"::Quote;
                QuoteHeader."No." := DocNo;
                QuoteHeader.Modify();

                OrdLine.SetRange("Document Type", "Sales Header"."Document Type");
                OrdLine.SetRange("Document No.", "Sales Header"."No.");
                if OrdLine.Findset() then
                    repeat
                        QuoteLine.Init();
                        QuoteLine := OrdLine;
                        QuoteLine."Document Type" := QuoteHeader."Document Type";
                        QuoteLine."Document No." := QuoteHeader."No.";
                        QuoteLine.Insert();
                    until OrdLine.next() = 0;

                OrderHeader.Get("Document Type", "No.");
                OrderHeader.Delete(true);
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
        OrderHeader: Record "Sales Header";
        QuoteHeader: Record "Sales Header";
        QuoteLine: Record "Sales Line";
        OrdLine: Record "Sales Line";
        DocNo: Code[20];
}

