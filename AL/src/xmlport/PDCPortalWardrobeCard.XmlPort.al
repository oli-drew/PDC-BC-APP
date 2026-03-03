/// <summary>
/// XmlPort PDC Portal Wardrobe Card (ID 50020).
/// </summary>
XmlPort 50020 "PDC Portal Wardrobe Card"
{
    Encoding = UTF8;

    schema
    {
        textelement(data)
        {
            textelement(filter)
            {
                textelement(wardrobeId)
                {
                }
                textelement(staffId)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
            }
            tableelement(wardrobeheader; "PDC Wardrobe Header")
            {
                MinOccurs = Zero;
                XmlName = 'header';
                fieldelement(id; WardrobeHeader."Wardrobe ID")
                {
                }
                fieldelement(description; WardrobeHeader.Description)
                {
                }

            }
            tableelement(wardrobeline; "PDC Wardrobe Line")
            {
                MinOccurs = Zero;
                XmlName = 'lines';
                SourceTableView = sorting("Wardrobe ID", "Sort Order");

                textattribute(jsonarray)
                {
                    XmlName = 'json_Array';
                }
                textelement(imageUrl)
                {
                }
                fieldelement(productCode; WardrobeLine."Product Code")
                {
                }
                textelement(productName)
                {

                    trigger OnBeforePassVariable()
                    var
                        Item: Record Item;
                    begin

                        Item.Reset();
                        Item.SetRange("PDC Product Code", WardrobeLine."Product Code");
                        Item.SetFilter(Blocked, '%1', false);

                        if not Item.FindFirst() then
                            productName := ''
                        else
                            productName := Item.Description;
                    end;
                }
                textelement(entitlement)
                {
                    XmlName = 'entitlement';
                }
                textelement(qtyissued)
                {
                    XmlName = 'qtyIssued';

                }
                fieldelement(type; WardrobeLine."Item Type")
                {
                }
                fieldelement(sortOrder; WardrobeLine."Sort Order")
                {
                }
                textelement(cost)
                {

                    trigger OnBeforePassVariable()
                    begin
                        //cost := format(CustPortalMgt.GetWardrobeLinePrices(WardrobeLine));
                        cost := '0.00';
                    end;
                }
                textelement(leadTime)
                {
                    MinOccurs = Zero;
                    trigger OnBeforePassVariable()
                    var
                        Item1: Record Item;
                        tmpDate: Date;
                    begin
                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", WardrobeLine."Product Code");
                        Item1.SetRange(Blocked, false);
                        if Item1.FindFirst() then
                            if format(Item1."Lead Time Calculation") <> '' then begin
                                tmpDate := CalcDate(Item1."Lead Time Calculation", WorkDate());
                                leadTime := format(tmpDate - WorkDate());
                            end;
                    end;
                }
                textelement(firstInQtyGroup)
                {
                    MinOccurs = Zero;
                    trigger OnBeforePassVariable()
                    var
                        WardrobeLine1: Record "PDC Wardrobe Line";
                    begin
                        firstInQtyGroup := 'Yes';
                        if wardrobeline."Item Type" = wardrobeline."Item Type"::Core then
                            if wardrobeline."Entitlement Qty. Group" <> '' then begin
                                WardrobeLine1.Reset();
                                WardrobeLine1.SetCurrentKey("Wardrobe ID", "Sort Order");
                                WardrobeLine1.setrange("Wardrobe ID", wardrobeline."Wardrobe ID");
                                WardrobeLine1.setrange("Entitlement Qty. Group", wardrobeline."Entitlement Qty. Group");
                                WardrobeLine1.FindFirst();
                                if WardrobeLine1."Product Code" <> wardrobeline."Product Code" then
                                    firstInQtyGroup := 'No';
                            end;
                    end;
                }
                tableelement(colours; "PDC Name Value Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'colours';
                    UseTemporary = true;
                    textattribute(jsonarray2)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(code; colours.Name)
                    {
                    }
                    fieldelement(description; colours.Value)
                    {
                    }

                    trigger OnPreXmlItem()
                    var
                        WardrobeItemOption: Record "PDC Wardrobe Item Option";
                        ProductColour: Record "PDC Product colour";
                        Item1: Record Item;
                        colourNum: Integer;
                    begin

                        if colours.FindSet() then begin
                            colours.Reset();
                            colours.DeleteAll();
                        end;

                        WardrobeItemOption.Reset();
                        WardrobeItemOption.SetRange("Wardrobe ID", wardrobeId);
                        WardrobeItemOption.SetRange("Product Code", WardrobeLine."Product Code");
                        WardrobeItemOption.SetRange("Has Unblocked Item Sizes", true);

                        if WardrobeItemOption.FindSet() then begin

                            colourNum := 1;

                            repeat
                                colours.Init();
                                colours.ID := colourNum;
                                colours.Name := WardrobeItemOption."Colour Code";

                                ProductColour.Reset();
                                ProductColour.SetRange(Code, WardrobeItemOption."Colour Code");

                                if ProductColour.FindFirst() then
                                    colours.Value := ProductColour.Description
                                else
                                    colours.Value := WardrobeItemOption."Colour Code";

                                Item1.Reset();
                                Item1.SetCurrentkey("PDC Product Code", "PDC Colour", "PDC Fit", "PDC Size");
                                Item1.SetRange("PDC Product Code", WardrobeLine."Product Code");
                                Item1.SetRange("PDC Colour", WardrobeItemOption."Colour Code");
                                Item1.SetRange(Blocked, false);
                                if Item1.FindFirst() then
                                    if Item1."PDC Colour Description" <> '' then
                                        colours.Value := Item1."PDC Colour Description";

                                colours.Insert();
                                colourNum := colourNum + 1;

                            until WardrobeItemOption.next() = 0;

                        end;
                    end;
                }
                tableelement(sizes; "PDC Text Buffer")
                {
                    XmlName = 'sizes';
                    UseTemporary = true;
                    textattribute(jsonarray3)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(colour; sizes.Text)
                    {
                    }
                    fieldelement(code; sizes."Text 2")
                    {
                    }
                    fieldelement(sizeSeq; sizes."Text 3")
                    {
                    }
                    fieldelement(description; sizes."Text 4")
                    {
                    }
                    fieldelement(sizeDefault; sizes."Bool 1")
                    {
                    }

                    trigger OnPreXmlItem()
                    var
                        Item1: Record Item;
                        WardrobeItemOption: Record "PDC Wardrobe Item Option";
                        i: Integer;
                    begin
                        sizes.DeleteAll();

                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", WardrobeLine."Product Code");
                        Item1.SetRange(Blocked, false);
                        Item1.SetCurrentkey("PDC Size Sequence");

                        if not (Item1.FindSet()) then exit;

                        i := 1;

                        repeat
                            if Item1."PDC Size Description" = '' then
                                Item1."PDC Size Description" := Item1."PDC Size";

                            if WardrobeItemOption.Get(wardrobeId, Item1."PDC Product Code", Item1."PDC Colour") then begin
                                sizes.Init();
                                sizes.ID := i;
                                sizes.Text := Item1."PDC Colour";
                                sizes."Text 2" := Item1."PDC Size";
                                sizes."Text 3" := Format(Item1."PDC Size Sequence");
                                sizes."Text 4" := Item1."PDC Size Description";
                                if DefaultSize."Size Scale Code" <> '' then
                                    if DefaultSize.Size = Item1."PDC Size" then
                                        sizes."Bool 1" := true;
                                sizes.Insert();
                                i := i + 1;
                            end;
                        until Item1.Next() = 0;
                    end;
                }
                tableelement(fits; "PDC Text Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'fits';
                    UseTemporary = true;
                    textattribute(jsonarray5)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(colour; fits.Text)
                    {
                    }
                    fieldelement(size; fits."Text 2")
                    {
                    }
                    fieldelement(code; fits."Text 3")
                    {
                    }
                    fieldelement(description; fits."Text 4")
                    {
                    }
                    fieldelement(fitsSeq; fits."Text 5")
                    {
                    }
                    fieldelement(fitDefault; fits."Bool 1")
                    {
                    }

                    trigger OnPreXmlItem()
                    var
                        Item1: Record Item;
                        WardrobeItemOption: Record "PDC Wardrobe Item Option";
                        i: Integer;
                    begin
                        fits.DeleteAll();

                        Item1.Reset();
                        Item1.SetRange("PDC Product Code", WardrobeLine."Product Code");
                        Item1.SetRange(Blocked, false);

                        if not (Item1.FindSet()) then exit;

                        i := 1;

                        repeat
                            if Item1."PDC Fit Description" = '' then
                                Item1."PDC Fit Description" := Item1."PDC Fit";

                            if WardrobeItemOption.Get(wardrobeId, Item1."PDC Product Code", Item1."PDC Colour") then begin
                                fits.Init();
                                fits.ID := i;
                                fits.Text := Item1."PDC Colour";
                                fits."Text 2" := Item1."PDC Size";
                                fits."Text 3" := Item1."PDC Fit";
                                fits."Text 4" := Item1."PDC Fit Description";
                                fits."Text 5" := format(Item1."PDC Fit Sequence");
                                if DefaultSize."Size Scale Code" <> '' then
                                    if DefaultSize.Fit = Item1."PDC Fit" then
                                        fits."Bool 1" := true;
                                if (Item1."PDC Fit" <> '') then fits.Insert();
                                i := i + 1;
                            end;
                        until Item1.Next() = 0;
                    end;
                }
                tableelement(Item; Item)
                {
                    MinOccurs = Zero;
                    XmlName = 'items';
                    UseTemporary = true;
                    textattribute(jsonarray4)
                    {
                        XmlName = 'json_Array';
                    }
                    fieldelement(no; Item."No.")
                    {
                    }
                    fieldelement(colour; Item."PDC Colour")
                    {
                    }
                    fieldelement(size; Item."PDC Size")
                    {
                    }
                    fieldelement(fit; Item."PDC Fit")
                    {
                    }
                    fieldelement(sla; Item."PDC SLA")
                    {
                    }
                    fieldelement(gender; Item."PDC Gender")
                    {
                    }

                    trigger OnPreXmlItem()
                    var
                        ItemDb: Record Item;
                        WardrobeItemOption: Record "PDC Wardrobe Item Option";
                        BranchStaffDb: Record "PDC Branch Staff";
                    begin
                        Item.DeleteAll();

                        BranchStaffDb.Get(staffId);

                        ItemDb.Reset();
                        ItemDb.SetRange("PDC Product Code", WardrobeLine."Product Code");

                        if not ItemDb.FindSet() then exit;

                        repeat
                            if WardrobeItemOption.Get(wardrobeId, ItemDb."PDC Product Code", ItemDb."PDC Colour") then begin
                                Item.TransferFields(ItemDb);
                                Item.Insert();
                            end;
                        until ItemDb.Next() = 0;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    PDCWardrobeItemOption: record "PDC Wardrobe Item Option";
                    toShow: Boolean;
                begin
                    toShow := false;
                    PDCWardrobeItemOption.SetRange("Wardrobe ID", wardrobeline."Wardrobe ID");
                    PDCWardrobeItemOption.SetRange("Product Code", wardrobeline."Product Code");
                    if PDCWardrobeItemOption.FindSet() then
                        repeat
                            PDCWardrobeItemOption.CalcFields("Has Unblocked Item Sizes");
                            if PDCWardrobeItemOption."Has Unblocked Item Sizes" then
                                toShow := true;
                        until (PDCWardrobeItemOption.Next() = 0) or toShow;
                    if not toShow then
                        currXMLport.Skip();

                    if not StaffEntitlFunctions.GetsStaffDefaultSize(staffId, WardrobeLine."Product Code", DefaultSize) then
                        clear(DefaultSize);

                    if staffId = '' then exit;

                    entitlement := Format(StaffEntitlFunctions.GetQtyEntitled(staffId, WardrobeLine."Product Code"));
                    qtyIssued := Format(StaffEntitlFunctions.GetQtyIssued(staffId, WardrobeLine."Product Code", false));
                end;
            }
        }
    }


    trigger OnPreXmlPort()
    begin
        jsonArray := 'true';
        jsonArray2 := 'true';
        jsonArray3 := 'true';
        jsonArray4 := 'true';
        jsonArray5 := 'true';
    end;

    var
        DefaultSize: Record "PDC Size Scale Line";
        StaffEntitlFunctions: Codeunit "PDC Staff Entitlement";


    /// <summary>
    /// FilterData.
    /// </summary>
    procedure FilterData()
    var
        StaffHeaderDb: Record "PDC Branch Staff";
    begin
        WardrobeHeader.Reset();
        WardrobeHeader.SetRange("Wardrobe ID", wardrobeId);
        WardrobeHeader.FindFirst();

        StaffHeaderDb.Get(staffId);

        WardrobeLine.Reset();

        if (StaffHeaderDb."Body Type/Gender" = 'M') or (StaffHeaderDb."Body Type/Gender" = 'F') then
            WardrobeLine.SetFilter("Item Gender", '%1|%2|%3', StaffHeaderDb."Body Type/Gender", '', 'U');

        WardrobeLine.SetRange("Wardrobe ID", WardrobeHeader."Wardrobe ID");
        WardrobeLine.SetRange(Discontinued, false);

        WardrobeLine.SetCurrentkey("Wardrobe ID", "Sort Order");
        if not WardrobeLine.FindSet() then exit;
    end;
}

