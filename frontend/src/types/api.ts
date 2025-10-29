// API Types generated from OpenAPI specification

export interface ItemSummary {
  itemId: string;
  name: string;
  price: number;
}

export interface ItemDetail {
  itemId: string;
  name: string;
  price: number;
  description: string;
  category?: string;
  brand?: string;
  sku?: string;
}

export interface StockInfo {
  itemId: string;
  inStock: boolean;
  quantity: number;
  warehouse?: string;
  lastUpdated?: string;
}

export interface TrackingEvent {
  timestamp: string;
  location: string;
  status: string;
  description?: string;
}

export interface TrackingInfo {
  trackingNo: string;
  status: 'Picked Up' | 'Processed' | 'In Transit' | 'Out for Delivery' | 'Delivered' | 'Returned' | 'Failed';
  currentLocation: string;
  estimatedDelivery?: string;
  deliveryDate?: string;
  history?: TrackingEvent[];
}

export interface ApiError {
  code: number;
  message: string;
  details?: string;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
  data?: ItemDetail | ItemSummary[] | StockInfo | TrackingInfo;
  error?: string;
}
