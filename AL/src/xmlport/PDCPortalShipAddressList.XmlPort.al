/// <summary>
/// XmlPort PDC Portal Ship Address List (ID 50024).
/// </summary>
xmlport 50024 "PDC Portal Ship Address List"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                MinOccurs = Zero;
                textelement(searchTerm)
                {
                    MinOccurs = Zero;
                }
            }
            tableelement(Customer; Customer)
            {
                MinOccurs = Zero;
                XmlName = 'myAddress';
                fieldelement(contact; Customer.Contact)
                {
                }
                fieldelement(name; Customer.Name)
                {
                }
                fieldelement(address; Customer.Address)
                {
                }
                fieldelement(address2; Customer."Address 2")
                {
                }
                fieldelement(city; Customer.City)
                {
                }
                fieldelement(county; Customer.County)
                {
                }
                fieldelement(postCode; Customer."Post Code")
                {
                }
                fieldelement(country; Customer."Country/Region Code")
                {
                }

                trigger OnAfterGetRecord()
                var
                    STA: Record "Ship-to Address";
                begin
                    if STA.Get(Customer."No.", UserShipToCode) then begin
                        Customer.Contact := STA.Contact;
                        Customer.Name := STA.Name;
                        Customer.Address := STA.Address;
                        Customer."Address 2" := STA."Address 2";
                        Customer.City := STA.City;
                        Customer.County := STA.County;
                        Customer."Post Code" := STA."Post Code";
                        Customer."Country/Region Code" := STA."Country/Region Code";
                    end;
                end;
            }
            tableelement(ShipToAddress; "Ship-to Address")
            {
                MinOccurs = Zero;
                XmlName = 'savedAddresses';
                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                fieldelement(code; ShipToAddress.Code)
                {
                }
                fieldelement(contact; ShipToAddress.Contact)
                {
                    MinOccurs = Zero;
                }
                fieldelement(name; ShipToAddress.Name)
                {
                }
                fieldelement(address; ShipToAddress.Address)
                {
                }
                fieldelement(address2; ShipToAddress."Address 2")
                {
                }
                fieldelement(city; ShipToAddress.City)
                {
                }
                fieldelement(county; ShipToAddress.County)
                {
                }
                fieldelement(postCode; ShipToAddress."Post Code")
                {
                }
                fieldelement(country; ShipToAddress."Country/Region Code")
                {
                }
                fieldelement(homeaddress; ShipToAddress."PDC Is Home Ship-To Address")
                {
                }
                fieldelement(email; ShipToAddress."E-Mail")
                {
                    MinOccurs = Zero;
                }
                fieldelement(mobileNo; ShipToAddress."Phone No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(showOnPortal; ShipToAddress."PDC Show On Portal")
                {
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
    end;

    var
        UserShipToCode: Code[10];
        FilterPerUser: Boolean;
        FilterPerBranch: Boolean;

    /// <summary>
    /// FilterData.
    /// </summary>
    /// <param name="PortalUser">VAR Record "PDC Portal User".</param>    
    procedure FilterData(var PortalUser: Record "PDC Portal User")
    var
        UserSTA: Record "PDC Portal User Ship-to Addrs";
        PortalMgt: Codeunit "PDC Portal Mgt";
        recRef: RecordRef;
        BranchFilter: Text;
    begin
        Customer.get(PortalUser."Customer No.");
        Customer.SetRecFilter();

        ShipToAddress.Reset();
        ShipToAddress.SetRange("Customer No.", PortalUser."Customer No.");
        ShipToAddress.setrange("PDC Show On Portal", true);
        if not ShipToAddress.FindSet() then exit;

        ShipToAddress.ClearMarks();
        if FilterPerUser then begin
            UserSTA.SetRange("Portal User ID", PortalUser.Id);
            UserSTA.SetRange("Customer No.", PortalUser."Customer No.");
            if UserSTA.FindSet() then
                repeat
                    if ShipToAddress.Get(UserSTA."Customer No.", UserSTA."Ship-to Code") then
                        ShipToAddress.Mark(true);
                until UserSTA.Next() = 0;
            ShipToAddress.MarkedOnly(true);
            if not ShipToAddress.FindSet() then exit;
        end;
        if FilterPerBranch then begin
            BranchFilter := PortalMgt.GetMyBranchesFilter(PortalUser);
            ShipToAddress.setfilter("PDC Branch No.", BranchFilter);
        end;

        if searchTerm <> '' then begin
            repeat
                recRef.GetTable(ShipToAddress);
                if Format(RecRef).ToLower().Contains(searchTerm.ToLower()) then
                    ShipToAddress.Mark(true)
                else
                    ShipToAddress.Mark(false);
            until ShipToAddress.Next() = 0;
            ShipToAddress.MarkedOnly(true);
            if not ShipToAddress.FindSet() then exit;
        end;

        UserShipToCode := PortalUser."Default Ship-to Code";
    end;


    /// <summary>
    /// SetFilterPerUser.
    /// </summary>
    procedure SetFilterPerUser()
    begin
        FilterPerUser := true;
    end;


    /// <summary>
    /// SetFilterPerBranch.
    /// </summary>
    procedure SetFilterPerBranch()
    begin
        FilterPerBranch := true;
    end;
}

