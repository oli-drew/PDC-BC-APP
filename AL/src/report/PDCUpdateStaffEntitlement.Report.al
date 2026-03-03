/// <summary>
/// Report PDC Update Staff Entitlement (ID 50019).
/// </summary>
Report 50019 "PDC Update Staff Entitlement"
{

    ProcessingOnly = true;

    dataset
    {
        dataitem("Wardrobe Line"; "PDC Wardrobe Line")
        {
            RequestFilterFields = "Wardrobe ID", "Product Code", "Customer No.";

            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then
                    window.Update(1, "Wardrobe ID");

                if ("Item Gender" <> '') then
                    WardrobeFunctions.UpdateStaffEntitlementFromWardrobeLine("Wardrobe Line", "Wardrobe Line");
            end;

            trigger OnPreDataItem()
            begin
                if GuiAllowed then
                    window.Open(ProgressTxt);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        WardrobeFunctions: Codeunit "PDC Staff Entitlement";
        window: Dialog;
        ProgressTxt: label 'Updating #1#################', Comment = '%1=progress';
}

