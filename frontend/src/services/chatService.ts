import { ItemsService, StockService, TrackService } from '../api';
import type { ItemSummary, ItemDetail, StockInfo, TrackingInfo } from '../api';

export const processUserMessage = async (message: string): Promise<string> => {
  const lowerMessage = message.toLowerCase().trim();

  try {
    // Get all items
    if (
      lowerMessage.includes('show') && lowerMessage.includes('items') ||
      lowerMessage.includes('list') && lowerMessage.includes('items') ||
      lowerMessage.includes('all items') ||
      lowerMessage === 'items'
    ) {
      const items = await ItemsService.getAllItems();
      return formatItemsList(items);
    }

    // Get item details by ID
    const itemIdMatch = lowerMessage.match(/item[-\s]?(\d+|[a-z0-9-]+)/i);
    if (itemIdMatch && (lowerMessage.includes('detail') || lowerMessage.includes('show') || lowerMessage.includes('get') || lowerMessage.includes('info'))) {
      const itemId = itemIdMatch[0].replace(/\s/g, '-');
      const item = await ItemsService.getItemById({ itemId });
      return formatItemDetail(item);
    }

    // Check stock
    if (lowerMessage.includes('stock') && itemIdMatch) {
      const itemId = itemIdMatch[0].replace(/\s/g, '-');
      const stock = await StockService.getStockByItemId({ itemId });
      return formatStockInfo(stock);
    }

    // Track order
    const trackingMatch = lowerMessage.match(/trk[-\s]?\d{4}[-\s]?\d+/i);
    if ((lowerMessage.includes('track') || lowerMessage.includes('status') || lowerMessage.includes('order')) && trackingMatch) {
      const trackingNo = trackingMatch[0].replace(/\s/g, '-').toUpperCase();
      const tracking = await TrackService.getTrackingStatus({ trackingNo });
      return formatTrackingInfo(tracking);
    }

    // Help command
    if (lowerMessage.includes('help') || lowerMessage === '?') {
      return getHelpMessage();
    }

    // Default response for unrecognized queries
    return `I'm not sure what you're asking. Here are some things I can help with:

• "Show me all items" - View all available items
• "Show item-001" - Get details for a specific item
• "Check stock for item-001" - Check stock availability
• "Track TRK-2025-001234" - Track an order

Try asking me one of these questions!`;
  } catch (error) {
    if (error instanceof Error) {
      return `Error: ${error.message}`;
    }
    return 'An unexpected error occurred. Please try again.';
  }
};

const formatItemsList = (items: ItemSummary[]): string => {
  if (items.length === 0) {
    return 'No items found.';
  }

  let response = `Found ${items.length} item${items.length > 1 ? 's' : ''}:\n\n`;
  items.forEach((item, index) => {
    response += `${index + 1}. ${item.name}\n`;
    response += `   ID: ${item.itemId}\n`;
    response += `   Price: $${item.price.toFixed(2)}\n\n`;
  });

  return response.trim();
};

const formatItemDetail = (item: ItemDetail): string => {
  let response = `📦 ${item.name}\n\n`;
  response += `Item ID: ${item.itemId}\n`;
  response += `Price: $${item.price.toFixed(2)}\n`;
  
  if (item.brand) {
    response += `Brand: ${item.brand}\n`;
  }
  
  if (item.category) {
    response += `Category: ${item.category}\n`;
  }
  
  if (item.sku) {
    response += `SKU: ${item.sku}\n`;
  }
  
  if (item.description) {
    response += `\nDescription:\n${item.description}\n`;
  }

  return response.trim();
};

const formatStockInfo = (stock: StockInfo): string => {
  let response = `📊 Stock Information for ${stock.itemId}\n\n`;
  response += `Status: ${stock.inStock ? '✅ In Stock' : '❌ Out of Stock'}\n`;
  response += `Quantity: ${stock.quantity} units\n`;
  
  if (stock.warehouse) {
    response += `Warehouse: ${stock.warehouse}\n`;
  }
  
  if (stock.lastUpdated) {
    const date = new Date(stock.lastUpdated);
    response += `Last Updated: ${date.toLocaleString()}\n`;
  }

  return response.trim();
};

const formatTrackingInfo = (tracking: TrackingInfo): string => {
  let response = `📦 Tracking Information\n\n`;
  response += `Tracking Number: ${tracking.trackingNo}\n`;
  response += `Status: ${getStatusEmoji(tracking.status)} ${tracking.status}\n`;
  response += `Current Location: ${tracking.currentLocation}\n`;
  
  if (tracking.estimatedDelivery) {
    const date = new Date(tracking.estimatedDelivery);
    response += `Estimated Delivery: ${date.toLocaleString()}\n`;
  }
  
  if (tracking.deliveryDate) {
    const date = new Date(tracking.deliveryDate);
    response += `Delivered: ${date.toLocaleString()}\n`;
  }

  if (tracking.history && tracking.history.length > 0) {
    response += `\n📜 Tracking History:\n`;
    tracking.history.forEach((event, index) => {
      const date = new Date(event.timestamp);
      response += `\n${tracking.history!.length - index}. ${date.toLocaleString()}\n`;
      response += `   ${event.location}\n`;
      response += `   ${event.status}${event.description ? ' - ' + event.description : ''}\n`;
    });
  }

  return response.trim();
};

const getStatusEmoji = (status: string): string => {
  const statusMap: Record<string, string> = {
    'Picked Up': '📤',
    'Processed': '⚙️',
    'In Transit': '🚚',
    'Out for Delivery': '🚛',
    'Delivered': '✅',
    'Returned': '↩️',
    'Failed': '❌',
  };
  return statusMap[status] || '📦';
};

const getHelpMessage = (): string => {
  return `🤖 BESTSELLER Assistant Help

I can help you with the following:

📦 Items
• "Show me all items" - List all available items
• "Show item-001" - Get details for a specific item

📊 Stock
• "Check stock for item-001" - Check stock availability
• "Stock item-002" - Check stock for an item

🚚 Tracking
• "Track TRK-2025-001234" - Track your order
• "Order status TRK-2025-001235" - Check order status

💡 Tips:
• You can use item IDs like "item-001" or "item 001"
• Tracking numbers look like "TRK-2025-001234"
• Ask me anything in natural language!`;
};
