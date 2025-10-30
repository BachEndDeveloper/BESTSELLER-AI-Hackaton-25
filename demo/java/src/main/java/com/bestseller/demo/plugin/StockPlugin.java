package com.bestseller.demo.plugin;

import com.bestseller.demo.data.DemoDataStore;
import com.bestseller.demo.model.StockInfo;
import com.microsoft.semantickernel.semanticfunctions.annotations.DefineKernelFunction;
import com.microsoft.semantickernel.semanticfunctions.annotations.KernelFunctionParameter;
import org.springframework.stereotype.Component;

/**
 * Semantic Kernel plugin for stock information retrieval.
 * This plugin provides functions that can be called by the kernel to get stock details.
 */
@Component
public class StockPlugin {

    private final DemoDataStore dataStore;

    public StockPlugin(DemoDataStore dataStore) {
        this.dataStore = dataStore;
    }

    /**
     * Gets stock information for a specific item.
     *
     * @param itemId the unique identifier for the item
     * @return stock information as a formatted string
     */
    @DefineKernelFunction(
        name = "getStockInfo",
        description = "Retrieves stock availability and quantity information for a product item"
    )
    public String getStockInfo(
        @KernelFunctionParameter(
            name = "itemId",
            description = "The unique identifier for the item (e.g., 'item-001')"
        ) String itemId
    ) {
        return dataStore.findStockByItemId(itemId)
            .map(stock -> String.format(
                "Item ID: %s, In Stock: %s, Quantity: %d, Warehouse: %s",
                stock.itemId(),
                stock.inStock() ? "Yes" : "No",
                stock.quantity(),
                stock.warehouse()
            ))
            .orElse("Stock information not found for item ID: " + itemId);
    }

    /**
     * Checks if an item is available for purchase.
     *
     * @param itemId the unique identifier for the item
     * @return availability status as a string
     */
    @DefineKernelFunction(
        name = "checkAvailability",
        description = "Checks if a product item is currently available for purchase"
    )
    public String checkAvailability(
        @KernelFunctionParameter(
            name = "itemId",
            description = "The unique identifier for the item (e.g., 'item-001')"
        ) String itemId
    ) {
        return dataStore.findStockByItemId(itemId)
            .map(stock -> stock.inStock()
                ? String.format("Yes, %s is available with %d units in stock", itemId, stock.quantity())
                : String.format("No, %s is currently out of stock", itemId))
            .orElse("Cannot check availability - item not found: " + itemId);
    }
}
