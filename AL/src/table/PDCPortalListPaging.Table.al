/// <summary>
/// Table PDC Portal List Paging (ID 50055).
/// </summary>
table 50055 "PDC Portal List Paging"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Page Index"; Integer)
        {
        }
        field(3; "No of Pages"; Integer)
        {
        }
        field(4; "No of Records"; Integer)
        {
        }
        field(5; "Records to Skip"; Integer)
        {
        }
        field(6; "Page Size"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    /// <summary>
    /// ClearData.
    /// </summary>
    procedure ClearData()
    begin
        Rec.Init();
        "Entry No." := 1;
        "Page Index" := 1;
        "No of Pages" := 1;
        "No of Records" := 0;
        "Page Size" := GetDefaultPageSize();
    end;

    local procedure GetDefaultPageSize(): Integer
    var
        PDCNavPortal: Record "PDC Portal";
    begin
        if PDCNavPortal.FindFirst() and (PDCNavPortal."Page Size" > 0) then
            exit(PDCNavPortal."Page Size");
        exit(15);
    end;

    /// <summary>
    /// SetRecords.
    /// </summary>
    /// <param name="pNoOfRecords">Integer.</param>
    procedure SetRecords(pNoOfRecords: Integer)
    begin
        "Page Size" := GetDefaultPageSize();

        Rec.Reset();
        if (not (Rec.FindFirst())) then begin
            Rec.ClearData();
            Rec.Insert();
        end;

        Rec."Page Size" := GetDefaultPageSize();

        Rec."No of Records" := pNoOfRecords;
        Rec."Records to Skip" := 0;
        if (Rec."Page Index" < 1) then
            Rec."Page Index" := 1;
        if ("Page Size" > 0) then begin
            Rec."No of Pages" := ROUND((Rec."No of Records" - 1) / "Page Size", 1, '<') + 1;
            if (Rec."No of Pages" < 1) then
                Rec."No of Pages" := 1;
            if (Rec."Page Index" > Rec."No of Pages") then
                Rec."Page Index" := Rec."No of Pages";
            Rec."Records to Skip" := (Rec."Page Index" - 1) * "Page Size";
        end else begin
            Rec."Page Index" := 1;
            Rec."No of Pages" := 1;
            Rec."Page Size" := 300;
        end;

        Rec.Modify();
    end;
}

