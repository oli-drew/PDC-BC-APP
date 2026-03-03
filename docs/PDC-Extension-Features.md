# PDC Extension – Feature Overview

> **App Name:** PDC · **Publisher:** JEMEL SIA · **Version:** 26.0.0.62  
> **Runtime:** 15.2 · **Target:** Cloud · **ID Range:** 50000–50299 (main), 50300–50399 (EDocument), 50400–50499 (Shopify), 60000–60099 (Fix)  
> **Dependencies:** Insight Works – IWorks Common 2.18+, Insight Works – PrintNode Connector 2.3+  
> **Companion Apps:** PDC EDocument (v26.0.0.56), PDC Shopify (v27.0.0.61), PDC Fix (v25.0.0.2)

---

## 1. Executive Summary

PDC is a purpose-built Business Central extension for **Peter Drew & Company (PDC)**, a corporate workwear / uniform management company. It transforms standard BC into a vertically-integrated platform that manages the **complete lifecycle of corporate uniform provisioning**: from product proposals and customer wardrobes through staff entitlement tracking, portal-based ordering, production planning, pick/pack/ship, courier integration, invoicing, and returns.

**Core business problems solved:**

- **Staff entitlement management** – each customer's staff have quantity/value/points-based wardrobe entitlements that must be tracked, enforced, and renewed over configurable periods.
- **Self-service ordering portal** – customer administrators and staff place orders through an external portal backed by BC data via XML/JSON web services, with branch-based security, draft order approval workflows, and Azure AD B2C authentication.
- **Multi-channel order intake** – orders originate from the Portal, EDI files (R777/TemplaCMS CSV), Shopify, and manual entry; all funnelled into standard BC sales orders with full traceability of origin.
- **End-to-end shipping** – DPD and DX courier APIs for shipment creation, label printing (PrintNode/EPL/PDF), and real-time parcel tracking.
- **Production & branding** – garments undergo branding/embroidery tracked via custom routing lines, with proposal costing, production order label printing, and auto-finish of production orders upon purchase receipt.
- **Demand planning** – monthly demand forecasting per product/colour with integrated views of inventory, purchase orders, and sales orders.
- **Consolidated invoicing** – period-based invoice consolidation grouped by branch, wearer, contract, or wardrobe.
- **E-Document exchange** – inbound EDI via Azure File Share (R777 CSV → Sales Orders) and outbound invoice CSV export.

---

## 2. What's Added or Changed in Business Central (High Level)

- **58 custom tables** and **57 table extensions** adding 400+ fields across core BC entities
- **104 custom pages** (20 API pages, cards, lists, worksheets) and **87 page extensions**
- **21 codeunits** in the main app, 6 in EDocument, 1 in Shopify — 28 total
- **66 reports** (document layouts + processing-only), 1 report extension
- **22 queries** (portal dashboards, entitlement counts, production order summaries as API queries)
- **49 XMLports** (6 purchase order CSV exports, 43 portal XML web service serialisers)
- **7 enums**, **2 enum extensions**
- **1 ControlAddIn** (HTML-to-PDF via html2pdf.js)
- **1 permission set** granting full RIMD on all custom objects
- Customer portal with 50+ web service endpoints (JSON/XML), Azure AD B2C integration, SSO
- Courier integration with DPD and DX APIs (shipment booking, PDF/EPL labels, parcel tracking)
- Job queue automation (draft order processing, email sending, order confirmation, auto-reserve/release, report printing)
- 7 standard BC reports replaced with PDC-branded versions
- 30+ event subscribers modifying standard posting, warehouse, planning, and pricing behaviours
- E-Document framework integration for Azure File Share inbound/outbound EDI
- Shopify Connector integration to capture order source and wearer data

---

## 3. Feature Breakdown (Detailed)

### Feature: Customer Wardrobe Management

- **What it does:** Defines per-customer product catalogues ("wardrobes") containing product lines with colour options. Each wardrobe line specifies a product code, gender filter, sort order, item type (core/accessory), and entitlement rules including period, quantity, value, or points-based groups.
- **Who uses it:** Uniform administrators, account managers.
- **Where in BC:** `PDC Wardrobe List` (Page 50024) → `PDC Wardrobe Card` (Page 50025) with subpage `PDC Wardrobe Lines` (Page 50027). Wardrobe Item Options (Page 50036). Wardrobe Worksheet (Page 50039) for bulk data entry.
- **How it works:** Wardrobes are assigned to customers via `PDC Wardrobe Header` (Table 50018). Each wardrobe has lines (`PDC Wardrobe Line`, Table 50019) specifying a product code that maps to items via `Item."PDC Product Code"`. Colour options per line are stored in `PDC Wardrobe Item Option` (Table 50021). Entitlement groups (`PDC Wardrobe Entitlement Group`, Table 50001) attach quantity/value/points budgets to wardrobe lines. Changes cascade to staff entitlement records automatically. A worksheet page allows bulk creation and posting of wardrobe lines.
- **Objects involved:**
  - Table 50018 `PDC Wardrobe Header`, Table 50019 `PDC Wardrobe Line`, Table 50021 `PDC Wardrobe Item Option`
  - Table 50001 `PDC Wardrobe Entitlement Group`, Table 50000 `PDC Staff Entitlement Group`
  - Table 50027 `PDC Wardrobe Worksheet`
  - Pages 50024, 50025, 50027, 50034, 50036, 50039, 50000, 50001
  - Codeunit 50000 `PDC Staff Entitlement` – manages cascade updates
- **Dependencies / setup:** Item table must have `PDC Product Code` populated. Size scales must be defined. Entitlement groups must be configured if group-based entitlement is used.
- **Edge cases / constraints:** Wardrobe lines cannot be deleted if staff entitlement records exist. Wardrobe headers cannot be deleted if staff is assigned. Gender filtering uses codes `M|O`, `F|O`, `U` (Male+Other, Female+Other, Unisex).

---

### Feature: Staff Entitlement Tracking

- **What it does:** Automatically tracks how many uniform items each staff member is entitled to, has been issued, has on order, on return, and on draft orders. Enforces configurable over-entitlement actions (No Action, Warning, Escalate, Block).
- **Who uses it:** Uniform coordinators, portal users, account managers.
- **Where in BC:** `PDC Staff Entitlement List` (Page 50030), `PDC Staff Entitlement Predict.` (Page 50060). Entitlement data also shown on Branch Staff Card and via API.
- **How it works:** When a staff member is assigned to a wardrobe, the system creates `PDC Staff Entitlement` (Table 50022) records per product per group. Start/end dates define the entitlement period (default 365 days). Quantity Posted/On Order/On Return/On Draft are FlowFields from Item Ledger Entries and Sales Lines filtered by `PDC Staff ID`. The `CalculateQuantities` method computes the remaining balance. A predicted version (`PDC Staff Entitlement Predict.`, Table 50050) supports what-if analysis. Over-entitlement action is configured per customer.
- **Objects involved:**
  - Table 50022 `PDC Staff Entitlement`, Table 50050 `PDC Staff Entitlement Predict.`
  - Codeunit 50000 `PDC Staff Entitlement`
  - Pages 50030, 50060
  - Report 50031 `PDC Staff Entitl. Calc. Qty`, Report 50019 `PDC Update Staff Entitlement`, Report 50051 `PDC Staff Entitlement Inactiv`
  - Query 50007 `PDCEntitlementCount`, Query 50008 `PDCEntitlementPredictedCount`
  - Enum 50001 `PDCEntitlementGroupType`, Enum 50006 `PDC Over Entitlement Action`
- **Dependencies / setup:** Branch Staff must be linked to a wardrobe. Wardrobe lines must exist with entitlement configuration. The customer's `PDC Over Entitlement Action` field controls enforcement behaviour.
- **Edge cases / constraints:** Entitlement periods can be postponed per staff member. Inactive entitlements are timestamped. The `UpdateDraftOrderItemLines` procedure is intentionally disabled (`exit;`).

---

### Feature: Branch & Staff Hierarchy

- **What it does:** Implements a hierarchical branch structure for customers with staff members assigned to branches. Branches support parent/child relationships with presentation ordering and indentation. Staff members hold demographics (gender, body type), wardrobe assignment, contract assignment, and wearer ID.
- **Who uses it:** Account managers, portal administrators.
- **Where in BC:** `PDC Branches` (Page 50018) → `PDC Branch Card` (Page 50028). `PDC Branch Staff List` (Page 50026) → `PDC Branch Staff Card` (Page 50029).
- **How it works:** `PDC Branch` (Table 50012) is keyed by Customer No. + Branch No. with a self-referential `Parent Branch No.` with cycle detection. Staff records (`PDC Branch Staff`, Table 50020) are auto-numbered, link to customer/branch/wardrobe/contract, and store demographics used for gender-filtered wardrobe product eligibility. Portal users are filtered by branch access, with hierarchical branch visibility (parent sees all children).
- **Objects involved:**
  - Table 50012 `PDC Branch`, Table 50020 `PDC Branch Staff`
  - Table 50034 `PDC Gender`, Table 50011 `PDC General Lookup` (BODYTYPE)
  - Pages 50018, 50028, 50026, 50029
  - API Pages 50100, 50106
  - Report 50056 `PDCCreateBranchStaffFromTG` – imports from Timegate HR system
- **Dependencies / setup:** Customer must exist. Gender and Body Type lookup values must be configured. For Timegate integration, `PDC Timegate Joiners Leavers` (Table 50002) must be populated.
- **Edge cases / constraints:** Branch cyclic inheritance is prevented on validation. Staff with existing entitlement records cannot be deleted. Wearer ID must be unique per customer.

---

### Feature: Customer Portal & Web Services

- **What it does:** Provides a comprehensive REST/SOAP API layer that powers an external customer ordering portal. Portal users (authenticated via Azure AD B2C or password hash) can browse wardrobes, check entitlement, create/approve draft orders, view orders/invoices/returns, download documents, and manage staff and addresses.
- **Who uses it:** Portal end-users (staff ordering uniforms), customer administrators, approvers.
- **Where in BC:** `PDC Nav Portal List` (Page 50088) → `PDC Nav Portal Card` (Page 50089). Portal User management: `PDC Portal User List` (Page 50085) → `PDC Portal User Card` (Page 50086). Portal roles: `PDC Nav Portal Roles` (Page 50090).
- **How it works:** Codeunit 50016 `PDCPortalsWebService` is the main routing handler with 50+ endpoints accepting JSON/XML requests. It dispatches to specific handler procedures based on Command/SubCommand parameters. Authentication supports password hash (MD5+salt) and SSO with pre-shared key. Codeunit 50018 `PDCPortalMgt` handles data filtering by portal user permissions (branch-based, role-based). 43 XMLports serialise/deserialise BC data for the portal. Azure AD B2C user management is handled by Codeunit 50010 `PDCAzureUserMgt` using Microsoft Graph API.
- **Objects involved:**
  - Tables 50051–50058: `PDC Portal User`, `PDC Portal User Role`, `PDC Portal`, `PDC Portal Role`, `PDC Portal List Paging`, `PDC Name Value Buffer`, `PDC Text Buffer`, `PDC Portal User Wardrobe`, `PDC Portal User Branch`, `PDC Portal User Ship-to Addrs`
  - Codeunits 50016 `PDCPortalsWebService`, 50017 `PDCPortalsManagement`, 50018 `PDCPortalMgt`, 50019 `PDCPortalSalesPrice`, 50010 `PDCAzureUserMgt`
  - 43 XMLports (IDs 50010–50064)
  - Pages 50085–50091, 50023, 50003, 50072
  - Enum 50005 `PDC Portal User Type` (Standard/Staff/Approver/Bulk Order)
  - Multiple portal reports (50020–50029, 50037, 50039, 50042, 50052, 50061, 50062, 50063, 50098)
- **Dependencies / setup:** `PDC Portal` record must be configured with authentication settings (Tenant Id, Client Id, Secret for Azure AD B2C). Portal roles must be defined. No. Series for wardrobes, draft orders, branch staff, contracts must be configured on the Portal card. For Azure AD B2C: Graph API credentials required.
- **Edge cases / constraints:** SSO auto-creates portal users if `SSOCreatePortalUser` is enabled. MD5 hashing with `'NAVPortalsSalt'` is used for legacy password authentication. Portal users see only branches they are assigned to; parent branches grant visibility to child branches.

---

### Feature: Draft Order Workflow

- **What it does:** Implements a pre-sales-order document ("draft order") created from the portal. Draft orders go through staff assignment, item selection (filtered by wardrobe/entitlement), SLA date calculation, optional approval, and conversion to one or more sales orders.
- **Who uses it:** Portal users (creators), portal approvers, BC order processors.
- **Where in BC:** `PDC Draft Orders` (Page 50031) → `PDC Draft Order` (Page 50032) with subpages for staff lines (Page 50033) and item lines (Page 50035).
- **How it works:** Draft orders (`PDC Draft Order Header`, Table 50023) are created from the portal with customer/shipping details. Staff lines (`PDC Draft Order Staff Line`, Table 50024) assign specific staff members. Item lines (`PDC Draft Order Item Line`, Table 50025) specify items from the wardrobe with quantities, pricing (calculated via `PDCPortalSalesPrice`), and SLA dates. Conversion is handled by Codeunit 50004 `PDCDraftOrderProcess` which groups by `Create Order No.` for multi-order draft orders, creates Sales Headers/Lines with all PDC traceability fields, adds carriage charges, and enqueues confirmation emails. Job queue wrapper Codeunit 50005 `PDCDraftOrderProcessJQ` provides async processing.
- **Objects involved:**
  - Tables 50023–50025: `PDC Draft Order Header`, `PDC Draft Order Staff Line`, `PDC Draft Order Item Line`
  - Codeunits 50004 `PDCDraftOrderProcess`, 50005 `PDCDraftOrderProcessJQ`
  - Pages 50031–50035
  - API Pages 50102–50105
  - Query 50011 `PDCDraftOrdItemByStaffProd`
  - Report 50032 `PDC Portal - Draft Order`, Report 50042 `PDCDraftOrdersNotification`, Report 50061 `PDCDraftOrdersApproveReminder`
- **Dependencies / setup:** Draft order No. Series configured on Portal card. Shipping Agent Services with carriage charge configuration. Customer-specific carriage charge overrides via `PDC Ship.Agent Serv. Per Cust.`.
- **Edge cases / constraints:** Draft orders support three shipping types: Ship All Available Now, Ship Complete Uniform Set, Ship Complete Order. Over-entitlement items require a reason code. The `Proceed Order` flag (FlowField) must be satisfied before conversion.

---

### Feature: Multi-Channel Order Intake

- **What it does:** Captures the origin of every sales order (`Order Source` field) from four channels: Portal, EDI, Shopify, or manual entry. Ensures full traceability of who ordered, for whom, and through which channel.
- **Who uses it:** Order processors, management reporting.
- **Where in BC:** `PDC Order Source` field on Sales Order (PageExt 50010), Sales Order List (PageExt 50035).
- **How it works:**
  - **Portal:** Codeunit 50004 sets `Order Source = 'PORTAL'` during draft order conversion.
  - **EDI:** Codeunit 50302 `PDCEDISalesOrderCreator` sets `Order Source = 'EDI'` when creating sales orders from R777 CSV imports via Azure File Share.
  - **Shopify:** Codeunit 50400 `PDCShopifyEvents` subscribes to `OnAfterCreateSalesHeader` and sets `Order Source = 'SHOPIFY'`.
  - **Manual:** No automatic source set; can be manually entered.
- **Objects involved:**
  - TableExt 50007 `PDCSalesHeader` – adds `PDC Order Source` field
  - Codeunit 50004 `PDCDraftOrderProcess`, Codeunit 50302 `PDCEDISalesOrderCreator`, Codeunit 50400 `PDCShopifyEvents`
  - PageExt 50010 `PDCSalesOrder`, PageExt 50035 `PDCSalesOrderList`
- **Dependencies / setup:** EDocument app required for EDI. Shopify app required for Shopify.
- **Edge cases / constraints:** The Order Source field is free-text Code[20], not an enum—any value can be entered manually.

---

### Feature: Courier Integration (DPD & DX)

- **What it does:** Integrates with DPD and DX courier APIs to book shipments, generate labels, and track parcels in real-time. Supports EPL (thermal) labels via PrintNode and PDF labels.
- **Who uses it:** Warehouse staff, despatch team.
- **Where in BC:** `PDC Sales Shipments` (Page 50015) for booking and label printing. `PDC Courier Sales Shipments` (Page 50016) for courier-specific view. `PDC Parcels Info` (Page 50050) for tracking.
- **How it works:** When a shipment is released, the system calls `PDCCourierShipmentHeader.Send_InsertShipment` which dispatches to DPD (Codeunit 50002) or DX (Codeunit 50007) based on `Shipping Agent."PDC Connection Type"`. DPD uses JSON REST for shipments + XML for tracking; DX uses JSON REST for both. Labels are printed via Insight Works PrintNode Connector (EPL format for DPD, PDF download for DX). Parcel tracking statuses are polled and mapped to standardised statuses (New/In Transit/Delivered/Exception/Returned/Cancelled). Codeunit 50012 `PDCCourierEvents` injects PDF labels into BC's report output stream.
- **Objects involved:**
  - Table 50010 `PDCCourierShipmentHeader`, Table 50028 `PDC Parcels Info`
  - Codeunits 50002 `PDCCourierDPD`, 50007 `PDCCourierDX`, 50012 `PDCCourierEvents`
  - Pages 50015, 50016, 50050
  - TableExt 50056 `PDCShippingAgent` – adds Connection Type, URL, Account, Login, Password, Label Printer
  - Report 50016 `PDC Update Parcels Info Status`, Report 50060 `PDC Courier Print Label`
  - Enum 50002 `PDCShippingAgentConnectionType` (DPD/DX)
- **Dependencies / setup:** Shipping agent must have Connection Type, Main URL, Account, Login, Password configured. Label Printer must be set on User Setup, Shipping Agent, or Sales & Receivables Setup (hierarchy). Insight Works PrintNode Connector must be installed and configured.
- **Edge cases / constraints:** DPD uses GeoSession token auth (re-obtained per session). DX uses token-based auth with expiry caching. Consignment numbers are stored on shipment headers and lines. Stop-tracking functionality exists for parcels that should no longer be polled.

---

### Feature: Production & Branding Management

- **What it does:** Extends production orders with branding/embroidery tracking. Branding records link branding types (embroidery, printing) and positions on garments to routing lines, enabling cost roll-up and work tracking. Proposals allow costing and branding quotation before production.
- **Who uses it:** Production planners, account managers, branding team.
- **Where in BC:** Released Production Orders (PageExt 50039) with Production Bin, Issue, Urgent, Production Status fields. Routing Lines (PageExt 50044) with Branding No. Proposal List (Page 50077) → Proposal Card (Page 50078).
- **How it works:** `PDC Branding` (Table 50045) links branding type + position + customer, calculating costs from type routing cost, consuming component items, and run time. Routing lines on production BOMs are extended with `PDC Branding No.` (TableExt 50053) connecting routing operations to branding specifications. Proposals (`PDC Proposal Header`, Table 50046 + product/costing/branding lines) provide customer quotations with margin calculation. The `PDCEventsHandler` subscriber on `OnAfterPostPurchaseDoc` auto-finishes production orders when subcontracted purchase receipts are posted.
- **Objects involved:**
  - Tables 50043–50045: `PDC Branding Type`, `PDC Branding Position`, `PDC Branding`
  - Tables 50046–50049: `PDC Proposal Header`, `PDC Proposal Product Line`, `PDC Proposal Costing Line`, `PDC Proposal Branding Line`
  - TableExts 50036 `PDCProductionOrder`, 50052 `PDCRoutingHeader`, 50053 `PDCRoutingLine`, 50055 `PDCProdOrderComponent`
  - Pages 50074–50084 (branding type/position/branding, proposal list/card/lines/factbox)
  - PageExts 50038–50040 (Released Prod Orders, Lines)
  - Report 50036 `PDC Proposal Print`, Report 50011 `PDC Production Order Labels`, Report 50048 `PDC Prod. Order PickNote`
  - 9 Production Order API Queries (50013–50021)
- **Dependencies / setup:** Branding types require work/machine centre references. Branding No. Series configured in Sales & Receivables Setup. Routing headers extended with Sell-to Customer No.
- **Edge cases / constraints:** Auto-finish of production orders after PO receipt traces through ILE → Reservation → Prod Order Component chain. Production labels track print count via `PDC No. Labels Printed`.

---

### Feature: Demand Planning

- **What it does:** Provides monthly demand forecasting per product/colour combination with integrated views of current inventory, purchase orders, and sales consumption data.
- **Who uses it:** Purchasing managers, demand planners.
- **Where in BC:** `PDC Demand Products` (Page 50051) → `PDC Demand Plan Register` (Page 50052). Supporting views: Inventory (Page 50053), Stock+PO-SO (Page 50054), Monthly Usage (Page 50055), Purchase Orders (Page 50056), Sales Orders (Page 50067). Custom requisition worksheet: `PDC Demand Prod. Req. Worksh.` (Page 50057).
- **How it works:** `PDC Demand Product` (Table 50038) defines product/colour combinations with FlowFields for sales and consumption quantities from Item Ledger Entries. Opening a product creates 18 months of `PDC Demand Plan Register` (Table 50039) records. Users enter demand forecasts per month. The demand item requisition worksheet (`PDC Demand Item Req. Line`, Table 50040) provides a custom requisition line per user for purchasing.
- **Objects involved:**
  - Tables 50038–50040: `PDC Demand Product`, `PDC Demand Plan Register`, `PDC Demand Item Req. Line`
  - Pages 50051–50058, 50067
- **Dependencies / setup:** Product codes and colour codes must be defined. Item Ledger Entries must have `PDC Product Code` populated.
- **Edge cases / constraints:** Demand plan registers are keyed by product + colour + year + month. Requisition lines are per-user (Requester ID = User ID).

---

### Feature: Item Creation Engine

- **What it does:** Batch creation of items with full PDC attribute population (product code, style, colour, fit, size, vendor, routing, size scale). Supports suggesting items from combinations of categories, colours, and size scales.
- **Who uses it:** Product managers, item administrators.
- **Where in BC:** `PDC Item Creation Batches` (Page 50017) → `PDC Item Creation Engine` (Page 50045, Worksheet type).
- **How it works:** `PDC Item Creation Batch` (Table 50004) groups creation lines by batch name and type (Normal/Production). `PDC Item Creation Engine` (Table 50033) stores item-to-create records. Report 50012 `PDC Suggest Items On Wksh.` generates combinations from category, colour, size scale, gender, and vendor options. Report 50013 `PDC Implement Items` creates actual Item records with all attributes, optionally creating SKUs and assigning locations/bins.
- **Objects involved:**
  - Tables 50004, 50033: `PDC Item Creation Batch`, `PDC Item Creation Engine`
  - Pages 50017, 50045
  - Reports 50012 `PDC Suggest Items On Wksh.`, 50013 `PDC Implement Items`
  - Report 50058 `PDC Suggest Prod. Items Wksh.` – for production item creation (with consuming garment and branding items)
  - Enum 50004 `PDC Item Create Type`
- **Dependencies / setup:** Item categories, product colours, size scales, vendors must be configured. Config templates used for default field population.
- **Edge cases / constraints:** Item No. is validated to not already exist in the Item table.

---

### Feature: Sales Price Management

- **What it does:** Bulk generation and management of sales prices with margin calculation, vendor item price import from Excel, and direct cost margin updates.
- **Who uses it:** Pricing analysts, account managers.
- **Where in BC:** `PDC Sales Price Generator` (Page 50059). Sales Prices page extension (PageExt 50076) adds product code, vendor info, margin calculation.
- **How it works:** `PDC Sales Price Generator` (Table 50041) is a worksheet for composing price records. Report 50017 suggests items; Report 50018 implements prices. The Sales Price table extension (50045) adds `PDC Margin` calculated from `PDC Direct Unit Cost`. Report 50050 `PDC SalesPriceUpdDirectCostMar` batch-updates direct cost margins. Report 50057 `PDC VendItemPriceImportExcel` imports vendor prices from Excel files.
- **Objects involved:**
  - Table 50041 `PDC Sales Price Generator`
  - TableExt 50045 `PDCSalesPrice`
  - Page 50059 `PDC Sales Price Generator`
  - PageExt 50076 `PDCSalesPrices`
  - Reports 50017, 50018, 50050, 50057
  - Codeunit 50019 `PDCPortalSalesPrice` – portal price calculation
- **Dependencies / setup:** Purchase prices must exist for margin calculation.
- **Edge cases / constraints:** Price specificity hierarchy: customer-specific > generic (enforced by `OnAfterFindSalesPrice` subscriber in EventsHandler).

---

### Feature: Email Management System

- **What it does:** Configurable email templates with HTML parameterisation, attachment support, automatic invoice/credit memo PDF attachment, test mode, and mailing groups. Full email log with retry.
- **Who uses it:** Operations, customer service, automated processes.
- **Where in BC:** `PDC Email Management Setup` (Page 50008), `PDC Email Management Log` (Page 50011 – UsageCategory = History).
- **How it works:** `PDC Email Management Setup` (Table 50009) stores templates (HTML Blob), addresses, and log entries differentiated by Type (Setup/Address/Log). Templates support token replacement (e.g., `{{userFirstName}}`). Codeunit 50006 `PDCEmailManagement` processes log entries, auto-attaches invoice/credit memo PDFs, validates addresses, and sends via BC Email module. Codeunit 50009 `PDCEmailManagementJQ` provides async job queue processing.
- **Objects involved:**
  - Table 50009 `PDC Email Management Setup`
  - Codeunits 50006, 50009
  - Pages 50008–50011
  - Various portal reports that trigger email notifications (50021, 50037, 50042, 50061)
- **Dependencies / setup:** Email templates must be configured with valid HTML. Sender email address must be set. BC Email module must be configured.
- **Edge cases / constraints:** Test mode redirects all emails to a test address. Skip flag allows excluding specific log entries. Error text stored on failed send attempts.

---

### Feature: Consolidated Invoicing

- **What it does:** Generates consolidated invoice reports grouping invoice/credit memo lines by configurable dimensions: branch, wearer, contract, wardrobe, web order, or ordered-by.
- **Who uses it:** Finance team, account managers.
- **Where in BC:** Report 50004 `PDC Consolidate Invoices` (RDLC), Report 50034 `PDC Period Consolid. Invoice`.
- **How it works:** `PDC Consolidation Buffer` (Table 50014) aggregates data from Sales Invoice Lines and Sales Cr.Memo Lines with all PDC traceability fields. The report provides start/end date filtering and 6 grouping options. Carbon Emissions CO2e is included in the consolidation.
- **Objects involved:**
  - Table 50014 `PDC Consolidation Buffer`
  - Reports 50004, 50034
- **Dependencies / setup:** PDC fields must be populated on sales documents.
- **Edge cases / constraints:** Buffer is a cross-entity table with a complex 11-field primary key.

---

### Feature: E-Document / EDI Integration

- **What it does:** Enables inbound EDI order processing (R777/TemplaCMS CSV files from Azure File Share → Sales Orders) and outbound invoice CSV export, using the BC E-Document framework.
- **Who uses it:** EDI administrators, operations team.
- **Where in BC:** E-Document Service Card (PageExt 50300) with Azure File Share configuration. SAS Token Dialog (Page 50300).
- **How it works:** The `PDC Azure File Share Connector` (Codeunit 50300) implements `IDocumentSender`/`IDocumentReceiver`/`IReceivedDocumentMarker` for Azure File Share access via REST API with SAS token. Inbound: `PDCR777CSVParser` (Codeunit 50301) parses R777 CSV files, `PDCEDIImportMgt` (Codeunit 50303) intercepts the E-Document framework to redirect from purchase to sales order creation via `PDCEDISalesOrderCreator` (Codeunit 50302). Outbound: `PDCCSVFormat` (Codeunit 50305) exports posted sales invoices as flat CSV.
- **Objects involved:**
  - Table 50300 `PDC EDI Import Line` (temporary), TableExt 50300 `PDC E-Doc Service Ext`
  - Codeunits 50300–50305
  - Page 50300, PageExt 50300
  - EnumExts 50300 `PDC Service Integration`, 50301 `PDC E-Document Format`
- **Dependencies / setup:** Azure Storage Account, File Share, Directory Path, SAS Token must be configured. Customer No. and Dummy Vendor No. set on E-Document Service for inbound. Separate inbound/outbound directory paths.
- **Edge cases / constraints:** Duplicate order detection by External Doc No. + Customer. Item lookup chain: Item No. → Customer Item Reference → General Item Reference → Vendor Item No. R777 parser handles quoted commas in CSV fields. File deletion after successful processing ("mark fetched" pattern).

---

### Feature: Shopify Integration

- **What it does:** Captures Shopify order metadata when orders are imported by the standard Shopify Connector, ensuring traceability within the PDC data model.
- **Who uses it:** E-commerce team, order processors.
- **Where in BC:** Standard Sales Orders with `Order Source = 'SHOPIFY'`.
- **How it works:** Codeunit 50400 `PDCShopifyEvents` subscribes to `OnAfterCreateSalesHeader` from Shopify Order Events. Sets Order Source, External Document No., Ship-to E-Mail, Ship-to Mobile Phone No., and Customer Reference from the Shopify Order.
- **Objects involved:**
  - Codeunit 50400 `PDCShopifyEvents`
- **Dependencies / setup:** PDC Shopify app depends on Microsoft Shopify Connector 27.0+ and PDC main app 26.0+.
- **Edge cases / constraints:** Minimal integration — only captures header-level data on order creation.

---

### Feature: Warehouse & Pick Processing

- **What it does:** Extends inventory picks with PDC-specific fields (wearer, customer reference, web order), adds courier info capture, custom pick list/instruction reports, barcode label printing, and a web service interface for barcode scanners.
- **Who uses it:** Warehouse staff, despatch team.
- **Where in BC:** Inventory Pick (PageExt 50067) with actions: Post+Print+Send Invoice, Pick Note, Shipments. Inventory Picks list (PageExt 50037). Codeunit 50015 `PDCInterface` provides web service endpoints.
- **How it works:** `PDCInterface` (Codeunit 50015) exposes XML/JSON web service endpoints for barcode scanners: `ImportInvPickInfo` (set shipping agent/packages), `InvPickPostPrint` (post + print + email), `InvPickPrintPickNote` (print pick note), `ShipmentCourierSendPrint` (book courier + print label), `ProdOrderPrint` (print production labels), `FinishProductionOrder`. User impersonation routes print jobs to the scanning user's configured printer. `PDCEventsHandler` subscribers copy PDC fields to warehouse activity lines and create inventory pick operations from sales order picks.
- **Objects involved:**
  - Codeunit 50015 `PDCInterface`
  - Codeunit 50001 `PDCFunctions` – `InvPickPostAndPrintAndEmail`, `PrintInvPickLabelsBackground`, `PrintInvPickInstructionBackground`
  - TableExts 50039–50040 `PDCWarehouseActivityHeader/Line`
  - PageExts 50066, 50067, 50037
  - Reports 50002 `PDC Pick List`, 50005 `PDC Pick Instruction`, 50038 `PDC Pick Instruction2`
- **Dependencies / setup:** PrintNode Connector must be configured. Label Printer must be set on User Setup. Web service endpoint must be published.
- **Edge cases / constraints:** Shipment Date overridden to WORKDATE on pick posting (via event subscriber). Shipping agent can be overridden per pick. Background report printing uses Job Queue.

---

### Feature: Purchase Order Export & Stock Import

- **What it does:** Exports purchase orders in vendor-specific CSV formats and imports stock level responses from vendors.
- **Who uses it:** Purchasing team.
- **Where in BC:** Purchase Order (PageExt 50015) with "Export to File" action. Vendor Card (PageExt 50004) configures export XMLport.
- **How it works:** Vendors are configured with `PDC Export PO Xmlport` (TableExt 50003 on Vendor) pointing to one of 6 export XMLports (50007, 50040–50044) producing vendor-specific CSV formats (B002, R007, O002, P003, U005, Generic). Import reports (50040 `PDC Import Stock P003`) process vendor stock response files. Some import reports (O002, R007) are commented out / incomplete.
- **Objects involved:**
  - XMLports 50007, 50040–50044 (export)
  - Reports 50040 `PDC Import Stock P003` (active), 50040/50041 commented (O002, R007)
  - TableExt 50003 `PDCVendor`, 50016 `PDCItemVendor`
  - PageExt 50004 `PDCVendorCard`
  - Report 50057 `PDC VendItemPriceImportExcel`
- **Dependencies / setup:** Vendor must have Export PO Xmlport configured. Vendor item catalogue must be populated.
- **Edge cases / constraints:** Some stock import reports are commented out (O002, R007). Export formats vary significantly between vendors—each requires its own XMLport.

---

### Feature: Staff Uniform History & Sizing

- **What it does:** Provides complete uniform order history per staff member across invoices, credit memos, sales orders, and draft orders. Also tracks size/fit preferences per staff member.
- **Who uses it:** Portal users, customer service, uniform coordinators.
- **Where in BC:** `PDC Staff Uniform History` (Page 50061) with four subparts. `PDC Staff Sizes` (Page 50066).
- **How it works:** The history page (50061) is a Card page sourced from `PDC Branch Staff` with ListPart subpages showing filtered Sales Invoice Lines, Sales Cr.Memo Lines, Sales Lines, and Draft Order Item Lines per staff member. Staff sizes (`PDC Staff Size`, Table 50029) record size/fit per size scale, auto-populated during sales posting via `OnAfterPostItemLine` subscriber in EventsHandler.
- **Objects involved:**
  - Pages 50061–50065 (history), Page 50066 (sizes)
  - Table 50029 `PDC Staff Size`
  - Size scale tables: 50031 `PDC Size Scale Header`, 50032 `PDC Size Scale Line`, 50036 `PDC Size Group`
  - Pages 50042–50044 (size scale management), 50048 (size group), 50049 (measurement type)
- **Dependencies / setup:** Size Scales must be defined with size/fit combinations.
- **Edge cases / constraints:** Staff sizes are auto-created on posting; the `Created By Item No.` field tracks which item established the size record.

---

### Feature: Contract Management

- **What it does:** Simple customer contract tracking with assignment to staff members and draft orders. Contracts appear on all document lines for traceability.
- **Who uses it:** Account managers, portal users.
- **Where in BC:** `PDC Contracts` (Page 50037) → `PDC Contract Card` (Page 50038).
- **How it works:** `PDC Contract` (Table 50026) stores contract records per customer, auto-numbered from Portal setup. Contract No. flows to Branch Staff, Draft Order Staff Lines, Sales Lines, and all posted documents (shipment, invoice, credit memo lines) for end-to-end traceability.
- **Objects involved:**
  - Table 50026 `PDC Contract`
  - Pages 50037, 50038
  - API Page 50101
- **Dependencies / setup:** Contract No. Series configured on Portal card.
- **Edge cases / constraints:** Contracts can be blocked. One contract per customer can be set as default.

---

### Feature: Roll-Out Project Tracking

- **What it does:** Tracks customer roll-out projects (new uniform deployments) with deadlines, linking roll-outs to sales and purchase orders.
- **Who uses it:** Project managers, account managers.
- **Where in BC:** `PDC Roll-Out List` (Page 50022). Roll-Out No. field on Sales Order (PageExt 50010) and Purchase Order (PageExt 50015).
- **How it works:** `PDC Roll-out` (Table 50016) stores roll-out projects auto-numbered from G/L Setup. The Roll-Out No. field is added to Sales Header and Purchase Header via table extensions.
- **Objects involved:**
  - Table 50016 `PDC Roll-out`
  - TableExt 50015 `PDCGeneralLedgerSetup` (No. Series)
  - Page 50022
  - PageExts 50010, 50015, 50035, 50036
- **Dependencies / setup:** Roll-Out No. Series configured in General Ledger Setup.
- **Edge cases / constraints:** Roll-outs can be blocked. Simple tracking only; no workflow logic.

---

### Feature: Job Queue Automation

- **What it does:** Provides background automation for draft order processing, email sending, order confirmation, auto-reserve/release of production and sales orders, report printing, and planning worksheet calculation.
- **Who uses it:** System administrators (setup), system automated.
- **Where in BC:** Job Queue Entries with Category `INTERFACE`. Job Queue Entry Card (PageExt 50053) with `PDC Force Running In Error` flag.
- **How it works:** Codeunit 50013 `PDCJobQueue` is a multi-command processor parsing semicolon-separated parameters. Supported commands: `SEND_REP_SP` (email salesperson reports), `PRINT_PROD` (print production labels if shortage), `RUN_REP` (run planning worksheet), `PROD_RESERVE` (auto-reserve firm planned prod orders), `PROD_RELEASE` (auto-release when fully reserved), `SALES_RESERVE` (auto-reserve sales orders). Additional JQ wrappers: 50005 (draft orders), 50009 (emails), 50020 (order confirmations). Background report printing via `PDCFunctions.ReportBackgroundPrint`.
- **Objects involved:**
  - Codeunits 50013, 50005, 50009, 50020
  - Codeunit 50001 `PDCFunctions` (auto-reserve, auto-release, background print)
  - TableExt 50033 `PDCJobQueueEntry` (Force Running In Error flag)
  - PageExt 50053 `PDCJobQueueEntryCard`
  - Report 50043 `PDC Job Queue Restart`
- **Dependencies / setup:** Job Queue Entries must be configured with appropriate parameters and schedules. `PDC Force Running In Error` flag bypasses error-state blocking.
- **Edge cases / constraints:** JQ parameter format: `COMMAND:param1,param2;COMMAND2:param1`. Up to 10 parameters per command. 3 retry attempts with 5-second delay on JQ wrappers.

---

### Feature: Role Centre Enhancements & Sales Cues

- **What it does:** Extends Order Processor, Small Business Owner, and CEO & President role centres with PDC navigation sections and custom sales cues (SLA tracking, ready-to-pick, over credit limit).
- **Who uses it:** Order processors, managers, executives.
- **Where in BC:** Order Processor Role Center (PageExt 50068), Small Business Owner RC (PageExt 50071), CEO & President (PageExt 50078), SO Processor Activities (PageExt 50031), SB Owner Activities (PageExt 50032).
- **How it works:** Role Centers gain navigation links to PDC Branches, Staff, Entitlement, Wardrobes, Draft Orders, Contracts, Portals, Portal Users. The SO Processor Activities cue part shows: SLA Today/Missed/Tomorrow, Sales Orders Not Ready/Ready to Release/Ready to Pick, Sales Return Orders Released, Firm Planned Prod Orders Not Ready. Background calculation via Codeunit 50011 `PDCSalesCueBackground`.
- **Objects involved:**
  - PageExts 50068, 50071, 50078, 50031, 50032
  - TableExts 50050 `PDCSalesCue`, 50051 `PDCSBOwnerCue`
  - Codeunit 50011 `PDCSalesCueBackground`
- **Dependencies / setup:** None beyond the extension being installed.
- **Edge cases / constraints:** SLA cue calculations use background tasks (Page.SetBackgroundTaskResult).

---

### Feature: Report Substitution (Custom Document Layouts)

- **What it does:** Replaces 7 standard BC reports with PDC-branded RDLC versions that include PDC-specific fields (wearer, branch, contract, consignment number, carbon emissions).
- **Who uses it:** All users generating documents.
- **Where in BC:** Transparent replacement via `OnAfterSubstituteReport` event subscriber in `PDCEventsHandler`.
- **How it works:** The EventsHandler codeunit (50003) substitutes standard report IDs with PDC report IDs:
  - Sales Invoice → Report 50044 `PDC Sales Invoice`
  - Sales Credit Memo → Report 50045 `PDC Credit Memo`
  - Sales Shipment → Report 50001 `PDC Sales Shipment`
  - Return Order Confirmation → Report 50010 `PDC Return Order Confirmation`
  - Purchase Order → Report 50009 `PDC Purchase Order`
  - Customer Statement → Report 50000 `PDC Statement`
  - Pick List → Report 50002 `PDC Pick List` (inferred – via `OnBeforePrintInvtPickHeader`)
- **Objects involved:**
  - Reports 50000, 50001, 50002, 50009, 50010, 50044, 50045
  - Codeunit 50003 `PDCEventsHandler`
- **Dependencies / setup:** RDLC layouts must be deployed.
- **Edge cases / constraints:** Report substitution is global; it applies to all companies in the tenant.

---

### Feature: Carbon Emissions Tracking

- **What it does:** Tracks CO2e (carbon dioxide equivalent) emissions per item and flows the value through sales lines, consolidation, and invoicing.
- **Who uses it:** Sustainability reporting, account managers.
- **Where in BC:** Item Card (field `PDC Carbon Emissions CO2e`), consolidated invoice reports.
- **How it works:** The `PDC Carbon Emissions CO2e` field on Item (TableExt 50005) is copied to Sales Lines via `OnAfterCopyFromItem` subscriber in EventsHandler. The consolidation buffer (Table 50014) includes Carbon Emissions CO2e for reporting.
- **Objects involved:**
  - TableExt 50005 `PDCItem` (field), TableExt 50008 `PDCSalesLine`
  - Table 50014 `PDC Consolidation Buffer`
  - Codeunit 50003 `PDCEventsHandler`
- **Dependencies / setup:** CO2e values must be entered on Item cards.
- **Edge cases / constraints:** Read-only on sales lines (populated from item master).

---

## 4. Data Model Changes

### 4.1 Custom Tables (58 tables)

| ID    | Table                          | Purpose                                                 |
| ----- | ------------------------------ | ------------------------------------------------------- |
| 50000 | PDC Staff Entitlement Group    | Defines entitlement group types and defaults            |
| 50001 | PDC Wardrobe Entitlement Group | Links entitlement groups to wardrobes with period/value |
| 50002 | PDC Timegate Joiners Leavers   | External HR system sync records                         |
| 50003 | PDC Portal User Ship-to Addrs  | Portal user → allowed ship-to addresses                 |
| 50004 | PDC Item Creation Batch        | Batch headers for item creation engine                  |
| 50009 | PDC Email Management Setup     | Email templates, addresses, and log entries             |
| 50010 | PDCCourierShipmentHeader       | Courier shipment bookings (DPD/DX)                      |
| 50011 | PDC General Lookup             | Cross-company multi-type lookup values                  |
| 50012 | PDC Branch                     | Hierarchical customer branches                          |
| 50013 | PDC General Lookup_existing    | Legacy lookup (Source/Status)                           |
| 50014 | PDC Consolidation Buffer       | Consolidated invoicing aggregation                      |
| 50016 | PDC Roll-out                   | Customer roll-out projects                              |
| 50017 | PDC Portal User Branch         | Portal user → branch access mapping                     |
| 50018 | PDC Wardrobe Header            | Wardrobe definitions per customer                       |
| 50019 | PDC Wardrobe Line              | Products within a wardrobe                              |
| 50020 | PDC Branch Staff               | Individual staff members                                |
| 50021 | PDC Wardrobe Item Option       | Colour options per wardrobe product                     |
| 50022 | PDC Staff Entitlement          | Core entitlement tracking per staff per product         |
| 50023 | PDC Draft Order Header         | Portal draft orders                                     |
| 50024 | PDC Draft Order Staff Line     | Staff assignment in draft orders                        |
| 50025 | PDC Draft Order Item Line      | Item lines in draft orders                              |
| 50026 | PDC Contract                   | Customer contracts                                      |
| 50027 | PDC Wardrobe Worksheet         | Bulk wardrobe data entry workspace                      |
| 50028 | PDC Parcels Info               | Parcel-level courier tracking                           |
| 50029 | PDC Staff Size                 | Size/fit preferences per staff                          |
| 50030 | PDC Item Category Line         | Colour options per item category                        |
| 50031 | PDC Size Scale Header          | Size scale definitions                                  |
| 50032 | PDC Size Scale Line            | Size/fit combinations with garment measurements         |
| 50033 | PDC Item Creation Engine       | Item creation worksheet lines                           |
| 50034 | PDC Gender                     | Gender lookup (2-char codes)                            |
| 50035 | PDC Product Colour             | Product colour master (6-char codes)                    |
| 50036 | PDC Size Group                 | Size group classification                               |
| 50037 | PDC Measurement Type           | Measurement type definitions                            |
| 50038 | PDC Demand Product             | Product/colour for demand planning                      |
| 50039 | PDC Demand Plan Register       | Monthly demand forecast entries                         |
| 50040 | PDC Demand Item Req. Line      | Demand-based requisition per user                       |
| 50041 | PDC Sales Price Generator      | Sales price generation worksheet                        |
| 50042 | PDC Ship.Agent Serv. Per Cust. | Customer-specific shipping charges                      |
| 50043 | PDC Branding Type              | Branding operation types                                |
| 50044 | PDC Branding Position          | Branding positions on garments                          |
| 50045 | PDC Branding                   | Individual branding records with cost calc              |
| 50046 | PDC Proposal Header            | Customer proposal/quotation headers                     |
| 50047 | PDC Proposal Product Line      | Product lines in proposals                              |
| 50048 | PDC Proposal Costing Line      | Detailed costing per proposal item                      |
| 50049 | PDC Proposal Branding Line     | Branding specs per proposal line                        |
| 50050 | PDC Staff Entitlement Predict. | Predicted entitlement (what-if analysis)                |
| 50051 | PDC Portal User                | Portal user accounts                                    |
| 50052 | PDC Portal User Role           | Portal user → role mapping                              |
| 50053 | PDC Portal                     | Portal configuration                                    |
| 50054 | PDC Portal Role                | Granular portal role permissions                        |
| 50055 | PDC Portal List Paging         | Portal list pagination state                            |
| 50056 | PDC Name Value Buffer          | General-purpose name/value pairs                        |
| 50057 | PDC Text Buffer                | Large text storage (split across 5 fields)              |
| 50058 | PDC Portal User Wardrobe       | Portal user → wardrobe access mapping                   |
| 50300 | PDC EDI Import Line            | Temporary EDI import buffer (EDocument app)             |

### 4.2 Table Extensions (57 extensions)

**Customer (Table 18):** ~20 fields added — email preferences, carriage charge limit, auto-pick toggle, default branch, branch mandatory flag, release blocking, statement/invoice email addresses, over-entitlement action (Enum), customer category code.

**Item (Table 27):** ~40+ fields — the largest extension. Product Code, Style/Colour/Fit/Size + descriptions + sort sequences, Size Scale Code, Gender, SLA days, Return Period, Zero Price Block, FOC, Variable Price, Contract Item, Prepaid, Vendor Inventory (FlowField), Qty to Ship/on Rel. Prod. Order/on Prod. Purch. Order (FlowFields), Carbon Emissions CO2e, Barcode (FlowField from Item Reference). 7 custom keys. Auto-generates barcode on insert.

**Sales Header (Table 36):** ~30 fields — Employee Name/ID, Customer Reference, Web Order No., Consignment No., Staff ID, Branch No., Wardrobe ID, Draft Order No., Order Source, Ordered By (ID/Name/Phone), Ship-to E-Mail/Mobile, Roll-Out No. Trigger modifications on Ship-to Code and Shipping Agent Service (carriage charge recalculation for returns). 514 lines.

**Sales Line (Table 37):** ~15 fields — Product Code, Wearer ID/Name, Customer Reference, Staff ID, Branch No., Wardrobe ID, Web Order No., Ordered By (ID/Name), Draft Order refs, Order Reason Code, Contract No., Carbon Emissions CO2e.

**Item Ledger Entry (Table 32):** 15+ fields — full order traceability (Product Code, Branch, Staff ID, Wardrobe, Colour Code, Wearer, Customer Reference, Web Order, Ordered By, Draft Order refs, Order Reason, Contract).

**All posted document tables** (Sales Shipment Header/Line, Sales Invoice Header/Line, Sales Cr.Memo Header/Line, Return Receipt Header/Line, Purch. Inv. Line, Purch. Cr. Memo Line): Mirror relevant PDC fields from unposted documents.

**Production Order (Table 5405):** Purchase Document No. (FlowField), Released D/T, No. Labels Printed, Printed D/T, Work Center No. (FlowField), Production Bin, Issue flag, Urgent flag, Production Status.

**Shipping Agent (Table 291):** Connection Type (DPD/DX enum), Main URL, Account, Login, Password, Label Printer.

**Shipping Agent Services (Table 5790):** Carriage Charge, Carriage Charge Limit, Carriage Charge Type/No., Show On Portal, Check Carriage Limit, Country/Region Code, Portal Sequence.

**Sales & Receivables Setup (Table 311):** ~20 fields — default templates, despatch/cut-off times, carriage charge G/L, multiple No. Series (barcode, branding, proposal, consignment), order confirmation attachments. 364 lines.

### 4.3 Enums

| ID    | Enum                           | Values                                             |
| ----- | ------------------------------ | -------------------------------------------------- |
| 50000 | PDCPackageType                 | Box, Bag                                           |
| 50001 | PDCEntitlementGroupType        | (blank), Quantity Group, Value Group, Points Group |
| 50002 | PDCShippingAgentConnectionType | (blank), DPD, DX                                   |
| 50003 | PDCItemSource                  | (blank), UK, Overseas                              |
| 50004 | PDC Item Create Type           | Normal, Production                                 |
| 50005 | PDC Portal User Type           | Standard, Staff, Approver, Bulk Order              |
| 50006 | PDC Over Entitlement Action    | No Action, Warning, Escalate, Block                |

All enums are `Extensible = true`.

**Enum Extensions (EDocument app):**

- 50300 `PDC Service Integration` extends `Service Integration` → adds `PDC Azure File Share`
- 50301 `PDC E-Document Format` extends `E-Document Format` → adds `PDC R777 CSV`, `PDC CSV`

---

## 5. UI Changes

### 5.1 Custom Pages (104 pages)

**API Pages (20):** Full REST API surface for branches, contracts, draft orders (header/staff/item lines), entitlement, items, production orders (+ lines/components/routing/comments), posted invoices/credit memos (+ lines), staff, users, wardrobes (+ lines). Publisher: `pdc`, Group: `app1`, Version: `v2.0`.

**Wardrobe Management (8):** Wardrobe List/Card, Lines, Item Options, Worksheet, Entitlement Groups.

**Staff & Entitlement (10):** Branch Staff List/Card, Entitlement List, Entitlement Predicted, Staff Sizes, Staff Uniform History (with 4 subpages), Size Scales (List/Card/Subform), Size Group, Gender, Measurement Type.

**Draft Orders (4):** Draft Orders List, Draft Order Card, Staff Lines (subpage), Item Lines (list).

**Portal Management (10):** Portal List/Card, Portal Roles, Portal User List/Card, User Branches/Ship-to Addresses/Wardrobes, User Password dialog.

**Email (4):** Setup, Addresses, Setup List, Log.

**Demand Planning (8):** Demand Products, Plan Register, Inventory/Stock+PO-SO/Monthly Usage/Purchase Orders/Sales Orders views, Requisition Worksheet.

**Shipping & Courier (4):** Sales Shipments, Courier Shipments, Shipping Agent Services Per Customer, Parcels Info.

**Product & Item (6):** Product Colour, Item Creation Engine/Batches, Item Category Lines, Sales Price Generator.

**Proposals & Branding (10):** Proposal List/Card, Product Line, Costing Line/Card, Branding Line/Card, Branding Type/Position/Branding master, Proposal FactBox.

**Contracts (2):** Contracts List, Contract Card.

**Miscellaneous (6):** Roll-Out List, Timegate Joiners/Leavers, General Lookups (2), Portal Info Display (2), Register User Task From Note.

### 5.2 Page Extensions (87 extensions)

**Role Centres (5):** Order Processor, Small Business Owner, CEO & President role centres extended with PDC navigation. SO Processor Activities and SB Owner Activities extended with custom cues.

**Customer & Contact (6):** Customer Card/List/Ledger Entries, Customer Template Card, Contact Card/List — adds PDC fields, statement actions, portal user creation.

**Sales Documents (14):** Sales Order/Quote/Invoice/Credit Memo/Return Order and their subforms — adds PDC fields (notes, order source, status, wearer data, branch, web order, contract), pick/release actions.

**Posted Sales Documents (9):** Posted Shipment/Invoice/Credit Memo and subforms — shows PDC traceability fields.

**Purchase Documents (8):** Purchase Order/subform, Invoice/Cr.Memo/Return subforms — adds export action, product code, skip payment discount.

**Item & Inventory (12):** Item Card/List/Lookup, Item Ledger Entries, Item Journal, Item Category, Vendor Catalog, Bin Content, Value Entries, Inventory Pick/Picks, Physical Inventory Journal.

**Production (8):** Released Production Order/Orders/Lines, Prod Order Components, Firm Planned Prod Orders, Manufacturing Setup, Routing/List/Lines.

**Setup (5):** Sales & Receivables Setup, Purchases & Payables Setup, General Ledger Setup, User Setup, Job Queue Entry Card.

**Shipping & Vendor (7):** Shipping Agents/Services, Ship-to Address/List, Vendor Card/Item Catalog, Countries/Regions.

**Other (13):** Reason Codes, VAT Statement, Sales Prices, SKU Card/List, Segment, User Task List, Planning/Req. Worksheets, Subcontracting Worksheet, Sales Comment Sheet.

### 5.3 Role Center Navigation Additions

All three role centres (Order Processor, Small Business Owner, CEO & President) gain navigation sections for:

- PDC Branches, Branch Staff, Staff Entitlement
- Wardrobes, Wardrobe Lines
- Draft Orders, Contracts
- NAV Portals, Portal Users
- Period Consolidated Invoice report

---

## 6. Process & Posting Changes

### 6.1 Sales Order Release Validation

**Subscriber:** `OnBeforeReleaseSalesDoc` / `OnBeforeManualReleaseSalesDoc` in `PDCEventsHandler` (CU 50003)

- Checks customer is not blocked (`PDC Block Release`)
- Validates branch is populated when `PDC Branch Mandatory` is set on customer
- Calls `SO_CheckMandatoryFields` (CU 50001) to validate mandatory sales order fields
- Prevents release if validation fails

### 6.2 Item Posting (Item Journal → ILE / Value Entry)

**Subscribers:** `OnBeforePostItemJnlLine`, `OnBeforeInsertItemLedgEntry`, `OnBeforeInsertValueEntry` in `PDCEventsHandler`

- Copies 15+ PDC fields from Item Journal Line to Item Ledger Entry (Product Code, Branch, Staff ID, Wardrobe, Colour, Wearer, Customer Reference, Web Order, Ordered By, Draft Order refs, Order Reason, Contract)
- Copies Product Code and Branch to Value Entry

### 6.3 Sales Posting

**Subscribers:** `OnBeforeSalesShptHeaderInsert`, `OnPostLinesOnBeforeGenJnlLinePost`, `OnAfterPostItemLine` in `PDCEventsHandler`

- Copies Number of Packages and mobile phone to Sales Shipment Header
- Copies Branch No. to General Journal Line during invoice posting
- **After posting items:** Updates `PDC Staff Size` records (auto-records size per staff/size scale), creates `PDC Portal User Ship-to Addrs` records from Sales Header ship-to addresses

### 6.4 Purchase Posting

**Subscriber:** `OnBeforePurchInvLineInsert` in `PDCEventsHandler`

- Copies Special Order fields from Purchase Line to Purchase Invoice Line
- **`OnAfterPostPurchaseDoc`:** Auto-finishes related Production Orders after purchase receipt (traces through ILE → Reservation → Prod Order Component)

**Manual-bind subscriber:** `OnAfterFinalizePosting` in `PDCEventsManual` (CU 50008) — prints purchase receipt labels in background

### 6.5 Warehouse Activity Posting

**Subscribers:** Multiple warehouse events in `PDCEventsHandler`

- Copies PDC fields to warehouse activity lines during pick creation
- Sets Shipment Date to WORKDATE on pick posting (`OnUpdateSourceDocumentOnAfterSalesLineModify`)
- Overrides Shipping Agent per customer-specific rules

### 6.6 Planning & Requisition

**Subscribers:** `OnBeforeCheckInsertFinalizePurchaseOrderHeader`, `OnFinalize...` in `PDCEventsHandler`

- Prevents duplicate PO lines for same production order during requisition worksheet carry-out
- Groups requisition lines by production order
- Copies `PDC Source` (UK/Overseas) to requisition lines

### 6.7 Standard Cost Calculation

**Subscriber:** `OnCalcProdBOMCostOnAfterCalcCompItemQtyBase` in `PDCEventsHandler`

- Populates Standard Cost Worksheet from Purchase Prices during standard cost calculation

### 6.8 Available Inventory Override

**Subscriber:** `OnAfterCalcAvailableInventory` in `PDCEventsHandler`

- Overrides available inventory calculation: sets available = `Item.Inventory` (ignoring standard ATP logic)

### 6.9 Pricing

**Subscriber:** `OnAfterFindSalesPrice` in `PDCEventsHandler`

- Prefers customer-specific prices over generic prices when both exist

### 6.10 Report Substitution

**Subscriber:** `OnAfterSubstituteReport` in `PDCEventsHandler`

Replaces 7 standard reports with PDC versions (see Feature: Report Substitution above).

### 6.11 Document Copy

**Subscriber:** `OnBeforeInsertToSalesLine` in `PDCEventsHandler`

- Preserves PDC fields when copying sales documents

---

## 7. Integrations & Automation

### 7.1 External API Integrations

| Integration             | Codeunit                           | Protocol                                    | Purpose                                                    |
| ----------------------- | ---------------------------------- | ------------------------------------------- | ---------------------------------------------------------- |
| DPD Courier             | 50002 `PDCCourierDPD`              | REST JSON (shipments) + SOAP XML (tracking) | Shipment booking, label generation, parcel tracking        |
| DX Courier              | 50007 `PDCCourierDX`               | REST JSON                                   | Shipment booking, PDF label download, tracking             |
| Microsoft Graph API     | 50010 `PDCAzureUserMgt`            | REST (Graph v1.0)                           | Azure AD B2C user creation, enable/disable, welcome emails |
| Azure File Share        | 50300 `PDCAzureFileShareConnector` | REST with SAS token                         | E-Document inbound/outbound file transfer                  |
| Insight Works PrintNode | via `IWX PrintNode API Mgt.`       | PrintNode API                               | EPL barcode label printing to network printers             |

### 7.2 Web Service Endpoints

| Endpoint                         | Codeunit | Format        | Purpose                                                                                                          |
| -------------------------------- | -------- | ------------- | ---------------------------------------------------------------------------------------------------------------- |
| `PDCInterface`                   | 50015    | XML / JSON    | Barcode scanner interface for warehouse (pick info, post/print, courier, production)                             |
| `PDCPortalsWebService.Call2`     | 50016    | JSON          | Portal API: 50+ routes for all portal operations                                                                 |
| `PDCPortalsWebService.Download2` | 50016    | JSON + binary | Portal file downloads (invoices, credit memos, shipments, reports as PDF/XLSX)                                   |
| 20 API Pages                     | Various  | OData v4      | RESTful API for branches, staff, wardrobes, draft orders, entitlement, production orders, invoices, credit memos |

### 7.3 File I/O

- **Purchase Order CSV Export:** 6 XMLports (50007, 50040–50044) for vendor-specific CSV formats
- **Stock Import:** Report 50040 (P003 format active; O002, R007 commented out)
- **Vendor Price Import:** Report 50057 imports from Excel
- **E-Document CSV Export:** Codeunit 50305 exports posted invoices as CSV
- **E-Document CSV Import:** Codeunit 50301 parses R777/TemplaCMS CSV files

### 7.4 Job Queue Entries / Scheduled Processes

| Category   | Codeunit                             | Commands / Purpose                                                                                     |
| ---------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| INTERFACE  | 50005 `PDCDraftOrderProcessJQ`       | Async draft order → sales order conversion                                                             |
| INTERFACE  | 50009 `PDCEmailManagementJQ`         | Async email sending                                                                                    |
| INTERFACE  | 50020 `PDCSalesOrderConfirmJQ`       | Async order confirmation emails                                                                        |
| INTERFACE  | 50013 `PDCJobQueue`                  | Multi-command: `SEND_REP_SP`, `PRINT_PROD`, `RUN_REP`, `PROD_RESERVE`, `PROD_RELEASE`, `SALES_RESERVE` |
| Background | `PDCFunctions.ReportBackgroundPrint` | Background report printing via JQ                                                                      |

### 7.5 Background Tasks

- Codeunit 50011 `PDCSalesCueBackground` — Role Centre cue calculations (SLA counts, order readiness)

---

## 8. Security & Permissions

### 8.1 Permission Set

**ID 50000 `PDC`** (Assignable = true) grants:

- **Table Data:** RIMD on all 56 custom tables
- **Tables:** X on all 56 custom tables
- **Reports:** X on all 66 reports
- **Codeunits:** X on 17 codeunits
- **XMLports:** X on 44 XMLports
- **Pages:** X on 73 pages
- **Queries:** X on 22 queries

This is a monolithic permission set — all users of the extension need the full set. There is no role-based permission split within BC.

### 8.2 Portal Role-Based Access

Portal-level RBAC is implemented via `PDC Portal Role` (Table 50054) with 25+ Boolean permission flags: Orders, Returns, Staff, Contracts, Finances, Entitlement, Checkout, Wardrobe, All Branches, Staff Request Create/Approve, Address Create/Edit, Bulk Order, etc. Roles are merged (OR logic) when a user has multiple roles.

### 8.3 Sensitive Data Handling

- **Passwords:** Portal user passwords stored as MD5 hash with salt `'NAVPortalsSalt'` (legacy). Azure AD B2C users use default password `@Portal1234!` on creation.
- **API Credentials:** Courier API login/password stored on Shipping Agent table (field-level). Azure AD B2C credentials (Client Id, Secret) stored on Portal table. Azure SAS tokens stored in Isolated Storage (Table 50300 extension).
- **Data Classification:** Most custom fields use `DataClassification = CustomerContent`. Some system fields use `SystemMetadata`.

**Concern:** MD5 password hashing is cryptographically weak. The hardcoded default password `@Portal1234!` for Azure AD B2C users should be changed on first login. API credentials stored in plain text on table records (not using Isolated Storage for courier credentials).

---

## 9. Configuration & Deployment Notes

### 9.1 Required Setup Steps

1. **Sales & Receivables Setup:** Configure ~20 PDC-specific fields:
   - Default Item/Customer/Vendor templates
   - Despatch Date Buffer, Order Cut Off Time, Despatch Cut Off Time
   - Carriage Charge G/L Account
   - No. Series: Barcode, Branding, Proposal, Consignment, Invoice, Credit Memo start numbers
   - Order Confirmation HTML attachment import
   - Invoice print/email labels count settings

2. **Purchases & Payables Setup:** Default G/L Account, Default Purchase Labels Count

3. **General Ledger Setup:** Roll-Out No. Series

4. **Manufacturing Setup:** Default Production Labels Count

5. **Portal Configuration (`PDC Nav Portal Card`):**
   - Portal Code, Type, URL
   - Authentication: Tenant Id, Client Id, Secret (Azure AD B2C)
   - SSO Pre-Shared Key (if SSO enabled)
   - No. Series: Wardrobe, Draft Orders, Branch Staff, Contracts
   - Page Size for portal pagination
   - Optional: Workflow Notifications, Return-to-Invoice, Admin Only Login

6. **Portal Roles:** Define roles with Boolean permission flags

7. **Shipping Agents:** Set Connection Type (DPD/DX), Main URL, Account, Login, Password, Label Printer

8. **Shipping Agent Services:** Configure Carriage Charge, Carriage Charge Type/No., Limit

9. **User Setup:** Assign Label Printers per user

10. **General Lookups:** Populate BODYTYPE values in `PDC General Lookup` (cross-company table)

11. **Size Scales:** Define Size Scale Headers/Lines with size/fit combinations

12. **Gender & Product Colour:** Populate lookup tables

13. **Item Data:** Populate PDC Product Code, Style, Colour, Fit, Size, Size Scale Code on items

14. **Web Service Publishing:** Publish Codeunit 50015 and 50016 as web services; configure API page routes

### 9.2 Feature Toggles / Setup Tables

- `PDC Portal.Admin Only Login` — restricts portal access
- `PDC Portal.Use Workflow Notifications` — enables notification emails
- `PDC Customer."PDC Do not send E-Mails"` — per-customer email opt-out
- `PDC Customer."PDC Do not print/send reports"` — per-customer report opt-out
- `PDC Customer."PDC Allow Auto-Pick"` — enables auto-pick creation
- `PDC Customer."PDC Branch Mandatory"` — enforces branch on sales orders
- `PDC Customer."PDC Block Release"` — prevents sales order release
- `PDC Customer."PDC Over Entitlement Action"` — controls over-entitlement behaviour
- `Job Queue Entry."PDC Force Running In Error"` — bypasses error-state blocking

### 9.3 Environment Requirements

- **BC Platform:** 26.0+, Runtime 15.2+, Cloud target
- **Dependencies:** Insight Works IWorks Common 2.18+, Insight Works PrintNode Connector 2.3+
- **EDocument App:** Requires BC E-Document Core 26.0+
- **Shopify App:** Requires Microsoft Shopify Connector 27.0+, BC Platform 27.0+
- **External:** Azure AD B2C tenant (for portal authentication), Azure Storage Account (for EDI), DPD/DX API accounts (for courier), PrintNode account (for label printing)

---

## 10. Known Limitations & TODOs

1. **Inactive Code — Barcode128B:** Codeunit 50014 `PDCBarcode128B` is entirely commented out. The BMP barcode generation has been replaced by an alternative approach (likely the barcode FlowField from Item Reference).

2. **Commented-out Stock Imports:** Reports for O002 and R007 stock import formats have their code fully commented out — only P003 import is active.

3. **Disabled Draft Order Item Update:** `PDCStaffEntitlement.UpdateDraftOrderItemLines` contains only `exit;` — this means changes to staff entitlement do NOT cascade to existing draft order item lines.

4. **Single Permission Set:** Only one monolithic permission set exists. There is no separation between read-only users, portal administrators, warehouse staff, or finance roles within BC.

5. **Legacy Password Hashing:** MD5 with salt `'NAVPortalsSalt'` is cryptographically weak. This is a security concern for any environments still using password-based portal authentication.

6. **Hardcoded Azure AD Password:** Default B2C user password `@Portal1234!` is hardcoded in `PDCAzureUserMgt`.

7. **Courier Credentials in Plain Text:** DPD/DX API credentials stored as plain text fields on the Shipping Agent table rather than Isolated Storage.

8. **Available Inventory Override:** The `OnAfterCalcAvailableInventory` subscriber sets available = `Item.Inventory`, effectively disabling standard ATP/available-to-promise logic. This is a significant behaviour change.

9. **General Lookup Cross-Company:** `PDC General Lookup` (Table 50011) has `DataPerCompany = false`, meaning lookup values are shared across all companies in the tenant. Changes in one company affect all.

10. **Fix Report (60000):** One-time data fix utility still present. The active code populates `PDC Document Id` on Sales Cr.Memo Lines. Contains commented-out test code.

11. **FirmProdOrderAutoRelease Logic:** Checks if all production order components are reserved from Item Ledger Entries before auto-releasing. The reservation check may not account for all reservation sources.

12. **No Assisted Setup Wizard:** No guided setup or assisted setup wizard exists. Configuration requires manual setup across multiple pages.

13. **Report 50053 (Custom Calc. Plan):** A custom MPS/MRP planning calculation report exists, duplicating standard planning logic. This may diverge from standard BC planning improvements in future versions.

14. **TODO Comments:** The `UpdateDraftOrderItemLines` procedure with `exit;` suggests intentional deferral — likely a planned feature for cascading entitlement changes to open draft orders.

15. **Proposal No. Series / Branding No. Series:** Configured in Sales & Receivables Setup rather than a dedicated PDC setup page — may be confusing for administrators.

---

_Generated from source code analysis of the PDC Business Central extension repository. All object references verified against AL source files._
