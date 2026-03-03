/// <summary>
/// PageExtension PDCSalesReturnOrder (ID 50061) extends Record Sales Return Order.
/// </summary>
pageextension 50061 PDCSalesReturnOrder extends "Sales Return Order"
{
    layout
    {
        addafter(Status)
        {
            field(PDCReturnFromInvoiceNo; Rec."PDC Return From Invoice No.")
            {
                ToolTip = 'Return From Invoice No.';
                ApplicationArea = All;
                Editable = false;
            }
            field(PDCReturnSubmitted; Rec."PDC Return Submitted")
            {
                ToolTip = 'Return Submitted';
                ApplicationArea = All;
            }
        }
        modify("Shipping and Billing")
        {
            Visible = false;
        }
        addafter("Foreign Trade")
        {
            group("PDC Collection Details")
            {
                group(PDCDetails)
                {
                    field("PDC Package Type"; Rec."PDC Package Type")
                    {
                        ToolTip = 'Package Type';
                        ApplicationArea = All;
                    }
                    field("PDC Number Of Packages"; Rec."PDC Number Of Packages")
                    {
                        ToolTip = 'Number Of Packages';
                        ApplicationArea = All;
                    }
                    field("PDC Collection Reference"; Rec."PDC Collection Reference")
                    {
                        ToolTip = 'Collection Reference';
                        ApplicationArea = All;
                    }
                }
                group("PDC Collection Address")
                {
                    field(PDCCollectionName; Rec."Ship-to Name")
                    {
                        ToolTip = 'Ship-to Name';
                        ApplicationArea = All;
                    }
                    field(PDCCollectionAddress; Rec."Ship-to Address")
                    {
                        ToolTip = 'Ship-to Address';
                        ApplicationArea = All;
                    }
                    field(PDCCollectionAddress2; Rec."Ship-to Address 2")
                    {
                        ToolTip = 'Ship-to Address 2';
                        ApplicationArea = All;
                    }
                    field(PDCCollectionCity; Rec."Ship-to City")
                    {
                        ToolTip = 'Ship-to City';
                        ApplicationArea = All;
                    }
                    field(PDCCollectionPosCode; Rec."Ship-to Post Code")
                    {
                        ToolTip = 'Ship-to Post Code';
                        ApplicationArea = All;
                    }
                }
                group("PDC Collection Contact")
                {
                    field(CollectionContact; Rec."Ship-to Contact")
                    {
                        ToolTip = 'Ship-to Contact';
                        ApplicationArea = All;
                    }
                    field(PDCShiptoEMail; Rec."PDC Ship-to E-Mail")
                    {
                        ToolTip = 'Notification E-Mail';
                        ApplicationArea = All;
                        Caption = 'Notification E-Mail';
                    }
                    field(PDCShiptoMobilePhoneNo; Rec."PDC Ship-to Mobile Phone No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Notification Mobile Phone No.';
                        ToolTip = 'Notification Mobile Phone No.';
                    }
                }
                group(PDCDropOff)
                {
                    Caption = 'Drop-Off';

                    field("PDC Drop-Off"; Rec."PDC Drop-Off")
                    {
                        ToolTip = 'Drop-Off';
                        ApplicationArea = All;
                    }
                    field("PDC Drop-Off Email"; Rec."PDC Drop-Off Email")
                    {
                        ToolTip = 'Drop-Off Email';
                        ApplicationArea = All;
                    }
                    field("PDC Drop-Off Location"; Rec."PDC Drop-Off Location")
                    {
                        ToolTip = 'Drop-Off Location';
                        ApplicationArea = All;
                    }
                }

            }
        }
    }
    actions
    {
    }
}

