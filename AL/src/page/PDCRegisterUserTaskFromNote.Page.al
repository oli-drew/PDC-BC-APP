/// <summary>
/// Page PDCRegisterUserTaskFromNote (ID 50004).
/// </summary>
page 50004 PDCRegisterUserTaskFromNote
{
    ApplicationArea = All;
    Caption = 'Register User Task From Note';
    PageType = ConfirmationDialog;
    SourceTable = "Record Link";

    layout
    {
        area(content)
        {

            label(Control19)
            {
                ApplicationArea = All;
                CaptionClass = Format(ConfirmTxt);
                Editable = false;
                ShowCaption = false;
            }
            field(MultiLineTextControl; MultiLineTextControl)
            {
                ApplicationArea = All;
                Caption = 'Task Description';
                MultiLine = true;
                ToolTip = 'Specifies what the task is about.';
                Editable = false;
            }
            field(UserNameFld; UserName)
            {
                Caption = 'User';
                ToolTip = 'User';
                ApplicationArea = All;

                trigger OnValidate()
                var
                    UserSelection: Codeunit "User Selection";
                begin
                    UserSelection.ValidateUserName(UserName);
                end;

                trigger OnDrillDown()
                var
                    User: Record User;
                begin
                    user.setrange(State, User.State::Enabled);
                    if page.RunModal(page::"User Lookup", User) in [Action::OK, Action::LookupOK] then
                        UserName := User."User Name";
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MultiLineTextControl := GetDescription();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::Yes then
            PDCFunctions.RegisterUserTaskFromNote(Rec, UserName);
    end;

    var
        PDCFunctions: Codeunit "PDC Functions";
        MultiLineTextControl: Text;
        UserName: code[50];
        ConfirmTxt: label 'Do you want to register task to user?';

    internal procedure GetResult(): Code[50];
    begin
        exit(UserName);
    end;

    local procedure GetDescription(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        DescriptionText: Text;
        charInt: Integer;
    begin
        TempBlob.FromRecord(Rec, Rec.FieldNo(Note));
        TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
        DescriptionText := TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator());
        charInt := DescriptionText[1];
        if charInt in [1 .. 10] then
            DescriptionText := CopyStr(DescriptionText, 2);
        exit(DescriptionText);
    end;
}
