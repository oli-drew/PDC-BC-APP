/// <summary>
/// Table PDC General Lookup (ID 50011).
/// </summary>
table 50011 "PDC General Lookup"
{
    //old No. 9062232

    // //DOC NA2015.1 JH 10/08/2012 - Migrated to 2013
    // //DOC NA2015.1 JH 13/02/2014 - Sequence added
    // //DOC NA2016.1 JH 27/08/2015 - Upgraded to 2016

    Caption = 'General Lookup';
    DataPerCompany = false;
    DrillDownPageID = "PDC General Lookup";
    LookupPageID = "PDC General Lookup";

    fields
    {
        field(1; Type; Code[20])
        {
            Caption = 'Type';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                if (CodeToName(Rec.Code, Rec.Description)) then
                    Rec.Validate(Description);
            end;
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; Sequence; Integer)
        {
            BlankZero = true;
            Caption = 'Sequence';
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
        key(Key2; "Code", Description)
        {
        }
        key(Key3; Type, Sequence, "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnInsert()
    begin
        Rec.TestField(Type);
        Rec.TestField(Code);
    end;

    local procedure CodeToName(pCode: Code[50]; var pName: Text[50]): Boolean
    var
        lResult: Boolean;
    begin
        //DOC NA2015.1 - Converting code to name
        //  -> pCode: Code
        //  <> pName: Target name
        //  <- TRUE = Converted, FALSE = Not

        lResult := false;
        if ((pCode <> '') and (pName = '')) then begin
            pName := ToTitleCase(pCode);
            lResult := true;
        end;
        exit(lResult);
    end;

    local procedure ToTitleCase(pString: Text[50]): Text[50]
    var
        lLen: Integer;
        lIndex: Integer;
        lString: Text;
        lStringCharacter: Text[1];
        lWordStarted: Boolean;
    begin
        //DOC NA2016.12 - Converting string to title case (first character uppercase of each word) for passed string
        //  -> pString: String
        //  <- Sentence-case string
        lLen := STRLEN(pString);
        lWordStarted := FALSE;

        for lIndex := 1 to lLen do begin
            lStringCharacter := COPYSTR(pString, lIndex, 1);
            if (lWordStarted) then
                lString := lString + LOWERcase(lStringCharacter)
            else
                lString := lString + UPPERcase(lStringCharacter);
            lWordStarted :=
            (
              ((lStringCharacter >= '0') and (lStringCharacter <= '9')) or
              ((lStringCharacter >= 'a') and (lStringCharacter <= 'z')) or
              ((lStringCharacter >= 'A') and (lStringCharacter <= 'Z'))
            );
        end;

        exit(CopyStr(lString, 1, 50));
    end;
}

