/// <summary>
/// TableExtension PDCPurchaseLine (ID 50010) extends Record Purchase Line.
/// </summary>
tableextension 50010 PDCPurchaseLine extends "Purchase Line"
{
    fields
    {

        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                // PDC1 >>
                if Type = Type::"G/L Account" then
                    if PurchasesPayablesSetup.Get() then
                        if PurchasesPayablesSetup."PDC Default G/L Account" <> '' then
                            Validate("No.", PurchasesPayablesSetup."PDC Default G/L Account");
                // PDC1 <<
            end;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item1: Record Item;
            begin
                case Type OF
                    type::"G/L Account":
                        "PDC Skip Pmt. Discount" := TRUE; //24.01.2020 JEMEL J.Jemeljanovs #3203
                    Type::Item:
                        begin
                            Item1.get("No.");
                            // PDC1 >>
                            "PDC Product Code" := Item1."PDC Product Code";
                            // PDC1 <<
                        end;
                end;
            end;
        }

        modify("Planning Flexibility")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen(); //15.05.2020 JEMEL J.Jemeljanovs #3230
            end;
        }

        field(50000; "PDC Product Code"; Code[30])
        {
            Caption = 'Product Code';
            TableRelation = Item."PDC Product Code";
        }
        field(50004; "PDC Skip Pmt. Discount"; Boolean)
        {
            Caption = 'Skip Pmt. Discount';
        }
        field(50005; "PDC Exclude from Payment Disc."; Decimal)
        {
            Caption = 'Exclude from Payment Disc.'; //tmp - used in Posting C90
        }
    }

    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
}

