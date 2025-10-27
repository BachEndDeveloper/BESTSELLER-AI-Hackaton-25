package com.bestseller.api.model;

import java.time.Instant;

public record StockInfo(
    String itemId,
    Boolean inStock,
    Integer quantity,
    String warehouse,
    Instant lastUpdated
) {
}
