# Item Creation Engine - Carbonfact Fields

## Overview

The Item Creation Engine (page 50045) has been extended with three new fields and a new action to support Carbonfact data. These fields are populated during item creation and propagated between purchase and production items.

---

## New Fields on Item Creation Worksheet

| Field | Type | Description |
|-------|------|-------------|
| Net Weight | Decimal | Net weight of the item in kilograms (min 0, up to 5 decimal places). |
| GTIN | Code[14] | Global Trade Item Number (barcode). |
| Tariff No. | Code[20] | Commodity/tariff classification code. Lookup to the Tariff Number table. |

These fields appear in the worksheet repeater alongside existing item data.

---

## Manage Attributes Action

The **Manage Attributes** action opens a StandardDialog (page 50040) that edits attributes stored in the **PDC Item Creation Attribute** subtable (table 50005). Attributes are stored per journal line and do not require the item to exist yet.

### How to Use

1. Select a row in the Item Creation Engine worksheet
2. Click **Manage Attributes** in the action bar
3. A dialog lists all defined Item Attributes with their current values (pre-populated from the subtable if values exist)
4. Type or modify attribute values as needed (e.g., fabric composition percentages)
5. Click **OK** to save — values are written to the subtable

When **Insert Items** runs, the subtable data is applied to the real Item Attribute Value Mapping table on the newly created item. The subtable records are then cleaned up automatically when the journal lines are deleted.

### Important

- Attributes can be managed at any time — before or after running Suggest Items
- For Production batches, **Suggest Items** automatically copies attributes from the consuming garment to the subtable
- Deleting a journal line automatically deletes its subtable attribute records

---

## Purchase Item Creation (Report 50013)

When creating purchase items via the **Insert Items** action, the following fields are now copied from the worksheet to the new Item record:

| Worksheet Field | Item Table Field | Notes |
|----------------|------------------|-------|
| Net Weight | Item."Net Weight" | Standard BC field (field 42) |
| GTIN | Item.GTIN | Standard BC field (field 1217) |
| Tariff No. | Item."Tariff No." | Standard BC field (field 47) |

These fields are set before the Item.Modify() call, so they are available immediately after item creation.

---

## Production Item Creation (Report 50058)

When suggesting production items on the worksheet, the system automatically propagates data from the **consuming garment** (the parent item found via Production BOM line 10000):

### Fields Propagated

| Source | Target | Description |
|--------|--------|-------------|
| Consuming Item."Net Weight" | Worksheet."Net Weight" | Weight copied from garment |
| Consuming Item.GTIN | Worksheet.GTIN | Barcode copied from garment |
| Consuming Item."Tariff No." | Worksheet."Tariff No." | Tariff code copied from garment |

### Fabric Attributes Copied

All item attribute value mappings (table 7505) from the consuming garment are copied to the **PDC Item Creation Attribute** subtable (table 50005) for the new journal line. This includes all fabric composition attributes (IDs 12-70) and any other attributes assigned to the consuming garment.

When **Insert Items** runs, the subtable data is applied to the real Item Attribute Value Mapping table on the newly created item. This means production items inherit the same fabric composition as their parent garment, which is essential for accurate Carbonfact export data.

### How It Works

1. During **Suggest Items**, the system finds the consuming garment via colour/size/fit matching
2. Net Weight, GTIN, and Tariff No. are copied from the consuming garment to the worksheet
3. All attribute mappings are copied from the consuming garment to the subtable (not directly to Item Attribute Value Mapping)
4. Users can review/edit attributes via **Manage Attributes** before creating items
5. During **Insert Items**, subtable attributes are written to the real Item Attribute Value Mapping table

> **Note**: If no consuming garment is found, the production item is skipped. No error is raised.

---

## CO2e Propagation

Carbon emissions (CO2e) values can be propagated from consuming garments to production items after Carbonfact has calculated and returned CO2e values.

### How to Run

1. From the Role Center, click **Import CO2e** in the Carbonfact group
2. Enable the **Propagate CO2e to production items** option on the request page
3. Import the CSV file — propagation runs automatically after import
4. A message shows: *"CO2e values propagated to X production items."*

### What It Does

For each Carbonfact-enabled item that has a Production BOM:
1. Finds the consuming garment on BOM line 10000
2. Copies the consuming garment's CO2e value to the production item
3. Updates the production item record
