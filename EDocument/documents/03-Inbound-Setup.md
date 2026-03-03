# Inbound Setup

This guide covers configuration for receiving orders from external systems.

**Prerequisite**: Complete [Azure Setup](02-Azure-Setup.md) first.

---

## Overview

Inbound processing:
1. External system exports orders as CSV files
2. Files uploaded to Azure File Share (via SFTP or direct)
3. Business Central retrieves and processes files
4. Sales Orders created automatically
5. Processed files deleted from Azure

---

## Step 1: Configure E-Document Service

Open your E-Document Service (created in Azure Setup) and configure:

### Document Format

Set **Document Format** based on your source system:

| Format | Source System |
|--------|---------------|
| R777 CSV | TemplaCMS |

### EDI Import Settings

| Field | Description | Required |
|-------|-------------|----------|
| **Customer No.** | Customer for created Sales Orders | Yes |
| **Dummy Vendor No.** | Any valid vendor (for framework validation) | Yes |
| **Order Source** | Code to identify EDI orders | No |

**About Dummy Vendor**: The E-Document framework requires a vendor internally. This vendor is never used - the system creates Sales Orders for the configured Customer. Select any valid vendor.

---

## Step 2: Configure Customer

The customer specified in E-Document Service needs:

### Ship-to Addresses

Each delivery code in CSV must match a Ship-to Address via the **PDC Address 3** field:

1. Open **Customer Card**
2. Go to **Ship-to Addresses**
3. For each address, set the **PDC Address 3** field to match the CSV delivery code

| CSV Delivery Code | PDC Address 3 Field |
|-------------------|---------------------|
| `STORE-001` | `STORE-001` |
| `DEPOT-A` | `DEPOT-A` |

**Important**:
- The system matches by **PDC Address 3** field, NOT the Ship-to Code
- Matching is case-sensitive
- The Ship-to Code can be any valid code (e.g., `MAIN`, `STORE1`)

### Custom Fields (Optional)

For contact information from CSV, ensure these fields exist:
- PDC Ship-to Mobile Phone No.
- PDC Ship-to E-Mail

These are added by the PDC main app.

---

## Step 3: Configure Items

The system looks up items by Product Code from CSV in this order:

1. **Direct Item No.** - Product Code matches Item No.
2. **Customer Item Reference** - Reference for the EDI customer
3. **Any Item Reference** - Reference with matching number
4. **Vendor Item No.** - Item's Vendor Item No. field

### Recommended: Create Item References

For each product code:

1. Open the **Item Card**
2. Go to **Item References**
3. Click **New** and enter:
   - **Reference Type**: Customer
   - **Reference Type No.**: Your EDI customer
   - **Reference No.**: Product code from CSV
   - **Unit of Measure**: Leave blank (uses base UOM)

---

## Step 4: Set Up Automatic Import

### Create Job Queue Entry

1. Search for **Job Queue Entries**
2. Click **New**
3. Configure:

| Field | Value |
|-------|-------|
| **Object Type to Run** | Codeunit |
| **Object ID to Run** | 6146 |
| **Description** | E-Doc Import - [Your Service] |
| **Parameter String** | Your E-Document Service code |

4. Set schedule:

| Field | Example |
|-------|---------|
| **Recurring Job** | Yes |
| **Run on Mondays-Fridays** | Yes |
| **Starting Time** | 06:00 |
| **No. of Minutes between Runs** | 15 |

5. Set **Status** to **Ready**

### Manual Import

To import manually without Job Queue:

1. Open **E-Document Services**
2. Select your service
3. Click **Receive** action
4. Files are downloaded and processed

---

## Step 5: Verify Setup

### Test Connection

1. Click **Test Connection** on E-Document Service
2. Should show: "Connection successful. Found X files in the directory."

### Test Import

1. Place a test CSV file in Azure directory
2. Run manual **Receive** action
3. Check **E-Documents** page for results
4. Verify Sales Order was created correctly

---

## Configuration Checklist

| Setting | Location | Value |
|---------|----------|-------|
| Service Integration | E-Document Service | Azure File Share |
| Document Format | E-Document Service | R777 CSV |
| Storage Account | E-Document Service | Your account name |
| File Share | E-Document Service | Your share name |
| Directory Path | E-Document Service | Inbound directory |
| SAS Token | E-Document Service | Configured (Read, List, Delete) |
| Customer No. | E-Document Service | EDI customer |
| Dummy Vendor No. | E-Document Service | Any vendor |
| Ship-to Addresses | Customer Card | PDC Address 3 matches CSV codes |
| Item References | Item Cards | Map product codes |
| Job Queue | Job Queue Entries | Codeunit 6146 |

---

## Business Rules

### Pricing

CSV prices are **ignored**. Business Central pricing is applied:
- Customer price groups
- Item unit prices
- Sales line discounts

### Unit of Measure

CSV unit is **ignored**. Item's base UOM is used.

### Duplicate Detection

If a Sales Order with the same External Document No. exists for the customer:
- File is skipped (not imported)
- File is deleted from Azure
- Warning logged

---

## Next Steps

- [Daily Operations](05-Daily-Operations.md) - Monitor imports
- [R777 CSV Format](06-R777-CSV-Format.md) - Column specification
- [Troubleshooting](08-Troubleshooting.md) - Resolve issues
