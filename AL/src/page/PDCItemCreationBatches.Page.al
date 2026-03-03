page 50017 "PDC Item Creation Batches"
{
    Caption = 'Item Creation Batches';
    DataCaptionExpression = Rec.Name;
    PageType = List;
    SourceTable = "PDC Item Creation Batch";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the item creation batch you are creating.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a brief description of the item creation batch name you are creating.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the type of the item creation batch you are creating.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Batch")
            {
                ApplicationArea = All;
                Caption = 'Edit Batch';
                Image = OpenWorksheet;
                ShortCutKey = 'Return';
                ToolTip = 'Edit Batch';
                RunObject = page "PDC Item Creation Engine";
                RunPageLink = "Journal Batch Name" = field(Name);
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Edit Batch_Promoted"; "Edit Batch")
                {
                }
            }
        }
    }
}

