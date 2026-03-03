/// <summary>
/// XmlPort PDC Portal User Role (ID 50051).
/// </summary>
XmlPort 50051 "PDC Portal User Role"
{
    //Old No. 9062299

    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/nav-portal-user-role';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(NavRoleList)
        {
            MaxOccurs = Once;
            MinOccurs = Once;
            tableelement("PDC Portal User Role"; "PDC Portal User Role")
            {
                MinOccurs = Zero;
                XmlName = 'NavRole';
                fieldelement(RoleCode; "PDC Portal User Role"."User Role Code")
                {
                }
            }
        }
    }
}

