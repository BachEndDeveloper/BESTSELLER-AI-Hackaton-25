package com.bestseller.demo.plugin;

import com.bestseller.demo.data.DemoDataStore;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests for the ItemPlugin to demonstrate kernel function behavior.
 */
class ItemPluginTest {

    private ItemPlugin itemPlugin;

    @BeforeEach
    void setUp() {
        DemoDataStore dataStore = new DemoDataStore();
        itemPlugin = new ItemPlugin(dataStore);
    }

    @Test
    void testGetItemInfo_ValidItem() {
        String result = itemPlugin.getItemInfo("item-001");
        
        assertNotNull(result);
        assertTrue(result.contains("Classic T-Shirt"));
        assertTrue(result.contains("$29.99"));
        assertTrue(result.contains("Apparel"));
    }

    @Test
    void testGetItemInfo_InvalidItem() {
        String result = itemPlugin.getItemInfo("item-999");
        
        assertNotNull(result);
        assertTrue(result.contains("Item not found"));
    }

    @Test
    void testSearchItemsByCategory_Apparel() {
        String result = itemPlugin.searchItemsByCategory("Apparel");
        
        assertNotNull(result);
        assertTrue(result.contains("Classic T-Shirt"));
        assertTrue(result.contains("Denim Jeans"));
    }

    @Test
    void testSearchItemsByCategory_Footwear() {
        String result = itemPlugin.searchItemsByCategory("Footwear");
        
        assertNotNull(result);
        assertTrue(result.contains("Running Shoes"));
    }

    @Test
    void testSearchItemsByCategory_NotFound() {
        String result = itemPlugin.searchItemsByCategory("Electronics");
        
        assertNotNull(result);
        assertTrue(result.contains("No items found"));
    }
}
