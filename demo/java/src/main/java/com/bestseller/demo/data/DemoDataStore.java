package com.bestseller.demo.data;

import com.bestseller.demo.model.ItemInfo;
import com.bestseller.demo.model.StockInfo;
import com.bestseller.demo.model.TrackingInfo;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Static data store for demo purposes.
 * In a real application, this would be replaced with database access.
 */
@Component
public class DemoDataStore {

    private final Map<String, ItemInfo> items = new HashMap<>();
    private final Map<String, StockInfo> stockInfo = new HashMap<>();
    private final Map<String, TrackingInfo> trackingInfo = new HashMap<>();

    public DemoDataStore() {
        initializeData();
    }

    private void initializeData() {
        // Initialize items
        items.put("item-001", new ItemInfo(
            "item-001",
            "Classic T-Shirt",
            new BigDecimal("29.99"),
            "A comfortable cotton t-shirt perfect for everyday wear",
            "Apparel"
        ));
        items.put("item-002", new ItemInfo(
            "item-002",
            "Denim Jeans",
            new BigDecimal("79.99"),
            "Premium denim jeans with a modern fit",
            "Apparel"
        ));
        items.put("item-003", new ItemInfo(
            "item-003",
            "Running Shoes",
            new BigDecimal("129.99"),
            "Lightweight running shoes for maximum comfort",
            "Footwear"
        ));

        // Initialize stock information
        stockInfo.put("item-001", new StockInfo("item-001", true, 150, "Main Warehouse"));
        stockInfo.put("item-002", new StockInfo("item-002", true, 75, "Main Warehouse"));
        stockInfo.put("item-003", new StockInfo("item-003", false, 0, "Main Warehouse"));

        // Initialize tracking information
        trackingInfo.put("TRK-2025-001", new TrackingInfo(
            "TRK-2025-001",
            "In Transit",
            "Distribution Center - Copenhagen",
            "2025-11-02"
        ));
        trackingInfo.put("TRK-2025-002", new TrackingInfo(
            "TRK-2025-002",
            "Delivered",
            "Customer Address",
            "2025-10-28"
        ));
    }

    public Optional<ItemInfo> findItemById(String itemId) {
        return Optional.ofNullable(items.get(itemId));
    }

    public Optional<StockInfo> findStockByItemId(String itemId) {
        return Optional.ofNullable(stockInfo.get(itemId));
    }

    public Optional<TrackingInfo> findTrackingByNumber(String trackingNo) {
        return Optional.ofNullable(trackingInfo.get(trackingNo));
    }
}
