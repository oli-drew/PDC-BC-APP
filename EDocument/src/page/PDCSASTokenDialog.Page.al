/// <summary>
/// Page PDC SAS Token Dialog (ID 50300).
/// Dialog for entering Azure SAS token.
/// </summary>
page 50300 "PDC SAS Token Dialog"
{
    Caption = 'Enter SAS Token';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'SAS Token';

                field(SASTokenField; SASTokenValue)
                {
                    ApplicationArea = All;
                    Caption = 'SAS Token';
                    ToolTip = 'Enter the Azure SAS token for authentication. The token will be stored securely.';
                    ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        if SASTokenValue = '' then
                            Error(SASTokenRequiredErr);
                    end;
                }
            }
        }
    }

    var
        EDocumentService: Record "E-Document Service";
        SASTokenValue: Text[1024];
        SASTokenRequiredErr: Label 'SAS Token is required.';

    procedure SetEDocumentService(var EDocService: Record "E-Document Service")
    begin
        EDocumentService := EDocService;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if SASTokenValue = '' then
                Error(SASTokenRequiredErr);

            EDocumentService.SetSASToken(SASTokenValue);
            EDocumentService.Modify(true);
        end;
        exit(true);
    end;
}
