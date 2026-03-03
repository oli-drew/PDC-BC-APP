# PDC Portal Customer Staff Sync

Customer Staff Sync allows you to automatically import staff records from Excel files stored in Azure Blob Storage. Configure per-customer connections, schedule automated imports, and track import history.

---

## Overview

### Why Customer Staff Sync?

Many customers maintain their staff lists in external systems that export to Excel:

*   **HR Systems**: Employee master data exports

*   **Workforce Management**: Shift planning systems

*   **External Portals**: Customer-managed staff databases

*   **Third-party Integrations**: Automated Excel exports from other platforms

Customer Staff Sync automates the import process, reducing manual data entry and ensuring staff records stay synchronized.

### What Gets Imported

The import reads Excel files with the following column mapping:

| Column | Field | BC Field |
|--------|-------|----------|
| A | Wearer ID | Wearer ID (unique key per customer) |
| B | First Name | First Name |
| C | Last Name | Last Name |
| D | Body Type | Body Type/Gender |
| E | Branch ID | Branch ID |
| F | Wardrobe ID | Wardrobe ID |
| G | Contract ID | Contract ID |

---

## Prerequisites

Before configuring Customer Staff Sync, you need:

1. **Azure Storage Account** with a Blob container created
2. Access to Azure Portal to generate SAS tokens
3. Excel files in the correct format uploaded to the container

---

## Azure Blob Storage Setup

### Step 1: Create Azure Storage Account

If you don't have a storage account:

1. Sign in to [Azure Portal](https://portal.azure.com)
2. Click **Create a resource** > **Storage account**
3. Configure:
   - **Resource group**: Select or create one
   - **Storage account name**: Lowercase, globally unique (e.g., `pdcstaffimports`)
   - **Region**: Choose nearest to your BC environment
   - **Performance**: Standard
   - **Redundancy**: LRS (Locally-redundant) is sufficient
4. Click **Review + Create** > **Create**

### Step 2: Create Blob Container

1. Open your Storage Account in Azure Portal
2. In the left menu, under **Data storage**, click **Containers**
3. Click **+ Container**
4. Enter:
   - **Name**: e.g., `staff-imports`
   - **Public access level**: Private (no anonymous access)
5. Click **Create**

### Step 3: Generate SAS Token

A Shared Access Signature (SAS) token provides secure access without sharing your storage account keys.

#### Required Permissions

| Permission | Required | Purpose |
|------------|----------|---------|
| Read | Yes | Download Excel files |
| List | Yes | Find files in container |
| Write | No | Not needed for import |
| Delete | No | Not needed for import |

#### Generate via Azure Portal

1. Open your **Storage Account**
2. In the left menu, under **Security + networking**, click **Shared access signature**
3. Configure:

   **Allowed services**: Blob only

   **Allowed resource types**: Container, Object (both required)

   **Allowed permissions**: Read, List

   **Start and expiry date/time**:
   - Start: Current date/time
   - Expiry: Future date (e.g., 1 year)

   **Allowed protocols**: HTTPS only

4. Click **Generate SAS and connection string**
5. Copy the **SAS token** value (starts with `sv=`)

#### Example SAS Token

```
sv=2022-11-02&ss=b&srt=co&sp=rl&se=2027-01-01T00:00:00Z&st=2026-01-01T00:00:00Z&spr=https&sig=xxxxx
```

#### SAS Token Parameters

| Parameter | Meaning |
|-----------|---------|
| `sv` | Storage service version |
| `ss=b` | Allowed services (b = Blob) |
| `srt=co` | Resource types (c=container, o=object) |
| `sp=rl` | Permissions (r=read, l=list) |
| `se` | Expiry date/time |
| `st` | Start date/time |
| `spr=https` | Protocol (HTTPS only) |
| `sig` | Cryptographic signature |

### Step 4: Upload Excel Files

1. In Azure Portal, open your container
2. Click **Upload**
3. Select your Excel file(s)
4. Click **Upload**

Or use [Azure Storage Explorer](https://azure.microsoft.com/products/storage/storage-explorer/) for desktop file management.

---

## BC Setup Guide

### Step 1: Open Customer Staff Sync

1. Choose the magnifier icon
2. Enter **PDC Blob Staff Import Setup List** or navigate via:
3. Order Processor Role Center > PDC Portal > PDC Administration > **Customer Staff Sync**

### Step 2: Create New Setup

1. Click **New** to create a new configuration
2. The Setup Card opens with the following sections:

### Step 3: Configure General Section

| Field | Description | Example |
|-------|-------------|---------|
| **Customer No.** | Select the customer for this import | CUST001 |
| **Enabled** | Enable/disable this configuration | Yes |

### Step 4: Configure Azure Connection Section

| Field | Description | Example |
|-------|-------------|---------|
| **Storage Account Name** | Azure storage account name (without .blob.core.windows.net) | pdcstaffimports |
| **Container Name** | Blob container name | staff-imports |
| **SAS Token** | Paste your SAS token (masked for security) | sv=2022-11-02&ss=b... |
| **File Name Pattern** | Pattern to match files | *.xlsx |

### Step 5: Configure Import Options Section

| Field | Description | Default |
|-------|-------------|---------|
| **Create New Staff** | Create new staff records if Wearer ID not found | Yes |
| **Update Existing Staff** | Update existing staff when Wearer ID found | Yes |

### Step 6: Test Connection

1. Click **Test Connection** action
2. If successful: "Connection to Azure Blob Storage was successful."
3. If failed: Check your settings (see Troubleshooting section)

---

## Page Layout Reference

### Setup Card Sections

**General**
- Customer No.
- Enabled

**Azure Connection**
- Storage Account Name
- Container Name
- SAS Token
- File Name Pattern

**Import Options**
- Create New Staff
- Update Existing Staff

**Last Import** (read-only)
- Last Import DateTime
- Last Import File Name
- Last Import Staff Created
- Last Import Staff Updated
- Last Import Errors

### Available Actions

| Action | Description |
|--------|-------------|
| **Test Connection** | Verify Azure Blob connection |
| **Run Import Now** | Execute import immediately |
| **View Staff List** | Open Branch Staff filtered by customer |
| **View Import Log** | View import history and status per row |

---

## Container Structure

Place Excel files in the configured container:

```
pdcstaffimports/
  staff-imports/
    staff-list-2026-01-15.xlsx
    staff-list-2026-02-01.xlsx
    staff-list-2026-02-03.xlsx  <-- Latest file imported
```

The import automatically selects the most recently modified file matching the pattern.

### File Name Patterns

| Pattern | Matches |
|---------|---------|
| *.xlsx | Any Excel file |
| staff*.xlsx | staff-list.xlsx, staff-2026.xlsx |
| staff-list.xlsx | Only exact match |

---

## Excel File Format

### Required Format

The Excel file must have:

*   **Header row**: Row 1 is skipped (headers)

*   **Data rows**: Starting from row 2

*   **Columns A-G**: As specified in the mapping

### Sample Excel Structure

| A (Wearer ID) | B (First Name) | C (Last Name) | D (Body Type) | E (Branch ID) | F (Wardrobe ID) | G (Contract ID) |
|---------------|----------------|---------------|---------------|---------------|-----------------|-----------------|
| EMP001 | John | Smith | M | BRANCH01 | WDR001 | CTR001 |
| EMP002 | Jane | Doe | F | BRANCH02 | WDR001 | CTR001 |
| EMP003 | Bob | Johnson | M | BRANCH01 | WDR002 | CTR002 |

### Field Validation

| Field | Required | Validation |
|-------|----------|------------|
| Wearer ID | Yes | Must not be empty |
| First Name | No | Text up to 30 chars |
| Last Name | No | Text up to 30 chars |
| Body Type | No | Must exist in PDC General Lookup (Type = BODYTYPE) |
| Branch ID | No | Must exist for the customer |
| Wardrobe ID | No | Must exist for the customer |
| Contract ID | No | Must exist for the customer |

---

## Running Imports

### Manual Import

1. Open the setup card for the customer
2. Click **Run Import Now**
3. Wait for completion message
4. Review results:
    *   Created: New staff records added
    *   Updated: Existing staff records modified
    *   Errors: Rows skipped due to validation

### Scheduled Import (Job Queue)

Set up automated imports using Job Queue:

1. Search for **Job Queue Entries**
2. Create a new entry:

| Field | Value |
|-------|-------|
| **Object Type to Run** | Codeunit |
| **Object ID to Run** | 50021 |
| **Description** | Staff Import - CUSTOMER |
| **Parameter String** | Customer No. (e.g., CUST001) |
| **Recurring Job** | Yes |
| **Run on Mondays-Sundays** | As needed |
| **Starting Time** | e.g., 06:00 |

3. Set status to **Ready**

### Job Queue Parameters

| Parameter String | Behavior |
|------------------|----------|
| (blank) | Process all enabled setups |
| CUST001 | Process only CUST001 |

---

## Import Behavior

### Matching Logic

Staff are matched by **Wearer ID + Customer No.**:

```
1. Search for existing staff where:
   - Sell-to Customer No. = Setup Customer No.
   - Wearer ID = Excel Wearer ID

2. If found: Update existing record
3. If not found: Create new record
```

### Create vs Update

| Scenario | Create New Staff = Yes | Create New Staff = No |
|----------|------------------------|----------------------|
| Staff exists | Update | Update |
| Staff not found | Create | Skip |

| Scenario | Update Existing = Yes | Update Existing = No |
|----------|----------------------|---------------------|
| Staff exists | Update | Skip |
| Staff not found | Create | Create |

### Field Update Behavior

When updating existing staff:

*   **Always updated**: First Name, Last Name, Name

*   **Validated then updated**: Body Type, Branch ID, Wardrobe ID, Contract ID

*   **Never updated**: Staff ID, Sell-to Customer No., Wearer ID

---

## Tracking & History

### Last Import Information

The setup card shows (read-only):

| Field | Description |
|-------|-------------|
| **Last Import DateTime** | When import last ran |
| **Last Import File Name** | Which file was imported |
| **Last Import Staff Created** | Count of new records |
| **Last Import Staff Updated** | Count of updated records |
| **Last Import Errors** | Count of skipped rows |

### Viewing Staff Results

Click **View Staff List** to open Branch Staff List filtered by customer.

---

## Import Log

The Import Log tracks every row processed during imports, providing detailed visibility into what happened.

### Accessing the Import Log

1. From Setup Card: Click **View Import Log** action
2. Direct search: Search for **PDC Blob Staff Import Log**

### Log Fields

| Field | Description |
|-------|-------------|
| **Entry No.** | Unique log entry number |
| **Import DateTime** | When the import was run |
| **Customer No.** | Customer for this import |
| **File Name** | Name of the imported file |
| **Row No.** | Excel row number |
| **Status** | Created, Updated, Skipped, or Error |
| **Wearer ID** | Wearer ID from Excel |
| **Staff ID** | BC Staff ID (if created/found) |
| **First Name** | First name from Excel |
| **Last Name** | Last name from Excel |
| **Branch ID** | Branch ID from Excel |
| **Wardrobe ID** | Wardrobe ID from Excel |
| **Contract ID** | Contract ID from Excel |
| **Message** | Result details or error description |

### Status Values

| Status | Color | Description |
|--------|-------|-------------|
| **Created** | Green | New staff record was created |
| **Updated** | Blue | Existing staff record was updated |
| **Skipped** | Yellow | Row was skipped (Create/Update disabled or duplicate) |
| **Error** | Red | Row failed validation (e.g., empty Wearer ID) |

### Duplicate File Detection

When running an import manually, if the file was already imported, you'll be prompted:

> "File [filename] was already imported on [datetime]. Do you want to import again?"

- Click **Yes** to re-import
- Click **No** to cancel

In Job Queue (scheduled) mode, previously imported files are automatically skipped.

### Log Actions

| Action | Description |
|--------|-------------|
| **Open Staff Card** | Open the staff record for this log entry |
| **Delete Old Entries** | Remove log entries older than 30 days |

---

## Troubleshooting

### Connection Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| "Authentication failed" | Invalid SAS token | Check SAS token was copied completely |
| "Token expired" | SAS token expired | Generate new token with future expiry |
| "Access denied" | Missing permissions | Verify Read and List are enabled |
| "Resource not found" | Wrong service type | Ensure token is for Blob service (not File) |
| "Storage account not found" | Wrong account name | Check name (lowercase, no .blob.core.windows.net) |
| "Container not found" | Wrong container name | Verify container exists in Azure |

### Import Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| No files found | Pattern doesn't match | Check File Name Pattern setting |
| No files found | Empty container | Upload Excel file to container |
| 0 created, 0 updated | Create/Update options disabled | Enable Create New Staff and/or Update Existing Staff |
| High error count | Invalid lookup values | Check Branch/Wardrobe/Contract IDs exist |

### Validation Errors

| Error Type | Cause | Resolution |
|------------|-------|------------|
| Wearer ID empty | Column A is blank | Ensure all rows have Wearer ID |
| Branch not found | Branch ID doesn't exist | Create branch or correct Excel data |
| Wardrobe not found | Wardrobe ID doesn't exist | Create wardrobe or correct Excel data |
| Body Type invalid | Body Type not in lookup | Add to PDC General Lookup (BODYTYPE) |

### Job Queue Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| Job not running | Status not Ready | Set Job Queue Entry status to Ready |
| Wrong customer processed | Parameter String incorrect | Verify Customer No. in Parameter String |
| All customers processed | Parameter String blank | Add specific Customer No. if needed |

---

## Security Best Practices

1. **Minimal SAS permissions**: Only enable Read + List
2. **Set expiry dates**: Don't create tokens that never expire
3. **Rotate tokens**: Regenerate tokens periodically (e.g., annually)
4. **Use HTTPS only**: Never use HTTP for SAS tokens
5. **Dedicated container**: Separate staff files from other data
6. **Private access**: Keep container access level as Private

---

## Best Practices

### File Management

1. **Use dated file names**: staff-list-2026-02-03.xlsx
2. **Archive old files**: Move processed files to archive folder
3. **Validate before upload**: Check Excel format matches expected structure

### Scheduling

| Frequency | Use Case |
|-----------|----------|
| Daily | High-turnover environments |
| Weekly | Stable workforce |
| On-demand | Occasional bulk updates |

### Monitoring

1. **Check Last Import info**: Review after scheduled runs
2. **Monitor error counts**: Investigate if errors increase
3. **Verify staff counts**: Spot-check imported records

---

## Field Reference

### Setup Table Fields

| Field | Type | Description |
|-------|------|-------------|
| Customer No. | Code[20] | Primary key, links to Customer |
| Storage Account Name | Text[100] | Azure storage account |
| Container Name | Text[100] | Blob container |
| SAS Token | Text[500] | Authentication (masked) |
| Enabled | Boolean | Active/inactive toggle |
| File Name Pattern | Text[100] | Pattern to match files |
| Create New Staff | Boolean | Create new records |
| Update Existing Staff | Boolean | Update existing records |
| Last Import DateTime | DateTime | Last run timestamp |
| Last Import File Name | Text[250] | Last imported file |
| Last Import Staff Created | Integer | Created count |
| Last Import Staff Updated | Integer | Updated count |
| Last Import Errors | Integer | Error count |

---

## Related Objects

| Object | ID | Purpose |
|--------|----|---------|
| Table | 50059 | PDC Blob Staff Import Setup |
| Table | 50060 | PDC Blob Staff Import Log |
| Enum | 50010 | PDC Blob Staff Import Status |
| Page | 50115 | PDC Blob Staff Imp. Setup Card |
| Page | 50116 | PDC Blob Staff Imp. Setup List |
| Page | 50117 | PDC Blob Staff Import Log |
| Codeunit | 50021 | PDC Blob Staff Import |

---

**Related Topics**: PDC Branch Staff, PDC Branches, PDC Wardrobes, Job Queue Entries
