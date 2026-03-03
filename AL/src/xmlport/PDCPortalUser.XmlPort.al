/// <summary>
/// XmlPort PDC Portal User (ID 50050).
/// </summary>
XmlPort 50050 "PDC Portal User"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/nav-portal-user';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(NavUserList)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            tableelement("PDC Portal User"; "PDC Portal User")
            {
                MinOccurs = Zero;
                XmlName = 'NavUser';
                fieldelement(Id; "PDC Portal User".Id)
                {
                }
                fieldelement(UserName; "PDC Portal User"."User Name")
                {
                }
                fieldelement(Email; "PDC Portal User"."E-Mail")
                {
                }
                fieldelement(PhoneNo; "PDC Portal User"."Phone No.")
                {
                }
                fieldelement(PasswordHash; "PDC Portal User"."Password Hash")
                {
                }
            }
        }
    }
}

