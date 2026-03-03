/// <summary>
/// PageExtension "PDC Released"ProductionOrders (ID 50038) extends page Released Production Orders.
/// </summary>
pageextension 50038 PDCReleasedProductionOrders extends "Released Production Orders"
{
    layout
    {
        addafter("Bin Code")
        {
            field("PDC Firm Planned Order No."; Rec."Firm Planned Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Firm Planned Order No.';
            }
            field(PDCPurchaseDocumentNo; Rec."PDC Purchase Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Purchase Document No.';
            }
            field("PDC Released DT"; Rec."PDC Released D/T")
            {
                ApplicationArea = All;
                ToolTip = 'Released D/T';
            }
            // field(PDCLabelPrinted; Rec."PDC No. Labels Printed" > 0)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Label Printed';
            //     ToolTip = 'Label Printed';
            // }
            field("PDC Printed D/T"; Rec."PDC Printed D/T")
            {
                ApplicationArea = All;
                ToolTip = 'Printed D/T';
            }
            field("PDC Work Center No."; Rec."PDC Work Center No.")
            {
                ApplicationArea = All;
                ToolTip = 'Work Center No.';
            }
            field(PDCCalcRunTime; Rec.CalcRunTime())
            {
                Caption = 'Run Time';
                ToolTip = 'Run Time';
                ApplicationArea = All;
                Editable = false;
            }
            field("PDC Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Creation Date';
            }
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
            field("PDC Branding Files"; BrandingFilesList())
            {
                ApplicationArea = All;
                Caption = 'Branding Files';
                ToolTip = 'Branding Files';
                Editable = false;
            }
            field("PDC Comments"; Rec.Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                ToolTip = 'Comment';
            }
            field("PDC Priority"; Rec."PDC Priority")
            {
                ApplicationArea = All;
                Caption = 'Priority';
                ToolTip = 'Priority';
                Editable = false;
            }
        }
    }

    local procedure BrandingFilesList(): Text
    var
        RoutingLine: Record "Routing Line";
        FileList: Text;
        SepTxt: Label ', ', Locked = true;
    begin
        RoutingLine.setrange("Routing No.", Rec."Routing No.");
        RoutingLine.SetAutoCalcFields("PDC Branding File");
        if RoutingLine.FindSet() then
            repeat
                if RoutingLine."PDC Branding File" <> '' then
                    if not FileList.Contains(RoutingLine."PDC Branding File") then
                        FileList += RoutingLine."PDC Branding File" + SepTxt;
            until RoutingLine.Next() = 0;
        if FileList <> '' then
            FileList := CopyStr(FileList, 1, StrLen(FileList) - StrLen(SepTxt));
        exit(FileList);
    end;
}

