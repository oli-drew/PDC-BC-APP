# Documentation Review - Carbonfact V3 Integration

**Created**: 2026-02-19
**Module**: Carbonfact Integration
**Version**: 26.0.0.83

---

## Documents Created

| Document | Path | Audience | Description |
|----------|------|----------|-------------|
| Overview | `docs/guides/carbonfact-integration.md` | All users | Module overview, workflow, concepts, object reference |
| Setup Guide | `docs/setup/carbonfact-setup.md` | Administrators | Step-by-step setup for all configuration areas |
| Export Process | `docs/processes/carbonfact-export.md` | End users | Product Data and Purchase Order export procedures |
| Item Creation | `docs/processes/carbonfact-item-creation.md` | End users | New fields, attribute management, production item propagation |
| Consolidated Invoice | `docs/processes/carbonfact-consolidated-invoice.md` | End users / BI | 68 new columns, data sources, BI usage |

---

## Copy Instructions for Confluence

1. Create a new Confluence space or section: **Carbonfact Integration**
2. Copy documents in this order:
   - `guides/carbonfact-integration.md` as the parent page
   - `setup/carbonfact-setup.md` as child of Overview
   - `processes/carbonfact-export.md` as child of Overview
   - `processes/carbonfact-item-creation.md` as child of Overview
   - `processes/carbonfact-consolidated-invoice.md` as child of Overview
3. Update any internal links to match Confluence page structure
4. Add Confluence labels: `pdc`, `carbonfact`, `sustainability`, `carbon-footprint`

---

## Change Summary

### What's New

- **Product Data Export** - 3-sheet Excel file (Products, Packaging, BOM) for Carbonfact upload
- **Purchase Order Export** - Purchase receipt data with transport distances
- **CO2e Import & Propagation** - CSV import with optional propagation to production items
- **Item Creation Engine** - Net Weight, GTIN, Tariff No. fields + Manage Attributes action
- **Item Creation Attribute subtable** (table 50005) - Stores attributes per journal line before items exist
- **Item Creation Attributes dialog** (page 50040) - StandardDialog for editing journal-line attributes
- **Production item propagation** - Automatic data and attribute copy from consuming garments to subtable
- **Consolidated Invoice** - 68 new columns (fabric attributes, contract flags, branch hierarchy, post code)
- **Item Category Carbonfact fields** - 18 new fields for lifecycle, packaging, and defaults

### What's Changed

- Item Card: New "Carbonfact Enabled" field
- Item Category Card: New "Carbonfact" section with 5 subsections
- Countries/Regions: New Truck Km and Ship Km fields
- Item Creation Engine page: 3 new fields in worksheet, Manage Attributes uses subtable dialog (no longer requires item to exist)
- Item Creation Engine table: OnDelete cascade to subtable
- Suggest Prod. Items: Copies attributes to subtable (not directly to Item Attribute Value Mapping)
- Implement Items: Applies subtable attributes to Item Attribute Value Mapping during item creation
- Consolidated Invoice report: Extended dataset with 68 additional columns
- Codeunit 50022 (PDC Carbonfact Mgt.) eliminated in V5 — logic moved into reports

### Pending

- RDLC layout update for Consolidated Invoice (manual Visual Studio task)
