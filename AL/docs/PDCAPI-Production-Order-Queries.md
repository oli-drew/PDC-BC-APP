# PDCAPI — Production Order Aggregation Queries

API documentation for the 9 production order aggregation query endpoints exposed by the PDC extension.

## Contents

- [Overview](#overview)
- [Base URL](#base-url)
- [Common Filters](#common-filters)
- [Group 1: Operation Count Queries](#group-1-operation-count-queries)
- [Group 2: Order Sum Queries](#group-2-order-sum-queries)
- [Group 3: Routing Quantity Queries](#group-3-routing-quantity-queries)
- [Quick Reference](#quick-reference)
- [Notes & Observations](#notes--observations)

---

## Overview

The PDC extension provides **9 read-only API query endpoints** that return aggregated production order data. They are organised into three functional groups, each with a variant for three production order statuses: **Firm Planned**, **Released**, and **Finished**.

| Group | What it returns | Firm Planned | Released | Finished |
|---|---|---|---|---|
| **Operation Count** | Sum of routing line `Input Quantity` | Query 50014 | Query 50018 | Query 50019 |
| **Order Sum** | Sum of production order `Quantity` | Query 50013 | Query 50016 | Query 50017 |
| **Routing Quantity** | Sum of branding `Routing Qty.` per order | Query 50015 | Query 50020 | Query 50021 |

All queries share these API properties:

| Property | Value |
|---|---|
| **API Publisher** | `pdc` |
| **API Group** | `app1` |
| **API Version** | `v2.0` |
| **Query Type** | API |
| **HTTP Method** | GET only (read-only) |

---

## Base URL

```
https://{baseUrl}/api/pdc/app1/v2.0/companies({companyId})/
```

Replace `{baseUrl}` with your Business Central environment URL (e.g. `api.businesscentral.dynamics.com/v2.0/{tenantId}/{environment}`).

---

## Common Filters

All 9 queries expose the same two optional filters on the Production Order table:

| Filter Name | Source Field | Type | Description |
|---|---|---|---|
| `creationDateFilter` | `Production Order."Creation Date"` | Date | Filter orders by their creation date |
| `workCenterFilter` | `Production Order."PDC Work Center No."` | Code[20] | Filter orders by PDC work center number |

Filters are applied via `$filter` in the OData query string using standard OData v4 comparison operators.

### Supported Operators

| Operator | Meaning | Example |
|---|---|---|
| `eq` | Equals | `creationDateFilter eq 2026-02-24` |
| `gt` | After | `creationDateFilter gt 2026-01-01` |
| `ge` | On or after | `creationDateFilter ge 2026-01-01` |
| `lt` | Before | `creationDateFilter lt 2026-03-01` |
| `le` | On or before | `creationDateFilter le 2026-02-28` |
| `ne` | Not equal | `creationDateFilter ne 2026-01-01` |

### Filter Examples

**Exact date:**

```http
GET .../{entitySetName}?$filter=creationDateFilter eq 2026-02-24
```

**Date range (between two dates):**

```http
GET .../{entitySetName}?$filter=creationDateFilter ge 2026-01-01 and creationDateFilter le 2026-01-31
```

**After a specific date:**

```http
GET .../{entitySetName}?$filter=creationDateFilter gt 2026-01-01
```

**Work center filter:**

```http
GET .../{entitySetName}?$filter=workCenterFilter eq 'WC-001'
```

**Combined — date range with work center:**

```http
GET .../{entitySetName}?$filter=creationDateFilter ge 2026-02-01 and creationDateFilter le 2026-02-28 and workCenterFilter eq 'WC-001'
```

---

## Group 1: Operation Count Queries

### Purpose

Returns a **single aggregated value**: the sum of `Input Quantity` from all `Prod. Order Routing Line` records linked to production orders of the filtered status.

### Data Structure

```
Production Order (filtered by Status)
  └── Prod. Order Routing Line (INNER JOIN on Status + Prod. Order No.)
        └── column: operationCount = SUM("Input Quantity")
```

### SQL Equivalent

```sql
SELECT SUM(rl."Input Quantity") AS operationCount
FROM "Production Order" po
INNER JOIN "Prod. Order Routing Line" rl
    ON rl.Status = po.Status
    AND rl."Prod. Order No." = po."No."
WHERE po.Status = '{Firm Planned|Released|Finished}'
    [AND po."Creation Date" = @creationDateFilter]
    [AND po."PDC Work Center No." = @workCenterFilter]
```

### Endpoints

| Status | Query ID | Entity Name | Entity Set Name |
|---|---|---|---|
| Firm Planned | 50014 | `firmPlannedProdOrderOperationCountQuery` | `firmPlannedProdOrderOperationCountQueries` |
| Released | 50018 | `releasedProdOrderOperationCountQuery` | `releasedProdOrderOperationCountQueries` |
| Finished | 50019 | `finishedProdOrderOperationCountQuery` | `finishedProdOrderOperationCountQueries` |

### Response Fields

| Field | Source | Aggregation | Description |
|---|---|---|---|
| `operationCount` | `Prod. Order Routing Line."Input Quantity"` | Sum | Total input quantity across all matching routing lines |

### Examples

**Get total routing input quantity for all Released orders:**

```http
GET /api/pdc/app1/v2.0/companies({companyId})/releasedProdOrderOperationCountQueries
```

**Response:**

```json
{
  "value": [
    {
      "operationCount": 542
    }
  ]
}
```

**Filtered by work center:**

```http
GET /api/pdc/app1/v2.0/companies({companyId})/firmPlannedProdOrderOperationCountQueries?$filter=workCenterFilter eq 'WC-001'
```

---

## Group 2: Order Sum Queries

### Purpose

Returns a **single aggregated value**: the sum of `Quantity` from all production orders of the filtered status. There is **no join to routing lines** — this queries the Production Order table directly.

### Data Structure

```
Production Order (filtered by Status)
  └── column: quantity = SUM("Quantity")
```

### SQL Equivalent

```sql
SELECT SUM(po."Quantity") AS quantity
FROM "Production Order" po
WHERE po.Status = '{Firm Planned|Released|Finished}'
    [AND po."Creation Date" = @creationDateFilter]
    [AND po."PDC Work Center No." = @workCenterFilter]
```

### Endpoints

| Status | Query ID | Entity Name | Entity Set Name |
|---|---|---|---|
| Firm Planned | 50013 | `firmPlannedProdOrderSumQuery` | `firmPlannedProdOrderSumQueries` |
| Released | 50016 | `releasedProdOrderSumQuery` | `releasedProdOrderSumQueries` |
| Finished | 50017 | `finishedProdOrderSumQuery` | `finishedProdOrderSumQueries` |

### Response Fields

| Field | Source | Aggregation | Description |
|---|---|---|---|
| `quantity` | `Production Order."Quantity"` | Sum | Total quantity across all matching production orders |

### Examples

**Get total quantity for all Firm Planned orders:**

```http
GET /api/pdc/app1/v2.0/companies({companyId})/firmPlannedProdOrderSumQueries
```

**Response:**

```json
{
  "value": [
    {
      "quantity": 1250
    }
  ]
}
```

**Filtered by creation date:**

```http
GET /api/pdc/app1/v2.0/companies({companyId})/finishedProdOrderSumQueries?$filter=creationDateFilter eq 2026-02-01
```

> **Important:** This sums the `Quantity` field on production order headers — it does **not** count the number of distinct orders. A single order for 100 units contributes 100 to this total, not 1.

---

## Group 3: Routing Quantity Queries

### Purpose

Returns the sum of `Routing Qty.` from the **PDC Branding** table, joined through the routing line chain, grouped by production order quantity. This is the most complex of the three query groups, involving a 4-table join.

### Data Structure

```
Production Order (filtered by Status)
  ├── column: quantity (grouped — production order quantity)
  └── Prod. Order Routing Line (INNER JOIN on Status + Prod. Order No.)
        └── Routing Line (INNER JOIN on Routing No. + Operation No.)
              └── PDC Branding (LEFT OUTER JOIN on Branding No.)
                    └── column: RoutingQtySum = SUM("Routing Qty.")
```

### SQL Equivalent

```sql
SELECT
    po."Quantity" AS quantity,
    SUM(b."Routing Qty.") AS RoutingQtySum
FROM "Production Order" po
INNER JOIN "Prod. Order Routing Line" prl
    ON prl.Status = po.Status
    AND prl."Prod. Order No." = po."No."
INNER JOIN "Routing Line" rl
    ON rl."Routing No." = prl."Routing No."
    AND rl."Operation No." = prl."Operation No."
LEFT OUTER JOIN "PDC Branding" b
    ON b."No." = rl."PDC Branding No."
WHERE po.Status = '{Firm Planned|Released|Finished}'
    [AND po."Creation Date" = @creationDateFilter]
    [AND po."PDC Work Center No." = @workCenterFilter]
GROUP BY po."Quantity"
```

### Key Design Details

- **Routing Line (master)** is joined via an inner join, so only prod. order routing lines that have a corresponding master routing line are included.
- **PDC Branding** is joined via a **left outer join**, so routing lines without a branding record are still included (with `RoutingQtySum` = 0 or null).
- The `quantity` column from the Production Order is a **grouping column** (no aggregation method), so results are grouped by distinct order quantity values.

### Endpoints

| Status | Query ID | Entity Name | Entity Set Name |
|---|---|---|---|
| Firm Planned | 50015 | `firmPlannedProdOrderRoutingQuantityQuery` | `firmPlannedProdOrderRoutingQuantityQueries` |
| Released | 50020 | `releasedProdOrderRoutingQuantityQuery` | `releasedProdOrderRoutingQuantityQueries` |
| Finished | 50021 | `finishedProdOrderRoutingQuantityQuery` | `finishedProdOrderRoutingQuantityQueries` |

### Response Fields

| Field | Source | Aggregation | Description |
|---|---|---|---|
| `quantity` | `Production Order."Quantity"` | Group By | Production order quantity (grouping key) |
| `RoutingQtySum` | `PDC Branding."Routing Qty."` | Sum | Total branding routing quantity for this group |

### Examples

**Get routing quantities for all Released orders:**

```http
GET /api/pdc/app1/v2.0/companies({companyId})/releasedProdOrderRoutingQuantityQueries
```

**Response:**

```json
{
  "value": [
    {
      "quantity": 50,
      "RoutingQtySum": 150
    },
    {
      "quantity": 100,
      "RoutingQtySum": 400
    }
  ]
}
```

In this example, production orders with quantity 50 have a total branding routing quantity of 150, while orders with quantity 100 have a total of 400.

**Filtered by work center:**

```http
GET /api/pdc/app1/v2.0/companies({companyId})/firmPlannedProdOrderRoutingQuantityQueries?$filter=workCenterFilter eq 'WC-001'
```

---

## Quick Reference

### All 9 Endpoints

| # | Query ID | Endpoint (append to base URL) | Returns |
|---|---|---|---|
| 1 | 50013 | `firmPlannedProdOrderSumQueries` | Sum of order quantity (Firm Planned) |
| 2 | 50014 | `firmPlannedProdOrderOperationCountQueries` | Sum of routing input qty (Firm Planned) |
| 3 | 50015 | `firmPlannedProdOrderRoutingQuantityQueries` | Branding routing qty by order qty (Firm Planned) |
| 4 | 50016 | `releasedProdOrderSumQueries` | Sum of order quantity (Released) |
| 5 | 50017 | `finishedProdOrderSumQueries` | Sum of order quantity (Finished) |
| 6 | 50018 | `releasedProdOrderOperationCountQueries` | Sum of routing input qty (Released) |
| 7 | 50019 | `finishedProdOrderOperationCountQueries` | Sum of routing input qty (Finished) |
| 8 | 50020 | `releasedProdOrderRoutingQuantityQueries` | Branding routing qty by order qty (Released) |
| 9 | 50021 | `finishedProdOrderRoutingQuantityQueries` | Branding routing qty by order qty (Finished) |

### Source File Reference

| Query ID | AL Object Name | Source File |
|---|---|---|
| 50013 | PDCAPI - FirmProdOrderSumQuery | `src/query/PDCAPIFirmProdOrderSumQuery.Query.al` |
| 50014 | PDCAPI - FirmProdOrdOpCntQuery | `src/query/PDCAPIFirmProdOrdOpCntQuery.Query.al` |
| 50015 | PDCAPI - FirmProdOrdRoutQtyQue | `src/query/PDCAPIFirmProdOrdRoutQtyQue.Query.al` |
| 50016 | PDCAPI - RelProdOrderSumQuery | `src/query/PDCAPIRelProdOrderSumQuery.Query.al` |
| 50017 | PDCAPI - FinProdOrderSumQuery | `src/query/PDCAPIFinProdOrderSumQuery.Query.al` |
| 50018 | PDCAPI - RelProdOrdOpCntQuery | `src/query/PDCAPIRelProdOrdOpCntQuery.Query.al` |
| 50019 | PDCAPI - FinProdOrdOpCntQuery | `src/query/PDCAPIFinProdOrdOpCntQuery.Query.al` |
| 50020 | PDCAPI - RelProdOrdRoutQtyQue | `src/query/PDCAPIRelProdOrdRoutQtyQue.Query.al` |
| 50021 | PDCAPI - FinProdOrdRoutQtyQue | `src/query/PDCAPIFinProdOrdRoutQtyQue.Query.al` |

---

## Notes & Observations

| # | Observation | Severity |
|---|---|---|
| 1 | **Operation Count naming is misleading.** The column `operationCount` actually sums `Input Quantity`, not a count of distinct operations. If the intent is to count operations, `Method = Count` should be used instead. If summing quantity is intended, a name like `inputQuantitySum` would be clearer. | ⚠️ Medium |
| 2 | **Order Sum queries return a quantity total, not an order count.** The column `quantity` sums the `Quantity` field across all orders — a single order for 100 units contributes 100, not 1. If a count of orders is needed, `Method = Count` on a different field (e.g. `No.`) would be required. | ⚠️ Medium |
| 3 | **Routing Quantity queries use a 4-table join with a left outer join to PDC Branding.** Production orders whose routing lines have no associated branding record will still appear in results, but with `RoutingQtySum` as 0 or null. | ℹ️ Info |
| 4 | **Routing Quantity results are grouped by order quantity**, not by production order number. Multiple orders with the same `Quantity` value will be aggregated into a single row. | ℹ️ Info |
| 5 | **No filter for production order number.** None of the 9 queries allow filtering by a specific `Prod. Order No.` — they always aggregate across all orders of the given status. | ℹ️ Info |
| 6 | **Operation Count and Routing Quantity queries have empty `OnBeforeOpen` triggers** that could be removed for cleanliness. The Order Sum queries do not have this trigger at all. | 🔵 Low |
