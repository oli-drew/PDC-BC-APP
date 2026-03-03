# Carbonfact Integration - Overview

## What is Carbonfact?

Carbonfact is a Paris-based carbon footprint calculation service for the fashion and textiles industry. It analyses product composition, packaging, manufacturing locations, and lifecycle data to calculate the carbon emissions (CO2e) associated with each garment.

## Integration Summary

The PDC Carbonfact integration connects Business Central with Carbonfact by:

1. **Exporting product data** - Item details, fabric composition, packaging, and lifecycle parameters as Excel files
2. **Exporting purchase order data** - Receipt quantities, factory locations, and transport distances as Excel files
3. **Importing CO2e results** - CSV upload from Carbonfact with calculated carbon footprint values per SKU
4. **Extending the Item Creation Engine** - New fields (Net Weight, GTIN, Tariff No.) and automatic fabric attribute propagation
5. **Extending Consolidated Invoices** - 68 new columns for fabric composition, contract status, branch hierarchy, and geographic data

---

## Key Concepts

### Carbonfact-Enabled Items

Only items flagged with **Carbonfact Enabled = Yes** on the Item Card are included in exports. This flag controls which items appear in Product Data and Purchase Order exports.

### Fabric Attributes (IDs 12-70)

Fabric composition is stored using Business Central's standard Item Attributes feature. Attribute IDs 12-70 represent specific material/construction/recycled combinations (e.g., "Polyester, Woven, Non-Recycled"). The numeric value of each attribute is the percentage of that material in the garment.

### Item Category Defaults

Each Item Category can be configured with Carbonfact defaults for lifecycle data, packaging specifications, and fallback values. When item-level data is missing (e.g., no Net Weight, no Country of Origin), the system falls back to the Item Category defaults.

### Care Label Composition

The care label is automatically built from an item's fabric attributes, sorted by percentage in descending order. Example: `45% Non-Recycled Cotton 30% Recycled Nylon 25% Non-Recycled Polyester`. Items without attributes use the category's default care label.

### CO2e Propagation

Production items inherit carbon emissions data from their consuming garment (the parent item on BOM line 10000). This propagation can be triggered manually from the Role Center after importing updated CO2e values.

---

## Module Components

| Component | Type | Purpose |
|-----------|------|---------|
| [Setup](../setup/carbonfact-setup.md) | Setup | Item Categories, Country/Region, Item flags |
| [Product Data Export](../processes/carbonfact-export.md#product-data-export) | Process | 3-sheet Excel export (Products, Packaging, BOM) |
| [Purchase Order Export](../processes/carbonfact-export.md#purchase-order-export) | Process | Purchase receipt export with transport distances |
| [Item Creation Engine](../processes/carbonfact-item-creation.md) | Process | Enhanced item creation with Carbonfact fields |
| [CF Consolidated Invoice](../processes/carbonfact-consolidated-invoice.md) | Process | Dedicated report (50066) with 68 attribute and hierarchy columns |

---

## Workflow

```
                         Business Central
                    +-----------------------+
                    |                       |
  Setup             |  1. Configure         |
  (one-time)        |     - Item Categories |
                    |     - Country/Region  |
                    |     - Enable Items    |
                    |                       |
                    +-----------+-----------+
                                |
                    +-----------v-----------+
                    |                       |
  Regular           |  2. Export            |
  (periodic)        |     - Product Data    |
                    |     - Purchase Orders |
                    |                       |
                    +-----------+-----------+
                                |
                       Upload to Carbonfact
                                |
                    +-----------v-----------+
                    |                       |
                    |  3. Carbonfact        |
                    |     calculates CO2e   |
                    |                       |
                    +-----------+-----------+
                                |
                      Download CSV results
                                |
                    +-----------v-----------+
                    |                       |
  Regular           |  4. Import CO2e       |
  (periodic)        |     from CSV file     |
                    |     + Propagate CO2e  |
                    |                       |
                    +-----------+-----------+
                                |
                    +-----------v-----------+
                    |                       |
  Reporting         |  5. Consolidated      |
                    |     Invoice with      |
                    |     fabric data       |
                    |                       |
                    +-----------------------+
```

---

## Objects Reference

### New Objects

| Type | ID | Name | Description |
|------|----|------|-------------|
| Table | 50005 | PDC Item Creation Attribute | Subtable storing item attributes per journal line before item creation |
| Table Extension | 50058 | PDC Item Category CF | 18 Carbonfact fields on Item Category |
| Page | 50040 | PDC Item Creation Attributes | StandardDialog for editing journal line attributes |
| Report | 50064 | PDC CF Product Data Export | Product Data Excel wrapper |
| Report | 50065 | PDC CF Purchase Export | Purchase Order Excel wrapper |
| Report | 50066 | PDC CF Consolidate Invoices | Consolidation report with 68 Carbonfact columns |
| Report | 50067 | PDC CF Import CO2e | CO2e CSV import with optional propagation to production items |

### Modified Objects

| Type | ID | Name | Changes |
|------|----|------|---------|
| Table | 50014 | PDC Consolidation Buffer | +68 fields (attributes, branches, post code) |
| Table | 50033 | PDC Item Creation Engine | +3 fields (Net Weight, GTIN, Tariff No.), OnDelete cascade to subtable |
| Table Extension | 50000 | PDC Country/Region | +2 fields (Truck Km, Ship Km) |
| Table Extension | 50005 | PDC Item | +1 field (Carbonfact Enabled) |
| Report | 50013 | PDC Implement Items | Copies new fields to created items |
| Report | 50058 | PDC Suggest Prod. Items Wksh. | Propagates data from consuming garment to subtable |
| Page | 50045 | PDC Item Creation Engine | +3 fields, Manage Attributes via subtable dialog |
| Page Extension | 50005 | PDC Item Card | +Carbonfact Enabled field |
| Page Extension | 50042 | PDC Item Category Card | +Carbonfact fields group |
| Page Extension | - | PDC Countries/Regions | +Truck Km, Ship Km fields |

---

## Data Volumes

Based on current PDC data:

| Dataset | Approximate Count |
|---------|-------------------|
| Total items | 132,500 |
| Carbonfact-enabled items | 47,700 |
| Products sheet rows | 47,700 |
| Packaging sheet rows | 95,400 (2 per item) |
| BOM sheet rows | 93,500+ (1+ per item per fabric) |
| Purchase receipts | 39,700 |
| Item Categories | 172 |
| Countries with transport data | 29 |
| Fabric attributes (IDs 12-70) | 59 active + 8 reserved |

---

## Limitations and Known Issues

- **CO2e Import**: Supports CSV files with `sku,footprint,unit` columns. Upload via the **Import CO2e from CSV** action on the Role Center.
- **RDLC Layout**: The CF Consolidated Invoice report (50066) layout needs manual updating in Visual Studio to display the 68 new columns visually.
- **Attribute percentages**: A small number of items (15) have fabric percentages that do not sum to 100% (e.g., 75%). This is a known data quality issue.
- **Orphan purchase entries**: Approximately 5,400 purchase entries are missing attributes, COO, or mass data.
