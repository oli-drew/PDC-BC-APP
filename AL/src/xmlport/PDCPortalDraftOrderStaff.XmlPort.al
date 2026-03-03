/// <summary>
/// XmlPort PDC Portal Draft Order Staff (ID 50018).
/// </summary>
XmlPort 50018 "PDC Portal Draft Order Staff"
{
    Encoding = UTF8;

    schema
    {
        textelement(list)
        {
            textelement(filter)
            {
                textelement(noFilter)
                {
                }
            }
            tableelement(draftorderstaffline; "PDC Draft Order Staff Line")
            {
                MinOccurs = Zero;
                XmlName = 'staff';
                UseTemporary = true;
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(no; DraftOrderStaffLine."Staff ID")
                {
                }
                fieldelement(staffLineNo; DraftOrderStaffLine."Line No.")
                {
                }
                fieldelement(name; DraftOrderStaffLine."Staff Name")
                {
                }
                fieldelement(gender; DraftOrderStaffLine."Body Type/Gender")
                {
                }
                fieldelement(yourId; DraftOrderStaffLine."Wearer ID")
                {
                }
                fieldelement(branch; DraftOrderStaffLine."Branch Name")
                {
                }
                fieldelement(uniform; DraftOrderStaffLine."Wardrobe Name")
                {
                }
                textelement(contract)
                {
                }
                textelement(numberoflines)
                {
                    XmlName = 'numberOfLines';

                    trigger OnBeforePassVariable()
                    var
                        DraftOrderHdrDb: Record "PDC Draft Order Header";
                        DraftOrderItemLineDb: Record "PDC Draft Order Item Line";
                        ContractDB: Record "PDC Contract";
                    begin
                        numberOfLines := '0';
                        DraftOrderItemLineDb.Reset();
                        DraftOrderItemLineDb.SetRange("Document No.", noFilter);
                        DraftOrderItemLineDb.SetRange("Staff Line No.", DraftOrderStaffLine."Line No.");
                        DraftOrderItemLineDb.SetFilter(Quantity, '>%1', 0);
                        numberOfLines := Format(DraftOrderItemLineDb.Count());

                        clear(contract);
                        DraftOrderHdrDb.get(draftorderstaffline."Document No.");
                        if ContractDB.get(DraftOrderHdrDb."Sell-to Customer No.", draftorderstaffline."Contract ID") then
                            contract := ContractDB."Contract Code";
                    end;
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
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>
    /// <param name="DraftOrderHeaderDb">VAR Record "PDC Draft Order Header".</param>
    procedure FilterData(var PortalUser: Record "PDC Portal User"; var DraftOrderHeaderDb: Record "PDC Draft Order Header")
    var
        DraftOrderStaffLineDb: Record "PDC Draft Order Staff Line";
    begin
        DraftOrderStaffLine.Reset();
        DraftOrderStaffLine.DeleteAll();
        DraftOrderHeaderDb.SetRange("Document No.", noFilter);

        if not DraftOrderHeaderDb.FindFirst() then exit;

        DraftOrderStaffLineDb.Reset();
        DraftOrderStaffLineDb.SetRange("Document No.", noFilter);

        if not DraftOrderStaffLineDb.FindSet() then exit;

        repeat
            DraftOrderStaffLine.TransferFields(DraftOrderStaffLineDb);
            DraftOrderStaffLine.Insert();
        until DraftOrderStaffLineDb.Next() = 0;
    end;
}

