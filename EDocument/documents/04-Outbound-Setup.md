# Outbound Setup

This guide covers configuration for sending documents to external systems.

**Prerequisite**: Complete [Azure Setup](02-Azure-Setup.md) first.

---

## Overview

Outbound processing:
1. User posts Sales Invoice in Business Central
2. E-Document created and formatted (CSV or XML)
3. File uploaded to Azure File Share
4. External system retrieves file for processing

---

## Step 1: Configure E-Document Service

You can either:
- Use an existing service (if doing both inbound and outbound)
- Create a dedicated outbound service

### Document Format

Set **Document Format** based on your needs:

| Format | Output | Use Case |
|--------|--------|----------|
| PDC CSV | .csv | Flat file integration |
| PEPPOL BIS 3.0 | .xml | Standard e-invoicing |

### Azure Settings

| Field | Description |
|-------|-------------|
| **Outbound Directory Path** | Where files are uploaded |

If **Outbound Directory Path** is empty, files go to the main **Directory Path**.

### SAS Token

Ensure your SAS Token includes **Write** permission.

---

## Step 2: Choose Sending Method

### Option A: Manual Sending

Send documents one at a time:

1. Post a Sales Invoice
2. Open **E-Documents** page
3. Find the document
4. Click **Send** action

### Option B: Automatic Sending

Send automatically when posting:

1. Create a **Document Sending Profile**:
   - Search for **Document Sending Profiles**
   - Click **New**
   - Set **Electronic Document** = "Through Document Exchange Service"
   - Select your E-Document Service

2. Assign to Customer:
   - Open **Customer Card**
   - Set **Document Sending Profile** to your profile

3. When posting invoices for this customer, they automatically send to Azure.

---

## Step 3: Configure by Format

### PDC CSV Format

No additional configuration needed. The format:
- Exports Posted Sales Invoices only
- Creates flat CSV with header repeated per line
- Names files as `{Invoice No.}.csv`

See [PDC CSV Format Reference](07-PDC-CSV-Format.md) for column details.

### PEPPOL BIS 3.0 Format

Standard E-Document PEPPOL format. May require:
- Company VAT Registration No.
- Customer VAT Registration No.
- GLN numbers (if required by recipient)

---

## Step 4: Test Outbound

1. Post a test Sales Invoice
2. Open **E-Documents** page
3. Find the invoice entry
4. Click **Send**
5. Check Azure File Share for the uploaded file
6. Verify file content is correct

### Verify in E-Document Log

- **Status** = "Sent" indicates success
- **File Name** shows the uploaded filename
- View **E-Document Log** for detailed upload info

---

## Configuration Checklist

| Setting | Location | Value |
|---------|----------|-------|
| Service Integration | E-Document Service | Azure File Share |
| Document Format | E-Document Service | PDC CSV or PEPPOL |
| Storage Account | E-Document Service | Your account name |
| File Share | E-Document Service | Your share name |
| Outbound Directory | E-Document Service | Outbound directory |
| SAS Token | E-Document Service | Configured (with Write) |
| Sending Profile | Customer Card | Optional (for auto-send) |

---

## File Naming

| Format | Naming Pattern | Example |
|--------|----------------|---------|
| PDC CSV | `{Invoice No.}.csv` | `SI302518.csv` |
| PEPPOL | `{Invoice No.}.xml` | `SI302518.xml` |

---

## Supported Documents

| Document Type | PDC CSV | PEPPOL |
|---------------|---------|--------|
| Posted Sales Invoice | Yes | Yes |
| Posted Sales Credit Memo | No | Yes |

---

## Troubleshooting

### File Not Appearing in Azure

1. Check **E-Document** status - is it "Sent"?
2. Check **E-Document Log** for errors
3. Verify **Outbound Directory Path** setting
4. Ensure SAS Token has **Write** permission

### "Failed to create file" Error

SAS Token lacks Write permission:
1. Generate new token with Write enabled
2. Update token in E-Document Service

### Wrong Directory

If files appear in wrong location:
1. Check **Outbound Directory Path** field
2. If empty, files go to **Directory Path** (inbound path)

---

## Next Steps

- [Daily Operations](05-Daily-Operations.md) - Monitor sent documents
- [PDC CSV Format](07-PDC-CSV-Format.md) - CSV column specification
- [Troubleshooting](08-Troubleshooting.md) - Resolve issues
