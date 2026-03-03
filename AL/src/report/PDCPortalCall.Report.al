/// <summary>
/// Report PDCFix (ID 50099).
/// </summary>
Report 50098 PDCPortalCall
{
    Caption = 'PDC Portal Call';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = CONST(1));
            trigger OnAfterGetRecord()
            var
                PDCPortalsWebService: Codeunit "PDC Portals Web Service";
            begin
                message(PDCPortalsWebService.Call2(UserId, PortalName, Path, Command, InputTxt));
            end;
        }
    }
    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(UserId; UserId)
                    {
                        ApplicationArea = All;
                        Caption = 'User Id';
                    }
                    field(PortalName; PortalName)
                    {
                        ApplicationArea = All;
                        Caption = 'Portal Name';
                    }
                    field(Path; Path)
                    {
                        ApplicationArea = All;
                        Caption = 'Path';
                    }
                    field(Command; Command)
                    {
                        ApplicationArea = All;
                        Caption = 'Command';
                    }
                    field(InputTxt; InputTxt)
                    {
                        ApplicationArea = All;
                        Caption = 'InputTxt';
                        ToolTip = 'InputTxt';
                        MultiLine = true;
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        UserId: Text[250];
        PortalName: Text[250];
        Path: Text[250];
        Command: Text[250];
        InputTxt: Text;

}