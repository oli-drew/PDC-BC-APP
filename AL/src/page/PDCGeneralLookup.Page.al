/// <summary>
/// Page PDC General Lookup (ID 50012).
/// </summary>
page 50012 "PDC General Lookup"
{
    Caption = 'General Lookup';
    PageType = List;
    SourceTable = "PDC General Lookup";
    SourceTableView = sorting(Type, Sequence, Code);
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field(Type; Rec.Type)
                {
                    ToolTip = 'Type';
                    ApplicationArea = All;
                    Visible = ShowType;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                    ApplicationArea = All;
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Sequence';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode
          then
            ShowType := false else
            ShowType := true;
    end;

    var
        ShowType: Boolean;

    procedure "--- M.F ---"()
    begin
    end;

    /// <summary>
    /// GetSelectedRecords.
    /// </summary>
    /// <param name="PDCGeneralLookup">VAR Record "PDC General Lookup".</param>
    procedure GetSelectedRecords(var PDCGeneralLookup: Record "PDC General Lookup")
    begin
        //DOC NA2015.1 - Returning selected records
        //  <> pContact: Target recordset

        CurrPage.SetSelectionFilter(PDCGeneralLookup);
    end;
}

