# Troubleshooting Guide

This guide helps resolve common issues with the PDC E-Document system.

---

## Connection Issues

### "Failed to connect to Azure File Share"

**Symptoms**: Test Connection fails, no files retrieved

**Possible Causes**:

1. **Invalid Storage Account Name**
   - Verify the name is correct (lowercase, no spaces)
   - Check Azure Portal for the exact name

2. **Invalid File Share Name**
   - Verify the file share exists in Azure
   - Names are case-sensitive

3. **Expired SAS Token**
   - Generate a new SAS Token in Azure Portal
   - Set a future expiration date
   - Update the token in E-Document Service

4. **Insufficient SAS Token Permissions**
   - Inbound needs: Read, List, Delete
   - Outbound needs: Write
   - Generate new token with correct permissions

5. **Network/Firewall Issues**
   - Check if Azure Storage is accessible
   - Verify firewall allows outbound HTTPS (port 443)

**Resolution Steps**:
1. Click **Test Connection** to see the specific error
2. Verify each setting against Azure Portal
3. Generate a new SAS Token if uncertain

---

### "Failed to list files"

**Symptoms**: Connection works but no files found

**Possible Causes**:

1. **Wrong Directory Path**
   - Verify directory exists in Azure
   - Check for typos
   - Path should not have leading/trailing slashes

2. **Directory is Empty**
   - Confirm files have been uploaded
   - Check the upload process

3. **SAS Token doesn't cover directory**
   - Ensure permissions apply to the specified path

**Resolution**:
1. Use Azure Portal to verify files exist
2. Check the exact directory path
3. Try with empty directory path (root)

---

## Outbound (Sending) Issues

### "Failed to create file in Azure"

**Cause**: SAS Token lacks Write permission or directory doesn't exist.

**Resolution**:
1. Generate new SAS Token with **Write** permission
2. Verify the outbound directory exists
3. Update token in E-Document Service

---

### "Failed to upload file"

**Cause**: Network error or Azure service unavailable.

**Resolution**:
1. Check internet connectivity
2. Verify Azure Storage Account is accessible
3. Retry the send operation

---

### "Cannot send empty document"

**Cause**: Document format did not generate content.

**Resolution**:
1. Check Document Format is configured correctly
2. Verify document has valid data
3. Check E-Document Log for format errors

---

### File Not Appearing in Azure After Send

**Possible Causes**:

1. **Wrong outbound directory**
   - Check "Azure Outbound Directory Path" setting
   - If empty, files go to inbound directory path

2. **SAS Token expired or invalid**
   - Generate new token with Write permission

3. **Send failed silently**
   - Check E-Document status and log for errors

---

## Inbound (Receiving) Issues

### "Customer No. is not configured on the E-Document Service"

**Cause**: E-Document Service missing required Customer No.

**Resolution**:
1. Open E-Document Services
2. Select your service
3. In EDI Import Settings, set **Customer No.**
4. Save and retry

---

### "Dummy Vendor No. must be configured" / "No vendor is set"

**Cause**: E-Document Service missing required Dummy Vendor No.

**Resolution**:
1. Open E-Document Services
2. Select your service
3. In EDI Import Settings, set **Dummy Vendor No.** to any valid vendor
4. Save and retry

> **Note**: The Dummy Vendor is required by the framework but never used. The system creates Sales Orders for the configured Customer.

---

### "Ship-to Address X not found for Customer Y"

**Cause**: Delivery Code in CSV doesn't match any Ship-to Address's **PDC Address 3** field

**Resolution**:
1. Open Customer Card for the configured customer
2. Go to **Ship-to Addresses**
3. Find or create the Ship-to Address
4. Set the **PDC Address 3** field to match the CSV Delivery Code value
5. File will process on next run

**Tips**:
- System matches by **PDC Address 3** field, NOT the Ship-to Code
- Matching is case-sensitive
- Check for leading/trailing spaces in CSV
- Review CSV file for exact Delivery Code value

---

### "Item with code X not found"

**Cause**: Product Code from CSV cannot be matched to an Item

**Behaviour**: Order still created, but line flagged as error

**Resolution**:
1. Identify correct Item No. in Business Central
2. Create **Item Reference**:
   - Open Item Card > Item References
   - Add: Reference Type = Customer, Reference No. = Product code
3. Future orders will match correctly
4. Manually add missing line to created Sales Order

---

### "Order X already exists. Skipping duplicate."

**Cause**: Sales Order with same External Document No. already exists

**Behaviour**: File deleted, warning logged (expected behaviour)

**Note**: This is protection against duplicates, not an error.

**If genuinely duplicated**: No action needed
**If new order with same number**: Contact source system administrator

---

### "Invalid date format: X. Expected YYYY-MM-DD"

**Cause**: Order Date in CSV not in expected format

**Resolution**:
1. Check source system date format
2. Dates must be YYYY-MM-DD (e.g., 2026-01-15)
3. Common issues: DD/MM/YYYY, MM/DD/YYYY, missing zeros

**Note**: Order will NOT be created if date format is invalid. Fix the source data and retry.

---

### "Insufficient columns: found X, expected at least Y"

**Cause**: CSV file structure doesn't match expected format

**Resolution**:
1. Verify CSV has all required columns
2. Check if columns were removed
3. Verify source system export configuration
4. See [R777 CSV Format](06-R777-CSV-Format.md) for required columns

---

## Sales Order Issues

### Order Created with Wrong Customer

**Cause**: E-Document Service configured with wrong Customer No.

**Resolution**:
1. Correct Customer No. in E-Document Service
2. Delete or void incorrectly created order
3. Re-upload CSV file for reprocessing

---

### Missing Sales Lines

**Possible Causes**:
1. Item lookup failed - check E-Document Log
2. CSV parsing error - verify file format

**Resolution**:
1. Review E-Document Log for specific import
2. Identify which lines failed
3. Manually add missing lines
4. Fix Item References for future imports

---

### Wrong Prices on Order

**Note**: This is expected - CSV prices are ignored.

**Explanation**: Business Central pricing is always used:
- Customer price groups
- Item unit prices
- Sales line discounts

If pricing is incorrect, check BC pricing setup.

---

## Azure File Share Issues

### Files Not Being Deleted After Processing

**Possible Causes**:
1. SAS Token lacks Delete permission
2. Processing failed (files only deleted on success)
3. File is locked by another process

**Resolution**:
1. Generate new token with Delete permission
2. Check E-Document Log for errors
3. Wait and retry

---

### Files in Azure but Not Importing

**Check**:
1. Job Queue Entry is active and running
2. E-Document Service is enabled
3. Directory path matches file location
4. File extension is recognised

---

## Job Queue Issues

### Import Not Running on Schedule

**Check**:
1. Job Queue Entry status is **Ready**
2. Entry is not on hold
3. No errors in Job Queue Log Entries
4. Correct Codeunit (6146) and parameters

**Resolution**:
1. Search for **Job Queue Entries**
2. Find E-Doc Import entry
3. Check status and last run time
4. Review **Job Queue Log Entries**
5. Restart if needed

---

## Quick Reference: Error Messages

### Outbound Errors

| Error Message | Cause | Quick Fix |
|--------------|-------|-----------|
| Failed to create file | No Write permission | Add Write to SAS Token |
| Failed to upload | Network issue | Check connectivity, retry |
| Cannot send empty document | Format error | Check Document Format |

### Inbound Errors

| Error Message | Cause | Quick Fix |
|--------------|-------|-----------|
| Failed to connect | SAS Token expired | Regenerate token |
| Customer not configured | Missing setup | Set Customer No. |
| No vendor is set | Missing setup | Set Dummy Vendor No. |
| Ship-to not found | PDC Address 3 not set | Set PDC Address 3 field |
| Item not found | Missing reference | Create Item Reference |
| Order already exists | Duplicate file | No action (expected) |
| Invalid date format | Wrong format in CSV | Use YYYY-MM-DD format |
| Insufficient columns | Malformed CSV | Check CSV structure |

---

## Getting Help

If issues persist:

1. **Document the issue**:
   - E-Document entry number
   - Exact error message
   - Screenshot of E-Document Log
   - Copy of source file (if available)

2. **Check logs**:
   - E-Document Log (detailed)
   - Job Queue Log Entries
   - Application Insights (if configured)

3. **Contact support** with collected information

---

## Related Documents

- [Azure Setup](02-Azure-Setup.md) - Connection configuration
- [Inbound Setup](03-Inbound-Setup.md) - Import configuration
- [Outbound Setup](04-Outbound-Setup.md) - Export configuration
- [Daily Operations](05-Daily-Operations.md) - Monitoring
