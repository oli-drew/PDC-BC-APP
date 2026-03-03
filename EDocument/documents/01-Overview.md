# PDC E-Document

## Overview

The PDC E-Document app provides bidirectional document exchange between Business Central and external systems via Azure File Share. It supports both receiving orders (inbound) and sending invoices (outbound).

## Key Features

### Inbound (Receiving)
- **Automatic Import**: CSV files retrieved from Azure File Share on schedule
- **Sales Order Creation**: Automatically creates Sales Orders with field mapping
- **Duplicate Detection**: Prevents the same order from being imported twice
- **Error Handling**: Continues processing valid orders even if some lines fail

### Outbound (Sending)
- **Invoice Export**: Send Posted Sales Invoices to Azure File Share
- **Multiple Formats**: Support for PEPPOL XML and PDC CSV formats
- **Automatic Upload**: Documents uploaded via Azure REST API

### Common
- **E-Document Integration**: Built on Microsoft's E-Document framework
- **Centralized Logging**: All activity tracked in E-Document Log
- **Secure Connection**: SAS Token authentication to Azure

## Supported Formats

| Format | Direction | Description |
|--------|-----------|-------------|
| R777 CSV | Inbound | TemplaCMS purchase order import |
| PDC CSV | Outbound | Flat CSV invoice export |
| PEPPOL BIS 3.0 | Outbound | Standard XML e-invoicing |

## How It Works

### Inbound Flow
```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  External       │     │  Azure File      │     │  Business       │
│  System         │────▶│  Share           │────▶│  Central        │
│                 │     │                  │     │                 │
│  Exports CSV    │     │  /inbound/       │     │  Creates Sales  │
│  orders         │     │                  │     │  Orders         │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

1. External system exports orders as CSV files
2. Files stored in Azure File Share (inbound directory)
3. Business Central retrieves files on schedule
4. E-Document Service processes each file
5. Sales Orders created with mapped fields
6. Processed files deleted from Azure

### Outbound Flow
```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Business       │     │  Azure File      │     │  External       │
│  Central        │────▶│  Share           │────▶│  System         │
│                 │     │                  │     │                 │
│  Posts Invoice  │     │  /outbound/      │     │  Retrieves      │
│                 │     │                  │     │  invoices       │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

1. User posts Sales Invoice in Business Central
2. Send action triggers E-Document export
3. Document formatted (CSV or XML)
4. File uploaded to Azure File Share (outbound directory)
5. External system retrieves file

## Components

| Component | Direction | Purpose |
|-----------|-----------|---------|
| Azure File Share Connector | Both | Connects to Azure (download/upload) |
| E-Document Service | Both | Configuration hub - connection, formats |
| R777 CSV Parser | Inbound | Parses CSV and extracts order data |
| Sales Order Creator | Inbound | Creates Sales Orders from parsed data |
| PDC CSV Format | Outbound | Generates CSV from Posted Sales Invoice |
| E-Document Log | Both | Tracks all activity and errors |

## Prerequisites

- Microsoft Dynamics 365 Business Central (version 26.0 or higher)
- Microsoft E-Document Core app
- Azure Storage Account with File Share
- SAS Token with appropriate permissions:
  - **Inbound**: Read, List, Delete
  - **Outbound**: Write
  - **Both**: Read, Write, List, Delete

## Quick Start

### For Inbound (Receiving Orders)

1. Open **E-Document Services** page
2. Create new service with **Service Integration** = "Azure File Share"
3. Set **Document Format** = "R777 CSV"
4. Configure Azure connection (account, share, directory)
5. Set **Customer No.** and **Dummy Vendor No.**
6. Enable automatic import via Job Queue or use **Receive** action

### For Outbound (Sending Invoices)

1. Open **E-Document Services** page
2. Create new service with **Service Integration** = "Azure File Share"
3. Set **Document Format** = "PDC CSV" or "PEPPOL BIS 3.0"
4. Configure Azure connection (account, share, outbound directory)
5. Post a Sales Invoice and use **Send** action

See [Azure Setup](02-Azure-Setup.md) to get started.

## Documentation

| # | Document | Description |
|---|----------|-------------|
| 02 | [Azure Setup](02-Azure-Setup.md) | Storage account, SAS tokens, connection |
| 03 | [Inbound Setup](03-Inbound-Setup.md) | Receiving orders configuration |
| 04 | [Outbound Setup](04-Outbound-Setup.md) | Sending documents configuration |
| 05 | [Daily Operations](05-Daily-Operations.md) | Monitoring and management |
| 06 | [R777 CSV Format](06-R777-CSV-Format.md) | Inbound column specification |
| 07 | [PDC CSV Format](07-PDC-CSV-Format.md) | Outbound column specification |
| 08 | [Troubleshooting](08-Troubleshooting.md) | Error resolution |
