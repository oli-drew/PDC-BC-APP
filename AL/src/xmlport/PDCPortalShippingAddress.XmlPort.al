/// <summary>
/// XmlPort PDC Portal Shipping Address (ID 50062).
/// </summary>
XmlPort 50062 "PDC Portal Shipping Address"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                textelement(f_code)
                {
                    XmlName = 'code';
                }
            }
            tableelement(shiptoaddress; "Ship-to Address")
            {
                XmlName = 'address';
                UseTemporary = true;
                fieldelement(code; ShipToAddress.Code)
                {
                    MinOccurs = Zero;
                }
                fieldelement(contact; ShipToAddress.Contact)
                {
                    MinOccurs = Zero;
                }
                fieldelement(name; ShipToAddress.Name)
                {
                }
                fieldelement(name2; ShipToAddress."Name 2")
                {
                    MinOccurs = Zero;
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
                }
                fieldelement(mobileNo; ShipToAddress."Phone No.")
                {
                }
                fieldelement(showOnPortal; ShipToAddress."PDC Show On Portal")
                {
                }
                fieldelement(branchNo; ShipToAddress."PDC Branch No.")
                {
                }
            }
        }
    }

    /// <summary>
    /// SaveData.
    /// </summary>
    /// <param name="NavPortalUser">Record "PDC Portal User".</param>
    procedure SaveData(NavPortalUser: Record "PDC Portal User")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ShipToAddressDb: Record "Ship-to Address";
        ShipToAddressDb2: Record "Ship-to Address";
        PDCPortalUserShipToAddrs: Record "PDC Portal User Ship-to Addrs";
        NoSeries: Codeunit "No. Series";
        tmpCode: Text;
        theCode: Code[20];
        counter: Integer;
        foundNewCode: Boolean;
    begin
        ShipToAddress.FindFirst();

        ShipToAddress.TestField(Name);
        ShipToAddress.TestField(Address);
        ShipToAddress.TestField(City);
        ShipToAddress.TestField("Post Code");

        counter := 0;
        foundNewCode := false;

        SalesSetup.get();
        SalesSetup.TestField("PDC Ship-to Addrs. Nos.");
        tmpCode := NoSeries.GetNextNo(SalesSetup."PDC Ship-to Addrs. Nos.", Today, true);

        repeat
            counter := counter + 1;
            if not ShipToAddressDb2.Get(NavPortalUser."Customer No.", tmpCode) then foundNewCode := true;
            if counter > 1 then
                if not ShipToAddressDb2.Get(NavPortalUser."Customer No.", tmpCode + '-' + Format(counter)) then begin
                    foundNewCode := true;
                    tmpCode := tmpCode + '-' + Format(counter);
                end;
        until foundNewCode;

        theCode := copystr(tmpCode, 1, MaxStrLen(theCode));

        ShipToAddressDb.Init();
        ShipToAddressDb.TransferFields(ShipToAddress, true);
        ShipToAddressDb.Validate("Customer No.", NavPortalUser."Customer No.");
        ShipToAddressDb.Validate(Code, theCode);
        ShipToAddressDb.Insert(true);

        ShipToAddressDb.Name := ShipToAddress.Name;
        ShipToAddressDb.Modify();

        PDCPortalUserShipToAddrs.Init();
        PDCPortalUserShipToAddrs."Portal User ID" := NavPortalUser.Id;
        PDCPortalUserShipToAddrs."Customer No." := NavPortalUser."Customer No.";
        PDCPortalUserShipToAddrs."Ship-to Code" := ShipToAddressDb.Code;
        PDCPortalUserShipToAddrs.Insert();

        ShipToAddress.DeleteAll();
        ShipToAddress.TransferFields(ShipToAddressDb);
    end;

    /// <summary>
    /// EditData.
    /// </summary>
    /// <param name="NavPortalUser">Record "PDC Portal User".</param>
    procedure EditData(NavPortalUser: Record "PDC Portal User")
    var
        ShipToAddressDb: Record "Ship-to Address";
    begin
        ShipToAddress.FindFirst();

        ShipToAddress.TestField(Name);
        ShipToAddress.TestField(Address);
        ShipToAddress.TestField(City);
        ShipToAddress.TestField("Post Code");

        if ShipToAddressDb.Get(NavPortalUser."Customer No.", ShipToAddress.Code) then begin
            ShipToAddressDb.Validate(Name, ShipToAddress.Name);
            ShipToAddressDb.Validate("Name 2", ShipToAddress."Name 2");
            ShipToAddressDb.Validate(Address, ShipToAddress.Address);
            ShipToAddressDb.Validate("Address 2", ShipToAddress."Address 2");
            ShipToAddressDb.Validate(City, ShipToAddress.City);
            ShipToAddressDb.Validate(County, ShipToAddress.County);
            ShipToAddressDb.Validate("Post Code", ShipToAddress."Post Code");
            ShipToAddressDb.Validate("Country/Region Code", ShipToAddress."Country/Region Code");
            ShipToAddressDb.Validate("PDC Is Home Ship-To Address", ShipToAddress."PDC Is Home Ship-To Address");
            ShipToAddressDb.Validate("E-Mail", ShipToAddress."E-Mail");
            ShipToAddressDb.Validate("Phone No.", ShipToAddress."Phone No.");
            ShipToAddressDb.Validate("PDC Show On Portal", ShipToAddress."PDC Show On Portal");
            ShipToAddressDb.Validate("PDC Branch No.", ShipToAddress."PDC Branch No.");
            ShipToAddressDb.Modify();
        end;
    end;
}

