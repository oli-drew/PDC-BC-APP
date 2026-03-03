/// <summary>
/// Page PDCAPI - Production Order (ID 50005).
/// </summary>
page 50005 "PDCAPI - Production Order"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Production Order';
    EntitySetCaption = 'Production Orders';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'productionOrder';
    EntitySetName = 'productionOrders';
    APIPublisher = 'pdc';
    APIGroup = 'app1';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Production Order";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(sourceType; Rec."Source Type")
                {
                    Caption = 'Source Type';
                }
                field(sourceNo; Rec."Source No.")
                {
                    Caption = 'Source No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(productionBin; Rec."PDC Production Bin")
                {
                    Caption = 'Production Bin';
                }
                field(productionBinChanged; Rec."PDC Production Bin Changed")
                {
                    Caption = 'Production Bin Changed';
                }
                field(issue; Rec."PDC Issue")
                {
                    Caption = 'Issue';
                }
                field(urgent; Rec."PDC Urgent")
                {
                    Caption = 'Urgent';
                }
                field(productionStatus; Rec."PDC Production Status")
                {
                    Caption = 'Production Status';
                }
                field(routingNo; Rec."Routing No.")
                {
                    Caption = 'Routing No.';
                }
                field(creationDate; Rec."Creation Date")
                {
                    Caption = 'Creation Date';
                }
                field(finishedDate; Rec."Finished Date")
                {
                    Caption = 'Finished Date';
                }
                field(productionStatusChanged; Rec."PDC Production Status Changed")
                {
                    Caption = 'Production Status Changed';
                }
                field(workCenterNo; Rec."PDC Work Center No.")
                {
                    Caption = 'Work Center No.';
                }
                field(firmPlannedOrderNo; Rec."Firm Planned Order No.")
                {
                    Caption = 'Firm Planned Order No.';
                }
                field(calcRunTime; Rec.CalcRunTime())
                {
                    Caption = 'Run Time';
                }
                field(brandingFilesList; lpBrandingFilesList())
                {
                    Caption = 'Branding Files';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(assignedUserID; Rec."Assigned User ID")
                {
                    Caption = 'Assigned User ID';
                }
                field(priority; Rec."PDC Priority")
                {
                    Caption = 'Priority';
                }
            }
            part(relProdOrderLines; "PDCAPI - Prod. Order Lines")
            {
                SubPageLink = Status = field(Status), "Prod. Order No." = field("No.");
                EntityName = 'prodOrderLine';
                EntitySetName = 'prodOrderLines';
            }
            part(prodOrderComponents; "PDCAPI - Prod.Order Components")
            {
                SubPageLink = Status = field(Status), "Prod. Order No." = field("No.");
                EntityName = 'prodOrderComponent';
                EntitySetName = 'prodOrderComponents';
            }
            part(prodOrderRouting; "PDCAPI - Prod. Order Routing")
            {
                SubPageLink = Status = field(Status), "Prod. Order No." = field("No.");
                EntityName = 'prodOrderRouting';
                EntitySetName = 'prodOrderRoutings';
            }
            part(prodOrderComSheet; "PDCAPI - Prod.Order Com. Sheet")
            {
                SubPageLink = Status = field(Status), "Prod. Order No." = field("No.");
                EntityName = 'prodOrderCommentSheet';
                EntitySetName = 'prodOrderCommentsSheet';
            }

        }
    }

    local procedure lpBrandingFilesList(): Text
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

    /// <summary>
    /// FinishProductionOrder.
    /// </summary>
    /// <param name="actionContext">VAR WebServiceActionContext.</param>
    /// <param name="updateUnitCost">Boolean.</param>
    [ServiceEnabled]
    procedure FinishProductionOrder(var actionContext: WebServiceActionContext; updateUnitCost: Boolean)
    var
        ProductionOrder: Record "Production Order";
        ProdOrderStatusManagement: codeunit "Prod. Order Status Management";
    begin
        ProductionOrder.Get(Rec.Status::Released, Rec."No.");
        ProdOrderStatusManagement.ChangeProdOrderStatus(ProductionOrder, ProductionOrder.Status::Finished, WorkDate(), updateUnitCost);

        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::"PDCAPI - Production Order");
        actionContext.AddEntityKey(Rec.FIELDNO("No."), ProductionOrder."No.");
        // Set the result code to inform the caller that an item was created.
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    /// <summary>
    /// procedure PrintProductionOrder call with odata, prints production order.
    /// </summary>
    [ServiceEnabled]
    procedure PrintProductionOrder()
    var
        ProductionOrder: Record "Production Order";
        ProductionOrder1: Record "Production Order";
    begin
        if ProductionOrder.Get(Rec.Status::Released, Rec."No.") then begin
            ProductionOrder1.Get(ProductionOrder.Status, ProductionOrder."No.");
            ProductionOrder1.SetRecfilter();
            Report.RunModal(Report::"PDC Production Order Labels", false, false, ProductionOrder1);
        end;
    end;

}
