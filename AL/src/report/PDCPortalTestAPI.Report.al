report 50062 "PDC Portal Test API"
{
    ApplicationArea = All;
    Caption = 'PDC Portal Test API';
    UsageCategory = Tasks;
    ProcessingOnly = true;


    dataset
    {
        dataitem(integer; "integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                if Command = '' then
                    Command := '{}';
                if InputTxt = '' then
                    InputTxt := '{}';
                message(PDCPortalsWebService.Call2(UserId, 'CUSTP', Path, Command, InputTxt));
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(UserIdFld; UserId)
                    {
                        ApplicationArea = All;
                        Caption = 'User ID';
                        ToolTip = 'Enter the User ID for the PDC Portal.';
                        TableRelation = "PDC Portal User".Id;
                    }
                    field(PathFld; Path)
                    {
                        ApplicationArea = All;
                        Caption = 'Path';
                        ToolTip = 'Enter the path for the PDC Portal API.';
                    }
                    field(CommandFld; Command)
                    {
                        ApplicationArea = All;
                        Caption = 'Command';
                        ToolTip = 'Enter the command for the PDC Portal API.';
                    }
                    field(InputTxtFld; InputTxt)
                    {
                        ApplicationArea = All;
                        Caption = 'Input Text';
                        ToolTip = 'Enter the input text for the PDC Portal API.';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        PDCPortalsWebService: Codeunit "PDC Portals Web Service";
        UserId: Text[250];
        Path: Text[250];
        Command: Text[250];
        InputTxt: Text;

}
