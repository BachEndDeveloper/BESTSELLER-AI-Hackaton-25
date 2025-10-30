package com.bestseller.demo.plugin;

import com.bestseller.demo.data.DemoDataStore;
import com.bestseller.demo.model.ItemInfo;
import com.microsoft.semantickernel.semanticfunctions.annotations.DefineKernelFunction;
import com.microsoft.semantickernel.semanticfunctions.annotations.KernelFunctionParameter;
import org.springframework.stereotype.Component;

/**
 * Semantic Kernel plugin for item information retrieval.
 * This plugin provides functions that can be called by the kernel to get item details.
 */
@Component
public class ItemPlugin {

    private final DemoDataStore dataStore;

    public ItemPlugin(DemoDataStore dataStore) {
        this.dataStore = dataStore;
    }

    /**
     * Gets item information by item ID.
     *
     * @param itemId the unique identifier for the item
     * @return item information as a formatted string
     */
    @DefineKernelFunction(
        name = "getItemInfo",
        description = "Retrieves detailed information about a product item by its ID"
    )
    public String getItemInfo(
        @KernelFunctionParameter(
            name = "itemId",
            description = "The unique identifier for the item (e.g., 'item-001')"
        ) String itemId
    ) {
        return dataStore.findItemById(itemId)
            .map(item -> String.format("""
                Item ID: %s
                Name: %s
                Price: $%.2f
                Category: %s
                Description: %s
                """.stripTrailing(),
                item.itemId(),
                item.name(),
                item.price(),
                item.category(),
                item.description()
            ))
            .orElse("Item not found with ID: " + itemId);
    }

    /**
     * Searches for items by category.
     *
     * @param category the category to search for
     * @return information about items in the category
     */
    @DefineKernelFunction(
        name = "searchItemsByCategory",
        description = "Searches for items in a specific category (e.g., 'Apparel', 'Footwear')"
    )
    public String searchItemsByCategory(
        @KernelFunctionParameter(
            name = "category",
            description = "The category to search for (e.g., 'Apparel', 'Footwear')"
        ) String category
    ) {
        // In this simple demo, we'll just return info about known categories
        if (category.equalsIgnoreCase("Apparel")) {
            return "Found items in Apparel category: Classic T-Shirt (item-001), Denim Jeans (item-002)";
        } else if (category.equalsIgnoreCase("Footwear")) {
            return "Found items in Footwear category: Running Shoes (item-003)";
        } else {
            return "No items found in category: " + category;
        }
    }
}
