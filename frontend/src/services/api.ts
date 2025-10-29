import axios from 'axios';
import type { ItemSummary, ItemDetail, StockInfo, TrackingInfo } from '../types/api';

// Default to local development server, can be configured via environment variable
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const apiService = {
  // Items endpoints
  async getAllItems(): Promise<ItemSummary[]> {
    const response = await api.get<ItemSummary[]>('/items');
    return response.data;
  },

  async getItemById(itemId: string): Promise<ItemDetail> {
    const response = await api.get<ItemDetail>(`/items/${itemId}`);
    return response.data;
  },

  // Stock endpoint
  async getStockByItemId(itemId: string): Promise<StockInfo> {
    const response = await api.get<StockInfo>(`/stock/${itemId}`);
    return response.data;
  },

  // Tracking endpoint
  async getTrackingStatus(trackingNo: string): Promise<TrackingInfo> {
    const response = await api.get<TrackingInfo>(`/track/${trackingNo}`);
    return response.data;
  },
};
