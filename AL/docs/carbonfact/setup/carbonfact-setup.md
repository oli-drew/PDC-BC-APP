# Carbonfact Integration - Setup Guide

## Overview

This guide explains how to configure the Carbonfact carbon footprint integration in Business Central. All setup must be completed before running exports.

All Carbonfact actions (Export Product Data, Export Purchase Orders, Import CO2e) are available from the **Role Center** under the **Carbonfact** group in the Processing section.

## Prerequisites

- **PDC application version 26.0.0.83 or later installed**
- **Item Attributes defined** — Fabric composition attributes (IDs 12-70) must exist in Business Central. Each attribute represents a material/construction combination (e.g. "Polyester, Woven, Non-Recycled"). These are assigned to items with a percentage value. Navigate to **Search > Item Attributes** to verify they exist.
- **Country/Region transport distances configured** — Countries used as Country of Origin on items must have **CF Truck Km** and **CF Ship Km** filled in. These specify the overland and sea distances from the source country to the UK warehouse. Navigate to **Search > Countries/Regions** — the two columns appear after the Intrastat Code column. See [Section 2](#2-countryregion-transport-distances) for field details.
- **Item Categories configured with Carbonfact data** — Each Item Category used by Carbonfact-enabled items must have the **Carbonfact** section filled in on the Item Category Card: lifecycle parameters (category name, lifecycle weeks, wears, wash frequency), packaging data (bag and carton material/type/mass), BOM loss rate, and default fallback values. See [Section 1](#1-item-category-configuration) for all 18 fields.

---

## 1. Item Category Configuration

Navigate to: **Search > Item Categories > open a category card**

A new **Carbonfact** section appears at the bottom of the Item Category Card with the following subsections.

### Lifecycle

These values are exported on the Products sheet and define the product's usage lifecycle for carbon footprint calculation.

| Field | Description | Example |
|-------|-------------|---------|
| PDC CF Category | Carbonfact product category name (e.g., Vest, Trousers, Jacket). Must match Carbonfact's accepted categories. | `Vest` |
| PDC CF Lifecycle Weeks | Expected product lifetime in weeks. | `104` |
| PDC CF No. of Wears | Total expected number of times the garment is worn. | `200` |
| PDC CF Uses per Wash | Number of wears between washes. | `5` |
| PDC CF Tumble Dried % | Fraction of garments that are tumble dried (0-1 scale, e.g. 0.30 = 30%). | `0.30` |
| PDC CF End Life Recycled % | Fraction recycled at end of life (0-1 scale). | `0.50` |
| PDC CF End Life Waste % | Fraction sent to waste at end of life (0-1 scale). Recycled + Waste should equal 1. | `0.50` |

### Packaging - Bag

| Field | Description | Example |
|-------|-------------|---------|
| PDC CF Pkg Bag Material | Material of the bag packaging. | `Recycled polyethylene` |
| PDC CF Pkg Bag Type | Type of bag packaging. | `Polybag` |
| PDC CF Pkg Bag Mass Kg | Weight of the bag packaging in kilograms. | `0.015` |

### Packaging - Carton

| Field | Description | Example |
|-------|-------------|---------|
| PDC CF Pkg Carton Material | Material of the carton packaging. | `Recycled Cardboard` |
| PDC CF Pkg Carton Type | Type of carton packaging. | `Outer Carton` |
| PDC CF Pkg Carton Mass Kg | Weight of the carton packaging in kilograms. | `0.350` |

### BOM

| Field | Description | Example |
|-------|-------------|---------|
| PDC CF BOM Loss Rate % | Manufacturing loss rate percentage for this category. | `5.00` |

### Defaults

Fallback values used when item-level data is missing.

| Field | Description | Example |
|-------|-------------|---------|
| PDC CF Default Care Label | Default fabric composition label when an item has no fabric attributes. | `100% Polyester` |
| PDC CF Default Mass | Default net weight (Kg) when item-level Net Weight is 0. | `0.250` |
| PDC CF Default COO | Default Country of Origin code when the item has no COO set. | `CN` |
| PDC CF Default Tariff Code | Default tariff/commodity code. | `6203320000` |

---

## 2. Country/Region Transport Distances

Navigate to: **Search > Countries/Regions**

Two new fields appear for each country:

| Field | Description | Example |
|-------|-------------|---------|
| PDC CF Truck Km | Truck transport distance from the country's port/factory to the UK warehouse, in kilometres. | `50` |
| PDC CF Ship Km | Shipping distance from the country of origin to the UK, in kilometres. | `18500` |

These values are used in the Purchase Order export to calculate transport emissions per item.

> **Tip**: Only countries that are used as a Country of Origin on items need transport distances configured. Currently 29 of 103 countries have values set.

---

## 3. Enabling Items for Carbonfact

Navigate to: **Search > Items > open an Item Card**

A new field is available in the item card:

| Field | Description |
|-------|-------------|
| PDC Carbonfact Enabled | When set to Yes, this item is included in all Carbonfact exports (Product Data and Purchase Orders). |

Only items with **Carbonfact Enabled = Yes** appear in export files. Items without this flag are completely excluded.

### Fabric Attributes

Items must have fabric composition attributes (IDs 12-70) assigned via the standard **Item Attributes** feature in Business Central. These attributes define the material breakdown used in care labels and BOM exports.

Attribute names follow the format: `Material, Construction, Recycled/Non-Recycled, (ID)`

Examples:
- `Polyester, Woven, Non-Recycled, (12)`
- `Cotton, Knitted, Recycled, (19)`
- `Nylon, Woven, Recycled, (25)`

The numeric value of each attribute represents the percentage of that material in the garment (e.g., 45 = 45%).

---

## 4. Importing CO2e Values

After Carbonfact has processed the product data and calculated carbon footprint values, the results can be imported back into Business Central.

### CSV File Format

The import file must be a CSV with three columns:

| Column | Description | Example |
|--------|-------------|---------|
| sku | Item No. in Business Central | `JKKBLACK36L` |
| footprint | CO2e value in kgCO2eq | `48.19290959` |
| unit | Unit of measure (informational) | `kgCO2eq` |

### How to Import

1. From the Role Center, click **Import CO2e** in the Carbonfact group
2. On the request page, enable **Propagate CO2e to production items** if you want automatic propagation after import
3. Click **OK**, then select the CSV file received from Carbonfact
4. The system matches each SKU to an Item record and updates the **Carbon Emissions CO2e** field
5. A summary message shows the number of items updated and any SKUs not found
6. If propagation was enabled, CO2e values are automatically copied to production items

### Notes

- All items matching the SKU are updated, regardless of the Carbonfact Enabled flag
- Existing CO2e values are overwritten with the new values from the CSV
- SKUs not found in the Item table are counted but do not cause errors

---

## Setup Checklist

Use this checklist to verify all configuration is complete before running your first export:

- [ ] Item Categories populated with Carbonfact lifecycle fields (Category, Lifecycle Weeks, No. of Wears, etc.)
- [ ] Item Categories populated with packaging data (Bag and Carton material, type, mass)
- [ ] Item Categories populated with default fallbacks (Default Care Label, Default Mass, Default COO)
- [ ] Country/Region records updated with Truck Km and Ship Km for relevant countries
- [ ] Items flagged with **Carbonfact Enabled = Yes**
- [ ] Item fabric attributes (IDs 12-70) assigned with correct percentage values
