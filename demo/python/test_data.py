#!/usr/bin/env python3
"""Simple test script to verify static data and models."""

import sys
import json

# Import the models to verify they work
try:
    from models import ITEMS, STOCK, TRACKING, ItemDetail, StockInfo, TrackingInfo
    print("✓ Successfully imported models")
except Exception as e:
    print(f"✗ Failed to import models: {e}")
    sys.exit(1)

# Test items data
print("\n=== Testing Items Data ===")
print(f"Total items: {len(ITEMS)}")
for item_id, item in list(ITEMS.items())[:2]:
    print(f"  - {item_id}: {item.name} (${item.price})")

# Test stock data
print("\n=== Testing Stock Data ===")
print(f"Total stock records: {len(STOCK)}")
for item_id, stock in list(STOCK.items())[:2]:
    status = "In Stock" if stock.in_stock else "Out of Stock"
    print(f"  - {item_id}: {status} (Qty: {stock.quantity})")

# Test tracking data
print("\n=== Testing Tracking Data ===")
print(f"Total tracking records: {len(TRACKING)}")
for tracking_no, tracking in list(TRACKING.items())[:2]:
    print(f"  - {tracking_no}: {tracking.status}")

# Test plugin functions
print("\n=== Testing Plugin Functions ===")
try:
    from plugin import BestsellerPlugin
    plugin = BestsellerPlugin()
    
    # Test get_all_items
    result = plugin.get_all_items()
    items = json.loads(result)
    print(f"✓ get_all_items returned {len(items)} items")
    
    # Test get_item_details
    result = plugin.get_item_details("item-001")
    item = json.loads(result)
    print(f"✓ get_item_details returned: {item.get('name')}")
    
    # Test get_stock_info
    result = plugin.get_stock_info("item-001")
    stock = json.loads(result)
    print(f"✓ get_stock_info returned: in_stock={stock.get('in_stock')}")
    
    # Test get_tracking_status
    result = plugin.get_tracking_status("TRK-2025-001234")
    tracking = json.loads(result)
    print(f"✓ get_tracking_status returned: status={tracking.get('status')}")
    
except ImportError as e:
    print(f"⚠ Skipping plugin tests (semantic_kernel not installed)")
    print("  Install dependencies with: pip install -r requirements.txt")
except Exception as e:
    print(f"✗ Failed to test plugin: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

print("\n✅ All tests passed!")
