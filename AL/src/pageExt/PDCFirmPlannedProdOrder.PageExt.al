/// <summary>
/// PageExtension PDCFirmPlannedProdOrder (ID 50086) extends Record Firm Planned Prod. Order.
/// </summary>
pageextension 50086 PDCFirmPlannedProdOrder extends "Firm Planned Prod. Order"
{
    layout
    {
        addlast(content)
        {
            group(PDCProduction)
            {
                Caption = 'PDC Production';

                field("PDC Production Bin"; Rec."PDC Production Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Bin';
                }
                field("PDC Production Bin Changed"; Rec."PDC Production Bin Changed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Bin Changed';
                    Editable = false;
                }
                field("PDC Issue"; Rec."PDC Issue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Issue';
                }
                field("PDC Urgent"; Rec."PDC Urgent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Urgent';
                }
                field("PDC Production Status"; Rec."PDC Production Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Status';
                }
                field("PDC Production Status Changed"; Rec."PDC Production Status Changed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Production Status Changed';
                    Editable = false;
                }
                field("PDC Priority"; Rec."PDC Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Priority';
                }
            }
        }
    }
}
