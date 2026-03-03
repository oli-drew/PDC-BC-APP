/// <summary>
/// Page PDC Nav Portal User Password (ID 50091).
/// </summary>
page 50091 "PDC Nav Portal User Password"
{
    Caption = 'Nav Portal User Password';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;
    SourceTable = "PDC Portal User";

    layout
    {
        area(content)
        {
            field(UserName; Rec."User Name")
            {
                ApplicationArea = All;
                ToolTip = 'User Name';
                Editable = false;
                Enabled = false;
            }
            field(NewPassword; NewPassword)
            {
                ApplicationArea = All;
                Caption = 'New Password';
                ToolTip = 'New Password';
                ExtendedDatatype = Masked;
            }
            field(NewPassword2; NewPassword2)
            {
                ApplicationArea = All;
                Caption = 'Retype New Password';
                ToolTip = 'Retype New Password';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if (CloseAction in [Action::OK, Action::LookupOK]) then begin
            if (NewPassword <> NewPassword2) then
                Error(DiffPwdErrLbl);
            if (NewPassword = '') then
                Error(EmptyPwdErrLbl);
        end;
        exit(true);
    end;

    var
        NewPassword: Text[250];
        NewPassword2: Text[250];
        DiffPwdErrLbl: label 'Passwords must match', Comment = 'Passwords must match';
        EmptyPwdErrLbl: label 'Password cannot be empty', Comment = 'Password cannot be empty';

    /// <summary>
    /// ReturnPassword.
    /// </summary>
    /// <returns>Return value of type Text[250].</returns>
    procedure ReturnPassword(): Text[250]
    begin
        exit(NewPassword);
    end;
}

