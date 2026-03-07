# Paperless Picking API Specification

## Base URL

```
https://api.businesscentral.dynamics.com/v2.0/{tenant-id}/{environment}/api/pdc/app1/v2.0
```

For the Dev2 sandbox:

```
https://api.businesscentral.dynamics.com/v2.0/993d2581-abc5-4140-a9f5-36eb0718f6a0/Dev2/api/pdc/app1/v2.0
```

## Authentication

OAuth 2.0 Bearer token. All requests require:

```
Authorization: Bearer {access_token}
Content-Type: application/json
```

---

## Endpoints

### 1. Trolleys

Master data for physical trolleys.

| Method | Endpoint                | Description          |
| ------ | ----------------------- | -------------------- |
| GET    | `/trolleys`             | List all trolleys    |
| GET    | `/trolleys({systemId})` | Get a single trolley |
| POST   | `/trolleys`             | Create a trolley     |
| PATCH  | `/trolleys({systemId})` | Update a trolley     |
| DELETE | `/trolleys({systemId})` | Delete a trolley     |

#### Fields

| Field          | Type        | Writable | Description                                                         |
| -------------- | ----------- | -------- | ------------------------------------------------------------------- |
| `systemId`     | GUID        | No       | System identifier (primary key for API)                             |
| `code`         | String(20)  | Yes      | Unique trolley code (e.g. "A", "B", "C")                            |
| `description`  | String(100) | Yes      | Description                                                         |
| `blocked`      | Boolean     | Yes      | If true, trolley cannot be assigned to picks                        |
| `defaultSlots` | Integer     | Yes      | Default number of slot positions                                    |
| `maxSlots`     | Integer     | Yes      | Maximum slot positions allowed                                      |
| `activePicks`  | Integer     | No       | Number of inventory picks currently using this trolley (calculated) |

#### Examples

**List all trolleys:**

```http
GET /trolleys
```

```json
{
  "value": [
    {
      "systemId": "a1b2c3d4-...",
      "code": "A",
      "description": "Trolley A - Main Floor",
      "blocked": false,
      "defaultSlots": 8,
      "maxSlots": 12,
      "activePicks": 2
    }
  ]
}
```

**Get available (unblocked) trolleys with no active picks:**

```http
GET /trolleys?$filter=blocked eq false and activePicks eq 0
```

**Create a trolley:**

```http
POST /trolleys
Content-Type: application/json

{
  "code": "E",
  "description": "Trolley E - Overflow",
  "defaultSlots": 6,
  "maxSlots": 10
}
```

---

### 2. Inventory Picks

Warehouse activity headers filtered to inventory picks only.

| Method | Endpoint                      | Description                               |
| ------ | ----------------------------- | ----------------------------------------- |
| GET    | `/inventoryPicks`             | List all inventory picks                  |
| GET    | `/inventoryPicks({systemId})` | Get a single pick (includes nested lines) |
| PATCH  | `/inventoryPicks({systemId})` | Update a pick (e.g. assign trolley)       |

> Insert and Delete are disabled — picks are created/deleted via standard BC warehouse processes.

#### Fields

| Field                      | Type       | Writable | Description                                            |
| -------------------------- | ---------- | -------- | ------------------------------------------------------ |
| `systemId`                 | GUID       | No       | System identifier                                      |
| `no`                       | String(20) | No       | Pick document number                                   |
| `sourceNo`                 | String(20) | No       | Source document number (Sales Order)                   |
| `locationCode`             | String(10) | No       | Warehouse location                                     |
| `assignedUserID`           | String(50) | No       | BC assigned user                                       |
| `pdcSalesDocCreatedAt`     | DateTime   | No       | When the source sales document was created             |
| `pdcShippingAgentCode`     | String(10) | No       | Shipping agent code                                    |
| `pdcShippingAgentServCode` | String(10) | No       | Shipping agent service code                            |
| `pdcNumberOfPackages`      | Integer    | Yes      | Number of packages for shipping                        |
| `pdcDateOfFirstPrinting`   | Date       | No       | Date pick was first printed                            |
| `pdcTimeOfFirstPrinting`   | Time       | No       | Time pick was first printed                            |
| `pdcShipToPostCode`        | String(20) | No       | Ship-to post code                                      |
| `pdcShipToCountryRegCode`  | String(10) | No       | Ship-to country/region code                            |
| `pdcUrgent`                | Boolean    | No       | Whether this pick is urgent                            |
| `pdcPackageType`           | String     | No       | Package type                                           |
| `pdcPickStatus`            | Enum       | No       | `Pending`, `In Progress`, or `Complete` (auto-managed) |
| `pdcTrolleyCode`           | String(20) | **Yes**  | Trolley assignment — triggers slot creation/deletion   |
| `pdcPickedBy`              | String(50) | No       | User who started picking (auto-set on trolley assign)  |
| `pdcPickStartedAt`         | DateTime   | No       | When picking started (auto-set)                        |
| `pdcPickCompletedAt`       | DateTime   | No       | When picking completed (auto-set)                      |
| `pdcTotalQuantity`         | Decimal    | No       | Total quantity across all lines (calculated)           |
| `pdcUniqueWearers`         | Integer    | No       | Distinct wearers on this pick (calculated)             |
| `pdcTotalLines`            | Integer    | No       | Total number of pick lines (calculated)                |
| `pdcTrolleyDefaultSlots`   | Integer    | No       | Default slots from assigned trolley (FlowField)        |
| `pdcTrolleyMaxSlots`       | Integer    | No       | Max slots from assigned trolley (FlowField)            |

#### Nested Part: `inventoryPickLines`

Each pick includes its lines as a nested entity (see Pick Lines section below).

#### Examples

**List all picks with status "In Progress":**

```http
GET /inventoryPicks?$filter=pdcPickStatus eq 'In Progress'
```

**Get a single pick with its lines:**

```http
GET /inventoryPicks({systemId})
```

```json
{
  "systemId": "f5e6d7c8-...",
  "no": "PICK-001234",
  "sourceNo": "SO-005678",
  "locationCode": "MAIN",
  "pdcPickStatus": "In Progress",
  "pdcTrolleyCode": "A",
  "pdcPickedBy": "JOHN",
  "pdcPickStartedAt": "2026-03-05T09:30:00Z",
  "pdcPickCompletedAt": "0001-01-01T00:00:00Z",
  "pdcTotalQuantity": 15,
  "pdcUniqueWearers": 3,
  "pdcTotalLines": 8,
  "pdcTrolleyDefaultSlots": 8,
  "pdcTrolleyMaxSlots": 12,
  "pdcUrgent": true,
  "inventoryPickLines": [
    {
      "systemId": "a1a1a1a1-...",
      "lineNo": 10000,
      "itemNo": "ITEM-001",
      "description": "Blue Polo Shirt",
      "quantity": 2,
      "qtyToHandle": 2,
      "pdcSlotNo": 1,
      "pdcWearerID": "W001",
      "pdcWearerName": "John Smith"
    }
  ]
}
```

**Assign a trolley to a pick (triggers slot creation + status change to In Progress):**

```http
PATCH /inventoryPicks({systemId})
Content-Type: application/json
If-Match: *

{
  "pdcTrolleyCode": "A"
}
```

**Clear the trolley assignment (resets status to Pending, deletes all slots):**

```http
PATCH /inventoryPicks({systemId})
Content-Type: application/json
If-Match: *

{
  "pdcTrolleyCode": ""
}
```

**List pending picks ordered by urgency then creation date:**

```http
GET /inventoryPicks?$filter=pdcPickStatus eq 'Pending'&$orderby=pdcUrgent desc,pdcSalesDocCreatedAt asc
```

**List picks on a specific trolley:**

```http
GET /inventoryPicks?$filter=pdcTrolleyCode eq 'A'
```

---

### 3. Inventory Pick Lines

Individual pick lines. Available both as nested entities on a pick header and independently.

| Method | Endpoint                                   | Description                          |
| ------ | ------------------------------------------ | ------------------------------------ |
| GET    | `/inventoryPicks({id})/inventoryPickLines` | Lines for a specific pick (nested)   |
| GET    | `/inventoryPickLines`                      | All pick lines (standalone)          |
| GET    | `/inventoryPickLines({systemId})`          | Single line                          |
| PATCH  | `/inventoryPickLines({systemId})`          | Update a line (e.g. set qtyToHandle) |

> Insert and Delete are disabled.

#### Fields

| Field                  | Type        | Writable | Description                                                     |
| ---------------------- | ----------- | -------- | --------------------------------------------------------------- |
| `systemId`             | GUID        | No       | System identifier                                               |
| `lineNo`               | Integer     | No       | Line number                                                     |
| `no`                   | String(20)  | No       | Parent pick document number                                     |
| `sourceNo`             | String(20)  | No       | Source document number                                          |
| `sourceLineNo`         | Integer     | No       | Source document line number                                     |
| `itemNo`               | String(20)  | No       | Item number                                                     |
| `description`          | String(100) | No       | Item description                                                |
| `binCode`              | String(20)  | No       | Bin code (pick location)                                        |
| `quantity`             | Decimal     | No       | Required quantity                                               |
| `qtyOutstanding`       | Decimal     | No       | Quantity still outstanding                                      |
| `qtyToHandle`          | Decimal     | **Yes**  | Quantity to handle — **this is how the picker confirms a pick** |
| `unitOfMeasureCode`    | String(10)  | No       | Unit of measure                                                 |
| `variantCode`          | String(10)  | No       | Item variant code                                               |
| `locationCode`         | String(10)  | No       | Location code                                                   |
| `pdcProductCode`       | String(20)  | No       | PDC product code                                                |
| `pdcWearerID`          | String(30)  | No       | Wearer ID                                                       |
| `pdcWearerName`        | String(100) | No       | Wearer name                                                     |
| `pdcCustomerReference` | String(35)  | No       | Customer reference                                              |
| `pdcWebOrderNo`        | String(35)  | No       | Web order number                                                |
| `pdcOrderedByID`       | String(30)  | No       | Ordered by ID                                                   |
| `pdcOrderedByName`     | String(100) | No       | Ordered by name                                                 |
| `pdcBranchNo`          | String(20)  | No       | Branch number                                                   |
| `pdcOrderedByPhone`    | String(30)  | No       | Ordered by phone                                                |
| `pdcSlotNo`            | Integer     | No       | Assigned trolley slot number (auto-assigned)                    |
| `pdcColour`            | String(30)  | No       | Colour                                                          |
| `pdcSize`              | String(20)  | No       | Size                                                            |
| `pdcFit`               | String(20)  | No       | Fit                                                             |
| `pdcInventory`         | Decimal     | No       | Available inventory                                             |
| `pdcVendorNo`          | String(20)  | No       | Vendor number                                                   |
| `pdcVendorSKU`         | String(30)  | No       | Vendor SKU                                                      |

#### Examples

**Get all lines for a pick, grouped by slot:**

```http
GET /inventoryPicks({systemId})/inventoryPickLines?$orderby=pdcSlotNo,lineNo
```

**Get lines for a specific slot:**

```http
GET /inventoryPickLines?$filter=no eq 'PICK-001234' and pdcSlotNo eq 1
```

**Mark a line as picked (set qty to handle = full quantity):**

```http
PATCH /inventoryPickLines({systemId})
Content-Type: application/json
If-Match: *

{
  "qtyToHandle": 2
}
```

> This triggers `CheckSlotComplete` and `CheckPickComplete` automatically. When all lines in a slot have `qtyToHandle = quantity`, the slot status changes to `Complete`. When all slots are complete, the pick status changes to `Complete`.

**Mark a line as not picked (zero out qty to handle):**

```http
PATCH /inventoryPickLines({systemId})
Content-Type: application/json
If-Match: *

{
  "qtyToHandle": 0
}
```

**Partial pick (e.g. only 1 of 3 available):**

```http
PATCH /inventoryPickLines({systemId})
Content-Type: application/json
If-Match: *

{
  "qtyToHandle": 1
}
```

---

### 4. Trolley Slots

Slot positions on a trolley, each representing one wearer's items within a pick.

| Method | Endpoint                                             | Description            |
| ------ | ---------------------------------------------------- | ---------------------- |
| GET    | `/trolleySlots`                                      | List all slots         |
| GET    | `/trolleySlots({systemId})`                          | Get a single slot      |
| POST   | `/trolleySlots({systemId})/Microsoft.NAV.deleteSlot` | Delete a slot (action) |

> Slots are auto-created when a trolley is assigned to a pick, and auto-deleted when the trolley is cleared. Insert/Delete via standard CRUD are disabled. Use the `deleteSlot` action instead.

#### Fields

| Field              | Type        | Writable | Description                                                    |
| ------------------ | ----------- | -------- | -------------------------------------------------------------- |
| `systemId`         | GUID        | No       | System identifier                                              |
| `entryNo`          | Integer     | No       | Auto-increment entry number                                    |
| `trolleyCode`      | String(20)  | No       | Trolley this slot belongs to                                   |
| `slotNo`           | Integer     | No       | Slot position number on the trolley                            |
| `invPickNo`        | String(20)  | No       | Inventory pick this slot is for                                |
| `pdcWearerID`      | String(30)  | No       | Wearer assigned to this slot                                   |
| `pdcWearerName`    | String(100) | No       | Wearer name                                                    |
| `status`           | Enum        | No       | `Pending` or `Complete` (auto-managed)                         |
| `totalLines`       | Integer     | No       | Number of pick lines in this slot (calculated)                 |
| `totalQty`         | Decimal     | No       | Total quantity to pick for this slot (calculated)              |
| `qtyHandled`       | Decimal     | No       | Quantity handled so far (calculated)                           |
| `splitFromEntryNo` | Integer     | No       | If this slot was created by splitting, the source entry number |

#### Examples

**Get all slots for a specific trolley:**

```http
GET /trolleySlots?$filter=trolleyCode eq 'A'&$orderby=slotNo
```

**Get all slots for a specific pick:**

```http
GET /trolleySlots?$filter=invPickNo eq 'PICK-001234'&$orderby=slotNo
```

```json
{
  "value": [
    {
      "systemId": "b2c3d4e5-...",
      "entryNo": 1,
      "trolleyCode": "A",
      "slotNo": 1,
      "invPickNo": "PICK-001234",
      "pdcWearerID": "W001",
      "pdcWearerName": "John Smith",
      "status": "Complete",
      "totalLines": 3,
      "totalQty": 5,
      "qtyHandled": 5,
      "splitFromEntryNo": 0
    },
    {
      "systemId": "c3d4e5f6-...",
      "entryNo": 2,
      "trolleyCode": "A",
      "slotNo": 2,
      "invPickNo": "PICK-001234",
      "pdcWearerID": "W002",
      "pdcWearerName": "Jane Doe",
      "status": "Pending",
      "totalLines": 5,
      "totalQty": 10,
      "qtyHandled": 3,
      "splitFromEntryNo": 0
    }
  ]
}
```

**Delete a slot (moves its lines to the first remaining slot):**

```http
POST /trolleySlots({systemId})/Microsoft.NAV.deleteSlot
```

> Returns 204 No Content on success. Cannot delete the last slot — clear the trolley assignment instead.

---

## Common Workflows

### 1. Start Picking

```
1. GET  /inventoryPicks?$filter=pdcPickStatus eq 'Pending'&$orderby=pdcUrgent desc
   → Choose a pick to work on

2. GET  /trolleys?$filter=blocked eq false and activePicks eq 0
   → Choose an available trolley

3. PATCH /inventoryPicks({pickSystemId})  { "pdcTrolleyCode": "A" }
   → Assigns trolley, creates slots (1 per wearer), sets status to "In Progress"

4. GET  /trolleySlots?$filter=invPickNo eq '{pickNo}'&$orderby=slotNo
   → Get the slot layout for the trolley display

5. GET  /inventoryPicks({pickSystemId})/inventoryPickLines?$orderby=pdcSlotNo,lineNo
   → Get lines grouped by slot for the picking UI
```

### 2. Pick Items

```
For each item scanned/confirmed:

1. Find the line:
   GET /inventoryPickLines?$filter=no eq '{pickNo}' and itemNo eq '{scannedItem}'

2. Mark as picked:
   PATCH /inventoryPickLines({lineSystemId})  { "qtyToHandle": {quantity} }
   → Slot and pick status auto-update

3. Refresh slot status:
   GET /trolleySlots?$filter=invPickNo eq '{pickNo}'&$orderby=slotNo
   → Check which slots are complete
```

### 3. Complete & Post

```
1. Verify all slots are complete:
   GET /trolleySlots?$filter=invPickNo eq '{pickNo}' and status eq 'Pending'
   → Should return empty if all done

2. The pick's pdcPickStatus will be "Complete" automatically

3. Posting is done via standard BC — not through custom API
```

### 4. Reassign Trolley

```
PATCH /inventoryPicks({pickSystemId})  { "pdcTrolleyCode": "B" }
→ Deletes old slots, creates new slots on trolley B, preserves pick status
```

---

## Status Flow

### Pick Status

```
Pending  ──(assign trolley)──▶  In Progress  ──(all slots complete)──▶  Complete
                                     ▲                                      │
                                     └──────(line updated, incomplete)──────┘
```

### Slot Status

```
Pending  ──(all lines qtyToHandle = quantity)──▶  Complete
    ▲                                                │
    └──────(any line qtyToHandle < quantity)──────────┘
```

---

## OData Query Reference

| Operation     | Syntax                               |
| ------------- | ------------------------------------ |
| Filter        | `$filter=field eq 'value'`           |
| Sort          | `$orderby=field asc` or `desc`       |
| Select fields | `$select=field1,field2`              |
| Top N         | `$top=10`                            |
| Count         | `$count=true`                        |
| Expand nested | `$expand=inventoryPickLines`         |
| Combine       | `?$filter=...&$orderby=...&$top=...` |

### Filter operators

| Operator     | Example                                            |
| ------------ | -------------------------------------------------- |
| `eq`         | `pdcPickStatus eq 'Pending'`                       |
| `ne`         | `pdcPickStatus ne 'Complete'`                      |
| `gt` / `ge`  | `pdcTotalQuantity gt 10`                           |
| `lt` / `le`  | `activePicks le 0`                                 |
| `and` / `or` | `pdcUrgent eq true and pdcPickStatus eq 'Pending'` |
| `contains`   | `contains(description, 'Polo')`                    |
