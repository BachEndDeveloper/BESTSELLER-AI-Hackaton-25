package com.bestseller.api.model;

import java.math.BigDecimal;

public record ItemDetail(
    String itemId,
    String name,
    BigDecimal price,
    String description,
    String category,
    String brand,
    String sku
) {
}
