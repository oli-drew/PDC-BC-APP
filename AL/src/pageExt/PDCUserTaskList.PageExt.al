/// <summary>
/// PageExtension PDCUserTaskList (ID 50083) extends Record User Task List.
/// </summary>
pageextension 50084 PDCUserTaskList extends "User Task List"
{
    layout
    {
        modify("Created DateTime")
        {
            Visible = true;
        }
        addafter(Title)
        {
            field(PDCTaskDescription; TaskDescription)
            {
                ApplicationArea = All;
                Caption = 'Task Description';
                ToolTip = 'Specifies what the task is about.';
                Editable = false;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        TaskDescription := Rec.GetDescription();
    end;

    var
        TaskDescription: Text;

}
