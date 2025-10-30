"""
Example usage of the BESTSELLER AI Demo API.

This script demonstrates how to interact with the API
without needing to install all dependencies.
"""

# Example: Manual testing of the data structures
print("=" * 60)
print("BESTSELLER AI Demo - Example Usage")
print("=" * 60)

# Import and display data
from models import ITEMS, STOCK, TRACKING

print("\n📦 Available Items:")
print("-" * 60)
for item_id, item in ITEMS.items():
    print(f"  {item_id}: {item.name} - ${item.price}")
    print(f"    Category: {item.category}, Brand: {item.brand}")
    print(f"    SKU: {item.sku}")
    print()

print("\n📊 Stock Information:")
print("-" * 60)
for item_id, stock in STOCK.items():
    status = "✅ In Stock" if stock.in_stock else "❌ Out of Stock"
    print(f"  {item_id}: {status}")
    print(f"    Quantity: {stock.quantity}")
    print(f"    Warehouse: {stock.warehouse}")
    print()

print("\n📍 Tracking Information:")
print("-" * 60)
for tracking_no, tracking in TRACKING.items():
    print(f"  {tracking_no}: {tracking.status}")
    print(f"    Location: {tracking.current_location}")
    print(f"    Estimated Delivery: {tracking.estimated_delivery}")
    if tracking.history:
        print(f"    History: {len(tracking.history)} events")
    print()

print("\n" + "=" * 60)
print("Example API Interactions (once server is running):")
print("=" * 60)

print("""
# 1. Health Check
curl http://localhost:8000/health

# 2. Get All Items
curl http://localhost:8000/items

# 3. Get Specific Item
curl http://localhost:8000/items/item-001

# 4. Check Stock
curl http://localhost:8000/stock/item-001

# 5. Track Shipment
curl http://localhost:8000/track/TRK-2025-001234

# 6. Chat with AI (requires Azure OpenAI credentials)
curl -X POST http://localhost:8000/chat \\
  -H "Content-Type: application/json" \\
  -d '{"message": "What items do you have available?"}'

# 7. Ask about specific item
curl -X POST http://localhost:8000/chat \\
  -H "Content-Type: application/json" \\
  -d '{"message": "Tell me about the Classic T-Shirt"}'

# 8. Check stock via chat
curl -X POST http://localhost:8000/chat \\
  -H "Content-Type: application/json" \\
  -d '{"message": "Is item-002 in stock?"}'

# 9. Track package via chat
curl -X POST http://localhost:8000/chat \\
  -H "Content-Type: application/json" \\
  -d '{"message": "Where is my package TRK-2025-001234?"}'
""")

print("\n" + "=" * 60)
print("Sample Questions for the AI Assistant:")
print("=" * 60)
questions = [
    "What items do you have?",
    "Tell me about item-001",
    "What's the price of the Denim Jeans?",
    "Is the Summer Dress in stock?",
    "How many Classic T-Shirts are available?",
    "Where is tracking number TRK-2025-001234?",
    "What's the status of my shipment TRK-2025-001235?",
    "Show me all items under $50",
    "What footwear do you have?",
    "When will tracking TRK-2025-001234 be delivered?",
]

for i, question in enumerate(questions, 1):
    print(f"  {i}. {question}")

print("\n" + "=" * 60)
