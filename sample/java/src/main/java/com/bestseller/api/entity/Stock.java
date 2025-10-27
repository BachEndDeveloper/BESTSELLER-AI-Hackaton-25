package com.bestseller.api.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

@Table("stock")
public record Stock(
    @Id
    @Column("id")
    Integer id,

    @Column("item_id")
    String itemId,

    @Column("in_stock")
    Boolean inStock,

    @Column("quantity")
    Integer quantity,

    @Column("warehouse")
    String warehouse,

    @Column("last_updated")
    Instant lastUpdated,

    @Column("created_at")
    Instant createdAt,

    @Column("updated_at")
    Instant updatedAt
) {
}
