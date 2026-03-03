/// <summary>
/// Page PDC Email Management Addresses (ID 50009).
/// </summary>
page 50009 "PDC Email Management Addresses"
{
    Caption = 'Email Management Addresses';
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "PDC Email Management Setup";
    SourceTableView = sorting(Code, Type, "Line No.")
                      where(Type = const(Address));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AddressType; Rec."Address Type")
                {
                    ToolTip = 'Address Type';
                    ApplicationArea = All;
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ToolTip = 'Email Address';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

