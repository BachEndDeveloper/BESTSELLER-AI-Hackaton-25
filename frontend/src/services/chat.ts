import { apiService } from './api';
import type { ChatMessage } from '../types/api';

export const chatService = {
  async processMessage(message: string): Promise<ChatMessage> {
    const lowerMessage = message.toLowerCase();
    
    try {
      // Check for item listing
      if (lowerMessage.includes('list items') || 
          lowerMessage.includes('show items') || 
          lowerMessage.includes('all items') ||
          lowerMessage.includes('what items')) {
        const items = await apiService.getAllItems();
        return {
          id: Date.now().toString(),
          role: 'assistant',
          content: `Found ${items.length} items:`,
          timestamp: new Date(),
          data: items,
        };
      }
      
      // Check for stock information (before item details to prioritize stock queries)
      const stockMatch = message.match(/stock.*?(item[- ]?\d{3})/i) || 
                        message.match(/in stock.*?(item[- ]?\d{3})/i);
      if (stockMatch || (lowerMessage.includes('stock') && message.match(/item[- ]?(\d{3})/i))) {
        const itemIdMatch = message.match(/item[- ]?(\d{3})/i);
        const itemId = itemIdMatch ? `item-${itemIdMatch[1]}` : 'item-001';
        const stock = await apiService.getStockByItemId(itemId);
        return {
          id: Date.now().toString(),
          role: 'assistant',
          content: `Stock information for item ${itemId}:`,
          timestamp: new Date(),
          data: stock,
        };
      }
      
      // Check for specific item details
      const itemMatch = message.match(/item[- ]?(\d{3})/i) || message.match(/item-(\w+)/i);
      if (itemMatch || lowerMessage.includes('item details') || lowerMessage.includes('tell me about')) {
        const itemId = itemMatch ? `item-${itemMatch[1]}` : 'item-001'; // Default to item-001 if no ID found
        const item = await apiService.getItemById(itemId);
        return {
          id: Date.now().toString(),
          role: 'assistant',
          content: `Here are the details for ${item.name}:`,
          timestamp: new Date(),
          data: item,
        };
      }
      
      // Check for tracking information
      const trackingMatch = message.match(/TRK-\d{4}-\d{6}/i) || 
                           message.match(/track(?:ing)?.*?(\w+-\d+-\d+)/i);
      if (trackingMatch || lowerMessage.includes('track') || lowerMessage.includes('shipment')) {
        const trackingNo = trackingMatch ? trackingMatch[0] : 'TRK-2025-001234'; // Default tracking number
        const tracking = await apiService.getTrackingStatus(trackingNo);
        return {
          id: Date.now().toString(),
          role: 'assistant',
          content: `Tracking information for ${trackingNo}:`,
          timestamp: new Date(),
          data: tracking,
        };
      }
      
      // Default response with help
      return {
        id: Date.now().toString(),
        role: 'assistant',
        content: `I can help you with the following:
        
• **List items**: "Show me all items" or "List items"
• **Item details**: "Tell me about item-001" or "Show item details"
• **Check stock**: "Is item-001 in stock?" or "Check stock for item-002"
• **Track shipment**: "Track TRK-2025-001234" or "Where is my package?"

What would you like to know?`,
        timestamp: new Date(),
      };
      
    } catch (error) {
      const err = error as { response?: { data?: { message?: string } }; message?: string };
      return {
        id: Date.now().toString(),
        role: 'assistant',
        content: 'Sorry, I encountered an error processing your request.',
        timestamp: new Date(),
        error: err.response?.data?.message || err.message || 'Unknown error',
      };
    }
  },
};
