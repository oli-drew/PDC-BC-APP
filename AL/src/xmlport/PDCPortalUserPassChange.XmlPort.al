/// <summary>
/// XmlPort PDC Portal User Pass Change (ID 50063).
/// </summary>
XmlPort 50063 "PDC Portal User Pass Change"
{
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement("<data>")
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'data';
            textelement(input)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(oldpassword)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'oldPassword';
                }
                textelement(newpassword)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'newPassword';
                }
                textelement(newpassword2)
                {
                    MaxOccurs = Once;
                    MinOccurs = Once;
                    XmlName = 'newPassword2';
                }

                trigger OnBeforePassVariable()
                begin
                    currXMLport.Skip();
                end;
            }
            textelement(output)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
            }
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

    /// <summary>
    /// UpdateUserPassword.
    /// </summary>
    /// <param name="NavPortalUser">VAR Record "PDC Portal User".</param>
    procedure UpdateUserPassword(var NavPortalUser: Record "PDC Portal User")
    begin
        NavPortalUser.ChangePassword(oldPassword, newPassword, newPassword2, true);
        NavPortalUser.Modify();
    end;
}

