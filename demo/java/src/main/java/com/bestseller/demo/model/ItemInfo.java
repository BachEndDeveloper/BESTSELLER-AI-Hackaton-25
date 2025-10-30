package com.bestseller.demo.model;

import java.math.BigDecimal;

/**
 * Represents basic item information.
 */
public record ItemInfo(
    String itemId,
    String name,
    BigDecimal price,
    String description,
    String category
) {}
