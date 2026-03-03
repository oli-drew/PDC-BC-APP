# Consolidated Invoice - Carbonfact Extension

## Overview

A dedicated Carbonfact Consolidated Invoice report (Report 50066 "PDC CF Consolidate Invoices") provides 68 data columns for carbon footprint reporting. This is a separate report from the standard Consolidated Invoice (Report 50004). The columns provide fabric composition percentages, contract status flags, ship-to post codes, and branch hierarchy levels for each invoice line.

---

## New Columns

### Contract Status (4 columns)

Boolean flags indicating whether the invoiced item matches its contract specification for each attribute.

| Column | Attribute ID | Description |
|--------|-------------|-------------|
| Contract Item | 8 | Item is on the contract |
| Contract Colour | 9 | Colour matches contract |
| Contract Size | 10 | Size matches contract |
| Contract Branding | 11 | Branding matches contract |

A value of **Yes** means the item has the corresponding attribute assigned (i.e., it is an attribute value mapping in table 7505 for that attribute ID). **No** means the attribute is not assigned.

### Ship-to Post Code (1 column)

| Column | Source | Description |
|--------|--------|-------------|
| Ship-to Post Code | Document Header | The post code from the ship-to address on the sales invoice or credit memo. |

### Branch Hierarchy (4 columns)

The customer's branch hierarchy, resolved by walking the parent branch chain.

| Column | Description | Example |
|--------|-------------|---------|
| Branch Level 0 | Top-level branch (indentation 0) | `Head Office` |
| Branch Level 1 | Second-level branch (indentation 1) | `North Region` |
| Branch Level 2 | Third-level branch (indentation 2) | `Manchester District` |
| Branch Level 3 | Bottom-level branch (indentation 3) | `Store 42` |

The branch level columns are populated by looking up the invoice's branch and walking up the parent chain:
- If the branch is at indentation 3, all four levels are populated
- If the branch is at indentation 0, only Branch Level 0 is populated
- Intermediate branches populate from their level upward to Level 0

### Fabric Composition (59 columns)

Decimal percentage values for each fabric attribute (IDs 12-70). Each column represents a specific material, construction method, and recycled status combination.

| Column | Attr ID | Material |
|--------|---------|----------|
| Polyester Woven Non-Recycled | 12 | Polyester, woven construction, non-recycled |
| Polyester Woven Recycled | 13 | Polyester, woven construction, recycled |
| Polyester Knitted Non-Recycled | 14 | Polyester, knitted construction, non-recycled |
| Polyester Knitted Recycled | 15 | Polyester, knitted construction, recycled |
| Cotton Woven Non-Recycled | 16 | Cotton, woven construction, non-recycled |
| Cotton Woven Recycled | 17 | Cotton, woven construction, recycled |
| Cotton Knitted Non-Recycled | 18 | Cotton, knitted construction, non-recycled |
| Cotton Knitted Recycled | 19 | Cotton, knitted construction, recycled |
| Wool Woven Non-Recycled | 20 | Wool, woven |
| Wool Woven Recycled | 21 | Wool, woven, recycled |
| Wool Knitted Non-Recycled | 22 | Wool, knitted |
| Wool Knitted Recycled | 23 | Wool, knitted, recycled |
| Nylon Woven Non-Recycled | 24 | Nylon, woven |
| Nylon Woven Recycled | 25 | Nylon, woven, recycled |
| Nylon Knitted Non-Recycled | 26 | Nylon, knitted |
| Nylon Knitted Recycled | 27 | Nylon, knitted, recycled |
| Viscose Woven Non-Recycled | 28 | Viscose, woven |
| Viscose Woven Recycled | 29 | Viscose, woven, recycled |
| Viscose Knitted Non-Recycled | 30 | Viscose, knitted |
| Viscose Knitted Recycled | 31 | Viscose, knitted, recycled |
| Lycra-Spandex Woven Non-Recycled | 32 | Lycra/Spandex, woven |
| Lycra-Spandex Woven Recycled | 33 | Lycra/Spandex, woven, recycled |
| Lycra-Spandex Knitted Non-Recycled | 34 | Lycra/Spandex, knitted |
| Lycra-Spandex Knitted Recycled | 35 | Lycra/Spandex, knitted, recycled |
| Other Woven Non-Recycled | 36 | Other materials, woven |
| Other Woven Recycled | 37 | Other materials, woven, recycled |
| Other Knitted Non-Recycled | 38 | Other materials, knitted |
| Other Knitted Recycled | 39 | Other materials, knitted, recycled |
| Leather Non-Recycled | 40 | Leather |
| Leather Recycled | 41 | Leather, recycled |
| Plastic Non-Recycled | 42 | Plastic |
| Plastic Recycled | 43 | Plastic, recycled |
| Kevlar Woven Non-Recycled | 44 | Kevlar, woven |
| ABS Plastic Moulded Non-Recycled | 45 | ABS Plastic, moulded |
| Acrylic Woven Non-Recycled | 46 | Acrylic, woven |
| Aramid Woven Non-Recycled | 47 | Aramid, woven |
| Metal Cast Non-Recycled | 48 | Metal, cast |
| Polyamide Woven Non-Recycled | 49 | Polyamide, woven |
| Polycarbonate Moulded Non-Recycled | 50 | Polycarbonate, moulded |
| Polyethylene Moulded Non-Recycled | 51 | Polyethylene, moulded |
| Polypropylene Woven Non-Recycled | 52 | Polypropylene, woven |
| Polyurethane Moulded Non-Recycled | 53 | Polyurethane, moulded |
| PVC Moulded Non-Recycled | 54 | PVC, moulded |
| Rubber Moulded Non-Recycled | 55 | Rubber, moulded |
| Carbon Fibre Woven Non-Recycled | 56 | Carbon Fibre, woven |
| Cashmere Woven Non-Recycled | 57 | Cashmere, woven |
| Cashmere Knitted Non-Recycled | 58 | Cashmere, knitted |
| Acrylic Knitted Non-Recycled | 59 | Acrylic, knitted |
| Acrylic Knitted Recycled | 60 | Acrylic, knitted, recycled |
| Bamboo Woven Non-Recycled | 61 | Bamboo, woven |
| Bamboo Woven Recycled | 62 | Bamboo, woven, recycled |
| Reserved 63-70 | 63-70 | Reserved for future materials |

Values represent the percentage of that material in the garment (e.g., 45 = 45% of the garment is that material). Items with no fabric attributes will show 0 in all columns.

---

## How Data is Populated

When the Consolidated Invoice report runs, each invoice line is enriched with:

1. **Fabric Attributes**: The system looks up item attribute value mappings (table 7505) for the invoiced item. Contract attributes (IDs 8-11) set Boolean flags. Fabric attributes (IDs 12-70) set percentage values using the formula: Buffer Field ID = Attribute ID + 24.

2. **Branch Hierarchy**: The system reads the PDC Branch record for the invoice line's branch, then walks the parent branch chain upward through indentation levels 0-3 to populate all branch level columns.

3. **Ship-to Post Code**: The system reads the Ship-to Post Code from the document header (Sales Invoice Header for invoices, Sales Cr. Memo Header for credit memos).

---

## Usage in BI and Reporting

The new columns in the consolidated invoice output enable:

- **Carbon footprint analysis** by material composition across all invoiced items
- **Contract compliance reporting** showing which items match contract specifications
- **Geographic analysis** using ship-to post codes and branch hierarchy
- **Material breakdown** for sustainability reporting and Carbonfact data validation

The data can be exported to Excel and used in Power BI or other BI tools for further analysis.

---

## RDLC Layout

The RDLC layout for Report 50066 needs to be updated separately in Visual Studio to display the new columns. The data columns are already available in the report dataset - only the visual layout needs updating.
