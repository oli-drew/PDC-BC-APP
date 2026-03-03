# Daily Operations

This guide covers day-to-day use of the E-Document system for both sending and receiving documents.

---

## Sending Documents (Outbound)

### How Sending Works

When you send a document through the E-Document framework:

1. **Document is posted** in Business Central
2. **E-Document is created** with formatted content (CSV or XML)
3. **Send action** uploads the file to Azure File Share
4. **File is stored** in the configured outbound directory
5. **External system** retrieves the file for processing

### Automatic Sending

To send automatically on posting:

1. Configure a **Document Sending Profile** with E-Document enabled
2. Assign the profile to the customer
3. When posting an invoice, it automatically sends to Azure File Share

### Manual Sending

To manually send a document:

1. Open **E-Documents** page
2. Find the document to send
3. Click **Send** action
4. The file is uploaded to Azure File Share

### Sent Document Naming

Files are named using the document number:

| Format | Example |
|--------|---------|
| PDC CSV | `SI302518.csv` |
| PEPPOL | `SI302518.xml` |

### Monitoring Sent Documents

In the E-Documents page, check:
- **Status** = "Sent" indicates successful upload
- **File Name** shows the uploaded filename
- **E-Document Log** contains detailed upload information

---

## Receiving Orders (Inbound)

### How Import Works

#### Automatic Import (Scheduled)

When the Job Queue runs:

1. **List Files**: System connects to Azure and lists files in directory
2. **Download Each File**: Each file downloaded, E-Document record created
3. **Parse CSV**: Parser extracts order header and line data
4. **Validate Data**: Check duplicates, Ship-to Code, Customer
5. **Create Sales Order**: If validation passes, Sales Order created
6. **Create Comment**: Special Instructions added as Sales Comment
7. **Delete Source File**: CSV deleted from Azure after success
8. **Log Result**: Success or failure logged in E-Document Log

#### Manual Import

To manually trigger an import:

1. Open **E-Document Services**
2. Select your EDI service
3. Click **Receive** action
4. Files are downloaded and processed
5. Successfully processed files deleted from Azure

---

## Monitoring

### E-Document Log

The primary place to monitor activity:

1. Search for **E-Documents** in Business Central
2. Filter by your service if needed
3. Review status of each entry:

| Status | Meaning |
|--------|---------|
| **In Progress** | Being processed |
| **Processed** | Completed successfully |
| **Sent** | Outbound document uploaded |
| **Error** | Processing failed - see details |

### Viewing Details

For each E-Document entry:

- **File Name**: Original filename
- **Document Record ID**: Link to created document
- **E-Document Log**: Detailed processing log with timestamps

Click on the **Document Record ID** to open the related document.

---

## Created Sales Orders (Inbound)

Orders created by EDI import have these characteristics:

| Field | Source |
|-------|--------|
| **Sell-to Customer No.** | E-Document Service configuration |
| **Ship-to Code** | Looked up via CSV Delivery Code (see note below) |
| **External Document No.** | CSV Order Number (Column A) |
| **Your Reference** | CSV Order Number (Column A) |
| **Order Date** | CSV Order Date |
| **Ship-to Contact** | CSV Contact Name |
| **PDC Ship-to Mobile Phone No.** | CSV Contact Phone |
| **PDC Ship-to E-Mail** | CSV Contact Email |
| **PDC Order Source** | E-Document Service configuration |

**Ship-to Code Note**: The CSV Delivery Code is matched against the **PDC Address 3** field on Ship-to Address records, not the Ship-to Code directly.

### Sales Order Lines

Each CSV line creates a Sales Line:

| Field | Source |
|-------|--------|
| **Type** | Item |
| **No.** | Looked up from Product Code |
| **Quantity** | CSV Quantity |
| **Unit Price** | Business Central pricing (CSV ignored) |
| **PDC Customer Reference** | CSV Purchase Order Reference (Column C) |

### Sales Comments

Special Instructions are added as Sales Comment Lines.

---

## Handling Errors

### Common Error Scenarios

| Error | Cause | Resolution |
|-------|-------|------------|
| "Ship-to Address X not found" | PDC Address 3 doesn't match | Set PDC Address 3 field |
| "Item with code X not found" | Product Code not found | Add Item Reference |
| "Order X already exists" | Duplicate file | No action needed |
| "Customer not configured" | Missing setup | Configure Customer No. |
| "Failed to create file" | No Write permission | Update SAS Token |
| "Connection failed" | Azure issue | Check SAS Token |

### Partial Success (Inbound)

If some lines fail but others succeed:

- Sales Order is still created
- Valid lines added to the order
- Failed lines logged in E-Document Log
- Review order and manually add missing items

### Retrying Failed Imports

Failed files remain in Azure (not deleted). To retry:

1. Fix the root cause (e.g., add missing Ship-to Address)
2. Run manual import or wait for next scheduled run
3. File will be reprocessed

---

## Daily Checklist

### Morning

1. Check **E-Documents** page for overnight activity
2. Review any **Error** status entries
3. Verify new Sales Orders are correct
4. Check sent documents were delivered

### Throughout Day

1. Monitor E-Document Log for issues
2. Handle customer queries about missing orders
3. Investigate if expected files haven't arrived

### End of Day

1. Confirm all expected orders have been imported
2. Verify all outbound documents were sent
3. Review error log for patterns
4. Escalate recurring issues

---

## Reports and Queries

### Find Orders by External Document No.

```
Sales Order List > Filter > External Document No. = [order number]
```

### Find All EDI Orders

```
Sales Order List > Filter > PDC Order Source = [your EDI source code]
```

### Find Documents by Date Range

```
E-Documents > Filter > Document Date = [date range]
```

---

## Contact Support

For issues not covered in [Troubleshooting](08-Troubleshooting.md):

1. Note the E-Document entry number
2. Note the error message
3. Save a copy of the source file (if available)
4. Contact your system administrator
