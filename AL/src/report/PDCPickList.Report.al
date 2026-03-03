/// <summary>
/// Report PDC Pick List (ID 50002).
/// </summary>
Report 50002 "PDC Pick List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Layouts/PickListPDC.rdlc';
    Caption = 'Pick List';
    AllowScheduling = true;

    dataset
    {
        dataitem(CopyLoop; "Integer")
        {
            DataItemTableView = sorting(Number);
            column(Number; Number)
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(DateToday; Format(Today))
            {
            }
            dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
            {
                DataItemTableView = sorting(Type, "No.") where(Type = const("Invt. Pick"));
                RequestFilterFields = "No.";
                column(NoWAH_Caption; "Warehouse Activity Header".FieldCaption("No."))
                {
                }
                column(NoWAH; "Warehouse Activity Header"."No.")
                {
                }
                column(SourceNo; SalesHeader."No.")
                {
                }
                column(ShipToName; SalesHeader."Ship-to Name")
                {
                }
                column(ShipToAddress; SalesHeader."Ship-to Address")
                {
                }
                column(ShipToAddress2; SalesHeader."Ship-to Address 2")
                {
                }
                column(ShipToCity; SalesHeader."Ship-to City")
                {
                }
                column(ShipToPostCode; SalesHeader."Ship-to Post Code")
                {
                }
                column(ShipToCounty; SalesHeader."Ship-to County")
                {
                }
                column(Notes; SalesHeader."PDC Notes")
                {
                }
                dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
                {
                    DataItemLink = "No." = field("No.");
                    DataItemTableView = sorting("Activity Type", "No.", "Line No.") where("Activity Type" = const("Invt. Pick"));
                    column(LineNo_WarehouseActivityLine; "Warehouse Activity Line"."Line No.")
                    {
                    }
                    column(ItemNo; Item."PDC Product Code")
                    {
                    }
                    column(Colour; Item."PDC Colour")
                    {
                    }
                    column(Size; Item."PDC Size")
                    {
                    }
                    column(Fit; Item."PDC Fit")
                    {
                    }
                    column(Quantity; "Warehouse Activity Line"."Qty. (Base)")
                    {
                    }
                    column(WearerID; "Warehouse Activity Line"."PDC Wearer ID")
                    {
                    }
                    column(WearerName; "Warehouse Activity Line"."PDC Wearer Name")
                    {
                    }
                    column(CustomerBranch; "Warehouse Activity Line"."PDC Branch No.")
                    {
                    }
                    column(CustRef; "Warehouse Activity Line"."PDC Customer Reference")
                    {
                    }
                    column(WebOrderNo; 'Web  ' + "Warehouse Activity Line"."PDC Web Order No.")
                    {
                    }
                    column(OrderedBy; "Warehouse Activity Line"."PDC Ordered By ID")
                    {
                    }
                    column(OrderedByName; 'Ordered By ' + "Warehouse Activity Line"."PDC Ordered By Name")
                    {
                    }
                    column(SizeSequence; Item."PDC Size Sequence")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Item.Get("Item No.");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if not SalesHeader.Get(SalesHeader."document type"::Order, "Warehouse Activity Header"."Source No.") then
                        SalesHeader.Init();

                    if not CurrReport.Preview then
                        WhseCountPrinted.Run("Warehouse Activity Header");

                    if not Customer.Get(SalesHeader."Sell-to Customer No.") then
                        Customer.Init();
                end;

                trigger OnPreDataItem()
                begin
                    if WhseActHeader.GetFilters <> '' then
                        "Warehouse Activity Header".CopyFilters(WhseActHeader);
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, NoOfCopies + 1);
            end;
        }
    }

    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("No of Copies"; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No of Copies';
                        ToolTip = 'No of Copies';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        OrderPickingListCaption = 'Pick Instruction';
        PageCaption = 'Page';
        CopyCaption = 'Copy';
        BranchCaption = 'Branch';
    }

    var
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        WhseActHeader: Record "Warehouse Activity Header";
        Customer: Record Customer;
        WhseCountPrinted: Codeunit "Whse.-Printed";
        NoOfCopies: Integer;

    /// <summary>
    /// SetWhseActHeader.
    /// </summary>
    /// <param name="p_WhseActHeader">VAR Record "Warehouse Activity Header".</param>
    procedure SetWhseActHeader(var p_WhseActHeader: Record "Warehouse Activity Header")
    begin
        WhseActHeader.CopyFilters(p_WhseActHeader);
    end;
}

