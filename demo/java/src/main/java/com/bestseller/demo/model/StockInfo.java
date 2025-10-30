package com.bestseller.demo.model;

/**
 * Represents stock information for an item.
 */
public record StockInfo(
    String itemId,
    boolean inStock,
    int quantity,
    String warehouse
) {}
