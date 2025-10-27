package com.bestseller.api.model;

import java.math.BigDecimal;

public record ItemSummary(
    String itemId,
    String name,
    BigDecimal price
) {
}
