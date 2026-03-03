# Azure Setup

This guide covers the common Azure configuration required for both inbound and outbound document exchange.

## Prerequisites

Before starting, you need:

1. **Azure Storage Account** with a File Share created
2. Access to Azure Portal to generate SAS tokens

---

## Step 1: Create Azure Storage Account

If you don't have a storage account:

1. Sign in to [Azure Portal](https://portal.azure.com)
2. Click **Create a resource** > **Storage account**
3. Configure:
   - **Resource group**: Select or create one
   - **Storage account name**: Lowercase, globally unique (e.g., `pdcedocuments`)
   - **Region**: Choose nearest to your BC environment
   - **Performance**: Standard
   - **Redundancy**: LRS (Locally-redundant) is sufficient
4. Click **Review + Create** > **Create**

---

## Step 2: Create File Share

1. Open your Storage Account in Azure Portal
2. In the left menu, under **Data storage**, click **File shares**
3. Click **+ File share**
4. Enter:
   - **Name**: e.g., `edocuments`
   - **Tier**: Transaction optimized
5. Click **Create**

### Create Directories (Optional)

For organization, create separate directories:

1. Open the file share
2. Click **+ Add directory**
3. Create directories:
   - `inbound` - for receiving files
   - `outbound` - for sending files

---

## Step 3: Generate SAS Token

A Shared Access Signature (SAS) token provides secure access without sharing your storage account keys.

### Required Permissions

| Direction | Permissions Needed |
|-----------|-------------------|
| Inbound only | Read, List, Delete |
| Outbound only | Write |
| Both directions | Read, Write, List, Delete |

### Generate via Azure Portal

1. Open your **Storage Account**
2. In the left menu, under **Security + networking**, click **Shared access signature**
3. Configure:

   **Allowed services**: File only

   **Allowed resource types**: Service, Container, Object (all three)

   **Allowed permissions**: Based on your needs (see table above)

   **Start and expiry date/time**:
   - Start: Current date/time
   - Expiry: Future date (e.g., 1 year)

   **Allowed protocols**: HTTPS only

4. Click **Generate SAS and connection string**
5. Copy the **SAS token** value (starts with `sv=`)

### Example SAS Token

```
sv=2022-11-02&ss=f&srt=sco&sp=rwld&se=2027-01-01T00:00:00Z&st=2026-01-01T00:00:00Z&spr=https&sig=xxxxx
```

### SAS Token Parameters

| Parameter | Meaning |
|-----------|---------|
| `sv` | Storage service version |
| `ss=f` | Allowed services (f = File) |
| `srt=sco` | Resource types (service, container, object) |
| `sp=rwld` | Permissions (r=read, w=write, l=list, d=delete) |
| `se` | Expiry date/time |
| `st` | Start date/time |
| `spr=https` | Protocol (HTTPS only) |
| `sig` | Cryptographic signature |

---

## Step 4: Configure E-Document Service

1. In Business Central, search for **E-Document Services**
2. Click **New** to create a service
3. Fill in:
   - **Code**: Unique identifier (e.g., `AZURE-EDI`)
   - **Description**: Descriptive name
   - **Service Integration**: Select **Azure File Share**
4. In the **Azure File Share** section:

| Field | Description | Example |
|-------|-------------|---------|
| **Storage Account Name** | Your Azure storage account name | `pdcedocuments` |
| **File Share Name** | The file share name | `edocuments` |
| **Directory Path** | Inbound directory (or root) | `inbound` |
| **Outbound Directory Path** | Outbound directory | `outbound` |

5. Click **Set SAS Token** action
6. Enter your SAS token and click **OK**
7. **SAS Token Configured** shows "Yes"

---

## Step 5: Test Connection

1. On the E-Document Service card, click **Test Connection**
2. Expected result: "Connection successful. Found X files in the directory."

### Troubleshooting Connection

| Issue | Solution |
|-------|----------|
| "Authentication failed" | Check SAS token was copied completely |
| "Token expired" | Generate new token with future expiry |
| "Access denied" | Verify required permissions are enabled |
| "Resource not found" | Ensure token is for File service (not Blob) |
| "Storage account not found" | Check account name (lowercase, no spaces) |

---

## Security Best Practices

1. **Minimal permissions**: Only enable permissions you need
2. **Set expiry dates**: Don't create tokens that never expire
3. **Rotate tokens**: Regenerate tokens periodically
4. **Use HTTPS only**: Never use HTTP for SAS tokens
5. **Separate tokens**: Consider separate tokens for inbound/outbound

---

## Alternative: Azure Storage Explorer

For a desktop experience:

1. Download [Azure Storage Explorer](https://azure.microsoft.com/products/storage/storage-explorer/)
2. Connect to your Azure account
3. Navigate to Storage Account > File Shares
4. Right-click the file share > **Get Shared Access Signature**
5. Configure and create

---

## Next Steps

- [Inbound Setup](03-Inbound-Setup.md) - Configure order receiving
- [Outbound Setup](04-Outbound-Setup.md) - Configure document sending
