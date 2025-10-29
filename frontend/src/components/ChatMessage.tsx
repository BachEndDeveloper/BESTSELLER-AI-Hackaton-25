import type { ChatMessage as ChatMessageType, ItemSummary, ItemDetail, StockInfo, TrackingInfo } from '../types/api';
import { Package, TruckIcon, AlertCircle, CheckCircle, XCircle } from 'lucide-react';

interface ChatMessageProps {
  message: ChatMessageType;
}

const ChatMessage: React.FC<ChatMessageProps> = ({ message }) => {
  const formatTime = (date: Date) => {
    return new Intl.DateTimeFormat('en-US', {
      hour: '2-digit',
      minute: '2-digit',
    }).format(date);
  };

  const renderData = () => {
    if (!message.data) return null;

    // Render Item List
    if (Array.isArray(message.data)) {
      const items = message.data as ItemSummary[];
      return (
        <div className="mt-3 space-y-2">
          {items.map((item) => (
            <div
              key={item.itemId}
              className="bg-white border border-gray-200 rounded-lg p-3 hover:shadow-md transition-shadow"
            >
              <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                  <Package className="w-4 h-4 text-gray-500" />
                  <span className="font-medium text-gray-900">{item.name}</span>
                </div>
                <span className="text-lg font-semibold text-blue-600">
                  ${item.price.toFixed(2)}
                </span>
              </div>
              <p className="text-xs text-gray-500 mt-1">{item.itemId}</p>
            </div>
          ))}
        </div>
      );
    }

    // Render Item Detail
    if ('description' in message.data) {
      const item = message.data as ItemDetail;
      return (
        <div className="mt-3 bg-white border border-gray-200 rounded-lg p-4">
          <div className="flex justify-between items-start mb-3">
            <div>
              <h3 className="text-lg font-semibold text-gray-900">{item.name}</h3>
              <p className="text-sm text-gray-500">{item.itemId}</p>
            </div>
            <span className="text-2xl font-bold text-blue-600">${item.price.toFixed(2)}</span>
          </div>
          <p className="text-gray-700 mb-3">{item.description}</p>
          <div className="grid grid-cols-2 gap-2 text-sm">
            {item.category && (
              <div>
                <span className="text-gray-500">Category:</span>
                <span className="ml-2 font-medium">{item.category}</span>
              </div>
            )}
            {item.brand && (
              <div>
                <span className="text-gray-500">Brand:</span>
                <span className="ml-2 font-medium">{item.brand}</span>
              </div>
            )}
            {item.sku && (
              <div className="col-span-2">
                <span className="text-gray-500">SKU:</span>
                <span className="ml-2 font-medium font-mono text-xs">{item.sku}</span>
              </div>
            )}
          </div>
        </div>
      );
    }

    // Render Stock Info
    if ('inStock' in message.data) {
      const stock = message.data as StockInfo;
      return (
        <div className="mt-3 bg-white border border-gray-200 rounded-lg p-4">
          <div className="flex items-center gap-3 mb-3">
            {stock.inStock ? (
              <CheckCircle className="w-6 h-6 text-green-500" />
            ) : (
              <XCircle className="w-6 h-6 text-red-500" />
            )}
            <div>
              <p className="font-semibold text-gray-900">
                {stock.inStock ? 'In Stock' : 'Out of Stock'}
              </p>
              <p className="text-sm text-gray-500">{stock.itemId}</p>
            </div>
          </div>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-500">Quantity:</span>
              <span className="font-medium">{stock.quantity} units</span>
            </div>
            {stock.warehouse && (
              <div className="flex justify-between">
                <span className="text-gray-500">Warehouse:</span>
                <span className="font-medium">{stock.warehouse}</span>
              </div>
            )}
            {stock.lastUpdated && (
              <div className="flex justify-between">
                <span className="text-gray-500">Last Updated:</span>
                <span className="font-medium">
                  {new Date(stock.lastUpdated).toLocaleString()}
                </span>
              </div>
            )}
          </div>
        </div>
      );
    }

    // Render Tracking Info
    if ('trackingNo' in message.data) {
      const tracking = message.data as TrackingInfo;
      return (
        <div className="mt-3 bg-white border border-gray-200 rounded-lg p-4">
          <div className="flex items-center gap-3 mb-3">
            <TruckIcon className="w-6 h-6 text-blue-500" />
            <div>
              <p className="font-semibold text-gray-900">{tracking.status}</p>
              <p className="text-sm text-gray-500">{tracking.trackingNo}</p>
            </div>
          </div>
          <div className="space-y-2 text-sm mb-4">
            <div className="flex justify-between">
              <span className="text-gray-500">Current Location:</span>
              <span className="font-medium">{tracking.currentLocation}</span>
            </div>
            {tracking.estimatedDelivery && (
              <div className="flex justify-between">
                <span className="text-gray-500">Estimated Delivery:</span>
                <span className="font-medium">
                  {new Date(tracking.estimatedDelivery).toLocaleString()}
                </span>
              </div>
            )}
            {tracking.deliveryDate && (
              <div className="flex justify-between">
                <span className="text-gray-500">Delivered:</span>
                <span className="font-medium text-green-600">
                  {new Date(tracking.deliveryDate).toLocaleString()}
                </span>
              </div>
            )}
          </div>
          
          {tracking.history && tracking.history.length > 0 && (
            <div className="border-t pt-3">
              <p className="text-sm font-medium text-gray-700 mb-2">Tracking History</p>
              <div className="space-y-2">
                {tracking.history.map((event, index) => (
                  <div key={index} className="flex gap-3 text-sm">
                    <div className="flex-shrink-0 w-2 h-2 mt-1.5 rounded-full bg-blue-500"></div>
                    <div className="flex-1">
                      <div className="flex justify-between">
                        <span className="font-medium text-gray-900">{event.status}</span>
                        <span className="text-gray-500 text-xs">
                          {new Date(event.timestamp).toLocaleString()}
                        </span>
                      </div>
                      <p className="text-gray-600 text-xs">{event.location}</p>
                      {event.description && (
                        <p className="text-gray-500 text-xs">{event.description}</p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      );
    }

    return null;
  };

  return (
    <div
      className={`flex ${
        message.role === 'user' ? 'justify-end' : 'justify-start'
      } mb-4`}
    >
      <div
        className={`max-w-[80%] rounded-lg px-4 py-3 ${
          message.role === 'user'
            ? 'bg-blue-600 text-white'
            : 'bg-gray-100 text-gray-900'
        }`}
      >
        <div className="whitespace-pre-wrap">{message.content}</div>
        {renderData()}
        {message.error && (
          <div className="mt-2 flex items-center gap-2 text-red-600 bg-red-50 rounded px-3 py-2">
            <AlertCircle className="w-4 h-4" />
            <span className="text-sm">{message.error}</span>
          </div>
        )}
        <div
          className={`text-xs mt-2 ${
            message.role === 'user' ? 'text-blue-200' : 'text-gray-500'
          }`}
        >
          {formatTime(message.timestamp)}
        </div>
      </div>
    </div>
  );
};

export default ChatMessage;
