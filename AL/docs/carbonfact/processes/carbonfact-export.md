# Carbonfact Data Export

## Overview

The Carbonfact export generates Excel files that are uploaded to Carbonfact's web platform for carbon footprint calculation. There are two export types:

1. **Product Data Export** - A 3-sheet Excel workbook with product details, packaging, and material composition
2. **Purchase Order Export** - A single-sheet Excel workbook with purchase receipt data and transport distances

Both exports are available from the **Role Center** under the **Carbonfact** group in the Processing section.

---

## Product Data Export

### How to Run

1. From the Role Center, click **Export Product Data** in the Carbonfact group
2. Click **OK** on the request page
3. The system generates a 3-sheet Excel file and downloads it to your browser

### What Gets Exported

Only items with **Carbonfact Enabled = Yes** are included.

### Sheet 1: Products

One row per item. Contains product identification, physical properties, lifecycle data, and care label composition.

| Column | Source | Description |
|--------|--------|-------------|
| product_id | Item No. | Unique product identifier |
| product_name | Item Description | Product name |
| image_url | (empty) | Reserved for future use |
| category | Item Category > PDC CF Category | Product category (e.g., "Vest") |
| mass_kg | Item Net Weight (or category default) | Product mass in kilograms |
| care_label_composition | Calculated from fabric attributes | Fabric composition string (see below) |
| country_of_origin | Item COO (or category default) | Country code (e.g., "CN") |
| lifecycle_weeks | Item Category > PDC CF Lifecycle Weeks | Product lifetime in weeks |
| number_of_wears | Item Category > PDC CF No. of Wears | Expected total wears |
| uses_per_wash | Item Category > PDC CF Uses per Wash | Wears between washes |
| tumble_dried_share | Item Category > PDC CF Tumble Dried % | Fraction tumble dried |
| end_of_life_recycled_share | Item Category > PDC CF End Life Recycled % | End-of-life recycled fraction |
| end_of_life_waste_share | Item Category > PDC CF End Life Waste % | End-of-life waste fraction |

#### Care Label Composition

The care label is built automatically from the item's fabric attributes (IDs 12-70):

- Each attribute's percentage and material name are extracted
- Components are sorted by percentage in descending order
- Format: `{percentage}% {Recycled/Non-Recycled} {Material}`

**Example**: An item with 45% non-recycled cotton, 30% recycled nylon, and 25% non-recycled polyester produces:

```
45% Non-Recycled Cotton 30% Recycled Nylon 25% Non-Recycled Polyester
```

If an item has no fabric attributes assigned, the system falls back to the **PDC CF Default Care Label** from the Item Category.

#### Mass Fallback

If an item's Net Weight is 0, the system uses the **PDC CF Default Mass** from the Item Category.

#### Country of Origin Fallback

If an item has no Country/Region of Origin Code set, the system uses the **PDC CF Default COO** from the Item Category.

### Sheet 2: Packaging

Two rows per item (one for bag packaging, one for carton packaging). Values come from the Item Category.

| Column | Source | Description |
|--------|--------|-------------|
| product_id | Item No. | Links back to the Products sheet |
| packaging_type | Item Category | Bag Type or Carton Type (e.g., "Polybag", "Outer Carton") |
| material | Item Category | Packaging material (e.g., "Recycled polyethylene") |
| recycled | Fixed | Always "Yes" |
| mass_kg | Item Category | Packaging weight in Kg |

> **Note**: If an Item Category has no bag or carton material configured, the corresponding row is skipped for items in that category.

### Sheet 3: BOM (Bill of Materials)

One row per fabric attribute per item. Contains the material breakdown for carbon footprint calculation.

| Column | Source | Description |
|--------|--------|-------------|
| product_id | Item No. | Links back to the Products sheet |
| material_type | Attribute name > Construction part | Fabric construction (e.g., "Woven", "Knitted", "Moulded") |
| composition | Attribute name > Recycled + Material parts | Material composition (e.g., "Non-Recycled Polyester") |
| recycled | Derived from attribute name | "Yes" if Recycled, "No" if Non-Recycled |
| mass_share | Attribute value | Percentage as text (e.g., "45%") |

The attribute name is parsed from the format `Material, Construction, Recycled, (ID)`:
- **material_type** = Construction (2nd part)
- **composition** = Recycled + Material (3rd part + 1st part)

---

## Purchase Order Export

### How to Run

1. From the Role Center, click **Export Purchase Orders** in the Carbonfact group
2. Enter the **Start Date** and **End Date** for the export period
3. Click **OK** to generate and download the Excel file

### What Gets Exported

Purchase receipts (Item Ledger Entries with Entry Type = Purchase) for Carbonfact-enabled items within the specified date range.

### Columns

| Column | Source | Description |
|--------|--------|-------------|
| product_id | Item No. | Product identifier |
| quantity | ILE Quantity | Quantity received |
| order_date | Posted Purchase Invoice or Purchase Receipt | Actual order date from the source document |
| receipt_date | ILE Posting Date | Date goods were received |
| factory_id | ILE Source No. (Vendor) | Vendor/factory identifier |
| truck_km | Country/Region > PDC CF Truck Km | Truck transport distance from COO |
| ship_km | Country/Region > PDC CF Ship Km | Ship transport distance from COO |

#### Order Date Lookup

The order date is looked up from the original purchase document:

1. **Posted Purchase Invoice** (primary): The system finds the Value Entry linked to the Item Ledger Entry with Document Type = Purchase Invoice, then reads the Order Date from the corresponding Purch. Inv. Header.
2. **Purchase Receipt** (fallback): If no Posted Purchase Invoice exists (e.g., not yet invoiced), the system uses the Order Date from the Purch. Rcpt. Header via the ILE Document No.
3. **Posting Date** (last resort): If neither document is found, the ILE Posting Date is used.

#### Transport Distances

Truck Km and Ship Km are looked up from the Country/Region table using the item's Country/Region of Origin Code. If the item has no COO or the country has no distances configured, both values are 0.

---

## Uploading to Carbonfact

After downloading the export files:

1. Log in to the Carbonfact web platform
2. Navigate to the data upload section
3. Upload the **Product Data** Excel file (Products + Packaging + BOM sheets)
4. Upload the **Purchase Orders** Excel file separately
5. Carbonfact processes the data and calculates carbon footprint values
