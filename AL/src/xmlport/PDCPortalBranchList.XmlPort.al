/// <summary>
/// XmlPort PDC Portal Branch List (ID 50010).
/// </summary>
XmlPort 50010 "PDC Portal Branch List"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            tableelement(Branch; "PDC Branch")
            {
                XmlName = 'branch';
                UseTemporary = true;
                SourceTableView = sorting("Presentation Order");

                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; Branch."Branch No.")
                {
                }
                fieldelement(name; Branch.Name)
                {
                }
                fieldelement(indentation; Branch.Indentation)
                {
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;


    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="BranchDb">VAR Record "PDC Branch".</param>
    procedure FilterData(var BranchDb: Record "PDC Branch")
    begin
        Branch.Reset();
        Branch.DeleteAll();

        if not BranchDb.FindSet() then exit;

        repeat
            Branch.TransferFields(BranchDb);
            Branch.Insert();
        until BranchDb.Next() = 0;
    end;
}

