# PDCAPI - Production Order

API documentation for the **PDCAPI - Production Order** page (ID 50005) and its linked sub-entities.

## Contents

- [Overview](#overview)
- [Base URL](#base-url)
- [Authentication](#authentication)
- [Production Order Entity](#production-order-entity)
  - [Fields](#fields)
  - [Computed Fields](#computed-fields)
  - [PDC Custom Fields](#pdc-custom-fields)
- [Standard CRUD Operations](#standard-crud-operations)
  - [List Production Orders](#list-production-orders)
  - [Get a Single Production Order](#get-a-single-production-order)
  - [Create a Production Order](#create-a-production-order)
  - [Update a Production Order](#update-a-production-order)
  - [Delete a Production Order](#delete-a-production-order)
- [Filtering & Query Options](#filtering--query-options)
- [Change Tracking (Delta Sync)](#change-tracking-delta-sync)
- [Bound Actions](#bound-actions)
  - [FinishProductionOrder](#finishproductionorder)
  - [PrintProductionOrder](#printproductionorder)
- [Sub-Entities (Navigation Properties)](#sub-entities-navigation-properties)
  - [Expanding Sub-Entities](#expanding-sub-entities)
  - [prodOrderLines — Production Order Lines](#prodorderlines--production-order-lines)
  - [prodOrderComponents — Production Order Components](#prodordercomponents--production-order-components)
  - [prodOrderRoutings — Production Order Routing Lines](#prodorderroutings--production-order-routing-lines)
  - [prodOrderCommentsSheet — Production Order Comment Sheet](#prodordercommentssheet--production-order-comment-sheet)
- [Full Example: Expand All Sub-Entities](#full-example-expand-all-sub-entities)

---

## Overview

| Property | Value |
|---|---|
| **Page ID** | 50005 |
| **API Publisher** | `pdc` |
| **API Group** | `app1` |
| **API Version** | `v2.0` |
| **Entity Name** | `productionOrder` |
| **Entity Set Name** | `productionOrders` |
| **Source Table** | Production Order |
| **OData Key** | `SystemId` (GUID) |
| **Change Tracking** | Enabled |
| **Extensible** | No |

This API page exposes Business Central **Production Orders** as a RESTful resource, along with four linked sub-entities for lines, components, routing, and comments. It also provides two bound actions for finishing and printing production orders.

---

## Base URL

```
https://{baseUrl}/api/pdc/app1/v2.0/companies({companyId})/productionOrders
```

Replace `{baseUrl}` with your Business Central environment URL (e.g. `api.businesscentral.dynamics.com/v2.0/{tenantId}/{environment}`).

---

## Authentication

Standard Business Central API authentication applies:

- **OAuth 2.0** — recommended for production use (Azure AD / Entra ID app registrations).
- **Basic Auth (API keys)** — for simple integrations; requires a web service access key.

All requests must include an `Authorization` header.

---

## Production Order Entity

### Fields

| API Field | Source | Type | Editable | Description |
|---|---|---|---|---|
| `id` | `SystemId` | GUID | No | Unique system identifier (OData key) |
| `status` | `Status` | Enum | Yes | BC production order status (`Simulated`, `Planned`, `Firm Planned`, `Released`, `Finished`) |
| `no` | `No.` | Code[20] | Yes | Production order number |
| `description` | `Description` | Text[100] | Yes | Primary description |
| `description2` | `Description 2` | Text[50] | Yes | Secondary description |
| `sourceType` | `Source Type` | Enum | Yes | Source type (Item, Family, Sales Header) |
| `sourceNo` | `Source No.` | Code[20] | Yes | Source number (e.g. Item No.) |
| `quantity` | `Quantity` | Decimal | Yes | Order quantity |
| `dueDate` | `Due Date` | Date | Yes | Due date |
| `routingNo` | `Routing No.` | Code[20] | Yes | Associated routing number |
| `creationDate` | `Creation Date` | Date | No | Date the order was created |
| `finishedDate` | `Finished Date` | Date | No | Date the order was finished |
| `firmPlannedOrderNo` | `Firm Planned Order No.` | Code[20] | No | Related firm planned order number |
| `comment` | `Comment` | Boolean | No | Whether comments exist for this order |
| `assignedUserID` | `Assigned User ID` | Code[50] | Yes | User assigned to the order |

### Computed Fields

These fields are calculated at read-time and are **read-only**.

| API Field | Source | Type | Description |
|---|---|---|---|
| `calcRunTime` | `CalcRunTime()` | Decimal | Total run time across all routing lines, calculated as `SUM(Routing Line "Run Time" × Order Quantity)` |
| `brandingFilesList` | `lpBrandingFilesList()` | Text | Comma-separated list of unique branding file names from the associated Routing Lines |

### PDC Custom Fields

These fields are added by the PDC extension (table extension 50036 on the Production Order table).

| API Field | Source | Type | Editable | Description |
|---|---|---|---|---|
| `productionBin` | `PDC Production Bin` | Text[30] | Yes | The production bin code for this order. Changing this value automatically timestamps `productionBinChanged`. |
| `productionBinChanged` | `PDC Production Bin Changed` | DateTime | No | Timestamp of when the production bin was last changed |
| `issue` | `PDC Issue` | Text[100] | Yes | Free-text issue description |
| `urgent` | `PDC Urgent` | Boolean | Yes | Whether this order is flagged as urgent |
| `productionStatus` | `PDC Production Status` | Text[100] | Yes | PDC-specific production status (free text). Changing this value automatically timestamps `productionStatusChanged`. |
| `productionStatusChanged` | `PDC Production Status Changed` | DateTime | No | Timestamp of when production status was last changed |
| `workCenterNo` | `PDC Work Center No.` | Code[20] | No | Work center number (FlowField — looked up from the first Prod. Order Routing Line) |
| `priority` | `PDC Priority` | Integer | Yes | Priority value (default: 0; lower = higher priority) |

---

## Standard CRUD Operations

### List Production Orders

```http
GET /api/pdc/app1/v2.0/companies({companyId})/productionOrders
```

Returns a collection of all production orders.

### Get a Single Production Order

```http
GET /api/pdc/app1/v2.0/companies({companyId})/productionOrders({systemId})
```

Returns one production order identified by its `SystemId` (GUID).

### Create a Production Order

```http
POST /api/pdc/app1/v2.0/companies({companyId})/productionOrders
Content-Type: application/json

{
  "no": "RPO-00042",
  "description": "Bike Frame Assembly",
  "sourceType": "Item",
  "sourceNo": "1000",
  "quantity": 50,
  "dueDate": "2026-03-15"
}
```

> **Note:** `DelayedInsert` is enabled on this page — the record is only inserted after all field values have been set.

### Update a Production Order

```http
PATCH /api/pdc/app1/v2.0/companies({companyId})/productionOrders({systemId})
Content-Type: application/json
If-Match: {etag}

{
  "urgent": true,
  "productionStatus": "In Progress",
  "productionBin": "BIN-05",
  "priority": 1
}
```

Use `If-Match: *` to skip concurrency checks, or supply the actual `@odata.etag` value from a previous GET.

### Delete a Production Order

```http
DELETE /api/pdc/app1/v2.0/companies({companyId})/productionOrders({systemId})
If-Match: {etag}
```

---

## Filtering & Query Options

The API supports standard OData v4 query options.

| Parameter | Example | Description |
|---|---|---|
| `$filter` | `$filter=status eq 'Released'` | Filter by field values |
| `$select` | `$select=no,description,status,quantity` | Return only specified fields |
| `$top` | `$top=10` | Limit number of records |
| `$skip` | `$skip=20` | Skip records (pagination) |
| `$orderby` | `$orderby=dueDate desc` | Sort results |
| `$expand` | `$expand=prodOrderLines` | Include sub-entities inline |
| `$count` | `$count=true` | Include total count in response |

### Filter Examples

```http
# Released orders only
GET ...productionOrders?$filter=status eq 'Released'

# Urgent orders due before a date
GET ...productionOrders?$filter=urgent eq true and dueDate lt 2026-04-01

# Orders for a specific item
GET ...productionOrders?$filter=sourceNo eq '1000'

# Orders assigned to a specific user
GET ...productionOrders?$filter=assignedUserID eq 'JOHN'
```

---

## Change Tracking (Delta Sync)

Change tracking is enabled (`ChangeTrackingAllowed = true`). This allows incremental synchronisation using delta tokens.

1. **Initial full sync:**
   ```http
   GET ...productionOrders
   ```
   The response includes an `@odata.deltaLink` URL.

2. **Subsequent delta requests:**
   ```http
   GET {deltaLink}
   ```
   Returns only records that have been created, modified, or deleted since the last sync.

---

## Bound Actions

### FinishProductionOrder

Transitions a **Released** production order to **Finished** status.

```http
POST /api/pdc/app1/v2.0/companies({companyId})/productionOrders({systemId})/Microsoft.NAV.FinishProductionOrder
Content-Type: application/json

{
  "updateUnitCost": true
}
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `updateUnitCost` | Boolean | Yes | Whether to recalculate the unit cost when finishing the order |

**Behaviour:**

1. Retrieves the production order with status **Released** and the current order number.
2. Calls the standard BC `Prod. Order Status Management` codeunit to change status to **Finished**, using the current `WorkDate` as the posting date.
3. Returns the updated production order with HTTP result code `201 Created`.

**Prerequisites:**
- The production order **must** have status `Released`. Calling this on any other status will raise an error.

### PrintProductionOrder

Triggers the **PDC Production Order Labels** report for the current order.

```http
POST /api/pdc/app1/v2.0/companies({companyId})/productionOrders({systemId})/Microsoft.NAV.PrintProductionOrder
```

No request body is required.

**Behaviour:**

1. Retrieves the production order with status **Released**.
2. Runs `Report::"PDC Production Order Labels"` filtered to the specific order.
3. The report runs modally on the server; the output depends on the report's rendering configuration (e.g. PDF).

**Prerequisites:**
- The production order **must** have status `Released`.

---

## Sub-Entities (Navigation Properties)

The production order has four linked sub-entities. Each is linked via `Status` and `Prod. Order No.` from the parent production order.

### Expanding Sub-Entities

Use `$expand` to include sub-entity data inline with the parent:

```http
# Expand one
GET ...productionOrders({id})?$expand=prodOrderLines

# Expand multiple
GET ...productionOrders({id})?$expand=prodOrderLines,prodOrderComponents,prodOrderRoutings,prodOrderCommentsSheet

# Expand all, on a collection
GET ...productionOrders?$filter=status eq 'Released'&$expand=prodOrderComponents
```

Each sub-entity is also directly accessible:

```http
GET ...productionOrders({id})/prodOrderLines
GET ...productionOrders({id})/prodOrderComponents
GET ...productionOrders({id})/prodOrderRoutings
GET ...productionOrders({id})/prodOrderCommentsSheet
```

---

### prodOrderLines — Production Order Lines

**Source page:** PDCAPI - Prod. Order Lines (ID 50006)  
**Source table:** Prod. Order Line  
**Entity name:** `prodOrderLine` / `prodOrderLines`

| API Field | Source | Type | Editable | Description |
|---|---|---|---|---|
| `id` | `SystemId` | GUID | No | Unique identifier |
| `prodOrderStatus` | `Status` | Enum | No | Parent order status |
| `prodOrderNo` | `Prod. Order No.` | Code | No | Parent production order number |
| `itemNo` | `Item No.` | Code | Yes | Item number being produced |
| `variantCode` | `Variant Code` | Code | Yes | Item variant code |
| `dueDate` | `Due Date` | Date | Yes | Line due date |
| `planningFlexibility` | `Planning Flexibility` | Enum | Yes | Planning flexibility setting |
| `description` | `Description` | Text | Yes | Line description |
| `description2` | `Description 2` | Text | Yes | Secondary description |
| `productionBOMNo` | `Production BOM No.` | Code | Yes | Production BOM number |
| `routingNo` | `Routing No.` | Code | Yes | Routing number |
| `routingVersionCode` | `Routing Version Code` | Code | Yes | Routing version |
| `productionBOMVersionCode` | `Production BOM Version Code` | Code | Yes | BOM version |
| `locationCode` | `Location Code` | Code | Yes | Location code |
| `binCode` | `Bin Code` | Code | Yes | Bin code |
| `startingDateTime` | `Starting Date-Time` | DateTime | Yes | Start date-time |
| `startingTime` | Computed | Time | No | Start time (extracted from Starting Date-Time) |
| `startingDate` | Computed | Date | No | Start date (extracted from Starting Date-Time) |
| `endingDateTime` | `Ending Date-Time` | DateTime | Yes | End date-time |
| `endingTime` | Computed | Time | No | End time (extracted from Ending Date-Time) |
| `endingDate` | Computed | Date | No | End date (extracted from Ending Date-Time) |
| `scrap` | `Scrap %` | Decimal | Yes | Scrap percentage |
| `quantity` | `Quantity` | Decimal | Yes | Quantity |
| `reservedQuantity` | `Reserved Quantity` | Decimal | No | Reserved quantity |
| `unitofMeasureCode` | `Unit of Measure Code` | Code | Yes | Unit of measure |
| `finishedQuantity` | `Finished Quantity` | Decimal | No | Quantity already finished |
| `remainingQuantity` | `Remaining Quantity` | Decimal | No | Quantity remaining to produce |
| `unitCost` | `Unit Cost` | Decimal | Yes | Unit cost |
| `costAmount` | `Cost Amount` | Decimal | No | Total cost amount |
| `shortcutDimension1Code` | `Shortcut Dimension 1 Code` | Code | Yes | Global dimension 1 |
| `shortcutDimension2Code` | `Shortcut Dimension 2 Code` | Code | Yes | Global dimension 2 |
| `shortcutDimCode3` – `shortcutDimCode8` | Computed | Code | No | Shortcut dimensions 3–8 |

---

### prodOrderComponents — Production Order Components

**Source page:** PDCAPI - Prod.Order Components (ID 50007)  
**Source table:** Prod. Order Component  
**Entity name:** `prodOrderComponent` / `prodOrderComponents`

| API Field | Source | Type | Editable | Description |
|---|---|---|---|---|
| `id` | `SystemId` | GUID | No | Unique identifier |
| `prodOrderStatus` | `Status` | Enum | No | Parent order status |
| `prodOrderNo` | `Prod. Order No.` | Code | No | Parent production order number |
| `itemNo` | `Item No.` | Code | Yes | Component item number |
| `variantCode` | `Variant Code` | Code | Yes | Item variant code |
| `dueDateTime` | `Due Date-Time` | DateTime | Yes | Due date-time |
| `dueDate` | `Due Date` | Date | Yes | Due date |
| `description` | `Description` | Text | Yes | Component description |
| `scrap` | `Scrap %` | Decimal | Yes | Scrap percentage |
| `calculationFormula` | `Calculation Formula` | Enum | Yes | How quantity is calculated (e.g. Length, Length×Width) |
| `length` | `Length` | Decimal | Yes | Length dimension |
| `width` | `Width` | Decimal | Yes | Width dimension |
| `weight` | `Weight` | Decimal | Yes | Weight dimension |
| `depth` | `Depth` | Decimal | Yes | Depth dimension |
| `quantityper` | `Quantity per` | Decimal | Yes | Quantity required per unit of parent |
| `reservedQuantity` | `Reserved Quantity` | Decimal | No | Reserved quantity |
| `unitofMeasureCode` | `Unit of Measure Code` | Code | Yes | Unit of measure |
| `flushingMethod` | `Flushing Method` | Enum | Yes | Flushing method (Manual, Forward, Backward, Pick + Forward, Pick + Backward) |
| `expectedQuantity` | `Expected Quantity` | Decimal | No | Total expected quantity |
| `remainingQuantity` | `Remaining Quantity` | Decimal | No | Remaining quantity to consume |
| `routingLinkCode` | `Routing Link Code` | Code | Yes | Links component to a routing operation |
| `locationCode` | `Location Code` | Code | Yes | Location code |
| `binCode` | `Bin Code` | Code | Yes | Bin code |
| `unitCost` | `Unit Cost` | Decimal | Yes | Unit cost |
| `costAmount` | `Cost Amount` | Decimal | No | Total cost amount |
| `position` | `Position` | Code | Yes | Position reference |
| `position2` | `Position 2` | Code | Yes | Position reference 2 |
| `position3` | `Position 3` | Code | Yes | Position reference 3 |
| `leadTimeOffset` | `Lead-Time Offset` | DateFormula | Yes | Lead time offset |
| `qtyPicked` | `Qty. Picked` | Decimal | No | Quantity picked for production |
| `qtyPickedBase` | `Qty. Picked (Base)` | Decimal | No | Quantity picked in base UOM |
| `substitutionAvailable` | `Substitution Available` | Boolean | No | Whether item substitutions are available |
| `vendorNo` | Item.`Vendor No.` | Code | No | Primary vendor number (looked up from Item card) |
| `itemVendorNo` | Item.`Vendor Item No.` | Code | No | Vendor's item number (looked up from Item card) |

> **Note:** `vendorNo` and `itemVendorNo` are looked up from the Item master record. They are read-only.

---

### prodOrderRoutings — Production Order Routing Lines

**Source page:** PDCAPI - Prod. Order Routing (ID 50013)  
**Source table:** Prod. Order Routing Line  
**Entity name:** `prodOrderRouting` / `prodOrderRoutings`

| API Field | Source | Type | Editable | Description |
|---|---|---|---|---|
| `id` | `SystemId` | GUID | No | Unique identifier |
| `prodOrderStatus` | `Status` | Enum | No | Parent order status |
| `prodOrderNo` | `Prod. Order No.` | Code | Yes | Parent production order number |
| `scheduleManually` | `Schedule Manually` | Boolean | Yes | Whether the operation is manually scheduled |
| `operationNo` | `Operation No.` | Code | Yes | Operation number |
| `previousOperationNo` | `Previous Operation No.` | Code | Yes | Previous operation in sequence |
| `nextOperationNo` | `Next Operation No.` | Code | Yes | Next operation in sequence |
| `type` | `Type` | Enum | Yes | Resource type (Work Center, Machine Center) |
| `no` | `No.` | Code | Yes | Work/Machine center number |
| `description` | `Description` | Text | Yes | Operation description |
| `flushingMethod` | `Flushing Method` | Enum | Yes | Flushing method |
| `startingDateTime` | `Starting Date-Time` | DateTime | Yes | Operation start date-time |
| `startingTime` | Computed | Time | No | Start time (extracted from Starting Date-Time) |
| `startingDate` | Computed | Date | No | Start date (extracted from Starting Date-Time) |
| `endingDateTime` | `Ending Date-Time` | DateTime | Yes | Operation end date-time |
| `endingTime` | Computed | Time | No | End time |
| `endingDate` | Computed | Date | No | End date |
| `setupTime` | `Setup Time` | Decimal | Yes | Setup time |
| `setupTimeUnitofMeasCode` | `Setup Time Unit of Meas. Code` | Code | Yes | Setup time UOM |
| `runTime` | `Run Time` | Decimal | Yes | Run time per unit |
| `runTimeUnitofMeasCode` | `Run Time Unit of Meas. Code` | Code | Yes | Run time UOM |
| `waitTime` | `Wait Time` | Decimal | Yes | Wait time |
| `waitTimeUnitofMeasCode` | `Wait Time Unit of Meas. Code` | Code | Yes | Wait time UOM |
| `moveTime` | `Move Time` | Decimal | Yes | Move time |
| `moveTimeUnitofMeasCode` | `Move Time Unit of Meas. Code` | Code | Yes | Move time UOM |
| `fixedScrapQuantity` | `Fixed Scrap Quantity` | Decimal | Yes | Fixed scrap quantity |
| `routingLinkCode` | `Routing Link Code` | Code | Yes | Links operation to components |
| `scrapFactor` | `Scrap Factor %` | Decimal | Yes | Scrap factor percentage |
| `sendAheadQuantity` | `Send-Ahead Quantity` | Decimal | Yes | Quantity to send ahead |
| `concurrentCapacities` | `Concurrent Capacities` | Decimal | Yes | Number of concurrent capacities |
| `unitCostper` | `Unit Cost per` | Decimal | Yes | Cost per unit |
| `lotSize` | `Lot Size` | Decimal | Yes | Lot size |
| `expectedOperationCostAmt` | `Expected Operation Cost Amt.` | Decimal | No | Expected operation cost |
| `expectedCapacityOvhdCost` | `Expected Capacity Ovhd. Cost` | Decimal | No | Expected capacity overhead cost |
| `expectedCapacityNeed` | Computed | Decimal | No | Expected capacity need (normalised by work center UOM time factor) |
| `routingStatus` | `Routing Status` | Enum | Yes | Routing line status |
| `locationCode` | `Location Code` | Code | Yes | Location code |
| `openShopFloorBinCode` | `Open Shop Floor Bin Code` | Code | Yes | Open shop floor bin |
| `toProductionBinCode` | `To-Production Bin Code` | Code | Yes | To-production bin |
| `fromProductionBinCode` | `From-Production Bin Code` | Code | Yes | From-production bin |
| `brandingNo` | Routing Line → `PDC Branding No.` | Code | No | PDC branding number (looked up from master Routing Line) |
| `brandingFile` | Branding → `Branding File` | Text | No | Branding file name (looked up from PDC Branding record) |
| `brandingPositionCode` | Branding → `Branding Position Code` | Code | No | Branding position code |
| `brandingPositionDescription` | Branding Position → `Description` | Text | No | Branding position description |

> **Note:** The branding fields (`brandingNo`, `brandingFile`, `brandingPositionCode`, `brandingPositionDescription`) are looked up by matching the current routing line's `Routing No.` and `Operation No.` back to the master **Routing Line** table, then resolving through the **PDC Branding** and **PDC Branding Position** records. They are read-only.

---

### prodOrderCommentsSheet — Production Order Comment Sheet

**Source page:** PDCAPI - Prod.Order Com. Sheet (ID 50014)  
**Source table:** Prod. Order Comment Line  
**Entity name:** `prodOrderCommentSheet` / `prodOrderCommentsSheet`

| API Field | Source | Type | Editable | Description |
|---|---|---|---|---|
| `id` | `SystemId` | GUID | No | Unique identifier |
| `prodOrderStatus` | `Status` | Enum | No | Parent order status |
| `prodOrderNo` | `Prod. Order No.` | Code | No | Parent production order number |
| `date` | `Date` | Date | Yes | Comment date |
| `comment` | `Comment` | Text | Yes | Comment text |
| `code` | `Code` | Code | Yes | Comment code |

---

## Full Example: Expand All Sub-Entities

### Request

```http
GET /api/pdc/app1/v2.0/companies({companyId})/productionOrders({systemId})?$expand=prodOrderLines,prodOrderComponents,prodOrderRoutings,prodOrderCommentsSheet
```

### Response (abbreviated)

```json
{
  "@odata.etag": "W/\"abc123\"",
  "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "status": "Released",
  "no": "RPO-00042",
  "description": "Bike Frame Assembly",
  "description2": "",
  "sourceType": "Item",
  "sourceNo": "1000",
  "quantity": 50,
  "dueDate": "2026-03-15",
  "productionBin": "BIN-05",
  "productionBinChanged": "2026-02-20T14:30:00Z",
  "issue": "",
  "urgent": false,
  "productionStatus": "In Progress",
  "routingNo": "RT-001",
  "creationDate": "2026-02-01",
  "finishedDate": "0001-01-01",
  "productionStatusChanged": "2026-02-15T09:00:00Z",
  "workCenterNo": "WC-100",
  "firmPlannedOrderNo": "",
  "calcRunTime": 250.0,
  "brandingFilesList": "logo.pdf, sticker.pdf",
  "comment": true,
  "assignedUserID": "JOHN",
  "priority": 1,

  "prodOrderLines": [
    {
      "id": "11111111-2222-3333-4444-555555555555",
      "prodOrderStatus": "Released",
      "prodOrderNo": "RPO-00042",
      "itemNo": "1000",
      "variantCode": "",
      "dueDate": "2026-03-15",
      "description": "Bicycle Frame",
      "quantity": 50,
      "finishedQuantity": 0,
      "remainingQuantity": 50,
      "unitCost": 45.00,
      "costAmount": 2250.00,
      "locationCode": "MAIN",
      "binCode": "BIN-05"
    }
  ],

  "prodOrderComponents": [
    {
      "id": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
      "prodOrderStatus": "Released",
      "prodOrderNo": "RPO-00042",
      "itemNo": "TUBE-01",
      "description": "Steel Tube 25mm",
      "quantityper": 2,
      "expectedQuantity": 100,
      "remainingQuantity": 100,
      "flushingMethod": "Manual",
      "locationCode": "MAIN",
      "binCode": "RAW-01",
      "unitCost": 5.50,
      "costAmount": 550.00,
      "vendorNo": "V-001",
      "itemVendorNo": "EXT-TUBE-25"
    }
  ],

  "prodOrderRoutings": [
    {
      "id": "ffff0000-1111-2222-3333-444444444444",
      "prodOrderStatus": "Released",
      "prodOrderNo": "RPO-00042",
      "operationNo": "10",
      "type": "Work Center",
      "no": "WC-100",
      "description": "Cutting",
      "setupTime": 15,
      "runTime": 5.0,
      "runTimeUnitofMeasCode": "MIN",
      "routingStatus": "In Progress",
      "brandingNo": "BR-001",
      "brandingFile": "logo.pdf",
      "brandingPositionCode": "FRONT",
      "brandingPositionDescription": "Front Panel"
    }
  ],

  "prodOrderCommentsSheet": [
    {
      "id": "99990000-aaaa-bbbb-cccc-dddddddddddd",
      "prodOrderStatus": "Released",
      "prodOrderNo": "RPO-00042",
      "date": "2026-02-01",
      "comment": "Prioritise this order for customer deadline.",
      "code": ""
    }
  ]
}
```

---

## API Page Cross-Reference

| Entity | Page Name | Page ID | Source Table |
|---|---|---|---|
| Production Order | PDCAPI - Production Order | 50005 | Production Order |
| Prod. Order Lines | PDCAPI - Prod. Order Lines | 50006 | Prod. Order Line |
| Prod. Order Components | PDCAPI - Prod.Order Components | 50007 | Prod. Order Component |
| Prod. Order Routing | PDCAPI - Prod. Order Routing | 50013 | Prod. Order Routing Line |
| Prod. Order Comment Sheet | PDCAPI - Prod.Order Com. Sheet | 50014 | Prod. Order Comment Line |
