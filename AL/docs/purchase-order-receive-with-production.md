# Purchase Order - Receive with Production Processing

## Overview

A new button **"Receive Today & PO Label & Prod"** has been added to the Purchase Order page that streamlines the receiving process when items are needed for production orders.

This button combines multiple steps into one automated process:
- Receives the purchase order items
- Prints purchase order labels
- Automatically processes related production orders
- Prints production labels for released orders
- Provides option to view affected production orders

## When to Use This Feature

Use **"Receive Today & PO Label & Prod"** when:
- Receiving items that are reserved for production orders
- You want to immediately print production labels
- You want to see which production orders were released from this receipt

Use the standard **"Receive Today & Label"** button when:
- Items are for stock or sales orders only
- You don't need production processing

## Location

**Page:** Purchase Order (Page 50)

**Button Location:** Actions > Posting group

The button appears alongside:
- **Receive Today** - receives without printing labels
- **Receive Today & Label** - receives and prints PO labels only
- **Receive Today & PO Label & Prod** - NEW - receives, prints PO labels, and processes production

## How It Works

### Step-by-Step Process

1. **Receive Purchase Order**
   - Sets receipt date to current work date
   - Posts the purchase receipt
   - Items move into inventory

2. **Print Purchase Order Labels**
   - Automatically prints labels from the posted receipt
   - Shows item details and reservation information
   - Only prints if vendor is configured to print labels

3. **Process Production Orders**
   - System identifies which Firm Planned Production Orders need items from this receipt
   - Automatically reserves components for production orders
   - Releases production orders that now have all components available

4. **Print Production Labels**
   - Prints labels for all production order lines that were just released
   - Labels include item details, production order number, and firm planned order reference

5. **View Production Orders** (Optional)
   - If some orders couldn't be released due to insufficient stock:
     - Warning message: **"Some Firm Planned Production Orders could not be released due to insufficient stock. Do you want to view the related production orders?"**
   - If all orders were successfully released:
     - Confirmation message: **"Do you want to view the released production orders?"**
   - Clicking **Yes** opens the Released Production Orders page filtered to show only the relevant orders

## Usage Instructions

1. Open the Purchase Order you want to receive
2. Verify the order details and quantities
3. Click **Actions > Posting > Receive Today & PO Label & Prod**
4. Confirm the posting when prompted: **"Do you want to post the Order?"**
5. Wait while the system:
   - Receives the order
   - Prints PO labels
   - Processes production orders
   - Prints production labels
6. If prompted, click **Yes** to view the affected production orders
7. In the Production Orders list, you can:
   - Review which orders were released
   - Enter the **Production Bin** location directly in Business Central
   - View production details and components

## What Happens to Different Item Types

### Items for Stock
- Received into inventory
- PO labels printed showing "For Stock"
- No production processing

### Items Reserved to Sales Orders
- Received into inventory
- PO labels printed showing Sales Order reservation
- No production processing
- Items remain on holding shelf for sales

### Items Reserved to Firm Planned Production Orders

**If sufficient quantity to release:**
- Received into inventory
- PO labels printed showing production reservation
- Production order automatically released
- Production labels printed for ALL items on that order
- Order appears in the production orders list

**If insufficient quantity:**
- Received into inventory
- PO labels printed
- Order remains Firm Planned (not released)
- Warning shown to user
- Order appears in the production orders list for review

## Benefits

1. **Time Savings**
   - Eliminates waiting for job queue to release production orders
   - No need to manually search for production orders
   - All labels print immediately

2. **Reduced Errors**
   - Firm Planned Order number visible immediately
   - No manual lookup required
   - Production Bin can be entered in BC instead of separate web page

3. **Better Workflow**
   - Receiving person knows instantly if items are for production
   - Can place items directly in correct production bin
   - Labels are applied immediately during receiving

## Production Bin Entry

After production labels print and you view the production orders:

1. Locate your production bin for the items
2. In the Production Orders list, find the order
3. Click to open the production order
4. Enter the **Production Bin** field
5. System tracks when bin was entered (**Production Bin Changed** timestamp)

This replaces the previous process of using the separate web page API to enter bin locations.

## Technical Notes

### Background Processing

The system uses existing production processing logic:
- **Auto-Reserve:** Automatically reserves available inventory to Firm Planned Production Order components
- **Auto-Release:** Releases production orders when all components are reserved from inventory

These functions run for ALL production orders in the system, not just those related to this PO. However, only production orders linked to items from this PO receipt will:
- Have labels printed
- Appear in the filtered list

### Label Printing

**PO Labels:** Print based on vendor setup (**Print Purch. Order Labels** checkbox)

**Production Labels:** Print only for released orders with items from this PO

Label counts may be limited by setup configuration:
- **Purchases & Payables Setup:** PDC Def. Purch. Labels Cnt.
- **Manufacturing Setup:** PDC Def. Prod. Labels Cnt.

## Comparison with Existing Buttons

| Feature | Receive Today | Receive Today & Label | Receive Today & PO Label & Prod |
|---------|---------------|----------------------|----------------------------------|
| Receive PO | ✓ | ✓ | ✓ |
| Print PO Labels | - | ✓ | ✓ |
| Process Production | - | - | ✓ |
| Print Production Labels | - | - | ✓ |
| View Production Orders | - | - | ✓ |

## Troubleshooting

**Problem:** Production labels didn't print

**Solutions:**
- Check if items were actually reserved to production orders
- Verify production orders were successfully released
- Check Manufacturing Setup for label count limits
- Verify items have sufficient quantity in inventory

**Problem:** Production orders didn't release

**Solutions:**
- Check if ALL components for the order are available
- Verify components are reserved from Item Ledger (not Purchase Orders)
- Review the unreleased orders list to see what's missing
- Some components may still be on other purchase orders

**Problem:** Can't find production orders in the list

**Solutions:**
- Make sure you clicked "Yes" when prompted to view orders
- Check that items on PO were actually reserved to production
- Production orders only show if components came from this specific PO receipt

## Related Features

- **Job Queue Entry:** PDC Job Queue PRODUCTION RELEASE - runs periodically to release production orders
- **API Page:** PDCAPI - Production Order (Page 50005) - external web page access
- **Released Production Orders Page:** Standard BC page with PDC extensions for tracking
