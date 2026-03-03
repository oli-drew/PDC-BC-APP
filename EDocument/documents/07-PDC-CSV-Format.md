# PDC CSV Format Reference

This document describes the PDC CSV format for **outbound** invoice export.

## Overview

| Property | Value |
|----------|-------|
| Direction | Outbound only |
| Source Document | Posted Sales Invoice |
| File Format | CSV (comma-separated) |
| Encoding | UTF-8 |
| Header Row | None |
| Structure | Flat (header data repeated per line) |
| File Naming | `{Invoice No.}.csv` |

## Column Specification

| Col | Name | BC Source | Field | Notes |
|-----|------|-----------|-------|-------|
| A | Invoice Number | Sales Invoice Header | No. | Document number |
| B | Source | Company Information | Name | Company name |
| C | Invoice header text | Sales Invoice Header | Your Reference | Customer's PO reference |
| D | Invoice date | Sales Invoice Header | Posting Date | Format: YYYY-MM-DD |
| E | Total NET value | *Calculated* | Sum of column N | Check total |
| F | Total VAT value | *Calculated* | Sum of column O | Check total |
| G | Detail line count | *Calculated* | Count of lines | Check sum |
| H | Product code | Sales Invoice Line | No. | Item number |
| I | Order number | Sales Invoice Header | Your Reference | Customer's PO reference |
| J | Invoice line text | Sales Invoice Line | Description | Line description |
| K | Quantity | Sales Invoice Line | Quantity | Quantity invoiced |
| L | Units | Sales Invoice Line | Unit of Measure | UOM code |
| M | NET unit cost | Sales Invoice Line | Unit Price | Price excl. VAT |
| N | NET line value | Sales Invoice Line | Line Amount | Line total excl. VAT |
| O | Line VAT | *Calculated* | Amount Incl. VAT - VAT Base Amount | VAT amount |

## Example Output

Invoice SI302518 with 2 lines:

```csv
SI302518,Peter Drew Contracts Ltd,AAA/1234,2025-08-18,27.90,5.58,2,ANS8000ORANGEM,AAA/1234,Blackrock Hi-Vis Coat,1,PCS,19.95,19.95,3.99
SI302518,Peter Drew Contracts Ltd,AAA/1234,2025-08-18,27.90,5.58,2,6500,AAA/1234,DX Standard,1,PCS,7.95,7.95,1.59
```

## Format Details

### Data Repetition

Header-level data (columns A-G, I) is repeated on every line. This creates a "flat" structure where each CSV row contains complete information.

### Check Totals

Columns E, F, and G contain totals calculated from all lines:

- **Column E** (Total NET): Sum of all Line Amounts (column N)
- **Column F** (Total VAT): Sum of all Line VAT values (column O)
- **Column G** (Line count): Number of invoice lines

These can be used by receiving systems to validate file integrity.

### Date Format

Dates are formatted as `YYYY-MM-DD` (ISO 8601 format).

Example: `2025-08-18` for August 18, 2025

### Decimal Format

Decimal values use period as decimal separator with 2 decimal places.

Example: `19.95`, `3.99`, `27.90`

### Text Escaping

Text fields containing commas, quotes, or line breaks are escaped:

- Fields with commas are wrapped in double quotes: `"Value, with comma"`
- Double quotes within text are doubled: `"He said ""Hello"""`

## Setup Requirements

To use PDC CSV format:

1. Create E-Document Service with **Service Integration** = "Azure File Share"
2. Set **Document Format** = "PDC CSV"
3. Configure Azure File Share connection settings
4. Configure **Outbound Directory Path** (optional, uses inbound path if empty)
5. Ensure SAS Token includes **Write** permission

## Sending Process

1. Post a Sales Invoice in Business Central
2. Navigate to Posted Sales Invoice
3. Use **Send** action or E-Document workflow
4. CSV file is generated and uploaded to Azure File Share
5. File appears in outbound directory as `{Invoice No.}.csv`

## Limitations

- **Export only** - PDC CSV cannot be used for import
- **Single invoice** - Batch export not supported
- **Sales invoices only** - Credit memos not currently supported

## Related Documents

- [Outbound Setup](04-Outbound-Setup.md) - Configuration guide
- [Daily Operations](05-Daily-Operations.md) - Monitoring and management
- [Troubleshooting](08-Troubleshooting.md) - Error resolution
