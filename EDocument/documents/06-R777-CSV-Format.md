# R777 CSV Format Reference

This document describes the R777 CSV format for **inbound** order import from TemplaCMS.

## Overview

| Property | Value |
|----------|-------|
| Direction | Inbound only |
| Source System | TemplaCMS (R777) |
| Target Document | Sales Order |
| File Format | CSV (comma-separated) |
| Encoding | UTF-8 |
| Header Row | None (data starts on first line) |
| Date Format | YYYY-MM-DD |

## File Structure

Each CSV file contains one purchase order. The file is a **flat structure** where:

- Header information is repeated on every line
- Each line represents one order line item
- Lines are grouped by Order Number (Column A)

Example with 3 line items:
```
ORD001,SRC,PO123,2026-01-15,...,ITEM1,...,5,...
ORD001,SRC,PO123,2026-01-15,...,ITEM2,...,10,...
ORD001,SRC,PO123,2026-01-15,...,ITEM3,...,3,...
```

---

## Column Mapping

### Columns Used (Mapped to Business Central)

| Column | Index | CSV Field | BC Field | Notes |
|--------|-------|-----------|----------|-------|
| A | 0 | Order Number | External Document No. + Your Reference + PDC Customer Reference | Maps to header fields AND line field 50003 |
| D | 3 | Order Date | Order Date | Format: YYYY-MM-DD |
| H | 7 | Special Instructions | Sales Comment Line | Added as order comment |
| I | 8 | Delivery Code | Ship-to Code | Must exist in BC |
| L | 11 | Product Code | Item No. | Via direct match or Item Reference |
| N | 13 | Quantity Required | Quantity | Decimal value |
| Y | 24 | Contact Name | Ship-to Contact | Max 100 characters |
| Z | 25 | Contact Phone | PDC Ship-to Mobile Phone No. | Max 30 characters |
| AB | 27 | Contact Email | PDC Ship-to E-Mail | Max 80 characters |

### Columns Ignored

| Column | Index | CSV Field | Reason |
|--------|-------|-----------|--------|
| B | 1 | Source | Not needed |
| C | 2 | Purchase Order Reference | PDC Customer Reference now from Column A |
| E | 4 | Required Date | Not used per specification |
| F | 5 | Total NET Order Cost | BC calculates pricing |
| G | 6 | Detail Line Count | Validation only |
| J | 9 | Delivery Address | Unreliable - use Ship-to Address |
| K | 10 | Delivery Post Code | Use Ship-to Address |
| M | 12 | Product Description | Use BC item description |
| O | 14 | Units | Use item's base UOM |
| P | 15 | NET Unit Cost | BC pricing used |
| Q | 16 | Extended NET Line Cost | BC calculates |
| R-U | 17-20 | Repeat Order Fields | Future enhancement |
| AA | 26 | Contact Mobile | Use Column Z |
| V | 21 | Site Code | Same as Delivery Code |
| W | 22 | Site Address | Same as Delivery Address |
| X | 23 | Site Post Code | Same as Delivery Post Code |

---

## Field Details

### Order Number (Column A)

- **Purpose**: Unique identifier from external system
- **Maps to**:
  - Sales Header "External Document No."
  - Sales Header "Your Reference"
  - Sales Line "PDC Customer Reference" (field 50003)
- **Validation**: Used for duplicate detection
- **Max length**: 35 characters (50 for PDC Customer Reference)
- **Note**: Applied to all lines in the order

### Order Date (Column D)

- **Purpose**: Date the order was placed
- **Format**: YYYY-MM-DD (ISO date format)
- **Maps to**: Sales Header "Order Date" and "Document Date"
- **Example**: `2026-01-15` = January 15, 2026

### Special Instructions (Column H)

- **Purpose**: Delivery notes or special handling instructions
- **Maps to**: Sales Comment Line
- **Max length**: 250 characters
- **Note**: Long instructions split across multiple comment lines

### Delivery Code (Column I)

- **Purpose**: Identifies the delivery location
- **Maps to**: Sales Header "Ship-to Code" (via lookup)
- **Lookup**: Matched against **PDC Address 3** field on Ship-to Address records
- **Validation**: Must match an existing Ship-to Address's PDC Address 3 field
- **Case sensitive**: Yes

### Product Code (Column L)

- **Purpose**: Identifies the item to order
- **Maps to**: Sales Line "No." (Item No.)
- **Lookup order**:
  1. Direct Item No. match
  2. Customer Item Reference
  3. Any Item Reference
  4. Vendor Item No.

### Quantity (Column N)

- **Purpose**: Number of units to order
- **Maps to**: Sales Line "Quantity"
- **Format**: Decimal number
- **Examples**: `5`, `10.5`, `100`

### Contact Name (Column Y)

- **Purpose**: Delivery contact person
- **Maps to**: Sales Header "Ship-to Contact"
- **Max length**: 100 characters

### Contact Phone (Column Z)

- **Purpose**: Phone number for delivery contact
- **Maps to**: Sales Header "PDC Ship-to Mobile Phone No."
- **Max length**: 30 characters

### Contact Email (Column AB)

- **Purpose**: Email for delivery contact
- **Maps to**: Sales Header "PDC Ship-to E-Mail"
- **Max length**: 80 characters

---

## Sample CSV File

```csv
"ORD-2026-001","R777","PO-12345","2026-01-15","2026-01-18","150.00","2","Handle with care","STORE-001","123 High Street, London","EC1A 1BB","PROD-A","Widget Type A","10","EA","5.00","50.00","","","","","STORE-001","123 High Street","EC1A 1BB","John Smith","020 1234 5678","07700 900000","john.smith@example.com"
"ORD-2026-001","R777","PO-12345","2026-01-15","2026-01-18","150.00","2","Handle with care","STORE-001","123 High Street, London","EC1A 1BB","PROD-B","Widget Type B","5","EA","20.00","100.00","","","","","STORE-001","123 High Street","EC1A 1BB","John Smith","020 1234 5678","07700 900000","john.smith@example.com"
```

This example shows:
- Order Number: ORD-2026-001
- 2 line items: PROD-A (qty 10) and PROD-B (qty 5)
- Delivery to STORE-001
- Contact: John Smith

---

## Business Rules

### Pricing

- CSV prices (Columns P, Q) are **ignored**
- Business Central pricing is applied based on:
  - Customer price groups
  - Item prices
  - Sales line discounts

### Unit of Measure

- CSV unit (Column O) is **ignored**
- Item's base unit of measure is used

### Duplicate Orders

- If order with same External Document No. exists for customer, file is **skipped**
- Error logged in E-Document Log
- CSV file remains in Azure for manual review/deletion

### Error Handling

| Scenario | Behaviour |
|----------|-----------|
| Item not found | Order created, line flagged as error |
| Ship-to Code not found | Order **not** created, file kept for retry |
| Invalid date format | Order **not** created, file kept for retry |
| Empty file | Error logged, file kept |
| Duplicate order | Skipped, error logged, file kept |

---

## Troubleshooting

### File Not Processing

Check:
- File is in the correct Azure directory
- File has .csv extension
- File is not empty

### Incorrect Data

Check:
- Column positions match this specification
- No extra columns added at beginning
- Text fields with commas are properly quoted

### Date Parsing Errors

Check:
- Date format is YYYY-MM-DD (ISO format)
- No invalid dates (e.g., 2026-02-31)
- Year is 4 digits

---

## Related Documents

- [Inbound Setup](03-Inbound-Setup.md) - Configuration guide
- [Daily Operations](05-Daily-Operations.md) - Monitoring imports
- [Troubleshooting](08-Troubleshooting.md) - Error resolution
