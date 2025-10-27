package com.bestseller.api.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.math.BigDecimal;
import java.time.Instant;

@Table("items")
public record Item(
    @Id
    @Column("item_id")
    String itemId,

    @Column("name")
    String name,

    @Column("price")
    BigDecimal price,

    @Column("description")
    String description,

    @Column("category")
    String category,

    @Column("brand")
    String brand,

    @Column("sku")
    String sku,

    @Column("created_at")
    Instant createdAt,

    @Column("updated_at")
    Instant updatedAt
) {
}
